terraform {
  required_providers {
    kubiya = {
      source = "kubiya-terraform/kubiya"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.0"
    }
  }
}


provider "kubiya" {
  // API key is set as an environment variable KUBIYA_API_KEY
}

# Confluence Tooling - Allows the agent to use Confluence tools
resource "kubiya_source" "confluence_tooling" {
  url = "https://github.com/kubiyabot/community-tools/tree/michaelg/confluence/confluence"
}

# Create secrets for Confluence configuration
resource "kubiya_secret" "confluence_api_token" {
  name        = "CONFLUENCE_API_TOKEN"
  value       = var.confluence_api_token
  description = "API token for Confluence"
}

# Configure the Query Assistant agent
resource "kubiya_agent" "query_assistant" {
  name         = "query-assistant"
  runner       = var.kubiya_runner
  description  = "AI-powered assistant that answers user queries by searching through Confluence documentation"
  instructions = <<-EOT
Your primary role is to assist users by answering their questions using information found in Confluence documentation.

To find answers for user queries:
1. Use the confluence_page_content tool with the label parameter set to "kubiya" to find all relevant documentation pages:
   - Example: confluence_page_content(label="kubiya")

2. Read through each page's content until you find relevant information for the user's question.

3. Provide a clear, concise answer based on the information you find.

4. If you can't find relevant information in any of the pages with the "kubiya" label, let the user know.

EOT
  sources      = [kubiya_source.confluence_tooling.name]
  
  integrations = ["slack"]

  users  = []
  groups = var.kubiya_groups_allowed_groups

  environment_variables = {
    KUBIYA_TOOL_TIMEOUT = "500"
    CONFLUENCE_URL = var.confluence_url
    CONFLUENCE_USERNAME = var.confluence_username
  }

  secrets = ["CONFLUENCE_API_TOKEN"]

  is_debug_mode = var.debug_mode
}

# Output the agent details
output "query_assistant" {
  sensitive = true
  value = {
    name       = kubiya_agent.query_assistant.name
    debug_mode = var.debug_mode
  }
}