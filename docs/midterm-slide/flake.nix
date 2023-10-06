{
  description = "Set up an environment to easily create and present slides markdown based slides";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            slides
          ];
        };

        packages.default = pkgs.writeShellScriptBin "startPresentation" ''
          ${pkgs.slides}/bin/slides main.md
        '';
      });
}
