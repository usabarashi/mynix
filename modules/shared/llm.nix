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
      terminal-notifier
    ]
    ++ [
      customPackages.claude-code-sandboxed
      customPackages.gemini-cli-wif
      customPackages.mcp-server-memory
    ];

  home.file = {

    # Claude Code settings
    ".claude/permissive-open.sb" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/permissive-open.sb";
      force = true;
    };
    ".claude/CLAUDE.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/CLAUDE.md";
      force = true;
    };
    ".claude/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/settings.json";
      force = true;
    };
    ".claude/scripts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/claude/scripts";
      force = true;
      recursive = true;
    };
    ".claude/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/agents/commands";
      force = true;
      recursive = true;
    };
    ".claude/skills" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/agents/skills";
      force = true;
      recursive = true;
    };

    # Codex CLI settings
    ".codex/AGENTS.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/codex/AGENTS.md";
      force = true;
    };
    ".codex/config.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/codex/config.toml";
      force = true;
    };
    ".codex/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/agents/commands";
      force = true;
      recursive = true;
    };
    ".codex/skills" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/agents/skills";
      force = true;
      recursive = true;
    };

    # Gemini CLI settings
    ".gemini/GEMINI.md" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/gemini/GEMINI.md";
      force = true;
    };
    ".gemini/settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/gemini/settings.json";
      force = true;
    };
    ".gemini/commands" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/agents/commands";
      force = true;
      recursive = true;
    };
    ".gemini/skills" = {
      source = config.lib.file.mkOutOfStoreSymlink "${repoPath}/config/agents/skills";
      force = true;
      recursive = true;
    };

  };
}
