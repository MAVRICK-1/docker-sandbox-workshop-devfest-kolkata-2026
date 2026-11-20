# Troubleshooting

| Problem | Try this |
|---|---|
| `docker version` shows no server | Start Docker Desktop and wait until it says running |
| `docker model` not found | Update Docker Desktop to a version with Model Runner |
| `localhost:12434` refuses connection | Enable host TCP support in Docker Desktop settings (AI section) |
| `sbx` not found | Re-run the install command for your OS, open a new terminal |
| Sandbox will not start on my laptop | Run `sbx diagnose`; if virtualization is blocked, use Cloud Sandboxes (Lab 7) |
| Agent cannot reach a website | Expected: deny by default. Allow it with `sbx policy allow network HOST` |
| Something is badly broken | `sbx reset --force --preserve-secrets` |
| Disk full | `sbx df`, then `sbx prune` |

When in doubt: `sbx COMMAND --help` and docs.docker.com/ai/sandboxes.
