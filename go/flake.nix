{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      imports = [ inputs.git-hooks-nix.flakeModule ];
      perSystem = { config, self', pkgs, lib, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pre-commit.settings = {
          hooks = {
            nixpkgs-fmt.enable = true;
            # golangci-lint.enable = true;
            gotest.enable = true;
            govet.enable = true;
            golines.enable = true;
            gofmt.enable = true;
          };
        };

        devShells = {
          default = with pkgs; mkShell { buildInputs = [ go ]; };

          dev = with pkgs;
            mkShell {
              buildInputs =
                [ go golangci-lint delve gotest golines nixfmt-classic ];
              shellHook = ''
                if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
                    ${config.pre-commit.installationScript}
                fi
              '';
            };
        };

        packages = {
          default = pkgs.buildGoModule rec {
            pname = "gorune";
            version = "0.0.1";
            vendorHash = "sha256-mGKxBRU5TPgdmiSx0DHEd0Ys8gsVD/YdBfbDdSVpC3U=";

            src = ./.;

            # doCheck = false;

            # buildInputs = lib.optionals pkgs.stdenv.isLinux [
            # ];

            # nativeBuildInputs = with pkgs; [ pkg-config ];

            # tags = lib.optionals stdenv.isDarwin [ "darwin" ]
            #     ++ lib.optionals stdenv.isLinux [ "docker" ];

            # subPackages = [ "" ];

            # ldflags = [ "-s" "-w" "-X info.version=${version}" ];

            meta = with lib; {
              description = "gorune";
              # license = licenses.asl20;
              # maintainers = with maintainers; [ ];
              mainProgram = pname;
            };
          };
        };
      };
      flake = { };
    };
}
