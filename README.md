# Crimson Forest

My personal forest of interconnected notes on mathematics, type theory, category theory, and functional programming.

**Live site:** https://allenxch.github.io/forest/

## Quick Start

```bash
# Enter development environment
nix develop

# Build the forest
forester build forest.toml

# Serve locally
cd output && python3 -m http.server 1313
```

Or use the dev script for auto-rebuild:
```bash
./dev.sh
```

## What is Forester?

Forester is an OCaml tool for creating "Forests" - densely interlinked mathematical websites / Zettelkasten systems, similar to the Stacks project or Kerodon. Created by Jon Sterling (Cambridge University).

## Forester Resources

- Source: https://git.sr.ht/~jonsterling/ocaml-forester
- GitHub Mirror: https://github.com/jonsterling/ocaml-forester
- OCaml Package: https://ocaml.org/p/forester/4.0.0/doc/README.html
- Example Forest: https://github.com/utensil/forest
- Discussion: https://jacobzelko.com/05172024064639-forest-zettelkasten/

## 1. Installation

### Prerequisites
- OCaml 5
- opam (OCaml package manager)

### Via opam

```bash
# Install opam if not present (Arch Linux)
sudo pacman -S opam

# Initialize opam (first time only)
opam init --auto-setup --yes
opam update

# Install forester
opam install forester
```

### Via Nix (this project)

```bash
# Enter dev shell
nix develop

# Or run forester directly
nix develop --command forester build forest.toml
```

## 2. Directory Structure

```
forest/
├── forest.toml          # Main configuration
├── flake.nix            # Nix development environment
├── trees/               # Your tree files (notes)
│   ├── index.tree       # Homepage
│   ├── macros.tree      # Shared macros
│   └── crimson-0001.tree # Notes with your prefix
├── assets/              # Images, files, etc.
├── output/              # Generated site (after build)
├── dev.sh               # Local development server
├── deploy.sh            # Manual deployment script
└── .github/workflows/   # Auto-deployment via GitHub Actions
```

## 3. Configuration: forest.toml

```toml
[forest]
trees = ["trees"]           # Directory containing .tree files
assets = ["assets"]         # Static assets directory
home = "index"              # Homepage tree (without .tree extension)
url = "https://yoursite.github.io/forest/"  # Base URL

prefixes = ["crimson"]      # Your author prefix for tree IDs
```

## 4. Tree File Syntax

Tree files use a LaTeX-like markup language.

### Basic Structure

```
\title{My Note Title}
\date{2026-02-12}
\taxon{note}
\tag{math}
\tag{draft}
\import{macros}

\p{This is a paragraph. Forester uses \em{backslash commands} for formatting.}

\p{Another paragraph with \strong{bold text} and \code{inline code}.}
```

### Metadata Commands

| Command | Purpose |
|---------|---------|
| `\title{...}` | Note title |
| `\date{YYYY-MM-DD}` | Creation/modification date |
| `\taxon{...}` | Category (note, definition, theorem, lemma, remark, etc.) |
| `\tag{...}` | Tags for organization (can have multiple) |
| `\author{...}` | Author reference |
| `\import{macros}` | Import macro definitions from another tree |

### Text Formatting

| Command | Result |
|---------|--------|
| `\p{...}` | Paragraph |
| `\em{...}` | Emphasis (italic) |
| `\strong{...}` | Strong (bold) |
| `\code{...}` | Inline code |

### Lists

```
\ul{
  \li{Unordered item 1}
  \li{Unordered item 2}
}

\ol{
  \li{Ordered item 1}
  \li{Ordered item 2}
}
```

### Links and References

```
\p{See \link{crimson-0002}{link text} for more.}

% Or automatic title:
\p{Related: [[crimson-0002]]}
```

### Transclusion (Include Another Tree)

```
% Include another tree as a subsection
\transclude{crimson-0002}

% Control expansion state
\scope{
  \put\transclude/expanded{false}
  \transclude{crimson-0003}
}
```

### Verbatim/Code Blocks

```
\startverb
def hello():
    print("Hello, World!")
\stopverb

% With TeX highlighting (in editors that support it):
\startverb%tex
\int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
\stopverb
```

### Mathematics (LaTeX)

```
\p{The quadratic formula is #{x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}}.}

% Display math:
##{
  \int_0^\infty e^{-x^2} dx = \frac{\sqrt{\pi}}{2}
}
```

### Images (via HTML passthrough)

```
\<html:img>[src]{assets/diagram.png}
```

### Block/Section Containers

```
\block{Section Title}{
  \p{Content inside this block.}
}
```

## 5. Tree Identifiers

Forester uses a unique ID system:
- Format: `prefix-XXXX` (your prefix + 4-digit base-36 number)
- Example: `crimson-0001`, `crimson-0A3F`
- Base-36 uses digits 0-9 and letters A-Z
- Allows ~1.6 million unique IDs per prefix

## 6. Creating New Trees

```bash
# Create a new tree with your prefix
forester new --dest=trees --prefix=crimson

# This generates something like: trees/crimson-0002.tree
```

## 7. Building Your Forest

```bash
# Build once
forester build forest.toml

# Output goes to output/ directory
```

## 8. Local Development

### Quick serve

```bash
forester build forest.toml
cd output && python3 -m http.server 1313
```

Open http://localhost:1313

### Watch mode (auto-rebuild)

```bash
./dev.sh
```

Note: Forester outputs XML + XSLT, which transforms to HTML in your browser.

## 9. Deployment

### Option 1: GitHub Actions (automatic)

Push to `main` branch → workflow builds and deploys to `gh-pages`.

First, enable GitHub Pages in repo settings:
- Settings → Pages → Source: "Deploy from a branch" → Branch: `gh-pages`

### Option 2: Manual deployment

```bash
./deploy.sh
```

This builds locally and force-pushes to the `gh-pages` branch.

## 10. Defining Macros

Create reusable macros in `macros.tree`:

```
\title{Macros}

% Category theory
\def\cat[x]{#{\mathbf{#x}}}
\def\Set{\cat{Set}}
\def\Top{\cat{Top}}

% Common symbols
\def\N{#{\mathbb{N}}}
\def\Z{#{\mathbb{Z}}}
\def\R{#{\mathbb{R}}}

% Custom shortcuts
\def\defn[term][body]{\strong{#term}: #body}
```

Then import and use in other trees:

```
\import{macros}

\p{Consider the category \Set of sets.}
\p{\defn{Group}{a set with a binary operation...}}
```

## 11. Known Limitations

1. **Less ergonomic than Markdown** - Verbose syntax for images, code blocks
2. **HTML attributes** - Adding width/style to elements not well-documented
3. **No partial transclusion** - Can only transclude entire trees, not sections
4. **No Markdown interop** - `.tree` is distinct; no import/export for markdown
5. **Browser XSLT** - Output relies on browser XSLT transformation

## 12. Editor Support

- **VSCode**: https://github.com/Trebor-Huang/vscode-forester
  - Syntax highlighting
  - Tree completion
  - New tree creation

## 13. Example Forests

- Jon Sterling: https://www.jonmsterling.com/
- utensil: https://utensil.github.io/forest/
- Trebor Huang: https://trebor-huang.github.io/forest/
- LocalCharts: https://forest.localcharts.org/

## 14. Changing Your Prefix Later

If you decide to change your prefix:

```bash
# Rename files
for f in trees/oldprefix-*.tree; do
  mv "$f" "${f/oldprefix-/newprefix-}"
done

# Update references in all trees
sed -i 's/oldprefix-/newprefix-/g' trees/*.tree

# Update forest.toml
sed -i 's/oldprefix/newprefix/g' forest.toml
```
