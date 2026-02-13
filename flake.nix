{
  description = "Personal forester notes";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.texlive.combined.scheme-medium
          pkgs.python3
          pkgs.fswatch
        ];

        shellHook = ''
          export PATH="$HOME/.opam/default/bin:$PATH"
          if ! command -v forester &> /dev/null; then
            echo "Forester not found. Install with: opam install forester"
          fi
        '';
      };
    };
}
