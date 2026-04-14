# Hermes Agent Wrapper

This repository is a wrapper around the upstream Hermes Agent source from [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent).

The application source no longer lives at the wrapper root. It is pinned as a git submodule at:

- `upstream/hermes-agent`

The current pinned upstream release lineage is:

- upstream tag: `v2026.4.13`
- upstream commit: `1af2e18d408a9dcc2c61d6fc1eef5c6667f8e254`

## Clone and update

Clone with submodules:

```bash
git clone --recurse-submodules git@github.com:ndizazzo/hermes-agent.git
```

If you already cloned the wrapper:

```bash
git submodule update --init --recursive
```

## Repository layout

- wrapper-owned files live at the repo root
- upstream application code lives in `upstream/hermes-agent`
- nested upstream submodules such as `mini-swe-agent` and `tinker-atropos` are owned by the upstream submodule, not by the wrapper root

## Build from the pinned upstream source

Python artifacts:

```bash
cd upstream/hermes-agent
python -m build --sdist --wheel
```

Docker image smoke build:

```bash
docker build -f upstream/hermes-agent/Dockerfile upstream/hermes-agent
```

## Updating the pinned upstream version

Move the submodule to the desired upstream tag or commit, then commit the wrapper change:

```bash
git -C upstream/hermes-agent fetch --tags
git -C upstream/hermes-agent checkout <upstream-tag-or-commit>
git add upstream/hermes-agent .gitmodules
```

If the upstream submodule set changes, refresh nested submodules too:

```bash
git submodule update --init --recursive
```

## Release flow

Wrapper release tags publish artifacts for whatever upstream revision is pinned by `upstream/hermes-agent`.

GitHub Actions in this repository:

- check out the wrapper tag with `submodules: recursive`
- build Python artifacts from `upstream/hermes-agent`
- build and publish the Docker image from `upstream/hermes-agent/Dockerfile`

That keeps wrapper metadata and release automation in this repository while leaving the Hermes application source under upstream control.
