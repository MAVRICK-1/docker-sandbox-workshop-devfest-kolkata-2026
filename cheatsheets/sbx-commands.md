# sbx command cheat sheet

Global flags: `--cloud`, `-D/--debug`, `--no-input`, `--version`. Source: docs.docker.com/reference/cli/sbx. Run `sbx COMMAND --help` for flags.

## Run and manage
| Command | What it does |
|---|---|
| `sbx run AGENT [PATH...]` | Create a sandbox and attach (default: current folder) |
| `sbx create AGENT\|KIT [PATH...]` | Create without attaching |
| `sbx ls` | List sandboxes (`-q` names, `--format json`) |
| `sbx exec -it NAME bash` | Run a command inside, e.g. a shell |
| `sbx stop NAME` | Stop without removing |
| `sbx rm NAME` | Remove the sandbox, VM and contents |
| `sbx prune` | Remove all stopped sandboxes |
| `sbx inspect NAME` | Show details |
| `sbx cp` | Copy files between sandbox and host |

## Account, health, housekeeping
| Command | What it does |
|---|---|
| `sbx login` / `sbx logout` | Sign in / stop local sandboxes and sign out |
| `sbx setup` | Experimental: detect host config |
| `sbx diagnose` | Check installation |
| `sbx df` | Disk usage |
| `sbx reset` | Reset all sandboxes (`--force --preserve-secrets`) |
| `sbx tui` | Interactive dashboard |
| `sbx version`, `sbx completion` | Version, shell completion |
| `sbx daemon` | start, stop, restart, status, log-level |
| `sbx settings` | ls, get, set, unset |

## Policy, secrets, ports, MCP, skills
| Command | What it does |
|---|---|
| `sbx policy` | allow/deny/rm network, ls, log, inspect, init, reset, refresh, check, approval |
| `sbx secret` | set, set-custom, import, ls, rm (stored on host, injected by proxy) |
| `sbx port` | ls, publish, unpublish |
| `sbx mcp` | add, ls, inspect, load, unload, rm, auth |
| `sbx skills` | Experimental: add, import, ls, rm, update |

## Templates, kits, environments
| Command | What it does |
|---|---|
| `sbx template` | save, load, ls, inspect, rm |
| `sbx kit` | Experimental: add, inspect, validate, pack, push, pull, sign, verify, provenance, builder |
| `sbx env` | Experimental: declarative `sbxenv.yaml`: create, run, exec, plan, rm |

## Cloud
`sbx --cloud COMMAND`, `sbx move`, `sbx attach`, `sbx ttl`, `sbx schedule`, `sbx volume --cloud`.
