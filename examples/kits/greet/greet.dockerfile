# syntax=docker/dockerfile:1
FROM scratch
COPY --chmod=0755 <<'EOF2' /usr/local/bin/greet
#!/bin/sh
echo "Hello from a kit, ${1:-world}!"
EOF2
