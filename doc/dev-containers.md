# Dev containers for Unicon

This repository includes **[Development Container](https://containers.dev/)** (“dev container”) definitions so you can build and test Unicon inside a **Linux** environment managed by Docker, without installing compilers and dependencies directly on your host. That is useful on **macOS** and **Windows**, and on Linux when you want an isolated or distro-specific setup.

## Prerequisites

- **Docker** (or Docker Desktop / a compatible engine) running on your machine.
- **VS Code** with the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

## Where the definitions live

Configuration files live under **`.devcontainer/<name>/devcontainer.json`**. There is **no** root **`.devcontainer/devcontainer.json`**; every profile is a **named subdirectory**. When you reopen in a container, the editor shows a **picker** so you can choose **Ubuntu** (`ubuntu-24/`), **Debian**, **Alpine**, and so on.

| Configuration folder | Intended environment |
|----------------------|----------------------|
| `ubuntu-24/` | Ubuntu 24.04 LTS (`noble`) |
| `debian-13/` | Debian 13 (`trixie`) |
| `alpine/` | Alpine Linux (musl libc); `image` is **`mcr.microsoft.com/devcontainers/base:alpine`** (latest published Alpine variant on MCR) |
| `alpine-32/` | Alpine Linux 32-bit (i386, musl libc); uses `i386/alpine:3.20` with `--platform=linux/386` |
| `fedora/` | Fedora |
| `rockylinux/` | Rocky Linux 9 |

### Alpine 32-bit without the editor remote server

**VS Code** does not ship a remote server for **32-bit Linux** (`linux/386`), so opening the **`alpine-32/`** dev container fails during server install. For the same image and layout (**`/unicon`** bind mount), run a plain Docker shell from the repository root:

```sh
./docker/alpine/run-i386-shell.sh
```

The script runs **`apk`** to install the same packages as the **Alpine / x86** CI job (**`build-base`**, **`diffutils`**) plus **`git`** (see **`docker/alpine/run-i386-shell.sh`** header). Then run **`./configure`** and **`make`** as usual. Keep editing in VS Code on the **host**; changes show up under **`/unicon`** in the container.

There is no way to make VS Code “default” to this instead of Dev Containers for that profile—the remote editor always expects a supported architecture. Use **`alpine/`** (64-bit) or another profile when you want **Reopen in Container**; use **`run-i386-shell.sh`** when you specifically need **i386** builds.

### Workspace path, `PATH`, and extensions

Each profile sets **`workspaceFolder`** to **`/unicon`**. The editor treats that directory as the project root **inside** the container (open files, search, tasks, and the integrated terminal’s current workspace all align with that path).

**`PATH`:** **`remoteEnv`** appends **`/unicon/bin`** to the container’s `PATH`, so after you **`make`** install binaries into the tree, commands such as **`unicon`** or **`icont`** can be run without a full path, consistent with a normal install prefix layout.

**Editor extensions:** **`customizations.vscode.extensions`** lists extensions to install into the **dev container** (the VS Code server that runs inside Docker). They are not necessarily the same install as on your **host** GUI; you get the Unicon syntax, debugger, LSP, and Makefile Tools inside the attached container session.

### How files are shared between host and container

This repo uses a **bind mount** so your clone on the **host** is visible **inside** the container at a fixed path. In each `devcontainer.json`, **`workspaceMount`** is equivalent to:

- **Source:** `${localWorkspaceFolder}` — the folder you opened locally (the repository root).
- **Target:** `/unicon` — where that same tree appears in the container.
- **Type:** `bind` — the container does **not** get a separate copy of the project; it sees the **same files** as on the host.

So “file sharing” here is not a background sync job or a network copy: the Docker engine mounts the host directory into the container’s filesystem view. Edits from the editor (on either side of the API), or from a shell **`cd /unicon`**, read and write **one** set of files. Build artifacts under **`/unicon`** (for example **`bin/`**, **`release/`**) therefore land next to your sources on the host disk as usual.

**Two common patterns** people compare:

| Pattern | What happens | This repo |
|--------|----------------|-----------|
| **Bind mount** | One directory on the host is mounted at a path in the container; changes are immediate and shared. | **Yes** — this is what **`workspaceMount`** does. |
| **Files only inside the container** | The project could live in a **Docker volume** or be **cloned inside** the image so it is not the same inode tree as a host folder; sharing with the host then requires export, commit, or volume tricks. | **No** — not the default here; the point is to edit the same clone you have on disk. |

With a bind mount, **the same files exist inside and outside** the container: there is no separate copy of the tree. That is convenient, but it also means **ownership and permissions** on build outputs (objects, libraries, `bin/`, generated `Makefile` fragments, `config.status`, and so on) reflect **whoever last wrote them**—the host user, the container’s **`vscode`** user, **root**, or another UID. That mismatch can cause confusing **`permission denied`** errors or **`make`** behavior when you move between environments. Different images also ship **different compilers and libraries**, so reusing object files from one place in another is unreliable.

**Matching your host user:** Each definition uses **`remoteUser`** **`vscode`** (the usual Dev Containers convention) and **`updateRemoteUserUID`: true** so the Dev Containers tooling can set **`vscode`’s numeric UID/GID** in the container to match **your local user** on the host. New files you create while attached to the container should then show the same ownership on the host filesystem when you **Reopen Folder Locally**.

**Normalizing the workspace on every start:** **`postStartCommand`** runs **`sudo chown -R vscode:vscode /unicon`** after **each** container start (including reopen), not only the first time the container is created. That fixes files still owned by **root** after image build or feature install, and keeps the bind-mounted tree aligned with **`vscode`** after UID sync—so you are less likely to see “wrong UID” artifacts that only look correct after reopening the folder on the host. On a very large clone the first pass can take a moment.

On **Windows** and **macOS**, Docker Desktop still implements the bind mount from your machine into the Linux VM that runs containers; the mount may use caching (**`consistency=cached`** in our config) so behavior stays close to native disks for editing. None of this replaces **`make distclean`** when switching compilers; see [Clean rebuilds when switching environments](#clean-rebuilds-when-switching-environments). After changing **`devcontainer.json`**, run **Dev Containers: Rebuild Container** once so the new lifecycle commands apply.

#### If `./configure` fails with `config.log: Permission denied`

**`make distclean`** removes Autoconf output; it does **not** fix file ownership. Root-owned or wrong-UID files can remain.

1. From **`/unicon`** inside the container (or the repo root on the host), fix ownership, then configure again:
   ```sh
   cd /unicon
   sudo chown -R "$(id -un):$(id -gn)" .
   ./configure
   ```
   On the **host** (Linux/macOS), from the repo root: **`sudo chown -R "$(id -u):$(id -g)" .`**

2. If problems persist, **rebuild** the dev container so **`postStartCommand`** runs again, or remove a leftover **`config.log`** after the `chown` (**`rm -f config.log`**).

#### Clean rebuilds when switching environments

When you **stop using a dev container** and build again on the **host**, when you **open a different dev container configuration** (another distro), or when you alternate between **host** and **container** builds, run **`make distclean`** from the **repository root** first (after a normal **`./configure`** / **`make`** workflow, this is the usual way to remove configured state and build artifacts). Then run **`./configure`** and **`make`** again in the environment you are using. That avoids stale binaries and permission leftovers from the previous environment.

## Opening the project in a container

1. Clone the repository and open the **repository root** in VS Code.
2. Run **Dev Containers: Reopen in Container** from the Command Palette (or accept the prompt to reopen in a container, if shown).
3. If several configurations exist, pick the one you want (for example **Ubuntu 24.04 LTS (noble)** (`ubuntu-24/`), **Debian 13**, **Alpine**, **Alpine 32-bit**, **Fedora**, or **Rocky Linux 9**).
4. After the image is built and the window attaches, use the integrated terminal: your shell runs **inside** the container; the tree is at **`/unicon`**.

### Switching to another configuration (including while already in a container)

**Dev Containers: Rebuild and Reopen in Container** only rebuilds the **configuration you are already using**. It does **not** show a list of profiles, so it feels like a refresh of the same container. To actually **change** distro/profile (for example from Debian to Fedora), use one of these:

1. **Preferred:** Command Palette (`Ctrl+Shift+P` / `Cmd+Shift+P`) → **Dev Containers: Switch Container** → pick another configuration (Ubuntu, Debian, Alpine, Alpine 32-bit, Fedora, Rocky Linux, …). If the command name differs slightly in your VS Code build, search the palette for `switch container`.

2. **If your editor does not offer Switch Container:** Command Palette → **Dev Containers: Reopen Folder Locally** (attach the window to the project on the **host**, not inside Docker). Then run **Dev Containers: Reopen in Container** — the **configuration picker** appears when several `.devcontainer/<name>/` folders exist.

3. **Status bar:** Click the green **remote / dev container** indicator (bottom-left); some versions expose “reopen locally” or container switching there (wording varies).

After you land in the new environment, run **`make distclean`**, then **`./configure`** and **`make`** again — see [Clean rebuilds when switching environments](#clean-rebuilds-when-switching-environments). The same applies when toggling between **host** and **container** work on the same clone.

## Building Unicon inside the container

The container definitions do **not** run `./configure` or `make` for you automatically. After the environment is ready, build from `/unicon` as usual, for example:

```sh
cd /unicon
./configure
make -j
make Test
```

If this clone was previously configured or built **on the host** or **in another dev container**, run **`make distclean`** before **`./configure`** here so you do not reuse stale artifacts or permissions from the other environment (see [Clean rebuilds when switching environments](#clean-rebuilds-when-switching-environments)).

Install any extra packages your chosen `./configure` options require (graphics, SSL, and so on) with that image’s package manager (`apt`, `dnf`, `apk`, etc.).

**Alpine** uses **musl** instead of **glibc**. Behavior and third-party libraries can differ from Debian- or Fedora-class systems; use it when you explicitly want to test that stack.

## Changing or extending configurations

- Edit the **`devcontainer.json`** in the corresponding **`.devcontainer/<name>/`** folder (for example **`ubuntu-24/`** for Ubuntu 24.04).
- See the [dev container specification](https://containers.dev/) for properties such as `image`, `features`, `postStartCommand`, and custom Dockerfiles.

For project-wide contribution rules (tests, sign-off, formatting), see the top-level **[`CONTRIBUTING.md`](../CONTRIBUTING.md)** file.
