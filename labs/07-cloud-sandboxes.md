# Lab 7: Cloud Sandboxes

Same microVM idea and same CLI, but the sandbox runs in Docker's cloud. Needs `sbx` 0.42.0 or newer, `sbx login`, and a plan that includes it. Good fallback for laptops that cannot run local virtualization.

```bash
sbx --cloud create --name cloud-project --allow-network github.com:443 claude
sbx --cloud exec cloud-project git clone https://github.com/docker/welcome-to-docker.git
```

## Cloud-aware commands
| Command | Purpose |
|---|---|
| `sbx --cloud COMMAND` | Send a supported command to the cloud API |
| `sbx move` | Move a sandbox between local and cloud; filesystem comes along |
| `sbx attach` | Connect to a cloud sandbox, starting it if stopped |
| `sbx ttl` | Show or extend time to live |
| `sbx schedule` | Scheduled cloud runs: create, ls, inspect, run, runs, update, rm |
| `sbx volume --cloud` | Persistent volumes (cloud only) |

Cloud has no local workspace path. Local and cloud keep **separate** credentials and network policies.
