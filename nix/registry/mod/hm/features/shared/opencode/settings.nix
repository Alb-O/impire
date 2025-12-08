# OpenCode settings
# Agent definitions, plugins, and provider configurations
{ ... }:
{
  # MCP server definitions
  mcp = {
    mcp-nixos = {
      type = "local";
      command = [ "mcp-nixos" ];
      enabled = true;
    };
    # context7 = {
    #   type = "remote";
    #   url = "https://mcp.context7.com/mcp";
    #   headers = { "CONTEXT7_API_KEY" = "..."; };
    #   enabled = true;
    # };
  };

  # Subagent definitions
  agent = {
    nixer = {
      model = "opencode/big-pickle";
      description = ''
        Upstream nix researcher agent, give it a nix research task.
        IMPORTANT: You must ask it to use `mcp-nixos` tools in your description of the task.
        Ask it to be thorough and use the `mcp-nixos` tool many times, it will report back.
      '';
      mode = "subagent";
      prompt = ''
        Use the Mcp-Nixos tools (e.g. nixos_search, nixos_info, home_manager_search) to query up-to-date packages & options.
        Report back with correct technical details from official sources, or otherwise depending on your task.
      '';
      tools = {
        write = false;
        edit = false;
        patch = false;
        bash = false;
        webfetch = false;
        "mcp-nixos_*" = true;
      };
    };
    docfinder = {
      model = "opencode/big-pickle";
      description = ''
        Technical documentation researcher agent, give it any techincal research task (e.g. libraries, APIs, languages).
        IMPORTANT: You must ask it to use `context7` tools in your description of the task.
        Ask it to be thorough and use the `context7` tools many times, it will report back.
      '';
      mode = "subagent";
      prompt = ''
        Use the Context7 tools (e.g. resolve_library_id, get_library_docs) to retrieve up-to-date technical docs relevant to your given task.
        Resolve library ID, then fetch docs with topics and token limits. Report back with detailed context and code examples from official sources.
      '';
      tools = {
        write = false;
        edit = false;
        patch = false;
        bash = false;
        webfetch = false;
        "context7_*" = true;
      };
    };
  };

  # Disable MCP tools by default (enabled per-agent above)
  tools = {
    "mcp-nixos_*" = false;
    "context7_*" = false;
  };

  # Plugins
  plugin = [
    "opencode-openai-codex-auth@4.0.2"
  ];

  # OpenAI provider configuration with OAuth models
  provider = {
    openai = {
      options = {
        reasoningEffort = "medium";
        reasoningSummary = "auto";
        textVerbosity = "medium";
        include = [ "reasoning.encrypted_content" ];
        store = false;
      };

      models = {
        "gpt-5.1-codex-low" = {
          name = "GPT 5.1 Codex Low (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "low";
            reasoningSummary = "auto";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-medium" = {
          name = "GPT 5.1 Codex Medium (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "medium";
            reasoningSummary = "auto";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-high" = {
          name = "GPT 5.1 Codex High (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "high";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-max" = {
          name = "GPT 5.1 Codex Max (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "high";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-max-low" = {
          name = "GPT 5.1 Codex Max Low (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "low";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-max-medium" = {
          name = "GPT 5.1 Codex Max Medium (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "medium";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-max-high" = {
          name = "GPT 5.1 Codex Max High (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "high";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-max-xhigh" = {
          name = "GPT 5.1 Codex Max Extra High (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "xhigh";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-mini-medium" = {
          name = "GPT 5.1 Codex Mini Medium (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "medium";
            reasoningSummary = "auto";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-codex-mini-high" = {
          name = "GPT 5.1 Codex Mini High (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "high";
            reasoningSummary = "detailed";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-low" = {
          name = "GPT 5.1 Low (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "low";
            reasoningSummary = "auto";
            textVerbosity = "low";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-medium" = {
          name = "GPT 5.1 Medium (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "medium";
            reasoningSummary = "auto";
            textVerbosity = "medium";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };

        "gpt-5.1-high" = {
          name = "GPT 5.1 High (OAuth)";
          limit = {
            context = 272000;
            output = 128000;
          };
          options = {
            reasoningEffort = "high";
            reasoningSummary = "detailed";
            textVerbosity = "high";
            include = [ "reasoning.encrypted_content" ];
            store = false;
          };
        };
      };
    };
  };
}
