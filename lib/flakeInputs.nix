{ inputs, system }:

{
  voicevox-cli = inputs.voicevox-cli.packages.${system}.default or null;
}
