{
  enabled = true;
  debug = false;
  model = "opencode/big-pickle";
  showModelErrorToasts = true;
  showUpdateToasts = true;
  strictModelSelection = true;

  strategies = {
    onIdle = [ "ai-analysis" ];
    onTool = [ ];
  };

  pruning_summary = "minimal";
  nudge_freq = 15;
  #protectedTools = [ "bash" ];
}
