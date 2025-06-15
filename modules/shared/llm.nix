{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # MCP Server
    github-mcp-server

    # LLM Client
    aider-chat
    claude-code
    opencode
  ];

  home.file = {
    ".aider.conf.yml" = {
      source = ../../config/aider/aider.conf.yml;
    };
  };

  # Claude Code Configuration
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

  home.file = {
    # See: https://docs.anthropic.com/ja/docs/claude-code/settings
    ".claude/settings.json" = {
      source = ../../config/claude/settings.json;
    };
  };

  home.file = {
    # See: https://github.com/opencode-ai/opencode
    "config/opencode/.opencode.json" = {
      source = ./../../config/opencode/.opencode.json;
    };
  };
}
