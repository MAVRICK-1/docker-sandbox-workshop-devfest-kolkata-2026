# Lab 1: Docker Model Runner (AI on your laptop)

**Idea:** you already know `docker pull` and `docker run`. Model Runner does the same for AI models. The model runs on your machine, so your prompts and code stay local and there is no per-token fee.

## Step 1: download a small model
```bash
docker model pull ai/smollm2
```
Downloads the model from Docker Hub and stores it locally. Models are packaged like container images (OCI artifacts). A small model is fine for learning.

## Step 2: chat with it
```bash
docker model run ai/smollm2 "Explain Docker in one line"
```
Runs the model once with your prompt and prints the answer. Without a prompt it opens an interactive chat.

## Step 3: see what you have
```bash
docker model ls
```
Lists the models stored on your machine.

## Step 4: call it like OpenAI
Model Runner offers an OpenAI-compatible API, so existing code can point at it.

Host endpoint: `http://localhost:12434/engines/v1`

Host access needs **TCP support** switched on in Docker Desktop settings (AI section). The exact setting name changes between Desktop versions, so look for it there.

```bash
curl http://localhost:12434/engines/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"ai/smollm2","messages":[{"role":"user","content":"Explain Docker in one line"}]}' | jq -r '.choices[0].message.content'
```
`jq -r '.choices[0].message.content'` prints only the answer. Drop it (use `| jq`) to see the full JSON: token counts, timings and the model path.

**Do not worry if the model ignores details** (for example asking for exactly five words). `smollm2` is a very small model: great for learning the API, weak at following strict instructions. Try a bigger model with `docker model pull` later if you want better answers.

From **inside a container**, the same API is reachable at `model-runner.docker.internal`.

## How it works (simple)
- Inference runs **on your host**, outside the Docker Desktop VM, and API calls are proxied to it.
- Engines: **llama.cpp** (GGUF models), **vLLM** (safetensors, Linux with NVIDIA), **Diffusers** (images).

## Check yourself
- Which command downloads a model? `docker model pull`
- Where does the model run? On your own machine.
