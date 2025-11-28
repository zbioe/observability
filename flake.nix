{
  description = "Observability";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11-small";
    utils.url = "github:numtide/flake-utils";
    compat.url = "github:nix-community/flake-compat";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
      compat,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells = rec {
          main = import ./devShell.nix { inherit pkgs; };
          default = main;
        };
      }
    );
}
