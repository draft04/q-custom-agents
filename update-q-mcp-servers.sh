#!/bin/bash

ldd --version
cd /tmp
curl --proto '=https' --tlsv1.2 -sSf "https://desktop-release.q.us-east-1.amazonaws.com/latest/q-x86_64-linux.zip" -o "q.zip"
unzip q.zip
./q/install.sh

# Installing UV
curl -LsSf https://astral.sh/uv/install.sh | sh

vi ~/.aws/amazonq/mcp.json

# Create directory if it doesn't exist
mkdir -p ~/.aws/amazonq

# Create/update MCP configuration
cat > ~/.aws/amazonq/mcp.json << 'EOF'
{
  "mcpServers": {
    "awslabs.aws-pricing-mcp-server": {
      "command": "uvx",
      "args": [
        "awslabs.aws-pricing-mcp-server@latest"
      ],
      "env": {
        "AWS_PROFILE": "your-aws-profile",
        "FASTMCP_LOG_LEVEL": "ERROR"
      }
    },
    "awslabs.cdk-mcp-server": {
      "command": "uvx",
      "args": [
        "awslabs.cdk-mcp-server@latest"
      ],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      }
    },
    "awslabs.aws-documentation-mcp-server": {
      "command": "uvx",
      "args": [
        "awslabs.aws-documentation-mcp-server@latest"
      ],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": []
    },
    "awslabs.terraform-mcp-server": {
      "command": "uvx",
      "args": [
        "awslabs.terraform-mcp-server@latest"
      ],
      "env": {
        "FASTMCP_LOG_LEVEL": "ERROR"
      },
      "disabled": false,
      "autoApprove": []
    }
  }
}
EOF

echo "MCP configuration updated successfully!"

# Run MCP server manually with timeout 15s
echo "Run MCP server aws-documentation-mcp-server manually with timeout 15s"
timeout 15s uv tool run awslabs.aws-documentation-mcp-server@latest 2>&1 || echo "Command completed or timed out"