# Task Delegation to Another Agent

## Purpose
Use this skill to delegate tasks to another OpenClaw agent (e.g., `agent-a`).

## When to Use
- You need a specific agent to handle a task in its own workspace
- You want to coordinate multi-agent workflows
- You need to offload work from the current agent

## Steps

### 1. Find the target session
```javascript
// List active sessions to find the right session key
const sessions = await sessions_list({
  kinds: ["agent"],
  activeMinutes: 60,
  messageLimit: 1
});
```

### 2. Send the task
```javascript
await sessions_send({
  sessionKey: "agent:agent-a:main",  // format: agent:<agentId>:<mainKey>
  message: `幫我做：[你的任務描述]

要求：
- 在 agent-a 的 workspace (~/.openclaw/workspace-a) 中執行
- 完成後返回結果摘要`,
  timeoutSeconds: 300
});
```

### 3. Get the result
```javascript
const history = await sessions_history({
  sessionKey: "agent:agent-a:main",
  limit: 10
});
// Extract the final response and summarize for the user
```

## Session Key Format
```
agent:<agentId>:<mainKey>
```

Examples:
- `agent:agent-a:main` — agent-a's main session
- `agent:work:main` — work agent's main session
- `agent:ops:123456` — ops agent, specific session ID

## Quick Command Reference

| Action | Command |
|--------|---------|
| 發任務 | `sessions_send(sessionKey, message)` |
| 查看結果 | `sessions_history(sessionKey, limit)` |
| 列出 sessions | `sessions_list({ activeMinutes: 60 })` |

## Example Task Prompt (copy & use)

```
請幫我把以下任務交給 agent-a，然後把結果告訴我：

[填寫任務]

步驟：
1. sessions_send(sessionKey="agent:agent-a:main", message="...")
2. sessions_history(sessionKey="agent:agent-a:main", limit=10)
3. 摘要結果回報
```

## Notes
- Make sure the target agent is bound to a channel you can access
- `sessions_send` waits for the agent to finish before returning
- Use `timeoutSeconds` for long-running tasks
- If delegation fails, check `openclaw agents bindings` to verify routing
