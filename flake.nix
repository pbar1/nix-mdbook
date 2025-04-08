{
  description = "Library for building mdBook projects";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    {
      lib = {
        buildMdBookProject =
          {
            pkgs ? null,
            system,
            src,
            name ? "mdbook-project",
            bookDir ? "book",
            mdBookBuildOptions ? "",
            nativeBuildInputs ? [ ],
            postBuild ? "",
            postInstall ? "",
          }:
          let
            pkgs' = if pkgs != null then pkgs else import nixpkgs { inherit system; };

            nativeBuildInputs' = [ pkgs'.mdbook ] ++ nativeBuildInputs;
          in
          pkgs'.stdenv.mkDerivation {
            inherit name src;

            nativeBuildInputs = nativeBuildInputs';

            buildPhase = ''
              mdbook build ${mdBookBuildOptions}
              ${postBuild}
            '';

            installPhase = ''
              mkdir -p $out
              cp -r ${bookDir}/* $out/
              ${postInstall}
            '';
          };
      };

      templates = {
        simple = {
          description = "A simple mdBook project";
          path = ./examples/simple;
        };

        with-plugin = {
          description = "An mdBook project using plugins";
          path = ./examples/with-plugin;
        };
      };
    };
}
