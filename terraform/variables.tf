# Required Core Configuration
variable "teammate_name" {
  description = "Name of your Query Assistant teammate (e.g., 'query-assistant'). Used to identify the teammate in logs and notifications."
  type        = string
  default     = "query-assistant"
}

# Access Control
variable "kubiya_groups_allowed_groups" {
  description = "Groups allowed to interact with the teammate (e.g., ['Admin', 'Users'])."
  type        = list(string)
  default     = ["Admin", "Users"]
}

# Kubiya Runner Configuration
variable "kubiya_runner" {
  description = "Runner to use for the teammate. Change only if using custom runners."
  type        = string
}

variable "debug_mode" {
  description = "Debug mode allows you to see more detailed information and outputs during runtime (shows all outputs and logs when conversing with the teammate)"
  type        = bool
  default     = true
}

# Confluence Configuration
variable "confluence_url" {
  description = "The URL of your Confluence instance (e.g., 'https://your-domain.atlassian.net/wiki')"
  type        = string
}

variable "confluence_username" {
  description = "The username or email for Confluence authentication"
  type        = string
}

variable "confluence_api_token" {
  description = "API token for Confluence authentication"
  type        = string
  sensitive   = true
}