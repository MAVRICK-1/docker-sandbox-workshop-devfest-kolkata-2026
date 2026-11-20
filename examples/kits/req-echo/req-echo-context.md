# req-echo

`req-echo <path> [curl options]` sends a request to
`https://httpbin.org/anything/<path>` and prints what the server received.

Use it when debugging HTTP client code. httpbin.org is public: never send
real credentials or customer data to it.
