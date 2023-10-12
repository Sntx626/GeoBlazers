{
  description = "Set up an environment to easily create and present slides markdown based slides";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      formatter = pkgs.alejandra;

      packages = rec {
        default = slides;

        slides = pkgs.writeShellScriptBin "startSlides" ''
          ${pkgs.slides}/bin/slides main.md
        '';

        present = pkgs.writeShellScriptBin "startPresent" ''
          ${pkgs.present}/bin/present main.md
        '';

        patat = pkgs.writeShellScriptBin "startPatat" ''
          ${pkgs.haskellPackages.patat}/bin/patat main.md
        '';
      };

      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          slides
          present
          viu # image in the terminal
        ];
      };
    });
}
