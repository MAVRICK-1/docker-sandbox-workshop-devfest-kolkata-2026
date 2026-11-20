# Lab 4: Build your own kit

**Idea:** a kit is a recipe card for a sandbox: tools, rules and settings, shared as an OCI image. Think npm package, but for agent environments. Spec v3 is **experimental**. You need `sbx` 0.45 or newer and Docker with Buildx.

## Kinds
- **workload**: a full environment (Docker publishes `docker.io/docker/sbx-kit-shell:1.0.0`)
- **mixin**: adds pieces to a workload. Most kits are mixins.
- **set**: a bundle of other kits ([examples/kit-set.yaml](../examples/kit-set.yaml))

## The kit files for this lab
Folder: [examples/kits/req-echo](../examples/kits/req-echo)
```
req-echo/
├── req-echo.yaml          # the descriptor
└── req-echo-context.md    # a note for the agent
```
What `req-echo.yaml` does, line by line:
- `# syntax=docker/sandbox-kit:3` must be the first line.
- `kind: mixin` means "add to a workload, do not replace it".
- `build:` is a small Dockerfile that creates one script, `req-echo`, inside the sandbox.
- `network-policy@1` allows **only** `httpbin.org` while the kit runs.
- `agent-context@1` hands the agent the text in `req-echo-context.md`, so it knows the tool exists.

A second example, [gojq](../examples/kits/gojq), shows a multi-stage build.

## Spec rules (v3)
- First line must be the syntax line.
- No `name`, `image`, `entrypoint` or `env` in the descriptor. Identity is the reference you use.
- Unknown fields are errors, so a typo fails the build.
- Capabilities are typed and versioned, e.g. `com.docker.sandbox/network-policy@1`, `agent-context@1`, `credential@1`, `lifecycle@1`, `volume@1`, `port@1`.

## Steps
Run these from the folder that contains `req-echo/`.

```bash
# 0. baseline: no kit, the command is missing
sbx run docker/sbx-kit-shell:1.0.0 --name req-echo-before
req-echo            # expect: command not found
exit

# 1. validate: building checks the descriptor strictly
docker buildx build -f req-echo/req-echo.yaml -t req-echo:dev req-echo/

# 2. run the kit locally, no registry needed
sbx run docker/sbx-kit-shell:1.0.0 --name req-echo-test --kit ./req-echo

# 3. inside the sandbox: use it, then try something the kit does not allow
req-echo 'orders?status=open'     # works: JSON echo from httpbin.org
curl -sS https://postman-echo.com/get   # blocked: only httpbin.org is allowed

# 4. clean up (on your host)
sbx rm req-echo-test -f
```

## Publish and run from the registry
```bash
docker login
docker buildx build ./req-echo -f ./req-echo/req-echo.yaml \
  -t docker.io/<NAMESPACE>/req-echo:1.0.0 --push

sbx run docker/sbx-kit-shell:1.0.0 --kit docker.io/<NAMESPACE>/req-echo:1.0.0 .
```
Replace `<NAMESPACE>` with your Docker Hub username. Keep a Docker engine running while you build.

## Other kit commands
`sbx kit add | inspect | pack | push | pull | sign | verify | provenance`. Flags may change: check `sbx kit --help`.

**Note on `sbx kit validate`:** it expects the older kit layout, a folder with `spec.yaml` (schema v1/v2). A v3 kit like `req-echo` has a `<name>.yaml` descriptor instead, so `sbx kit validate ./req-echo` fails with "spec.yaml (or spec.yml) is required". For v3, validate by building (step 1 above).

Community kits: github.com/docker/sbx-kits-contrib
Sources: docs.docker.com/ai/sandboxes/customize/kit-examples, docs.docker.com/learn/content/build-your-first-sandbox-kit

## Authoring guide: the Dockerfile form

Source: [docs.docker.com/ai/sandboxes/customize/author](https://docs.docker.com/ai/sandboxes/customize/author/)

Keep each kit in its own directory. A kit has a YAML descriptor (workload, mixin or set) and, usually, a Dockerfile. If there is a Dockerfile, its name must match the descriptor: `greet.yaml` pairs with `greet.dockerfile`.

```text
greet/
├── greet.yaml
├── greet.dockerfile
└── context.md
```

The smallest example is in `examples/kits/greet`. The descriptor does not hold the build recipe, the Dockerfile does. The inline `build: |` form used by `req-echo` is the other way.

Build it, then run it:

```bash
docker buildx build -f greet/greet.yaml -t greet:dev greet/
sbx run docker/sbx-kit-shell:1.0.0 --name greet-test --kit ./greet
```

Inside the sandbox: `greet Kolkata`.

### Which capability to use
- `network-policy@1`: which domains the kit may reach (see `req-echo`).
- `agent-context@1`: a note that tells the agent what the kit adds.
- `resources@1`: default CPU and memory for a workload. Put it on the workload, because sbx ignores it on a mixin.
- `long-running@1`: keep a local sandbox running after sessions end. It takes no config:

```yaml
capabilities:
  - type: com.docker.sandbox/long-running@1
```

Add `optional: true` if the kit still works when the sandbox stops automatically.

Capabilities belong to the kit. A plain `docker build` does not apply them.

### Where to put setup work
| Put it in | It runs |
|---|---|
| Dockerfile `RUN` and `COPY` | when the image builds |
| lifecycle `install` hooks | once, at sandbox creation, before the agent starts |
| lifecycle `files` | at creation, after install hooks |
| lifecycle `startup` hooks | every sandbox start, so make them safe to repeat |

Install hooks get only basic variables. Name anything else in the hook's `env` list. Full field reference: the [lifecycle@1 definition](https://github.com/docker/sandbox-kit-spec/blob/main/docs/spec/capabilities/com.docker.sandbox/lifecycle@1.md).

> The `greet` files follow the layout in the docs but were not run end to end. Build before you trust them.

### Share your kit
Source: [docs.docker.com/ai/sandboxes/customize/author/distribute](https://docs.docker.com/ai/sandboxes/customize/author/distribute/)

```bash
docker login
docker buildx build ./greet -f ./greet/greet.yaml \
  --platform linux/amd64,linux/arm64 \
  -t docker.io/NAMESPACE/greet:1.0.0 --push

sbx kit sign docker.io/NAMESPACE/greet:1.0.0
sbx kit verify docker.io/NAMESPACE/greet:1.0.0 \
  --certificate-identity SIGNER_IDENTITY \
  --certificate-oidc-issuer ISSUER_URL
```

Share through Git instead with a reference like `git+https://github.com/ORG/REPO.git#ref=COMMIT&dir=greet`. Git and folder kits cannot be signed.

- `sbx` pulls published images. It cannot use an image that exists only in your local Docker store. While developing, pass the folder with `--kit ./greet`.
- `docker run` applies only the image config, not the kit settings or hooks. Run kits with `sbx`.
- `sbx kit pack`, `push` and `pull` are for v1 and v2 kits. Use Buildx for v3.
