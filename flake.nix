{
  description = "Single-host NixOS flake for nixxy (AMD desktop + RX 9070 XT)";

  inputs = {
    # RDNA4 (RX 9070 XT) needs a recent kernel and Mesa. Track unstable and
    # re-check ROCm/AI after each flake update — that stack moves quickly.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations.nixxy = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hifzhil = import ./home/hifzhil.nix;
          }
        ];
      };

      # Isolated Buildroot toolchain (FHS). In current nixpkgs this is
      # buildFHSEnv; buildFHSUserEnv is the older name.
      packages.${system}.buildroot-env = pkgs.buildFHSEnv {
        name = "buildroot-env";
        targetPkgs =
          p: with p; [
            bc
            binutils
            bison
            bzip2
            cmake
            cpio
            curl
            file
            flex
            gcc
            gnumake
            gnutar
            ncurses
            patch
            perl
            pkg-config
            python3
            rsync
            unzip
            wget
            which
            xz
            zlib
          ];
        runScript = "bash";
      };

      devShells.${system} = {
        default = pkgs.mkShell {
          packages = with pkgs; [
            git
            nixfmt-rfc-style
          ];
        };

        buildroot = pkgs.mkShell {
          packages = [ self.packages.${system}.buildroot-env ];
          shellHook = ''
            echo "Entering Buildroot FHS env (buildFHSEnv)."
            exec ${self.packages.${system}.buildroot-env}/bin/buildroot-env
          '';
        };

        # Yocto does not fit NixOS's layout. Use CROPS/poky (needs Docker).
        yocto = pkgs.mkShell {
          packages = with pkgs; [
            docker
            git
          ];
          shellHook = ''
            echo "Yocto: run inside a container, not a native Nix env."
            echo "  docker pull crops/poky"
            echo "  mkdir -p \"\$PWD/yocto\""
            echo "  docker run --rm -it -v \"\$PWD/yocto:/workdir\" crops/poky --workdir=/workdir"
          '';
        };
      };
    };
}
