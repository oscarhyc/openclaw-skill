---
name: nano-banana-gen
description: Generate AI images using the NanoBanana image generation API. Use when the user wants to create, edit, or generate images via the NanoBanana API. Triggers on: "generate an image", "create an image with nano banana", "nano banana image", "generate picture", "make an image", "create artwork", "generate a photo", or any image generation task.
---

# NanoBanana Image Generator

Generate AI images from text prompts using the **Grsai API** (recommended).

## API Credentials

- **Base URL**: `https://grsaiapi.com` (Global) / `https://grsai.dakka.com.cn` (China)
- **Auth**: `Authorization: Bearer <API_KEY>`
- **API Key**: `sk-019056d7a0a245188c732d754b40ae09` (Oscar / Grsai)
- **Credits**: 5,000 (base Nano Banana only)
- **Key management**: https://grsai.com/dashboard/api-keys

## Workflow (using script)

```bash
~/.openclaw/skills/nano-banana-gen/scripts/gen_image.sh \
  "A beautiful sunset over the ocean" \
  "nano-banana" \
  "1K" \
  "sk-019056d7a0a245188c732d754b40ae09"
```

Args: `<prompt> <model> <image_size> <api_key>`
- **model**: `nano-banana` (default, has credits) or `nano-banana-2` (may need top-up)
- **image_size**: `1K` (default)

## Manual API Call

```bash
curl -s --max-time 90 -X POST "https://grsaiapi.com/v1/draw/nano-banana" \
  -H "Authorization: Bearer sk-019056d7a0a245188c732d754b40ae09" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "your prompt here",
    "model": "nano-banana",
    "image_size": "1K",
    "n": 1
  }'
```

## Response Format (SSE Streaming)

Response comes as **SSE stream** — parse each line:

```
data: {"id":"...","progress":1,"status":"running",...}
data: {"id":"...","progress":50,"status":"running",...}
data: {"results":[{"url":"https://...png","content":""}],"progress":100,"status":"succeeded",...}
```

**Done when:** `"status":"succeeded"` → Image URL in `"results"[0].url`

**Failed when:** `"status":"failed"` or `"code":-1` → insufficient credits or error

## Parameters

| Param | Required | Default | Description |
|-------|----------|---------|-------------|
| `prompt` | ✅ | — | Image description |
| `model` | — | `nano-banana` | `nano-banana` (has credits) or `nano-banana-2` |
| `image_size` | — | `1K` | Image resolution |
| `n` | — | `1` | Number of images (1–4) |

## Status Values

| Status | Meaning |
|--------|---------|
| `running` | Generating — keep reading stream |
| `succeeded` | Done — image URL in `results[0].url` |
| `failed` | Failed — check `failure_reason` |

## Error: Insufficient Credits

If `"code":-1,"msg":"insufficient credits"`:
- Grsai base credits (5,000) only cover **nano-banana** model
- For **nano-banana-2**: top up at https://grsai.com/dashboard/billing
- Or check https://nanobananaapi.ai for alternative Pro/2 credits

For full API docs see: `references/api.md`
