{
  description = "NixOS desktop configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flyline = {
      url = "github:HalFrgrd/Flyline";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flyline, zen-browser, ... }: {
    nixosModules.default = { pkgs, ... }: {
      imports = [ ./default.nix flyline.nixosModules.default ];
      _module.args.finpilotZen = zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

    nixosConfigurations.surface = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        self.nixosModules.default
        ./hosts/surface/configuration.nix
      ];
    };
  };
}