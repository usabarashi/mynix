{ inputs, customPackages }:

[
  (final: prev: {
    customPackages = customPackages.packages.${final.system};
    flakeInputs = import ./flakeInputs.nix { inherit inputs; system = final.system; };
  })
]