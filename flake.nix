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
  };

  outputs = { nixpkgs, home-manager, lanzaboote, nixvim, agenix, ... }@inputs: {
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
        ];
      };

      "mxkrsv@default" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./home
          ./home/gui
          nixvim.homeManagerModules.nixvim
        ];
      };
    };
  };
}
