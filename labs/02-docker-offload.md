# Lab 2 (optional): Docker Offload

**Idea:** your laptop is tired. Offload runs Docker work on a stronger cloud machine while you keep using the same commands.

Needs Docker Desktop 4.97+ and a Docker plan that includes Offload. Check docs.docker.com/offload for current plans and pricing.

## Commands
```bash
docker offload create        # create your cloud engine (or connect to the one you have)
docker --cloud build .       # run any Docker command against the cloud engine
docker offload stop          # pause it; state is kept
```

## Options
| Flag | Meaning |
|---|---|
| `--cpus`, `--memory` | Size at creation. Default 4 vCPUs and 8 GiB |
| `--idle-timeout` | How long idle time lasts before auto-pause (default 5 minutes) |
| `--keep-alive` | Turn off idle pausing |
| `--context` | Run one command against your local daemon instead |

## Running vs paused
- **Running:** connected and billable. Builds and containers run on cloud hardware.
- **Paused:** not billed. Containers, images and volumes are kept. Any command resumes it.

**Remember:** stop it when you finish. The cloud is someone else's computer, but the bill is yours.

GPUs: the current docs page does not mention them. Older beta Offload offered NVIDIA L4, so check before promising GPU.
