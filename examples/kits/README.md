# Example kits

| Folder | Kind | What it does |
|---|---|---|
| [req-echo](req-echo) | mixin | Adds a `req-echo` command, allows only `httpbin.org`, and gives the agent a short note about the tool |
| [greet](greet) | mixin | Smallest kit in the Dockerfile form: `greet.yaml` + `greet.dockerfile` + `context.md` |
| [gojq](gojq) | mixin | Adds the `gojq` JSON tool, built in a separate stage so only the binary ships |
| [../kit-set.yaml](../kit-set.yaml) | set | Bundles other published kits into one reference |

The first three are **mixins**: they add to a workload (Docker's shell kit) instead of replacing it. Spec v3 is experimental and needs `sbx` 0.45 or newer.
Source: docs.docker.com/ai/sandboxes/customize (kit examples and authoring patterns). Validate with a build before you trust a file.
