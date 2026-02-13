{
  description = "Personal forester notes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    forester = {
      url = "sourcehut:~jonsterling/ocaml-forester";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, forester }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        foresterPkg = forester.packages.${system}.default;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            foresterPkg
            pkgs.texlive.combined.scheme-medium
            pkgs.python3
            pkgs.fswatch
          ];
        };
      }
    );
}
