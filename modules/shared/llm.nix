{ config, pkgs, lib, repoPath ? null, ... }:

{
  home.packages = with pkgs; [
    # MCP Server
    nodejs_24
    github-mcp-server

    # LLM Client
    aider-chat
    claude-code
    opencode
  ];

  # Claude Code Configuration & Dynamic file management
  #
  # Note: MCP servers cannot be configured via JSON files.
  # After applying this configuration, manually add MCP servers using CLI commands.
  #
  # MCP Server Scopes (https://docs.anthropic.com/en/docs/claude-code/mcp):
  # - Local (default): Available only to you in the current project
  # - Project (-s project): Shared with everyone in the project (stored in .mcp.json)
  # - User (-s user): Available to you across all projects
  #
  # User scope is recommended for personal tools like GitHub access that you want
  # to use across all your projects without sharing credentials with team members.
  #
  # Add GitHub MCP server (user scope):
  # claude mcp add github -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PERSONAL_ACCESS_TOKEN -s user -- github-mcp-server stdio
  #
  # List configured MCP servers:
  # claude mcp list
  #
  # Remove MCP server:
  # claude mcp remove github

  home.file =
    let
      # Use symlinks if repoPath is provided, otherwise use source copies
      useSymlinks = repoPath != null && repoPath != "";
    in
    {
      # Aider configuration - conditional configuration
      ".aider.conf.yml" =
        if useSymlinks then {
          source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/aider/aider.conf.yml";
        } else {
          source = ../../config/aider/aider.conf.yml;
        };

      # Claude settings - conditional configuration
      ".claude/settings.json" =
        if useSymlinks then {
          source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/settings.json";
        } else {
          source = ../../config/claude/settings.json;
        };

      # OpenCode settings - conditional configuration
      "config/opencode/.opencode.json" =
        if useSymlinks then {
          source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/opencode/.opencode.json";
        } else {
          source = ../../config/opencode/.opencode.json;
        };
    };
}
