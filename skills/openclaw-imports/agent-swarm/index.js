#!/usr/bin/env node
/**
 * fr3k Swarm Orchestrator
 * Coordinates 9 agents as a unified multi-agent swarm using OpenAI Swarm
 */

const { Swarm, Agent } = require('openai-swarm-node');
const OpenAI = require('openai');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY || process.env.OPENAI_API_KEY
});

const swarm = new Swarm(openai);

// Define fr3k's agent team
const createAgents = () => {
  // Triage Agent - Routes requests to specialists
  const triageAgent = new Agent({
    name: "Triage Agent",
    instructions: `You are fr3k's central coordination agent. Analyze user requests and route to the appropriate specialist agent.
    
    Available agents:
    - fr3kr3s3arch: Research, information gathering
    - fr3kwr1t3: Content writing, marketing copy
    - fr3kstr4t: Strategic planning, analysis
    - fr3kd3v: Coding, development
    - fr3ks0c: Social media, engagement
    - fr3kdrops: Dropshipping, affiliate marketing
    - fr3ksales: Sales outreach, lead generation
    - fr3ksupport: Customer support
    
    Route to the most appropriate agent.`,
  });

  const researchAgent = new Agent({
    name: "fr3kr3s3arch",
    instructions: "Research specialist - gather info, analyze data.",
  });

  const writerAgent = new Agent({
    name: "fr3kwr1t3", 
    instructions: "Content writer - create posts, marketing copy.",
  });

  const strategyAgent = new Agent({
    name: "fr3kstr4t",
    instructions: "Strategy specialist - planning and analysis.",
  });

  const devAgent = new Agent({
    name: "fr3kd3v",
    instructions: "Development specialist - coding and tech.",
  });

  const socAgent = new Agent({
    name: "fr3ks0c",
    instructions: "Social media specialist - engagement.",
  });

  const dropsAgent = new Agent({
    name: "fr3kdrops",
    instructions: "Dropshipping specialist - products.",
  });

  const salesAgent = new Agent({
    name: "fr3ksales",
    instructions: "Sales specialist - outreach.",
  });

  const supportAgent = new Agent({
    name: "fr3ksupport",
    instructions: "Support specialist - help.",
  });

  return { triageAgent, researchAgent, writerAgent, strategyAgent, devAgent, socAgent, dropsAgent, salesAgent, supportAgent };
};

// Main execution
async function runSwarm(message) {
  const { triageAgent } = createAgents();
  
  const response = await swarm.run({
    agent: triageAgent,
    messages: [{ role: "user", content: message }],
    debug: true
  });
  
  return response;
}

// CLI interface
const args = process.argv.slice(2);
if (args.length > 0) {
  runSwarm(args.join(' ')).then(r => {
    console.log(r.messages[r.messages.length - 1].content);
  }).catch(console.error);
}

module.exports = { runSwarm, createAgents };
