{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        templates = {
          rust-project = {
            path = ./templates/rust-project;
            description = "A Rust template, using crane, treefmt-nix and flake-utils";
            welcomeText = ''
              # Getting started
              1. Edit rust-toolchain.toml, to change rust-toolchain version.
              2. Edit project's name in flake.nix
              3. If you want to create binary application, edit .gitignore
              4. Run `cargo init`!!
            '';
          };
          with-flake-parts = {
            path = ./templates/with-flake-parts;
            description = "A Rust template, using crane, treefmt-nix and flake-parts";
            welcomeText = ''
              # Getting started
              1. Edit rust-toolchain.toml, to change rust-toolchain version.
              2. Edit project's name in flake.nix
              3. If you want to create binary application, edit .gitignore
              4. Run `cargo init`!!
            '';
          };
          bevyengine-development = {
            path = ./templates/bevyengine-development;
            description = "A Rust template for developing with Bevyengine";
            welcomeText = ''
              # Getting started
              1. Edit rust-toolchain.toml, to change rust-toolchain version.
              2. Edit project's name in flake.nix
              3. If you want to create binary application, edit .gitignore
              4. Run `cargo init`!!
            '';
          };
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";

            # Nix
            programs.nixfmt.enable = true;

            # ShellScripts
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;

            # GitHub Actions
            programs.actionlint.enable = true;
          };

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.nil
            ];
          };
        };
    };
}
