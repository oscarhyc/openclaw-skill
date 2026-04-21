# NanoBanana API — Grsai Platform Reference

## Platform
**Grsai API** — https://grsai.com  
(Recommended over nanobananaapi.ai — better pricing, 5,000 base credits)

## Base URL
```
https://grsaiapi.com       # Global
https://grsai.dakka.com.cn  # China direct
```

## Authentication
```
Authorization: Bearer <API_KEY>
```

## Generate Image — POST `/v1/draw/nano-banana`

### Request
```json
{
  "prompt": "A vintage Hong Kong street scene with a red bus",
  "model": "nano-banana",
  "image_size": "1K",
  "n": 1
}
```

### Response — SSE Stream (newline-delimited JSON)

Each line starts with `data:` prefix:

```json
data: {"id":"xxx","results":null,"progress":1,"status":"running","failure_reason":"","error":"","callback_url":"","start_time":xxx,"end_time":0}
data: {"id":"xxx","results":null,"progress":50,"status":"running","failure_reason":"","error":"","callback_url":"","start_time":xxx,"end_time":0}
data: {"id":"xxx","results":[{"url":"https://...png","content":""}],"progress":100,"status":"succeeded","failure_reason":"","error":"","callback_url":"","start_time":xxx,"end_time":xxx}
```

### Parse response
```bash
# Capture all output
RESULT=$(curl -s --max-time 90 -X POST ...)

# Check for error (not SSE)
if echo "$RESULT" | grep -q '"code"'; then
  echo "Error: $(echo $RESULT | grep -o 'msg\":\"[^\"]*')"
  exit 1
fi

# Get final line
FINAL=$(echo "$RESULT" | grep '^data:' | tail -1)

# Extract status
STATUS=$(echo "$FINAL" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

# Extract URL
IMG_URL=$(echo "$FINAL" | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)
```

## Model Options

| Model | Credits | Status |
|-------|---------|--------|
| `nano-banana` | Base credits (5,000) | ✅ Available |
| `nano-banana-2` | Separate top-up needed | ⚠️ May show insufficient credits |
| `nano-banana-pro` | Separate top-up needed | ❌ Insufficient credits |

## Status Values

| Status | Meaning |
|--------|---------|
| `running` | In progress |
| `succeeded` | Done — URL in `results[0].url` |
| `failed` | Failed — check `failure_reason` |

## Error Responses

```json
{"code":-1,"data":null,"msg":"insufficient credits"}
{"code":-1,"data":null,"msg":"..."}
```

## Image Sizes

- `1K` — standard (default)

## Notes

- Response is **SSE streaming** — keep reading until `status: succeeded` or `failed`
- `nano-banana-2` uses the same endpoint, just set `model` param
- Image URLs may expire — download promptly
- China host (`grsai.dakka.com.cn`) for mainland China users
