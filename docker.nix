{ config, pkgs, ... }:

let 
  os = if pkgs.stdenv.isLinux then "linux"
       else if pkgs.stdenv.isDarwin then "darwin"
       else throw "Unsupported architecture";
  arch = if pkgs.stdenv.isx86_64 then "x86_64"
         else if pkgs.stdenv.isAarch64 then "aarch64"
         else throw "Unsupported architecture";
  composeVersion = "v2.17.3";
in
{
  home.packages = with pkgs; [
    docker
  ];

  # see: https://github.com/docker/compose/releases
  home.activation.dockerComposeConfig = config.lib.dag.entryAfter ["writeBoundary"] ''
    echo "Setting Docker Compose Plugin configuration..."
    mkdir -p ${config.home.homeDirectory}/.docker/cli-plugins
    /usr/bin/curl -SL https://github.com/docker/compose/releases/download/${composeVersion}/docker-compose-${os}-${arch} \
      -o ${config.home.homeDirectory}/.docker/cli-plugins/docker-compose
    chmod a+x ${config.home.homeDirectory}/.docker/cli-plugins/docker-compose
  '';
}
