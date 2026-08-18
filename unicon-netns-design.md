# Native Network Namespace Support for Unicon — Design Doc

**Status:** implemented (working tree); Linux only (see "Explicitly out of scope" for why)
**Feature string:** `Network namespaces` (`_NETNS` / `HAVE_NETNS`)

---

## 1. Motivation

A common pattern for building test topologies on Linux is to combine
network namespaces, veth pairs, and optional bridges — no full
containers, no rootfs, just isolated network stacks wired together,
cheap enough to spin up dozens of nodes per test run. This doc designs
the equivalent as a native Unicon capability: a small set of real
runtime additions, plus a thin `.icn` library (`package net`) for
everything that doesn't need to be native.

## 2. Design principles

**One process (or one OS thread) = one namespace, permanently.**
Namespace membership lives on `struct nsproxy`, refcounted, shared by
default across every thread in a process unless something explicitly
requests a new one (`unshare`) or joins an existing one (`setns`).
Nothing in this design ever asks a single process/thread to represent
more than one namespace over its lifetime — that's what makes both
execution modes below safe with zero extra bookkeeping. See §7 for
why this specifically resolves the coexpression-scheduling question.

**Additive, non-breaking extensions to existing builtins wherever
one already fits, rather than new functions.** Confirmed against the
real Unicon source that this is the established idiom — IPv6 extended
`open()`'s existing mode-flag parsing, SSL did the same, and SSH
([PR #641][ssh-pr]) rode `open()`'s mode flag plus its trailing
`attr[n]` slot for `key=value` options. This design follows the same
pattern for `open`/`close`/`fork`/`spawn`/`system`, and introduces new
surface (`package net`) only where no existing verb fits.

[ssh-pr]: https://github.com/uniconproject/unicon/pull/641

**Two execution modes, both riding the same primitive differently:**
- **Process mode** — full isolation, independent fault domain, real
  separate pid.
- **Thread mode** — same OS process, dedicated pthread (confirmed:
  `spawn()`-created coexpressions each get their own real
  `pthread_create()`'d thread via `nctramp`, not a simulated
  green-thread — see §7), net-only isolation, cheaper, cooperative
  scheduling.

An application picks per node; neither mode is privileged over the
other.

---

## 3. Native API changes

### 3.1 `open(name, "j", attr[n])`

New mode character `"j"` (namespace), following the exact SSH/SSL
precedent of a new `open()` mode flag plus trailing `key=value` attrs:

```
ns := open("r1", "j")                         # ephemeral (userns fallback if needed)
ns := open("r1", "j", "persist=yes")          # visible to `ip netns list`
ns := open("lan0", "j", "bridge=yes")         # bridge0 pre-provisioned inside
ns := open("r1", "j", "userns=yes")           # force rootless bootstrap (see 3.7)
ns := open("r1", "j", "userns=no")            # never bootstrap; fail if unprivileged
```

Implementation: fork a short-lived child, `unshare(CLONE_NEWNET)`,
bind-mount `/proc/self/ns/net` onto a private path under
`/tmp/unicon-netns/` (always) and, if `persist=yes`, a second bind
mount at `/var/run/netns/<name>` (for manual `ip netns` debugging).
Child brings `lo` up before exiting. New `Fs_NETNS` file-status bit
(`040`); state hangs off the `File` block as `struct NetnsFile *`
(`fd.netns`), same role `Fs_SSH` plays for SSH.

Ephemeral (no `persist`) namespaces have no user-visible filesystem
footprint — the private bind mount is what pins the namespace alive;
there is no meaningful difference in mechanism between "ephemeral" and
"persisted," only whether the second, user-visible mount also exists.

Helpers live in `src/common/rnetns.c` (`netns_create` / `netns_join` /
`netns_release` / `netns_userns_active`).

### 3.2 `close(ns)`

**Always tears down — no `force` parameter, no override to refuse.**
Same `function{0,1} close(f)` signature already in the runtime today,
unmodified arity; just a new `Fs_NETNS` branch that unconditionally
unmounts the private bind mount (and the `persist` mount, if set).

This is safe, not just simpler: unmounting the bind mount doesn't
touch the underlying kernel namespace object at all — that's kept
alive by its own `nsproxy` refcount, independent of the bind mount.
Any process still `setns()`'d into it (a live `fork(ns)` child, say)
keeps running completely unaffected, still holding its own reference.
What `close()` actually does is stop *this* file object's ability to
reach the namespace by name/path afterward — a `persist=yes` entry
disappears from `ip netns list`; a later `open()` by that name
creates a fresh namespace rather than finding the old one. The
kernel's own refcounting was always the real safety mechanism, not
ours, so there's nothing lost by not having an override.

`Attrib(ns,"refcount")` remains available as an informational,
non-enforcing check — a caller can look before closing if they want
to, but `close()` itself doesn't gate on it.

### 3.3 `fork(ns)`

Real POSIX `fork()` (`fxposix.ri`, `function{0,1} fork()`) gains one
optional leading arg: in the child branch, inside the existing C
`inline{}` block, right after the real `fork(2)` syscall and before
control returns to Icon, `netns_join()` is called. Guarantees the join
happens before the child's first Icon statement, by construction.

### 3.4 `spawn(ns, x, blocksize, stringsize, stacksize, soft)`

Restructured to `argv[argc]` with `OptNetns` leading-arg detection
(mirrors `OptWindow` in `grttin.h`). `spawn()` sets `pending_ns` on
`struct b_coexpr` before `CREATE_CE_THREAD`; `nctramp` calls
`netns_join()` first thing if it's set. This makes "join before
anything else" a runtime guarantee, not an Icon-level convention.

With concurrent threads, `spawn()` starts the OS thread immediately —
no `@ce` activation is required (that pattern is for non-concurrent
coexpressions). Callers typically `wait(ce)` (or `<<@ce`) when they
need the thread to finish.

### 3.5 `system(ns, argv, d_stdin, d_stdout, d_stderr, mode)`

Same `argv[argc]` + `OptNetns` restructuring as `spawn()`; one
`netns_join()` call inserted into the existing `case 0:` child branch
before `dup_fds`/`exec`.

### 3.6 `exec(path, argv[argc])`

**Unmodified.** By the time `exec()` runs inside a `fork(ns)`-forked
child, the process is already namespaced; `exec()` itself needs no
namespace awareness.

### 3.7 Rootless bootstrap — folded into `open()`'s attrs

`userns=yes` on `open(name,"j",...)` forces, once, idempotently: enter a
new user namespace and map the calling uid/gid to 0 inside it, then a
private mount namespace, then the netns creation itself — so
`CAP_NET_ADMIN`-requiring operations work unprivileged.

**Implicit fallback:** if `userns=` is **omitted** and the privileged
create fails with `EPERM`/`EACCES`, `open(...,"j")` retries once after
the same bootstrap. Explicit `userns=yes` or `userns=no` disables that
fallback (`userns=no` never bootstraps; `userns=yes` bootstraps up
front without a failed privileged attempt first).

**Real kernel constraint:** `unshare(CLONE_NEWUSER)` fails with
`EINVAL` if the calling process is already multithreaded — this must
happen before any `spawn()`-created thread-mode node exists. The
`runerr` message for that failure says *why* explicitly.

**Helper-map bootstrap** (in `netns_bootstrap_userns()` in
`src/common/rnetns.c`): writing `/proc/self/uid_map` from the same
process that just called `unshare(CLONE_NEWUSER)` is rejected with
`EPERM` on hosts that restrict unprivileged userns (notably AppArmor
`kernel.apparmor_restrict_unprivileged_userns=1`). Maps are therefore
written by a short-lived `fork()` helper that stays in the **host**
userns. The helper is not a separate program — same binary, a few
lines of C, then `_exit`.

```text
Unicon program
  └─ open("r1", "j")   # or open(..., "userns=yes")
       └─ [if omitted userns= and create got EPERM/EACCES: set userns=1]
       └─ netns_bootstrap_userns()     # when userns requested / fallback
            ├─ pipe() for sync
            ├─ fork()
            │    ├─ child (helper): wait on pipe
            │    │                 write /proc/<parent>/{setgroups,gid_map,uid_map}
            │    │                 signal parent; _exit
            │    └─ parent (main):  unshare(CLONE_NEWUSER)
            │                      signal helper “maps please”
            │                      wait until maps are done
            │                      unshare(CLONE_NEWNS), mark mounts private
            └─ return; then netns_create() as today
```

After a successful bootstrap the Unicon process is uid 0 *inside* the
userns for the rest of its life; later `open(...,"j")` /
`fork(ns)` / `spawn(ns)` / `system(ns,...)` / even `ip` via
`package net` need no further privilege on the host.

During bootstrap a private tmpfs is mounted on `/var/run/netns` so
`persist=yes` and `ip netns` can create entries — the host's
`/var/run/netns` is often not writable to a mapped-root userns.

**AppArmor note:** helper-map fixes the uid_map write. Creating
further namespaces (`CLONE_NEWNS` / `CLONE_NEWNET`) can still be
denied while `kernel.apparmor_restrict_unprivileged_userns=1`. On
such hosts, either run privileged (`CAP_NET_ADMIN`) or relax that
sysctl (e.g. `sysctl kernel.apparmor_restrict_unprivileged_userns=0`)
for unprivileged netns. Verified: with the sysctl at 0, the full
unprivileged path (open / fork / spawn / system / persist) succeeds.

`Attrib(ns, "userns")` — read-only query of whether rootless mode is
active. Setting stays exclusively at `open()` time.

---

## 4. Argument ordering convention

**`ns` leads when it is the scope the operation executes in.**
`fork(ns)`, `spawn(ns,...)`, `system(ns,...)`, `close(ns)` — in each,
`ns` answers "what is this call *about*," same role `w` plays in
`DrawPoint(w,x,y)`.

**`ns` sits in its natural position when it's a plain value, not the
subject.** `Link.move(target)` (§6) — the receiver (`self`, the link
being moved) is the subject; the target namespace is just where it's
going.

---

## 5. `Attrib()` — read-only for now

```
Attrib(ns, "name")       # get
Attrib(ns, "persist")    # get
Attrib(ns, "refcount")   # get -- live spawn()/fork() children; informational
                          # only, close() does not gate on this (§3.2)
Attrib(ns, "userns")     # get
```

Writes explicitly deferred. Interface/address/route configuration
lives in `package net` instead (§6).

---

## 6. `package net` — no runtime changes, ships as `uni/lib/netns.icn`

Everything below is pure `.icn`, shelling out to `ip` / `ip netns`.
No rtnetlink, no new C beyond the native open/join path. **Deliberately
deferred:** a native rtnetlink implementation.

`Link.move` / `run` accept a `Netns` instance, a string name, or a
native netns File from `open(...,"j")` (via `Attrib(...,"name")`).
When cooperating with native opens, use `persist=yes` so
`ip netns exec <name>` can find the namespace under `/var/run/netns/`.

`Veth.peer()` returns a host-resident `Link` for the other end (does
not copy `ns` — the two ends often move into different namespaces).
Call `peer()` before or after moving the first end; then `move()` the
peer independently.

### 6.1 `Netns` — the namespace container

Prefers native `open(name,"j","persist=yes")` (keeps the File open so
the persist mount stays pinned); falls back to `ip netns add`.
`delete()` closes the File or runs `ip netns del`.

### 6.2 `Link` and subtypes — interface abstraction

A base `Link` class plus one subclass per link type. Every `Link`
method funnels through `run()`, which scopes `ip` via `ip netns exec`
when the link currently belongs to a namespace.

```unicon
class Link(name, ns)
   # up/down/move/attach/detach/addr/delete → run([...])
   # ns_name(target) resolves Netns | string | native File
end

class Veth(peer_name) : Link()
class Bridge() : Link()
class Vrf(table) : Link()      # stub
class Tun(mode) : Link()       # stub
```

### 6.3 Example: three-node shared-LAN topology

```unicon
procedure main()
   local r1, r2, ns1, ns2, veth1, pid1

   ns1 := open("r1", "j")
   ns2 := open("r2", "j")

   veth1 := Veth("veth-r1", "veth-r2")
   peer := veth1.peer()
   veth1.move(Netns("r1"))
   peer.move(Netns("r2"))

   veth1.addr("10.0.0.1/24")
   peer.addr("10.0.0.2/24")

   # process mode — fork() fails (no value) only on error; the child's
   # successful result is 0, so discriminate with comparison, not else
   pid1 := fork(ns1) | stop("fork failed: ", &errortext)
   if pid1 = 0 then
      exec("/usr/sbin/some-daemon", "some-daemon", "-f")
   # else parent -- pid1 is r1's process id

   # thread mode (concurrent threads: spawn starts the OS thread; no @ce)
   t2 := spawn(ns2, create node_body())
   wait(t2)

   close(ns1)
   close(ns2)
end
```

---

## 7. Threading model — why this is safe

- **`spawn()`-created coexpressions get a real, dedicated
  `pthread_create()`'d OS thread** (`CREATE_CE_THREAD` →
  `pthread_create(..., nctramp, cp)`), pinned for that coexpression's
  whole life. `setns()` on that thread is permanent and correctly
  scoped — no migration risk.
- **On the native-coswitch backend**, ordinary (non-`spawn()`ed)
  coexpressions share one OS thread. A namespace joined on that thread
  is genuinely shared by every coexpression running on it — correct
  given this design never asks one process to represent more than one
  namespace.
- **Child threads/processes inherit the creator's current namespace
  by default** (`nsproxy` is refcounted and shared unless
  `CLONE_NEW*` is explicitly requested).

---

## 8. Build integration

1. Runtime hooks in `src/runtime/fxposix.ri` (`fork`),
   `src/runtime/fmisc.r` (`spawn`, `Attrib`), `src/runtime/fsys.r`
   (`open`/`close`/`system`), plus `rcoexpr.r` (`nctramp`),
   `ralc.r` / `rmisc.r` (image / init).
2. `Fs_NETNS` in `src/h/rmacros.h`; `struct NetnsFile` and
   `pending_ns` in `src/h/rstructs.h`; `OptNetns` in `src/h/grttin.h`.
3. New common module `src/common/rnetns.c` linked from
   `src/common/Makefile` (design originally assumed only editing
   existing `.r`/`.ri` files; helpers were extracted to keep the
   syscall/mount logic out of the RTL sources).
4. `configure.ac` `HAVE_NETNS` link check for `unshare`/`setns`
   `CLONE_NEWNET`. Non-Linux hosts omit the feature; first use gets a
   clean `runerr` rather than a build failure.
5. Feature registration in `src/h/feature.h` /
   `src/h/auto.in`; library `uni/lib/netns.icn` in `uni/lib/Makefile`.

---

## 9. Explicitly out of scope (for now)

- **Native rtnetlink implementation.**
- **BSD (jail-based) or Windows backends.**
- **A fully portable Interface/Bridge/Route feature.**
- **PID/mount namespace isolation for process-mode nodes.**
  `fork(ns)` only isolates the network namespace.
- **`Attrib()` writes** for interface/address/route state.

---

## 10. As-built notes / follow-ups

- `Fs_NETNS` is `040` when `HAVE_NETNS`; otherwise `0` so `OptNetns`
  stays compilable on non-Linux.
- `spawn()` / `system()` `argv[argc]` + `OptNetns` restructuring is
  additive for existing callers (optional leading ns File).
- Creating a netns requires `CAP_NET_ADMIN`, or a successful
  `userns=yes` helper-map bootstrap (§3.7). On AppArmor hosts with
  `apparmor_restrict_unprivileged_userns=1`, relax that sysctl for
  unprivileged runs (or use CAP_NET_ADMIN).
- **Orphaned-mount reaper:** live handles are registered in
  `rnetns.c`; `atexit` plus `SIGINT`/`SIGTERM` (only when still
  `SIG_DFL`) umount private and persist pins. Cleanup runs only in the
  creating process (`getpid()` guard) so `fork`/`fork(ns)` children
  that call `exit` do not tear down the parent's pins. `SIGKILL` still
  orphans.
- **CLOEXEC:** no long-lived ns fd is held (path-based pins);
  `netns_join` opens with `O_CLOEXEC`, and create/bootstrap pipes use
  `pipe2(O_CLOEXEC)`.
- **Name collisions:** ephemeral `open("r1","j")` twice yields two
  independent objects; `persist=yes` uses `O_EXCL` and the second open
  fails. Covered in `tests/posix/netns.icn`.
- **Base `Link(name)`** wraps an existing iface (no create) for
  `.move()` into a namespace; `Veth`/`Bridge`/`Vrf`/`Tun` create.
- Test coverage: `tests/posix/netns.icn` drops to `nobody` when started
  as root, then forces `userns=yes`; `tests/unicon/nettopo.icn` covers
  package-net veth topology. Both skip cleanly via
  `This Program Requires ...` when privileges are unavailable
  (Makefile.test treats that as non-FAIL).
- `Link.ns_name` must not use `type(x) == "Netns"` — package instances
  report `net__Netns__state`; use `\x.name` (or `classname`).
- `Veth` creation should pass an `initns` under userns (host RTNETLINK
  create is often denied); create inside the ns then `move()` the peer.
- Still open: `Netns.list()` / link stats, `Netns.current()`,
  macvlan/ipvlan stubs.
