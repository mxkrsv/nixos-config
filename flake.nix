{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    #nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";

      # reduces size, but may break build
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    agenix.url = "github:ryantm/agenix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, lanzaboote, nixvim, agenix, nix-index-database, ... }@inputs: {
    nixosConfigurations = {
      sayaka = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ ... }: { networking.hostName = "sayaka"; })
          ./system
          ./system/sayaka
          lanzaboote.nixosModules.lanzaboote
        ];
      };

      homura = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ ... }: { networking.hostName = "homura"; })
          ./system
          ./system/homura
          lanzaboote.nixosModules.lanzaboote
        ];
      };

      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ({ ... }: { networking.hostName = "fallback-hostname"; })
          ./system
        ];
      };
    };

    homeConfigurations = {
      "mxkrsv@sayaka" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home
          ./home/gui
          nixvim.homeManagerModules.nixvim
          agenix.homeManagerModules.age
          nix-index-database.hmModules.nix-index
        ];
      };

      "mxkrsv@homura" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home
          ./home/gui
          nixvim.homeManagerModules.nixvim
          agenix.homeManagerModules.age
          nix-index-database.hmModules.nix-index
        ];
      };

      "mxkrsv@default" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home
          ./home/gui
          nixvim.homeManagerModules.nixvim
          nix-index-database.hmModules.nix-index
        ];
      };
    };
  };
}
