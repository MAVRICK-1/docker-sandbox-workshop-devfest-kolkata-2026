# Lab 5: Network policy, secrets, ports

## Network policy (deny by default)
```bash
sbx policy ls                                   # see active rules
sbx policy allow network registry.npmjs.org     # allow one host
sbx policy allow network "*.example.com:443"    # allow a pattern and port
sbx policy log                                  # see what was allowed or blocked
```
Outbound traffic is blocked unless a rule allows it. The built-in allowlist has broad wildcards, so review it and remove what you do not need. Org admins can manage policy centrally on a paid plan.

## Secrets
```bash
sbx secret set       # store a secret on the host
sbx secret ls
sbx secret rm
```
Secrets live on the **host**. The agent sees a fake placeholder; a proxy outside the VM swaps in the real value for approved requests. A tricked agent cannot leak a key it never had.

## Ports
```bash
sbx port ls
sbx port publish     # expose a sandbox port to the host
sbx port unpublish
```

## MCP servers and skills
```bash
sbx mcp ls
sbx skills ls        # experimental
```
Subcommand names come from the CLI reference. Run `sbx COMMAND --help` for flags.
