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

    nixvim.url = "github:pta2002/nixvim";

    agenix.url = "github:ryantm/agenix";
  };

  outputs = { nixpkgs, home-manager, lanzaboote, nixvim, agenix, ... }@attrs: {
    nixosConfigurations = {
      sayaka = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./system/configuration.nix
          lanzaboote.nixosModules.lanzaboote
        ];
      };
    };

    homeConfigurations = {
      "mxkrsv@sayaka" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = attrs;
        modules = [
          ./home
          ./home/gui
          nixvim.homeManagerModules.nixvim
          agenix.homeManagerModules.age
        ];
      };
    };
  };
}
