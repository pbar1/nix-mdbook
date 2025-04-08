{
  description = "A simple mdBook project";

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
      packages = eachSystem (system: rec {
        book = mdbook.lib.buildMdBookProject {
          inherit system;
          name = "simple";
          src = ./.;
        };
        default = book;
      });
    };
}
