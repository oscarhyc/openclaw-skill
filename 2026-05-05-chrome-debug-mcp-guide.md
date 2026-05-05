# Chrome Debug App — Bypass Remote Debugging Auth

## Problem

Chrome 136+ enforces that `--remote-debugging-port` must be accompanied by `--user-data-dir` pointing to a **non-standard directory**. Without this, Chrome shows the "Allow remote debugging?" popup **every time** a new process connects, even for the same Chrome session.

## Solution: Create a Dedicated "Chrome Debug" App

### Step 1: Create the App

```bash
cat << 'EOF' > ~/Desktop/create_chrome_debug.sh
#!/bin/bash
APP_PATH="/Applications/Chrome Debug.app"
mkdir -p "$APP_PATH/Contents/MacOS"
mkdir -p "$APP_PATH/Contents/Resources"

cat << 'INNER_EOF' > "$APP_PATH/Contents/MacOS/core_script"
#!/bin/bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --remote-debugging-port=9222 \
  --user-data-dir="$HOME/Documents/ChromeDebugProfile" &
INNER_EOF

chmod +x "$APP_PATH/Contents/MacOS/core_script"

cat << 'INNER_EOF' > "$APP_PATH/Contents/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com">
<plist version="1.0">
<dict>
 <key>CFBundleExecutable</key>
 <string>core_script</string>
 <key>CFBundlePackageType</key>
 <string>APPL</string>
 <key>CFBundleName</key>
 <string>Chrome Debug</string>
</dict>
</plist>
INNER_EOF

cp "/Applications/Google Chrome.app/Contents/Resources/appIcon.icns" \
   "$APP_PATH/Contents/Resources/appIcon.icns" 2>/dev/null

echo "✅ Done"
EOF

bash ~/Desktop/create_chrome_debug.sh && rm ~/Desktop/create_chrome_debug.sh
```

### Step 2: Configure OpenClaw to Connect to Chrome Debug

Edit `~/.openclaw/openclaw.json` — find the `mcp.servers.chrome-devtools` section and change from:

```json
"chrome-devtools": {
  "command": "npx",
  "args": ["-y", "chrome-devtools-mcp@latest", "--autoConnect"]
}
```

to:

```json
"chrome-devtools": {
  "command": "npx",
  "args": ["-y", "chrome-devtools-mcp@latest", "--browserUrl", "http://localhost:9222"]
}
```

### Step 3: Restart Gateway

```bash
openclaw gateway restart
```

## How It Works

1. **Chrome Debug.app** launches Chrome with:
   - `--remote-debugging-port=9222`
   - `--user-data-dir="$HOME/Documents/ChromeDebugProfile"`

2. Because `ChromeDebugProfile` is a **non-standard** directory (not the default Chrome profile), Chrome treats it as an isolated debugging environment and **does not show the auth popup**.

3. **OpenClaw** connects directly to `http://localhost:9222` via `--browserUrl`, bypassing the `autoConnect` mechanism that would otherwise try to detect Chrome channels automatically.

## Important Notes

- **Profile is separate**: `~/Documents/ChromeDebugProfile` is completely separate from your normal Chrome (`~/Library/Application Support/Google/Chrome/`). You'll need to re-login to websites once in Chrome Debug.
- **One Chrome at a time**: If you have another Chrome running with `--remote-debugging-port=9222`, they will conflict. Always quit all Chrome instances before starting Chrome Debug.
- **No auth popup**: Once Chrome Debug is running, subsequent OpenClaw MCP connections do NOT trigger the "Allow remote debugging?" popup.
- **Profile persists**: Your logins and cookies in Chrome Debug persist across restarts (unlike a temporary profile that gets deleted).

## Rollback

To restore original behavior:

1. Delete the Chrome Debug app:
   ```bash
   rm -rf "/Applications/Chrome Debug.app"
   ```

2. Delete the Chrome Debug profile (WARNING: deletes all stored sessions):
   ```bash
   rm -rf ~/Documents/ChromeDebugProfile
   ```

3. Revert `~/.openclaw/openclaw.json` to use `--autoConnect`

4. Restart gateway: `openclaw gateway restart`

## Why This Works

Chrome 136 introduced a security change:
> "These switches will no longer be respected if attempting to debug the **default Chrome data directory**. These switches **must** now be accompanied by the `--user-data-dir` switch to point to a **non-standard directory**."

By using `~/Documents/ChromeDebugProfile`, we satisfy Chrome's requirement for a non-standard directory, which suppresses the security prompt.

## Key Files

| File | Purpose |
|------|---------|
| `/Applications/Chrome Debug.app` | The app you click to launch Chrome Debug |
| `~/Documents/ChromeDebugProfile/` | Chrome profile for Chrome Debug (isolated from normal Chrome) |
| `~/.openclaw/openclaw.json` | OpenClaw config — change MCP args to use `--browserUrl` |

## Useful Commands

```bash
# Check if Chrome is running on port 9222
lsof -i :9222

# Check which Chrome processes have remote debugging
ps aux | grep "remote-debugging-port"

# Get WebSocket endpoint
curl http://localhost:9222/json/version
```

## Common Issues

| Issue | Solution |
|-------|----------|
| "Not connected" error | Ensure Chrome Debug is running (check `lsof -i :9222`) |
| Auth popup still appears | Make sure you quit ALL Chrome instances first, then only open Chrome Debug |
| Connection timeout | Run `openclaw gateway restart` to refresh the MCP connection |

---
*Created: 2026-05-05*
*OpenClaw + Chrome DevTools MCP*