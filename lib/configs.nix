{ lib, homeModules, hostPaths }:

let
  # Purpose-based configuration mapping
  purposeConfigs = {
    "PRIVATE" = {
      homeModule = homeModules.darwin;
      hostPath = hostPaths.private;
    };
    "WORK" = {
      homeModule = homeModules.work;
      hostPath = hostPaths.work;
    };
  };
in
{
  inherit purposeConfigs;
  
  # Validate and select configuration based on purpose
  selectConfig = hostPurpose:
    purposeConfigs.${hostPurpose} or 
    (builtins.throw "❌ HOST_PURPOSE must be one of: ${lib.concatStringsSep ", " (builtins.attrNames purposeConfigs)}. Got: '${hostPurpose}'");
}