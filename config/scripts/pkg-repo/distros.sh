# Shared by the Unicon package-repo scripts.
# Keep this list in sync with the Deb/Rpm matrices in .github/workflows/packages.yml.
# canonical_source_dist must be the suite whose amd64 job sets upload_orig: true.

debians="bookworm trixie"
ubuntus="jammy noble resolute"
dist="$debians $ubuntus"
canonical_source_dist="trixie"
deb_arches="amd64 arm64"
source_arch_preference="amd64 arm64"

# Apt components, and the rpm directory under rpm.unicon.org/<variant>/.
#   dev     master snapshots
#   rc      release candidates
#   stable  latest official release
#   13.3    the minor release we publish. Older minors are not built.
# There is no major-only component (no "13").
# "release" is not itself a component. Publishing a release copies the
# packages into every name in release_components (13.3 and stable).
# Add the next minor here when it exists, then re-run init-local-repos.sh.
channels="dev rc stable 13.3"
release_components="13.3 stable"

# Public ids of the key already used by "make debin" (SIGNKEYID in the Makefile).
signkey="A90FC36D9429409798E9C2D874DEED43AB194DBF"
signwith="74DEED43AB194DBF"
