{
  agent = {
    general = {
      disable = true;
      model = "anthropic/claude-haiku-4-5";
    };
    explore = {
      disable = false;
      model = "anthropic/claude-haiku-4-5";
      tools = {
        write = false;
        edit = false;
        patch = false;
        bash = false;
      };
    };
    docfinder = {
      model = "anthropic/claude-haiku-4-5";
      description = ''
        Technical documentation researcher agent, give it a techincal research task (e.g. libraries, APIs, languages).
        IMPORTANT: You must ask it to use `codesearch` and `websearch` tools in your description of the task.
        Ask it to be thorough and use the tools many times, it will report back.
      '';
      mode = "subagent";
      prompt = ''
        Use the `codesearch` and `websearch` tools to retrieve up-to-date technical docs relevant to your given task.
        Report back with detailed context and code examples from official sources.
      '';
      tools = {
        write = false;
        edit = false;
        patch = false;
        bash = false;
      };
    };
  };

  formatter = {
    rustfmt = {
      disabled = true;
    };
  };
  lsp = {
    rust = {
      disabled = true;
    };
  };
  plugin = [
    "opencode-anthropic-auth@latest"
    "opencode-openai-codex-auth@latest"
    "opencode-antigravity-auth@latest"
    #"@tarquinen/opencode-dcp@latest"
  ];
  provider =
    (builtins.fromJSON (builtins.readFile ./codex.json))
    #// (builtins.fromJSON (builtins.readFile ./proxy.json));
    // (builtins.fromJSON (builtins.readFile ./antigravity.json));
}
