# MCP Skill - Model Context Protocol Integration

Use this skill when working with MCP servers or building MCP integrations for fr3k consulting.

## What is MCP?

MCP (Model Context Protocol) is the "USB-C for AI" - a standardized way to connect AI apps to external tools/data sources.

## Quick Reference

### Popular MCP Servers (2026)
| Server | Use Case |
|--------|----------|
| **FastMCP** | Python-based MCP server development |
| **Firecrawl** | Web scraping & search |
| **Exa** | AI-powered web search |
| **Ruflo** | Agent orchestration |
| **IBM Context Forge** | Enterprise MCP gateway |

### MCP Setup (Python/FastMCP)
```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("my-server")

@mcp.tool()
async def my_tool(param: str) -> str:
    """Tool description."""
    return result

if __name__ == "__main__":
    mcp.run()
```

## OpenClaw Integration

### Running MCP Servers
Use `exec` to run MCP servers in the background:
```bash
cd /path/to/mcp-server
source .venv/bin/activate
python server.py
```

### Connecting to MCP from OpenClaw
Currently OpenClaw doesn't have native MCP client support. For consulting:
1. Run MCP server as external process
2. Use `exec` or `web_fetch` to interact
3. Document MCP setup for clients

## Consulting Notes

When teaching MCP workshops:
- Emphasize standardized tool definitions
- Show STDIO vs HTTP server tradeoffs
- Demonstrate Claude Desktop configuration
- Include security best practices

## Resources
- Docs: https://modelcontextprotocol.io
- Awesome List: https://github.com/appcypher/awesome-mcp-servers
- GitHub: https://github.com/topics/model-context-protocol
