{ pkgs }:
with pkgs;
with builtins;
mkShell {
  packages = [
    docker-compose
  ];

  shellHook =
    let
      # Envs default value
      envs = {
        PROVIDER = "docker-compose";
      };
      exportEnvOrDefault = env: default: ''export ${env}=''${${env}:-"${default}"}'';
      exportEnvs =
        envs: concatStringsSep "\n" (map (key: (exportEnvOrDefault key envs."${key}")) (attrNames envs));
    in
    exportEnvs envs;

}
