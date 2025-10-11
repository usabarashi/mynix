{
  config,
  pkgs,
  lib,
  repoPath,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      codex
      gemini-cli

      nodejs # npx
      terminal-notifier
    ]
    ++ [
      customPackages.claude-code-sandboxed
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
    # List configured MCP servers:
    # claude mcp list
    #
    # Remove MCP server:
    # claude mcp remove github

    # Claude settings
    ".claude/permissive-open.sb" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/permissive-open.sb";
    };
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/CLAUDE.md";
    };
    ".claude/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/settings.json";
    };
    ".claude/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/commands";
      recursive = true;
    };
    ".claude/scripts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/scripts";
      recursive = true;
    };

    # Codex CLI settings
    ".codex/AGENTS.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/codex/AGENTS.md";
    };
    ".codex/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/codex/config.toml";
    };

    # Gemini CLI settings
    ".gemini/GEMINI.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/gemini/GEMINI.md";
    };
    ".gemini/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/gemini/settings.json";
    };
    ".gemini/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/gemini/commands";
      recursive = true;
    };

  };
}
