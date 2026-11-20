# Lab 0: Setup

## What you need
1. **Docker Desktop** with Model Runner (Desktop 4.41+ on Windows, 4.40+ on macOS) or **Docker Engine** on Linux.
2. **The `sbx` CLI**: the free Docker Sandboxes tool. Installed in Lab 3.
3. **A Docker account**: you sign in once with `sbx login`.
4. **An agent API key**: bring your own key for the coding agent you choose (Claude Code, Codex, etc.).

## Check Docker works
```bash
docker version
docker run --rm hello-world
```
- `docker version` shows client and server versions. If the server part errors, Docker Desktop is not running.
- `hello-world` pulls a tiny image and prints a message. It proves the engine works.

## Locked-down laptop?
Cloud Sandboxes need no local virtualization. See [Lab 7](07-cloud-sandboxes.md).
