{ lib }:

let
  getEnvOrThrow =
    var: fallbackMsg:
    let
      value = builtins.getEnv var;
    in
    if value != "" then value else builtins.throw fallbackMsg;
in
{
  repoPath = getEnvOrThrow "MYNIX_REPO_PATH" "MYNIX_REPO_PATH environment variable must be set for multi-user sharing. Please set it to your repository path.";

  currentUser = getEnvOrThrow "CURRENT_USER" "CURRENT_USER environment variable must be set. Please ensure whoami is available.";

  hostPurpose = builtins.getEnv "HOST_PURPOSE";
  systemType = builtins.getEnv "SYSTEM_TYPE";
  arch = builtins.getEnv "ARCH";
}
