# Lab 3: Your first sandboxed agent

**Idea:** each agent session runs in its own **microVM** with its own kernel and private Docker engine. Your laptop sits outside the fence.

## Install
macOS:
```bash
brew trust docker/tap && brew install docker/tap/sbx
```
Windows:
```powershell
winget install Docker.sbx
```
Linux (Ubuntu): install `docker-sbx` with apt (see docker.com/products/docker-sandboxes).

## Sign in and run
```bash
sbx login            # sign in to Docker
cd ~/projects/hello  # any small project folder
sbx run claude       # create a sandbox and attach to the agent
```
- `sbx run AGENT [PATH...]` creates a sandbox and attaches. Defaults to the current folder.
- Swap `claude` for `codex` or another supported agent: Claude Code, Codex, Copilot, Cursor, Devin, Docker Agent, Droid, Kiro, OpenCode, or a plain shell.
- You bring your own model key. No permission prompts: the sandbox is the safety.

## Useful follow-ups
```bash
sbx ls                       # list sandboxes
sbx exec -it NAME bash       # open a shell inside
sbx stop NAME                # stop, keep it
sbx rm NAME                  # delete the sandbox and its VM
sbx run claude --branch my-feature   # agent gets its own Git worktree
```

## What is mounted
- Your project folder (workspace): read-write
- Optional extra folders: add `:ro` for read-only
- Skills store: read-only
- Nothing else from your home folder

## Check yourself
- Why is a microVM safer than a plain container? It has its own kernel instead of sharing yours.
