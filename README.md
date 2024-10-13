# 🌋 Tephrite

Build and publish Conda packages from Mojo projects.

**⚠️ Warning 🧪 Experimental Code 🚧 Under Construction**

Build Mojo packages with [`mojo package`](https://docs.modular.com/mojo/cli/package).

Build and publish Conda packages from Mojo packages with `tephrite build` and `tephrite publish`.

Search, add, and install Conda Mojo packages with the [Magic](https://docs.modular.com/magic/) package manager for Mojo projects.

# 🔌 Use

Build Conda packages with `tephrite build [<dir>]` from the recipe in directory `<dir>`.
If `<dir>` is not specified, then build from `recipe`.
This stores the package in directory `target/conda`.

Publish Conda packages with `tephrite publish` after `magic run anaconda login`.
This uploads the package specified in the recipe from directory `target/conda`.

Just `tephrite` without arguments prints the usage.

Search for packages with [`magic search [-c <channel>] <package>`](https://docs.modular.com/magic/commands#magic-search).

Add and install packages with [`magic add <package>`](https://docs.modular.com/magic/commands#magic-add) and
[`magic install`](https://docs.modular.com/magic/commands#magic-install).

Import and use [Mojo packages](https://docs.modular.com/mojo/manual/packages).

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

## Package Versions

Magic is based on Conda and [Conda's package version specifiers](https://docs.conda.io/projects/conda-build/en/latest/resources/package-spec.html#package-match-specifications)
are based on [Python version specifiers](https://packaging.python.org/en/latest/specifications/version-specifiers/).

Python version specifiers and [Semantic Versioning (SemVer)](https://semver.org/) are [not fully compatible](https://packaging.python.org/en/latest/specifications/version-specifiers/#semantic-versioning).

Use SemVer for the first three components of the [release segment](https://packaging.python.org/en/latest/specifications/version-specifiers/#final-releases).
Use Python pre- and developmental releases instead of SemVer pre-releases.

# 🪛 Develop

with [Git](https://git-scm.com/book),
[Mojo](https://docs.modular.com/mojo/manual/),
[conda-build](https://docs.conda.io/projects/conda-build/en/stable/), and
[anaconda](https://docs.anaconda.com/anacondaorg/commandreference/).

1. Clone with `git clone https://github.com/gerald-scharitzer/tephrite.git`
2. Enter with `cd tephrite`
3. Update with `magic update [-n]`

## ♻️ Cycle

1. Clean with `magic run clean`
2. Run with `magic run main`
3. Test with `magic run test`
4. Build with `magic run mojo-build`
5. Execute with `magic run target/tephrite`
6. Pack with `magic run mojo-pack`
7. Build Conda package with `magic run build` or `magic run target/tephrite b`

## 🚢 Release

1. Branch with `git branch version` and `git checkout version` where `version` is the next release.
2. Sync `VERSION` in [`mojoproject.toml`](mojoproject.toml), [`meta.yaml`](meta.yaml), [`tephrite/__init__.mojo`](src/tephrite/__init__.mojo), and [`test_tephrite.mojo`](src/test_tephrite.mojo)
3. Sync `USAGE` in [`cli.mojo`](src/cli.mojo) and [`README.md` section "Use"](#-use)
4. Sync `description` in [`mojoproject.toml`](mojoproject.toml), [`meta.yaml`](recipe/meta.yaml), and [`main.mojo`](src/main.mojo).
5. Run the [development cycle](#cycle)
6. Upload Conda package with `magic run anaconda upload target/conda/noarch/tephrite-version-0.tar.bz2` where `version` is the [semantic Python version](https://packaging.python.org/en/latest/specifications/version-specifiers/#semantic-versioning), or with `magic run target/tephrite p`
7. Document with `magic run doc`
8. Stage with `git add .`
9. Commit with `git commit -m "message"` where `message` describes the changes
10. Push branch with `git push` or push new branch with `git push --set-upstream origin branch` where `branch` is the version.
11. Tag with `git tag version` where `version` is the semantic Python version
12. Push tag with `git push origin tag` where `tag` is the version

## ✨ Feature

1. Branch with `git branch feature` and `git checkout feature` where `feature` is the new feature.

# 📋 Backlog

Build with [Rattler](https://github.com/prefix-dev/rattler-build) instead of Conda to:
- pack platform-specific binaries from `mojo build` into the `bin` directory
- utilize Conda recipe version 2
- build `.conda` packages

Build Conda packages as [`.conda` files](https://docs.conda.io/projects/conda-build/en/stable/resources/package-spec.html).

Build and package binaries as platform-specific Conda packages.

Provide binaries and Mojo packages as Conda package features.

Authenticate to Anaconda with token.

Sync `mojoproject.toml` to Conda recipe.

Upload to [prefix.dev](https://prefix.dev/docs/prefix/api#uploading-a-package-via-api) via API.

`mojo doc` all source files, when it can generate something more human-readable than JSON.

Process packages independent from their containing file system structure.

- unit tests
- integration tests
- doc tests
- review license

## ⚠️ Issues

Array of literals cannot be subscripted (runtime error).

Code diagnostics cannot resolve imports from nested tests.

Not specifying `about.license_family` causes invalid license "BSD 3-Clause" in info/index.json.
