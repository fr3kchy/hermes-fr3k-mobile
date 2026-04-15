# Analytics Dashboard Skill

Track and visualize OpenClaw usage metrics, token consumption, and agent performance.

## Commands

### Show Dashboard
```
@analytics-dashboard view
```
Opens the analytics dashboard in browser.

### Session Stats
```
@analytics-dashboard sessions
```
Shows session count, duration, and activity.

### Token Usage
```
@analytics-dashboard tokens
```
Displays token consumption by agent/model.

### Agent Performance
```
@analytics-dashboard agents
```
Shows performance metrics per agent.

### Export Report
```
@analytics-dashboard export [--format json|csv]
```
Export analytics data.

## Configuration

```json
{
  "skills": {
    "analytics-dashboard": {
      "enabled": true,
      "retentionDays": 30,
      "trackTokens": true,
      "trackSessions": true,
      "trackAgents": true,
      "dashboardPort": 8890
    }
  }
}
```

## Metrics Tracked

- **Session Analytics**: Count, duration, messages per session
- **Token Usage**: Per-model, per-agent, daily/monthly totals
- **Agent Performance**: Response times, success rates, tool usage
- **Channel Activity**: Messages per channel, peak hours
- **Cost Estimates**: Based on model pricing

## Dashboard Features

- Real-time metrics visualization
- Historical trends
- Agent leaderboards
- Cost breakdown by model
- Export to CSV/JSON
