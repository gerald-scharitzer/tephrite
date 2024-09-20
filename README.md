# 🌋 Tephrite

Build Mojo packages from projects.

[Magic](https://docs.modular.com/magic/) is a package manager for Mojo projects.
Build Mojo packages such that they can be published, searched, added, and installed.

**⚠️ Warning 🧪 Experimental Code 🚧 Under Construction**

# 🔌 Use

`tephrite build <dir>` builds a Conda package from the recipe in directory `<dir>`.

Just `tephrite` without arguments prints the usage.

Search, add, and install packages with [`magic` commands](https://docs.modular.com/magic/commands).

## Setup

Install Magic.

[Build](#-develop) the main module, because Mojo does not support main functions in packages yet.

Check the version with `tephrite v`.

# 💡 Rationale

The standard library [`builtin` package](https://docs.modular.com/mojo/stdlib/builtin/) is imported automatically.
The [other standard library packages](https://docs.modular.com/mojo/stdlib/algorithm/functional/)
are imported from the installation directory of the library.
Other packages are imported from the directory of the main module
or directories specified as `-I` options for the commands
[`mojo build`](https://docs.modular.com/mojo/cli/build#-i-path),
[`mojo run`](https://docs.modular.com/mojo/cli/run#-i-path), and
[`mojo package`](https://docs.modular.com/mojo/cli/package#-i-path).

Mojo packages are imported from [directories or package files](https://docs.modular.com/mojo/manual/packages) in the file system.
Installing a package stores it in the file system.

What is the module search order?

# 🪛 Develop

with [Git](https://git-scm.com/book),
[Mojo](https://docs.modular.com/mojo/manual/), and
[conda-build](https://docs.conda.io/projects/conda-build/en/stable/).

1. Clone with `git clone https://github.com/gerald-scharitzer/tephrite.git`
2. Enter with `cd tephrite`
3. Update with `magic update`
4. Start the Magic shell with `magic shell`
5. Test with `mojo test`
6. Run with `mojo src/main.mojo`
7. Build with `mkdir -p target && mojo build -o target/tephrite src/main.mojo`
8. Execute with `target/tephrite`
9. Package with `mojo package -o target src/tephrite`
10. Exit the Magic shell with `logout`
11. Build Conda package with `magic run build`
12. Document with `mojo doc -o target/tephrite-doc.json src/tephrite`
13. Sync `VERSION` in [`meta.yaml`](meta.yaml), [`tephrite/__init__.mojo`](src/tephrite/__init__.mojo), and [`test_tephrite.mojo`](src/test_tephrite.mojo)
14. Sync `USAGE` in [`cli.mojo`](src/cli.mojo) and [`README.md` section "Use"](#-use)
15. Stage with `git add`
16. Commit with `git commit -m "message"` where `message` describes the changes
17. Push branch with `git push`
18. Tag with `git tag version` where `version` is the [semantic version](https://semver.org/)
19. Push tag with `git push origin tag` where `tag` is the version
20. Clean with `rm -r target`

# 📋 Backlog

Publish Mojo packages as Conda packages.

Build Conda packages as [`.conda` files](https://docs.conda.io/projects/conda-build/en/stable/resources/package-spec.html).

`mojo doc` all source files, when it can generate something more human-readable than JSON.

Process packages independent from their containing file system structure.

- magic tasks
- unit tests
- integration tests
- doc tests
- review license

## Issues

Array of literals cannot be subscripted (runtime error).

Code diagnostics cannot resolve imports from nested tests.
