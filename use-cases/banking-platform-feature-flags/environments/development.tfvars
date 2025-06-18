# Development Environment - Specific Configuration
# This file contains environment-specific configurations for development

# Environment name
environment_name = "dev"

# # Development-only feature flags (experimental features)
# feature_flags = [
#   {
#     name              = "voice-banking-beta"
#     description       = "Voice-activated commands (experimental)"
#     default_treatment = "off"
#     environments      = ["dev"] # Dev only for now
#     lifecycle_stage   = "development"
#     category          = "experiment"
#     treatments = [
#       {
#         name           = "off"
#         configurations = "{\"voice_enabled\": false}"
#         description    = "Voice banking disabled"
#       },
#       {
#         name           = "on"
#         configurations = "{\"voice_enabled\": true, \"commands\": [\"balance\", \"transfer\", \"history\"]}"
#         description    = "Voice banking enabled with extended commands for development"
#       }
#     ]
#     rules = []
#   },
#   {
#     name              = "experimental-ui"
#     description       = "New experimental user interface"
#     default_treatment = "classic"
#     environments      = ["dev"]
#     lifecycle_stage   = "development"
#     category          = "experiment"
#     treatments = [
#       {
#         name           = "classic"
#         configurations = "{\"ui_version\": \"classic\"}"
#         description    = "Classic UI"
#       },
#       {
#         name           = "modern"
#         configurations = "{\"ui_version\": \"modern\", \"animations\": true}"
#         description    = "Modern UI with animations"
#       }
#     ]
#     rules = []
#   }
# ]
