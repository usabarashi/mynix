{ inputs, system }:

{
  vdh-cli = inputs.vdh-cli.packages.${system}.default or null;
  voicevox-cli = inputs.voicevox-cli.packages.${system}.default or null;
}