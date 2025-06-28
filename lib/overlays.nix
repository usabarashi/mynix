{ customPackages, flakeInputs }:

[
  (final: prev: {
    inherit customPackages flakeInputs;
  })

  (final: prev: {
    lib = prev.lib.extend (
      libFinal: libPrev: {
        maintainers = libPrev.maintainers // {
          usabarashi = {
            github = "usabarashi";
          };
        };
      }
    );
  })
]
