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
          # OCaml/opam dependencies
          pkgs.opam
          pkgs.ocaml
          pkgs.gcc
          pkgs.pkg-config
          pkgs.gmp
          pkgs.libev

          # For LaTeX rendering (tikz-cd diagrams)
          (pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-medium
              standalone
              tikz-cd
              pgf
              tikzfill
              dvisvgm;
          })

          # Development utilities
          pkgs.python3
          pkgs.fswatch
        ];

        shellHook = ''
          eval $(opam env --switch=forester5)
          if ! command -v forester &> /dev/null; then
            echo "Forester not found in forester5 switch."
            echo "Create the switch and install forester with:"
            echo "  opam switch create forester5 5.3.0"
            echo "  opam install forester"
          else
            echo "Forester $(forester --version) ready"
          fi
        '';
      };
    };
}
