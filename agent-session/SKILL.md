# Agent Session Management in OpenClaw

## Purpose
Create new sessions, switch between agents, and manage session URLs in OpenClaw Control UI.

## Quick Session URLs

| Agent | URL |
|-------|-----|
| main | http://127.0.0.1:18789/chat?session=agent:main:main |
| any-agent | http://127.0.0.1:18789/chat?session=agent:AGENT_ID:main |

**Format:** `agent:AGENT_ID:SESSION_NAME`

---

## Method 1: Direct URL (Easiest)

```
http://127.0.0.1:18789/chat?session=agent:AGENT_ID:main
```

Replace `AGENT_ID` with your agent name (e.g., `marketing-specialist`, `agent-a`).

---

## Method 2: Through Web UI

1. Go to `http://127.0.0.1:18789/chat`
2. Find the **agent selector** dropdown at the top
3. Select your target agent

---

## Method 3: Command Line

```bash
# List all agents
openclaw agents list

# Check all sessions
openclaw sessions list

# Create new agent
openclaw agents add NEW_AGENT_NAME --non-interactive --workspace ~/.openclaw/agents/NEW_AGENT_NAME/workspace
```

---

## Troubleshooting

### "pairing required" error
```bash
# Check pairing status
openclaw pairing list

# Restart gateway
openclaw gateway restart
```

### Agent not showing in dropdown
- Use **direct URL method**
- Or restart the gateway: `openclaw gateway restart`

---

## Create New Agent (if needed)

```bash
openclaw agents add NEW_AGENT_NAME \
  --non-interactive \
  --workspace ~/.openclaw/agents/NEW_AGENT_NAME/workspace
```

Then bind to a channel:
```bash
openclaw agents bind --agent NEW_AGENT_NAME --bind web
```

---

## Session Key Format Reference

| Pattern | Meaning |
|---------|---------|
| `agent:main:main` | main agent, main session |
| `agent:agent-a:main` | agent-a, main session |
| `agent:work:123456` | work agent, specific session ID |

---

## Notes
- Session keys are stable and persistent across gateway restarts
- Each agent has isolated workspace and memory
- Use `openclaw agents bindings` to verify routing setup
