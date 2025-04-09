# nix-mdbook

Nix library flake for building [mdBook][mdbook] projects.

## Quickstart

Create a new flake in the current directory using the [`simple`][simple]
template in this repo:

```sh
nix flake init -t github:pbar1/nix-mdbook#simple
```

For a slightly more complex example - using mdBook plugins like
[`mdbook-graphviz`][mdbook_graphviz] - create a new flake using the
[`with-plugin`][with_plugin] template:

```sh
nix flake init -t github:pbar1/nix-mdbook#with-plugin
```

Then, build the book. The Nix store output in `result/` is the contents of the
built `book/` directory (ie, the compiled book itself):

```sh
nix build .#book
```

### GitHub Actions & Pages

The `with-plugin` example from above is built using GitHub Actions and deployed
to GitHub Pages as a test.

- [Demo site](https://pbar1.github.io/nix-mdbook)
- [GitHub Actions workflow](./.github/workflows/publish-github-pages.yml)

## Usage

### Flake

```nix
{
  inputs.mdbook.url = "github:pbar1/nix-mdbook";
  outputs =
    { mdbook, ... }:
    let
      system = "x86_64-linux";
    in
    {
      packages = rec {
        book = mdbook.lib.buildMdBookProject {
          inherit system;
          src = ./.;
        };
        default = book;
      };
    };
}
```

### `mdbook.lib.buildMdBookProject`

| Attribute            | Default Value      | Description                                                                                                        |
| -------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------ |
| `pkgs`               | `null`             | Optional Nixpkgs instance. If not provided, a new instance will be imported using the specified system.            |
| `system`             | (required)         | The system architecture to build for (e.g., "x86_64-linux").                                                       |
| `src`                | (required)         | Source directory containing the mdBook project.                                                                    |
| `name`               | `"mdbook-project"` | Name of the output package.                                                                                        |
| `bookDir`            | `"book"`           | Directory where mdBook outputs its generated files.                                                                |
| `mdBookBuildOptions` | `""`               | Additional command-line options to pass to `mdbook build`.                                                         |
| `nativeBuildInputs`  | `[ ]`              | List of additional build inputs (e.g., mdBook plugins) to include. The `mdbook` package is automatically included. |
| `postBuild`          | `""`               | Custom commands to run after the build phase.                                                                      |
| `postInstall`        | `""`               | Custom commands to run after the installation phase.                                                               |

<!-- Links -->

[mdbook]: https://github.com/rust-lang/mdBook
[simple]: ./examples/simple/flake.nix
[with_plugin]: ./examples/with-plugin/flake.nix
[mdbook_graphviz]: https://github.com/dylanowen/mdbook-graphviz
