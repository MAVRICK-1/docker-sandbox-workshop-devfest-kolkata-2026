# Docker Offload command cheat sheet

| Command / flag | Meaning |
|---|---|
| `docker offload create` | Create your cloud engine, or connect to the existing one |
| `docker --cloud CMD` | Run any Docker command against the cloud engine |
| `docker offload stop` | Pause (state kept) |
| `--cpus`, `--memory` | Size at creation (default 4 vCPUs, 8 GiB) |
| `--idle-timeout` | Idle time before auto-pause (default 5 min) |
| `--keep-alive` | Disable idle pausing |
| `--context` | Run one command against your local daemon |

Running = billable. Paused = not billed. Source: docs.docker.com/offload/core-concepts
