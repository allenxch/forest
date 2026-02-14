# Crimson Forest

My personal forest of interconnected notes on mathematics, type theory, category theory, and functional programming.

**Live site:** https://allenxch.github.io/forest/

## Quick Start

```bash
# Install forester via opam
opam install forester

# Build the forest
forester build forest.toml

# Serve locally
cd output && python3 -m http.server 1313
```

Open http://localhost:1313 in your browser.

## What is Forester?

Forester is an OCaml tool for creating "Forests" - densely interlinked mathematical websites / Zettelkasten systems, similar to the Stacks project or Kerodon. Created by Jon Sterling (Cambridge University).

## Directory Structure

```
forest/
├── forest.toml          # Main configuration
├── flake.nix            # Nix dev environment (see note below)
├── trees/               # Tree files (notes)
│   ├── index.tree       # Homepage
│   ├── macros.tree      # Shared macros
│   └── xxx-*.tree       # Notes with your prefix
├── theme/               # forester-base-theme (submodule)
├── assets/              # Images, files, etc.
├── output/              # Generated site (after build)
├── dev.sh               # Local dev server with watch
├── deploy.sh            # Manual deployment script
└── .github/workflows/   # Auto-deployment via GitHub Actions
```

## Installation

### Via opam (recommended)

```bash
# Install opam if needed
# Arch: sudo pacman -S opam
# Ubuntu: sudo apt install opam

# Initialize opam (first time only)
opam init --auto-setup --yes
opam update

# Install forester
opam install forester
```

### Via Nix

> **Note:** The forester nix flake currently has upstream dependency issues with OCaml 5.3.0. On NixOS, opam binaries also fail due to dynamic linking. For now, use opam on non-NixOS systems or wait for upstream fixes.

```bash
# If the flake works on your system:
nix develop
forester build forest.toml
```

## Configuration

`forest.toml`:
```toml
[forest]
trees = ["trees"]
assets = ["assets"]
theme = "theme"
home = "index"
url = "https://yourusername.github.io/forest/"
```

## Tree Syntax

Tree files use a LaTeX-like markup:

```
\title{My Note}
\date{2026-02-13}
\taxon{note}
\tag{math}
\import{macros}

\p{A paragraph with \em{emphasis} and \strong{bold}.}

\p{Inline math: #{x^2 + y^2 = z^2}}

##{
  \int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
}

\transclude{xxx-0002}
```

### Key Commands

| Command | Purpose |
|---------|---------|
| `\title{...}` | Note title |
| `\date{YYYY-MM-DD}` | Date |
| `\taxon{...}` | Category (note, definition, theorem, etc.) |
| `\tag{...}` | Tags |
| `\p{...}` | Paragraph |
| `\em{...}` | Italic |
| `\strong{...}` | Bold |
| `\code{...}` | Inline code |
| `#{...}` | Inline math |
| `##{...}` | Display math |
| `\transclude{id}` | Include another tree |
| `\import{macros}` | Import macro definitions |

### Lists

```
\ul{
  \li{Item 1}
  \li{Item 2}
}
```

### Code Blocks

```
\startverb
def hello():
    print("Hello")
\stopverb
```

## Creating New Trees

```bash
forester new --dest=trees --prefix=xxx
# Creates: trees/xxx-XXXX.tree
```

Tree IDs use base-36 (0-9, A-Z), allowing ~1.6 million unique IDs per prefix.

## Deployment

### Automatic (GitHub Actions)

Push to `main` → CI builds and deploys to `gh-pages`.

Enable GitHub Pages:
1. Settings → Pages
2. Source: Deploy from branch
3. Branch: `gh-pages`, folder: `/ (root)`

### Manual

```bash
./deploy.sh
```

## Macros

Define in `macros.tree`:
```
\title{Macros}

\def\cat[x]{#{\mathbf{#x}}}
\def\Set{\cat{Set}}
\def\N{#{\mathbb{N}}}
```

Use in other trees:
```
\import{macros}
\p{Consider the category \Set.}
```

## Resources

- Forester source: https://git.sr.ht/~jonsterling/ocaml-forester
- Documentation: https://www.forester-notes.org/
- Example forests:
  - https://utensil.github.io/forest/
  - https://trebor-huang.github.io/forest/
  - https://forest.localcharts.org/

## Known Limitations

1. Syntax more verbose than Markdown
2. No partial transclusion (entire trees only)
3. No Markdown import/export
4. Relies on browser XSLT transformation
5. Nix flake has upstream OCaml dependency issues
