# Confluence Knowledge Assistant

This Terraform module creates an AI-powered assistant that answers user queries by searching through Confluence documentation across multiple spaces. It helps teams quickly find information stored in your organization's knowledge base.

## Overview

The module creates:
- A Kubiya AI agent specialized in searching and retrieving Confluence content
- Integration with Confluence API for content access
- Support for searching across multiple Confluence spaces
- Ability to reference specific important pages
- Secure storage for API keys and sensitive data

## Use Cases

### 1. Cross-Space Knowledge Queries
When a user has a question that might span multiple documentation areas:
- Searches across multiple configured Confluence spaces
- Aggregates and ranks results from different spaces
- Retrieves full page content when needed
- Provides comprehensive answers with references to source pages

### 2. Documentation Discovery
When users need to find specific documentation:
- Lists available Confluence spaces
- Shows content within specific spaces
- Helps navigate complex documentation structures
- Provides direct links to relevant pages

## Setup Instructions

### Prerequisites
- Confluence Cloud or Server instance with API access
- Confluence API token
- Slack workspace with Kubiya app installed
- Terraform >= 1.0

### Installation

1. Include the module in your Terraform configuration:

```hcl
module "confluence_assistant" {
  source = "path/to/confluence-assistant"
  
  teammate_name        = "query-assistant"
  kubiya_runner        = "your-runner"
  
  confluence_url       = "https://your-domain.atlassian.net/wiki"
  confluence_username  = "your-email@example.com"
  confluence_api_token = var.confluence_api_token
  
  # Multiple spaces to search
  confluence_space_keys = ["DOCS", "DEV", "TEAM"]
  
  # Optional specific important pages
  specific_page_ids = ["123456", "789012"]
}
```

2. Initialize and apply the Terraform configuration:
```bash
terraform init
terraform apply
```

## Configuration Options

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `teammate_name` | Name for the AI assistant | No | "query-assistant" |
| `kubiya_runner` | Kubiya runner to use | Yes | - |
| `confluence_url` | URL of your Confluence instance | Yes | - |
| `confluence_username` | Username/email for Confluence | Yes | - |
| `confluence_api_token` | API token for Confluence | Yes | - |
| `confluence_space_keys` | List of space keys to search | No | ["DOCS"] |
| `specific_page_ids` | List of important page IDs | No | [] |

## Security Considerations

- All sensitive keys are stored securely using Kubiya's secret management
- Communication between services uses encrypted channels
- Access to the AI assistant can be restricted using the `kubiya_groups_allowed_groups` variable

## Support

For issues, questions, or contributions, please contact [support contact information].
