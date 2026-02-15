# Forest

My forest of interconnected notes on math, types, and more.

**Live site:** https://allenxch.github.io/forest/

[Forester](https://git.sr.ht/~jonsterling/ocaml-forester) created by Jon Sterling is a tool for creating "forests" - a linked Zettelkasten system, similar to the ones used in Stacks project or Kerodon. 

## Installation

### opam 

```bash
opam init --auto-setup --yes
opam update

opam switch create forester 5.3.0
opam install forester
```

### Nix/NixOS

`flake.nix` provides opam and dependencies:

```bash
nix develop
forester build forest.toml
```

## Resources

- Forester source: https://git.sr.ht/~jonsterling/ocaml-forester
- Documentation: https://www.forester-notes.org/
- Example forests:
  - https://trebor-huang.github.io/forest/
  - https://forest.localcharts.org/
