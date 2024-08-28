{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, nixpkgs, flake-utils, treefmt-nix, ... }:
  {
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
    };
  } //
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      formatter = treefmtEval.config.build.wrapper;

      checks = {
        formatting = treefmtEval.config.build.check self;
      };

      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nil
          pkgs.nixpkgs-fmt
        ];

        shellHook = ''
          export PS1="\n[nix-shell:\w]$ "
        '';
      };
    });
}
