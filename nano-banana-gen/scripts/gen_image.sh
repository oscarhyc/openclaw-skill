#!/bin/bash
# NanoBanana Image Generator — Grsai API
# Usage: gen_image.sh "<prompt>" [model] [image_size] [api_key]
# Example: gen_image.sh "A sunset" nano-banana 1K "sk-019..."

PROMPT="${1:-}"
MODEL="${2:-nano-banana}"
SIZE="${3:-1K}"
KEY="${4:-}"

if [ -z "$PROMPT" ] || [ -z "$KEY" ]; then
  echo "Usage: gen_image.sh <prompt> <model> <image_size> <api_key>"
  echo "Example: gen_image.sh \"A sunset\" nano-banana 1K \"sk-019...\""
  exit 1
fi

BASE="https://grsaiapi.com"

echo "🎨 Submitting (model=$MODEL, size=$SIZE)..."
echo "📝 Prompt: $PROMPT"

# Stream response and capture the final line with URL
RESULT=$(curl -s --max-time 90 -X POST "$BASE/v1/draw/nano-banana" \
  -H "Authorization: Bearer $KEY" \
  -H "Content-Type: application/json" \
  -d "{\"prompt\":\"$PROMPT\",\"model\":\"$MODEL\",\"image_size\":\"$SIZE\",\"n\":1}")

# Check for error response (not SSE format)
if echo "$RESULT" | grep -q '"code"'; then
  MSG=$(echo "$RESULT" | grep -o '"msg":"[^"]*"' | head -1)
  echo "❌ API Error: $MSG"
  exit 1
fi

# Extract final SSE data line
FINAL=$(echo "$RESULT" | grep '^data:' | tail -1)

STATUS=$(echo "$FINAL" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
FLAG=$(echo "$FINAL" | grep -o '"progress":[0-9]*' | grep -o '[0-9]*')

if [ "$STATUS" = "succeeded" ]; then
  IMG_URL=$(echo "$FINAL" | grep -o '"url":"[^"]*"' | head -1 | cut -d'"' -f4)
  echo "✅ Done! Image URL: $IMG_URL"
  exit 0
elif [ "$STATUS" = "failed" ]; then
  REASON=$(echo "$FINAL" | grep -o '"failure_reason":"[^"]*"' | cut -d'"' -f4)
  echo "❌ Failed: $REASON"
  exit 1
else
  echo "❌ Unexpected status: $STATUS (flag=$FLAG)"
  echo "Raw: $FINAL"
  exit 1
fi
