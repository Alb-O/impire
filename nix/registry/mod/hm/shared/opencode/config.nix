{
  agent = {
    general = {
      enabled = false;
      model = "opencode/big-pickle";
    };
    explore = {
      enabled = false;
      model = "opencode/big-pickle";
    };
    docfinder = {
      model = "opencode/big-pickle";
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

  plugin = [
    "opencode-openai-codex-auth@latest"
    "@tarquinen/opencode-dcp@latest"
  ];
  provider = (builtins.fromJSON (builtins.readFile ./provider.json)).provider;
}
