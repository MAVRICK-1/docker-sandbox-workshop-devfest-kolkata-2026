# Lab 5: Policies, secrets, ports

A **policy** is a set of rules about what a sandbox may reach or mount. There are two sources:
- **Local**: you set it on your machine with `sbx policy`.
- **Organization**: an admin sets it in Docker Home. When it is on, it is the **only** policy in effect. Local rules still show in `sbx policy ls` but as `inactive`.

Three kinds of rules exist:
| Kind | Controls | Who can set it |
|---|---|---|
| Network | Which hosts the agent can reach | Local or org |
| Filesystem | Which host folders can be mounted as a workspace | **Org only** |
| MCP | Which MCP servers and tools can be used | **Org only** |

Within the active policy, **deny beats allow**.

## 1. Pick a preset first
```bash
sbx policy init balanced     # choices: allow-all, balanced, deny-all
```
Until a preset is set, `sbx run` and `sbx create` fail. `balanced` allows common dev hosts (npm, PyPI, GitHub) and denies the rest.

## 2. Network rules (deny by default)
```bash
sbx policy ls                                   # active rules
sbx policy ls --wide                            # more detail, including governance source
sbx policy ls --include-inactive                # also show rules that are switched off
sbx policy allow network registry.npmjs.org     # allow one host
sbx policy allow network "*.npmjs.org,*.pypi.org"   # several at once
sbx policy allow network "*.example.com:443"    # pattern plus port
sbx policy allow network "**"                   # allow everything (use with care)
sbx policy deny network ads.example.com         # block a host
sbx policy rm network ...                       # remove a rule
sbx policy log                                  # what was allowed or blocked
sbx policy reset                                # start over
```
Scope a rule to one sandbox:
```bash
sbx policy allow network --sandbox my-sandbox api.example.com
```
If the agent cannot install packages or call an API, run `sbx policy log` and allow the host it was blocked on.

## 3. Filesystem rules (organization only)
They control which host paths can be **mounted** as a workspace. They do not control individual files inside a mounted folder.
- Actions: `read` and `write`. A writable workspace needs **both**; read-only needs just `read`.
- Use `**`, not `*`: a single `*` does not match across folders. Example: `~/Downloads/**`.
- Without an org policy, a sandbox can mount any folder you can access.
- Checked at creation time. After changing a rule, remove the sandbox and create a new one.

Error you may see:
```
403 Forbidden: mount policy denied: ... fs:mount:read denied: no applicable policies
```
Meaning: an org policy is on and no filesystem rule allows that folder. Fix it in Docker Home, under AI Platform, Filesystem access (or turn governance off for a personal org).

## 4. MCP rules (organization only)
Org admins control which MCP servers can be registered and which tools, resources and prompts they may use. You manage your own servers with `sbx mcp` (below).

## 5. Secrets
```bash
sbx secret set       # store a secret on the host
sbx secret ls
sbx secret rm
```
Secrets live on the **host**. The agent sees a fake placeholder; a proxy outside the VM swaps in the real value for approved requests. A tricked agent cannot leak a key it never had.

## 6. Ports
```bash
sbx port ls
sbx port publish     # expose a sandbox port to the host
sbx port unpublish
```

## 7. MCP servers and skills
```bash
sbx mcp ls
sbx skills ls        # experimental
```

Run `sbx COMMAND --help` for flags. Sources: docs.docker.com/ai/sandboxes/governance
