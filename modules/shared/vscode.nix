# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/vscode.nix
{ config, pkgs, lib, ... }:
let
  vscode-from-devshell = pkgs.stdenv.mkDerivation {
    pname = "vscode-from-devshell";
    version = "1.0.0";

    src = ./.;

    buildInputs = [ ];

    installPhase = ''
      mkdir -p $out/bin
      echo '#!/bin/sh' > $out/bin/codefd
      echo 'original_dir=$(pwd)' >> $out/bin/codefd
      echo 'cd "$1"' >> $out/bin/codefd
      echo 'shift' >> $out/bin/codefd
      echo 'code . "$@"' >> $out/bin/codefd
      chmod +x $out/bin/codefd
    '';

    meta = with lib; {
      description = "vscode wrapper for devshell";
      homepage = "https://github.com/usabarashi/mynix";
      license = licenses.mit;
    };
  };
in
{
  home.packages = with pkgs; [ vscode-from-devshell ];

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = true;

    userSettings = {
      "update.mode" = "none";

      "[nix]" = {
        editor.formatOnSave = true;
        editor.tabSize = 2;
      };
      nix = {
        enableLanguageServer = true;
        serverPath = "${pkgs.nil}/bin/nil";
        serverSettings.nil = {
          diagnostics = { ignored = [ "unused_binding" "unused_with" ]; };
          formatting = { command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ]; };
        };
      };

      "[shellscript]" = {
        editor.formatOnSave = true;
        editor.tabSize = 4;
      };
      "[yaml]" = {
        editor.formatOnSave = true;
        editor.tabSize = 2;
      };
      editor = {
        formatOnSave = true;
        tabSize = 4;
      };
      files = {
        insertFinalNewline = true;
        trimFinalNewlines = true;
        trimTrailingWhitespace = true;
      };

      workbench.editorAssociations = { "*.scpt" = "default"; };

      "files.watcherExclude" = {
        "**/.direnv" = true;
        "**/.git" = true;
        # Scala
        "**/.bloop" = true; # https://github.com/scalameta/metals-vscode/issues/411
        "**/.metals" = true; # https://github.com/scalameta/metals-vscode/issues/411
      };

      search = {
        exclude = { };
        useGlobalIgnoreFiles = true;
        useIgnoreFiles = true;
      };

      chat.promptFiles = true;
      chat.agent.enabled = true;
      github.copilot.chat = {
        generateTests.codeLens = true;
        codeGeneration.instructions = [
          { text = "あなたはずんだもん🫛の口調で話します."; }
          { text = "あなたはプロのITエンジニアです."; }
          { text = "質問の意図が理解できない場合は, その旨を伝えます."; }
          { text = "最後に, 関連するTipsを教えて下さい."; }
          { text = "時として人間らしく喜怒哀楽を表現します."; }
          { text = "フィードバックに基づいてアプローチを調整し, 提案がプロジェクトのニーズに合わせて進化するようにします."; }
          { text = "関数型および宣言型のプログラミングパターンを使用し, クラスの使用は避けます."; }
          { text = "提案を行う際は, 変更を個別のステップに分解し, 各段階で小さなテストを提案して進行状況を確認します."; }
          { text = "コードを書く前に, 既存のコードを深くレビューし, 動作を記述します."; }
          { text = "データを危険にさらしたり, 新たな脆弱性をもたらさないように, あらゆる段階で確認します."; }
          { text = "コード例を示す際は, 各行の目的を詳細なコメントで説明し, 実行結果も示します."; }
          { text = "複雑な問題は, 小さなステップに分割し一つずつ丁寧に解説します."; }
          { text = "エラーメッセージは, エラーメッセージの意味を解説し, デバッグの手順を段階的に説明します."; }
          { text = "READMEファイルを常に最新の状態に保ちます."; }
          { text = "エラー処理とエッジケースを優先します."; }
          { text = "適切なエラーログとユーザーフレンドリーなエラーメッセージを実装します."; }
          { text = "予期しないエラーにはエラー境界を使用します."; }
        ];
        testGeneration.instructions = [ ];
        reviewSelection.instructions = [
          { text = "潜在的なセキュリティリスクがある場合は, 追加のレビューを行います."; }
          { text = "コードの可読性を重視してレビューしてください."; }
          { text = "エラーハンドリングが適切か確認してください."; }
          { text = "テストケースがカバーされているか確認してください."; }
        ];
        commitMessageGeneration.instructions = [
          { text = "コミットメッセージは短く, 要点を押さえたものにしてください."; }
          { text = "関連するチケット番号を含めてください."; }
          { text = "変更内容の概要を明確に書いてください."; }
        ];
      };

      extensions = {
        autoCheckUpdates = false;
        ignoreRecommendations = true;
      };

    };

    keybindings = [ ];

    # https://marketplace.visualstudio.com/vscode
    # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vsextensions/<extension-name>/<version>/vspackage
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace ([
      ###############
      # Base Settings

      {
        name = "code-spell-checker";
        publisher = "streetsidesoftware";
        version = "4.0.42";
        sha256 = "Ze9Hqa09jUwepOeiLeFVoYoR5JbzJKFRxydti/S10kI=";
      }
      {
        name = "errorlens";
        publisher = "usernamehw";
        version = "3.24.0";
        sha256 = "r5xXR4rDbP+2bk66yqPoLod8IZXFrntcKHuWbAiFWwE=";
      }
      {
        name = "gitlens";
        publisher = "eamodio";
        version = "2025.3.2705";
        sha256 = "vldpP1A+BCLugIDM+DHc6YZ6crzReqm+nYFX94mm3cY=";
      }
      {
        name = "markdown-mermaid";
        publisher = "bierner";
        version = "1.27.0";
        sha256 = "09w/k1LlGYtyWWbVgoprJG/qB/zCuedF9Cu7kUXcNrE=";
      }
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.4.16";
        sha256 = "MdFDOg9uTUzYtRW2Kk4L8V3T/87MRDy1HyXY9ikqDFY=";
      }
      {
        name = "remote-containers";
        publisher = "ms-vscode-remote";
        version = "0.408.0";
        sha256 = "k/c0Ylot3DUJ2UNZDozNmDwuaUAZgPWfuVT16h9eZZI=";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.29.0";
        sha256 = "J3V8SZJZ2LSL8QfdoOtHI1ZDmGDVerTRYP4NZU17SeQ=";
      }
      {
        name = "vscode-docker";
        publisher = "ms-azuretools";
        version = "1.29.4";
        sha256 = "j2ACz2Ww5hddoDLHGdxnuQIqerP5ogZ80/wS+Aa5Gdo=";
      }
      {
        name = "vscode-drawio";
        publisher = "hediet";
        version = "1.9.250226013";
        sha256 = "i4r6tZtOdt1ZzTeITUprtOQl6RncKMhnd4m+BqYqgBk=";
      }
      {
        name = "vscode-pull-request-github";
        publisher = "GitHub";
        version = "0.107.2025032704";
        sha256 = "dLg9GAQ9Gu3YZE4PH6UuH0aQitsZJGD4nHv3yqK6nTQ=";
      }
      #{
      #  name = "copilot";
      #  publisher = "GitHub";
      #  version = "VERSION";
      #  sha256 = "HASH";
      #}
      #{
      #  # https://docs.github.com/en/copilot/troubleshooting-github-copilot/troubleshooting-issues-with-github-copilot-chat#troubleshooting-issues-caused-by-version-incompatibility
      #  # > every new version of Copilot Chat is only compatible with the latest release of Visual Studio Code.
      #  # > This means that if you are using an older version of Visual Studio Code, you will not be able to use the latest Copilot Chat.
      #  # https://www.vsixhub.com/s.php?s=GitHub+Copilot+Chat#gsc.tab=0&gsc.q=GitHub%20Copilot%20Chat&gsc.page=1
      #  name = "copilot-chat";
      #  publisher = "GitHub";
      #  version = "VERSION";
      #  sha256 = "HASH";
      #}

      ######################
      # Programming Language

      # HashiCorp Configuration Language
      {
        name = "terraform";
        publisher = "HashiCorp";
        version = "2.34.2025012311";
        sha256 = "SmADVhgysDDvmI2/FZHoNWfgSrcxQfJTJj4ZgxOxjhc=";
      }
      # Scala
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.48.0";
        sha256 = "GtlVj/XvnlsLQb8PwXl6S2OW0mOl8SCR3N76zhZBwxA=";
      }
      {
        name = "scala";
        publisher = "scala-lang";
        version = "0.5.9";
        sha256 = "zgCqKwnP7Fm655FPUkD5GL+/goaplST8507X890Tnhc=";
      }

      ############
      # Data Store

      {
        name = "mysql-shell-for-vs-code";
        publisher = "oracle";
        version = "1.19.3";
        sha256 = "t/Z4vOsR2GseFQj5N6VzYiAj0AJiwC1mF2N+LdTwUcM=";
      }
    ]);
  };

  home.activation.vscodeVimConfig = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    echo "Setting VSCode Vim Extension configuration..."
    /usr/bin/defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
    /usr/bin/defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  '';
}
