{
  description = "An mdBook project using plugins";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    mdbook.url = "github:pbar1/nix-mdbook";
  };

  outputs =
    {
      systems,
      nixpkgs,
      mdbook,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        rec {
          book = mdbook.lib.buildMdBookProject {
            inherit pkgs system;
            name = "with-plugin";
            src = ./.;
            nativeBuildInputs = with pkgs; [
              mdbook-graphviz
              graphviz
            ];
          };
          default = book;
        }
      );
    };
}
