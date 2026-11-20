#!/usr/bin/env bash
# Call Docker Model Runner through its OpenAI-compatible API.
curl http://localhost:12434/engines/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"ai/smollm2","messages":[{"role":"user","content":"Explain Docker in one line"}]}'
