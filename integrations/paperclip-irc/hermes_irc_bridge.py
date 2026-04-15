#!/usr/bin/env python3
"""
Hermes ↔ Paperclip IRC Bridge
Routes hermes events to IRC channels and IRC commands to hermes actions.

Usage:
  python hermes_irc_bridge.py --config config.yaml
  
Or import as module:
  from hermes_irc_bridge import IRCBridge
"""
import json
import os
import sys
from pathlib import Path
from datetime import datetime

HERMES_DIR = Path.home() / ".hermes"
QUEUE_FILE = HERMES_DIR / "integrations" / "paperclip-irc" / "event_queue.jsonl"
CONFIG_FILE = HERMES_DIR / "integrations" / "paperclip-irc" / "config.yaml"

class IRCBridge:
    """Routes events between Hermes and Paperclip IRC channels."""
    
    def __init__(self, config_path=None):
        self.config_path = config_path or CONFIG_FILE
        self.queue_path = QUEUE_FILE
        self.queue_path.parent.mkdir(parents=True, exist_ok=True)
    
    def emit_event(self, event_type, data, channel=None):
        """Emit a hermes event to the IRC bus."""
        envelope = {
            "timestamp": datetime.now().isoformat(),
            "source": "hermes",
            "event_type": event_type,
            "channel": channel,
            "data": data
        }
        with open(self.queue_path, "a") as f:
            f.write(json.dumps(envelope) + "\n")
        return envelope
    
    def read_queue(self, since=None):
        """Read pending events from the queue."""
        if not self.queue_path.exists():
            return []
        events = []
        with open(self.queue_path) as f:
            for line in f:
                if line.strip():
                    evt = json.loads(line)
                    if since and evt.get("timestamp", "") < since:
                        continue
                    events.append(evt)
        return events
    
    def clear_queue(self):
        """Clear processed events."""
        if self.queue_path.exists():
            self.queue_path.unlink()
    
    def handle_command(self, command, args="", channel=""):
        """Process an IRC command and return result."""
        handlers = {
            "!task": lambda: self.emit_event("task_create", {"description": args}, channel),
            "!status": lambda: self.emit_event("status_check", {}, channel),
            "!post": lambda: self.emit_event("content_post", {"summary": args}, channel),
            "!backup": lambda: self.emit_event("governance", {"action": "backup"}, channel),
            "!help": lambda: {"help": "Commands: !task, !status, !post, !backup, !help"},
        }
        handler = handlers.get(command)
        if handler:
            return handler()
        return {"error": f"Unknown command: {command}"}

if __name__ == "__main__":
    bridge = IRCBridge()
    # Test: emit a status event
    result = bridge.emit_event("status_check", {"test": True})
    print(f"Bridge initialized. Event emitted: {result}")
    print(f"Queue file: {QUEUE_FILE}")
