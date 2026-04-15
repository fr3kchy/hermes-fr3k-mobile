#!/usr/bin/env node

/**
 * Agent Collaboration Module
 * Enables shared memory and communication between multiple agents
 */

const fs = require('fs');
const path = require('path');

const SHARED_MEM_DIR = path.join(process.env.HOME || '/home/openclaw', '.openclaw', 'shared-memory');

// Ensure shared memory directory exists
if (!fs.existsSync(SHARED_MEM_DIR)) {
  fs.mkdirSync(SHARED_MEM_DIR, { recursive: true });
}

class AgentCollaboration {
  constructor(config = {}) {
    this.teamName = config.teamName || 'default';
    this.teamAgents = config.teamAgents || [];
    this.sharedKey = config.sharedMemoryKey || 'shared';
  }

  getSharedMemFile() {
    return path.join(SHARED_MEM_DIR, `${this.teamName}-shared.json`);
  }

  readSharedMemory() {
    const file = this.getSharedMemFile();
    if (fs.existsSync(file)) {
      return JSON.parse(fs.readFileSync(file, 'utf8'));
    }
    return { messages: [], knowledge: [], events: [] };
  }

  writeSharedMemory(data) {
    const file = this.getSharedMemFile();
    fs.writeFileSync(file, JSON.stringify(data, null, 2));
  }

  shareMessage(message, targetAgents = []) {
    const mem = this.readSharedMemory();
    const entry = {
      type: 'message',
      content: message,
      from: 'current-agent',
      to: targetAgents.length ? targetAgents : this.teamAgents,
      timestamp: new Date().toISOString()
    };
    mem.messages.push(entry);
    this.writeSharedMemory(mem);
    return `Shared with ${entry.to.join(', ')}: "${message}"`;
  }

  createTeam(teamName, agents) {
    const teamFile = path.join(SHARED_MEM_DIR, `${teamName}-team.json`);
    const teamData = { name: teamName, agents, created: new Date().toISOString() };
    fs.writeFileSync(teamFile, JSON.stringify(teamData, null, 2));
    return `Team "${teamName}" created with: ${agents.join(', ')}`;
  }

  queryKnowledge(query) {
    const mem = this.readSharedMemory();
    const results = mem.knowledge.filter(k => k.content.toLowerCase().includes(query.toLowerCase()));
    if (results.length === 0) return `No knowledge found for: "${query}"`;
    return results.map(r => `- ${r.content}`).join('\n');
  }

  addKnowledge(content, tags = []) {
    const mem = this.readSharedMemory();
    mem.knowledge.push({ content, tags, addedBy: 'current-agent', timestamp: new Date().toISOString() });
    this.writeSharedMemory(mem);
    return `Knowledge added: "${content.substring(0, 50)}..."`;
  }

  broadcast(message) {
    const mem = this.readSharedMemory();
    mem.events.push({ type: 'broadcast', content: message, timestamp: new Date().toISOString() });
    this.writeSharedMemory(mem);
    return `Broadcast to team ${this.teamName}: "${message}"`;
  }
}

const args = process.argv.slice(2);
const command = args[0];

const collab = new AgentCollaboration({
  teamName: 'fr3k',
  teamAgents: ['fr3kr3s3arch', 'fr3kwr1t3', 'fr3kstr4t', 'fr3kd3v', 'fr3ks0c']
});

let result;
switch (command) {
  case 'share': result = collab.shareMessage(args[1], args.slice(2)); break;
  case 'team': result = collab.createTeam(args[1], args.slice(2)); break;
  case 'query': result = collab.queryKnowledge(args[1]); break;
  case 'broadcast': result = collab.broadcast(args.slice(1).join(' ')); break;
  case 'learn': result = collab.addKnowledge(args.slice(1).join(' ')); break;
  default:
    result = `Agent Collaboration CLI
Usage:
  share <message> [agents...] - Share message with team
  team <name> <agents...>   - Create a team
  query <term>             - Query shared knowledge
  broadcast <message>      - Broadcast to all agents
  learn <content>          - Add to shared knowledge`;
}
console.log(result);
