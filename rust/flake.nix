{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
    imports = [
    ];
    perSystem = { self', pkgs, lib, system, ... }: {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      devShells.default = with pkgs; mkShell {
          buildInputs = [ cargo rustc ];
          RUST_SRC_PATH = rustPlatform.rustLibSrc;
      };
    };
    flake = {
    };
  };
}