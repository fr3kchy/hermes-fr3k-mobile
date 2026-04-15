#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const ANALYTICS_DIR = path.join(process.env.HOME || '/home/openclaw', '.openclaw', 'analytics');
const DATA_FILE = path.join(ANALYTICS_DIR, 'metrics.json');

if (!fs.existsSync(ANALYTICS_DIR)) fs.mkdirSync(ANALYTICS_DIR, { recursive: true });
if (!fs.existsSync(DATA_FILE)) fs.writeFileSync(DATA_FILE, JSON.stringify({ sessions: [], tokens: [], agents: [], channels: [] }, null, 2));

class AnalyticsDashboard {
  load() { 
    const data = JSON.parse(fs.readFileSync(DATA_FILE, 'utf8'));
    // Migration: add channels if missing
    if (!data.channels) data.channels = [];
    if (!data.sessions) data.sessions = [];
    if (!data.tokens) data.tokens = [];
    if (!data.agents) data.agents = [];
    return data;
  }
  save(data) { fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2)); }

  sessions() {
    const d = this.load();
    const total = d.sessions.length;
    const today = d.sessions.filter(s => new Date(s.timestamp).toDateString() === new Date().toDateString()).length;
    const avg = total ? Math.round(d.sessions.reduce((a, s) => a + (s.duration || 0), 0) / total) : 0;
    return `Sessions\nTotal: ${total}\nToday: ${today}\nAvg: ${avg}s`;
  }

  tokens() {
    const d = this.load();
    const total = d.tokens.reduce((a, t) => a + (t.count || 0), 0);
    const byModel = {};
    d.tokens.forEach(t => { byModel[t.model] = (byModel[t.model] || 0) + t.count; });
    const breakdown = Object.entries(byModel).map(([m, c]) => `  ${m}: ${c}`).join('\n');
    return `Tokens\nTotal: ${total}\n${breakdown}`;
  }

  agents() {
    const d = this.load();
    const byAgent = {};
    d.agents.forEach(a => { byAgent[a.name] = (byAgent[a.name] || 0) + 1; });
    const sorted = Object.entries(byAgent).sort((a, b) => b[1] - a[1]);
    return sorted.map(([n, c]) => `  ${n}: ${c}`).join('\n') || 'No data';
  }

  channels() {
    const d = this.load();
    const byChannel = {};
    d.channels.forEach(c => { byChannel[c.name] = (byChannel[c.name] || 0) + 1; });
    const sorted = Object.entries(byChannel).sort((a, b) => b[1] - a[1]);
    return sorted.map(([n, c]) => `  ${n}: ${c} messages`).join('\n') || 'No data';
  }

  recordChannel(channelName) {
    const d = this.load();
    d.channels.push({ name: channelName, timestamp: new Date().toISOString() });
    this.save(d);
  }

  view() { return `Dashboard: http://localhost:8890/analytics`; }

  export(fmt = 'json') {
    const d = this.load();
    return fmt === 'csv' ? JSON.stringify(d) : JSON.stringify(d, null, 2);
  }
}

const a = process.argv.slice(2), c = a[0], ad = new AnalyticsDashboard();
console.log(
  c === 'sessions' ? ad.sessions() :
  c === 'tokens' ? ad.tokens() :
  c === 'agents' ? ad.agents() :
  c === 'channels' ? ad.channels() :
  c === 'view' ? ad.view() :
  c === 'export' ? ad.export(a[1]) :
  'Usage: sessions|tokens|agents|channels|view|export'
);
