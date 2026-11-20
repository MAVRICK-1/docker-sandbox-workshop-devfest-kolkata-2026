# Let Your AI Agent Code, Not Compromise

Hands-on lab guide for the Pre-DevFest Workshop at **DevFest Kolkata 2026** (21 Nov 2026, Sister Nivedita University).
Speaker: Rishi Mondal (Docker Ambassador, CNCF Kubestronaut).

AI coding agents are useful, but they run commands for you. One bad command and your home folder, keys or database can go. This workshop shows how to give agents a **fence**: Docker Sandboxes (`sbx`), plus local models (Model Runner) and cloud help (Offload).

## The big idea in one line
The sandbox is the safety, not the permission prompt. Prompts depend on a human paying attention; a wall does not.

## What is in this repo
| File | What you do |
|---|---|
| [labs/00-setup.md](labs/00-setup.md) | Install and check everything |
| [labs/01-model-runner.md](labs/01-model-runner.md) | Run an AI model on your laptop |
| [labs/02-docker-offload.md](labs/02-docker-offload.md) | Borrow a cloud machine for heavy work |
| [labs/03-first-sandbox.md](labs/03-first-sandbox.md) | Install `sbx` and run your first sandboxed agent |
| [labs/04-break-it-on-purpose.md](labs/04-break-it-on-purpose.md) | Try to escape the sandbox |
| [labs/05-network-policy-secrets.md](labs/05-network-policy-secrets.md) | Control network, secrets, ports |
| [labs/06-kits.md](labs/06-kits.md) | Build, test and publish a kit |
| [labs/07-cloud-sandboxes.md](labs/07-cloud-sandboxes.md) | Run the same sandbox in the cloud |
| [cheatsheets/sbx-commands.md](cheatsheets/sbx-commands.md) | Every `sbx` command in one page |
| [cheatsheets/docker-offload-commands.md](cheatsheets/docker-offload-commands.md) | Every Offload command and flag |
| [troubleshooting.md](troubleshooting.md) | Common problems |
| [examples/](examples) | Copy-paste files |

## How to use it
Do the labs in order. Each one explains **what the command does**, **what you should see**, and **why it matters**.

## Honest notes
- Docker moves fast. Features marked *experimental* can change. Check `sbx COMMAND --help` and the official docs if something differs.
- Kits spec v3 is experimental and not final.
- Cloud features need a Docker account and a plan that includes them.

## Sources
- docs.docker.com/ai/model-runner
- docs.docker.com/ai/sandboxes (and `/security`, `/cloud`)
- docs.docker.com/reference/cli/sbx
- docs.docker.com/offload/core-concepts
- github.com/docker/sandbox-kit-spec
