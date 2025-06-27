{ customPackages, flakeInputs }:

[
  (final: prev: {
    inherit customPackages flakeInputs;
  })
]
