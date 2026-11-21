# Lab 6: Build your own kit

**Idea:** a kit is a recipe card for a sandbox: tools, rules and settings, shared as an OCI image. Think npm package, but for agent environments. Spec v3 is **experimental**. You need `sbx` 0.45 or newer and Docker with Buildx.

## Kinds
- **workload**: a full environment (Docker publishes `docker.io/sbx/shell:latest`)
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
sbx run docker.io/sbx/shell:latest --name req-echo-before
req-echo            # expect: command not found
exit

# 1. validate: building checks the descriptor strictly
docker buildx build -f req-echo/req-echo.yaml -t req-echo:dev req-echo/

# 2. run the kit locally, no registry needed

SBX_KIT_BUILDER=sandbox sbx run docker.io/sbx/shell:latest --name req-echo-test --kit ./req-echo

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

sbx run docker.io/sbx/shell:latest --kit docker.io/<NAMESPACE>/req-echo:1.0.0 .
```
Replace `<NAMESPACE>` with your Docker Hub username. Keep a Docker engine running while you build.

**Use a container builder for publishing.** A push through the default `docker` driver with the classic image store can drop the kit descriptor, so the image no longer looks like a kit. Create a container builder once and select it:
```bash
docker buildx create --name kit-builder --driver docker-container --bootstrap
docker buildx build --builder kit-builder ./req-echo -f ./req-echo/req-echo.yaml \
  -t docker.io/<NAMESPACE>/req-echo:1.0.0 --push
```
For kits shared as multi-platform images, add `--platform linux/amd64,linux/arm64 --provenance=mode=min`.

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
sbx run docker.io/sbx/shell:latest --name greet-test --kit ./greet
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

## Kit sets
Source: [docs.docker.com/ai/sandboxes/customize/author/kit-sets](https://docs.docker.com/ai/sandboxes/customize/author/kit-sets/)

A set is a v3 kit with `kind: set` that bundles existing kits into one kit your team can run. It holds one workload and any number of mixins, or only mixins that users add to a workload with `--kit`. Example: [examples/kit-set.yaml](../examples/kit-set.yaml).

```yaml
# syntax=docker/sandbox-kit:3
schemaVersion: "3"
kind: set
displayName: Codex with req-echo
version: "1.0.0"
kits:
  - ref: docker.io/docker/sbx-kit-codex:0.155.1
  - ref: docker.io/NAMESPACE/req-echo:1.0.0
```

- Each `ref` must be a published registry reference. Local paths and Git URLs are not accepted, so publish `req-echo` first (see Share your kit).
- A set has no Dockerfile and no `build:` block.
- Shared settings go on the set. For example, a `network-policy@1` capability for extra domains. Keep tool-specific access in the tool's own kit.
- Fix or expose arguments on a component:
  ```yaml
  args:
    lint_mode:
      default: check
      enum: [check, fix]
  kits:
    - ref: docker.io/my-org/linter-kit:1.0.0
      args:
        mode: ${{ kit.args.lint_mode }}
  ```
  Users then run the published set with `--kit-arg lint_mode=fix`.

Build and publish a set like any other kit, then run it:
```bash
docker buildx build ./codex-tools -f ./codex-tools/codex-tools.yaml \
  -t docker.io/NAMESPACE/codex-tools:1.0.0 --push

sbx run docker.io/NAMESPACE/codex-tools:1.0.0 --name my-project            # set with a workload
sbx run WORKLOAD_REFERENCE --kit docker.io/NAMESPACE/codex-tools:1.0.0     # mixins-only set
```

Rules:
- At most one workload per set. The build fails if more than one kit is a workload.
- The build fails if a dependency is missing or two kits declare the same feature in `provides`.
- Reordering `kits:` does not change the order. Dependencies apply first. Give component files separate paths.
- A published set records each component's exact image digest. Existing sandboxes keep the kit configuration they were created with, so create a new sandbox to use an updated set.
- If you add instructions through `agent-context` on the set, leave out the filename.

## Troubleshooting kits
Source: [github.com/docker/sandbox-kit-spec](https://github.com/docker/sandbox-kit-spec)

- **Workload image:** the labs use `docker.io/sbx/shell:latest`, which works with local `--kit` builds. `docker/sbx-kit-shell` is not published on Docker Hub.
- **401 when pulling a kit:** run `sbx login` (and `docker login`) and retry.
- **A local kit build fails** because the host builder cannot export OCI: run with `SBX_KIT_BUILDER=sandbox sbx run ...` to build in a dedicated builder sandbox instead. `SBX_KIT_BUILDER=host` forces the host builder.
- **Linux:** install with `sudo apt install docker-sbx`, then `sudo usermod -aG kvm $USER` and log in again so `/dev/kvm` works before `sbx run`. Then run `sbx login`.
- **Workload base images** must provide bash, the `agent` user (uid 1000), git and a CA store. A kit built on a bare distro image builds but fails when the agent launches.
- **Check a published kit** with `kit-tck validate docker.io/NAMESPACE/req-echo:1.0.0` (the spec repo's checker). A successful push alone does not prove the descriptor survived.
