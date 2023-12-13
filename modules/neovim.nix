# see: https://neovim.io/
# see: https://github.com/rockerBOO/awesome-neovim
# see: https://github.com/nix-community/home-manager/blob/master/modules/programs/neovim.nix
{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraConfig = ''
      noremap <Tab> <c-w><c-w>
      noremap j gj
      noremap k gk
      set cursorline
      set confirm
      set number
    '';

    plugins = with pkgs.vimPlugins; [
      vim-nix
    ];
  };

}
