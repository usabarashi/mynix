{
  config,
  pkgs,
  lib,
  repoPath,
  ...
}:

let
  kibela-mcp-server = pkgs.callPackage (repoPath + "/packages/kibela-mcp-server/default.nix") { };
in
{
  home.packages = with pkgs; [
    nodejs # npx
    github-mcp-server
    kibela-mcp-server

    claude-code
  ];

  home.file = {

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
    # Add Kibela MCP server (user scope):
    # claude mcp add kibela -e KIBELA_ORIGIN=https://your-subdomain.kibe.la -e KIBELA_ACCESS_TOKEN=$KIBELA_ACCESS_TOKEN -s user -- kibela-mcp-server
    #
    # List configured MCP servers:
    # claude mcp list
    #
    # Remove MCP server:
    # claude mcp remove github
    # claude mcp remove kibela

    # Claude settings
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/CLAUDE.md";
    };
    ".claude/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/settings.json";
    };
  };
}
