# Lab 6: Build your own kit

**Idea:** a kit is a recipe card for a sandbox: tools, rules and settings, shared as an OCI image. Think npm package, but for agent environments. Spec v3 is **experimental**.

## Kinds
- **workload**: a full environment
- **mixin**: adds pieces to another kit
- **set**: a bundle of other kits

Example: [examples/kit-set.yaml](../examples/kit-set.yaml)

## Spec rules (v3)
- First line must be `# syntax=docker/sandbox-kit:3`.
- No `name`, `image`, `entrypoint` or `env` in the descriptor. Identity is the reference you use.
- Unknown fields are errors.
- Capabilities are typed and versioned, e.g. `volume@1`, `port@1`, `privileged@1`, `kit-registry@1`. Community kits also use `network-policy@1`, `credential@1`, `lifecycle@1`.
- A workload base needs bash, user `agent` (uid 1000), git and a CA store.

## Steps
```bash
# 1. check your kit folder
sbx kit validate ./my-kit && sbx kit inspect ./my-kit

# 2. try locally, no registry needed
sbx create --name my-kit ./my-kit ~/projects/hello
sbx run ./hello --kit ./gh .

# 3. build as an OCI image and push
docker buildx build . -f my-kit.yaml --push -t docker.io/me/my-kit:1.0.0

# 4. run anywhere, local or cloud
sbx run docker/sbx-kit-shell:1.0.0 --kit docker.io/me/my-kit:1.0.0 .
sbx --cloud run docker/sbx-kit-shell:1.0.0 --kit docker.io/me/my-kit:1.0.0
```
Replace `me` with your Docker Hub username. Building a local kit uses the host Docker API, so keep a Docker engine running. Flags may change: check `sbx kit --help`.

## Other kit commands
`sbx kit add | inspect | validate | pack | push | pull | sign | verify | provenance`

Community kits: github.com/docker/sbx-kits-contrib
