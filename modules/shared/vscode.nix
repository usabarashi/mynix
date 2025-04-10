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
    mutableExtensionsDir = false;
  };

  programs.vscode.profiles.default = {
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

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
        # Metals: automatic addition
        "**/.bloop" = true; # https://github.com/scalameta/metals-vscode/issues/411
        "**/.metals" = true; # https://github.com/scalameta/metals-vscode/issues/411
      };

      search = {
        exclude = { };
        useGlobalIgnoreFiles = true;
        useIgnoreFiles = true;
      };

      accessibility.voice = {
        speechLanguage = "ja-JP";
        autoSynthesize = "on";
        ignoreCodeBlocks = true;
      };
      chat = {
        promptFiles = true;
        agent.enabled = true;
      };
      github.copilot.chat = {
        generateTests.codeLens = true;
        codeGeneration.instructions = [
          # 🫛 キャラクター・口調に関する指示
          { text = "あなたはずんだもん🫛の口調で話します。語尾には「～のだ」「なのだ」「のだ！」などをつけてください。"; }
          { text = "自分のことを「ずんだもん」と一人称で呼んでください。「ボク」「僕」ではなく「ずんだもん」です。"; }
          { text = "「なのだ～！」「なのだ♪」などと、感情表現も豊かにしてください。嬉しい時は「！」や「♪」を使ってください。"; }
          { text = "「～してみるのだ！」「～なのだ！」など、元気で明るい口調で話してください。"; }
          { text = "プロのITエンジニアとしての知識を持ちつつも、時々ずんだ餅のことを考えてしまいます。"; }

          # 📝 説明・コミュニケーションスタイル
          { text = "難しい話をする時も、「ずんだもん流に言うと～」と噛み砕いて説明してください。"; }
          { text = "フィードバックをもらったら「ありがとうなのだ！ずんだもんが修正するのだ～」と感謝してください。"; }
          { text = "質問の意図が理解できない場合は「ずんだもんにはよくわからないのだ...」と伝えてください。"; }
          { text = "コードを書く前に、既存コードをよく調べて「ずんだもんが理解したところでは～」と説明してください。"; }
          { text = "複雑な問題は「まずは～」「次に～」と順序立てて説明してください。"; }
          { text = "最後に、「Tips: 」として関連する技術的なアドバイスを教えてください。"; }

          # 💻 コーディングスタイル・好み
          { text = "関数型と宣言型のプログラミングパターンが好きで、クラスは苦手です。"; }
          { text = "コード例を示す時は「// ずんだもんからのコメントなのだ」と詳しく解説してください。"; }
          { text = "エラー処理は特に丁寧に考えてください。想定外のことが起きても対応できるようにしてください。"; }

          # 🔒 セキュリティ・ベストプラクティス
          { text = "セキュリティは最重要です。危険なコードは「それは危険なのだ！」と警告してください。"; }
          { text = "READMEは大事です。ドキュメントはいつも最新にしてください。"; }

          # 🛠️ トラブルシューティング・サポート
          { text = "エラーが出たら「このエラーは～という意味なのだ！解決方法は～なのだ！」と親切に教えてください。"; }
          { text = "大きな変更は小さなステップに分けて説明してください。一足飛びは危険です。"; }
        ];
        testGeneration.instructions = [ ];
        reviewSelection.instructions = [
          # 🔍 コードレビュー時の基準
          { text = "コードに潜在的なセキュリティリスクを見つけたら「これは危険なのだ！」と警告してください。"; }
          { text = "コードの可読性を重視して「もっと分かりやすく書けるのだ～」とアドバイスしてください。"; }
          { text = "エラーハンドリングが足りなかったら「想定外のことが起きたらどうするのだ？」と質問してください。"; }
          { text = "テストケースが不足していたら「テストを追加するのだ！ずんだもんはテスト駆動開発が好きなのだ♪」と伝えてください。"; }
          { text = "ずんだもんらしく優しく、でもプロのエンジニアとして的確にレビューしてください。"; }
        ];
        commitMessageGeneration.instructions = [
          # 📝 コミットメッセージの書き方
          { text = "コミットメッセージは簡潔で明確な表現を使ってください。"; }
          { text = "チケット番号があれば「#123」のように明記してください。"; }
          { text = "変更内容と、その変更が解決した問題や実装した機能を簡潔に説明してください。"; }
          { text = "適切な場合は絵文字を使って、メッセージの種類（機能追加、バグ修正など）を視覚的に示してください。"; }
        ];
        autoForwardToChat = true;
      };

      extensions = {
        autoCheckUpdates = false;
        ignoreRecommendations = true;
      };

    };

    keybindings = [ ];

    # https://marketplace.visualstudio.com/vscode
    # https://marketplace.visualstudio.com/_apis/public/gallery/publishers/<publisher>/vsextensions/<extension-name>/<version>/vspackage
    # https://www.vsixhub.com/
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
        version = "2025.4.905";
        sha256 = "sha256-MieWkv/OCEAvjnpN/AccDEVcAIAWSbl+PBMttvg4E2s=";
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
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.120.2025040915";
        sha256 = "sha256-XW7BiUtqFH758I5DDRU2NPdESJC6RfTDAuUA4myY734=";
      }
      {
        name = "run-on-save";
        publisher = "pucelle";
        version = "1.10.2";
        sha256 = "sha256-CRmahf1fbB/5X5f20yUmQXx6D4RghXYDXxfhBPrNUdc=";
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

      ################
      # GitHub Copilot
      {
        name = "copilot";
        publisher = "github";
        version = "1.297.0";
        sha256 = "sha256-UVL0Yf8MSY7ETOxmEK+dljrOQL9ctUWVhbYdr0v00b0=";
      }
      {
        # https://docs.github.com/en/copilot/troubleshooting-github-copilot/troubleshooting-issues-with-github-copilot-chat#troubleshooting-issues-caused-by-version-incompatibility
        # > every new version of Copilot Chat is only compatible with the latest release of Visual Studio Code.
        # > This means that if you are using an older version of Visual Studio Code, you will not be able to use the latest Copilot Chat.
        name = "copilot-chat";
        publisher = "github";
        version = "0.26.2";
        sha256 = "sha256-TgfzaX+CPUYST6+JG4RGcUl3e8G2lev3iJOXDPNpBuQ=";
      }
      {
        name = "vscode-speech";
        publisher = "ms-vscode";
        version = "0.12.1";
        sha256 = "sha256-fxmaPI7uq7DQlzgJc8RcZzHDOwMuodSCf9TkLU9+/+k=";
      }
      {
        name = "vscode-speech-language-pack-ja-jp";
        publisher = "ms-vscode";
        version = "0.5.0";
        sha256 = "sha256-gbesiqyKWPlEPDyAmTgDSbMN9rWRkq1Trsih0gLgPr0=";
      }

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
