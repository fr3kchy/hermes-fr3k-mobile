# Agent Collaboration Skill

Enable inter-agent communication and shared memory spaces for multi-agent teams.

## Commands

### Share Memory Between Agents
```
@agent-collaboration share <message> with <agent1>, <agent2>
```
Shares a message with specified agents in the team.

### Create Shared Context
```
@agent-collaboration create-team <team-name> with <agent1>, <agent2>, <agent3>
```
Creates a shared context namespace for multiple agents.

### Query Shared Knowledge
```
@agent-collaboration ask <team-name> about <query>
```
Queries the shared knowledge base across agents.

### Broadcast to Team
```
@agent-collaboration broadcast <message>
```
Sends message to all agents in your configured team.

## Configuration

Add to `openclaw.json`:

```json
{
  "skills": {
    "agent-collaboration": {
      "enabled": true,
      "teamName": "fr3k",
      "teamAgents": ["fr3kr3s3arch", "fr3kwr1t3", "fr3kstr4t"],
      "sharedMemoryKey": "fr3k-team-shared"
    }
  }
}
```

## Features

- **Shared Context**: Agents can read/write to shared memory namespace
- **Team Broadcast**: Send messages to all team agents simultaneously
- **Cross-Agent Query**: Ask questions that aggregate knowledge across agents
- **Event Sync**: Real-time sync of important events between agents

## Use Cases

1. Research agent finds info → shares with writing agent
2. Strategy agent makes decision → notifies execution agents
3. Any agent can query team knowledge base
