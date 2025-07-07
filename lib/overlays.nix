{ flakeInputs }:

[
  (final: prev: {
    customPackages = import ../packages { pkgs = final; };
    inherit flakeInputs;
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
