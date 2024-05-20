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
    nixosConfigurations =
      let
        makeNixosConfiguration = name: modules: nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ({ ... }: { networking.hostName = name; })
            ./system

          ] ++ modules;
        };
      in
      {
        fallback = makeNixosConfiguration "fallback-hostname" [ ];

        sayaka = makeNixosConfiguration "sayaka" [
          ./system/sayaka
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.age
        ];

        homura = makeNixosConfiguration "homura" [
          ./system/homura
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.age
        ];
      };

    homeConfigurations =
      let
        makeHomeConfiguration = modules: home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home
            nixvim.homeManagerModules.nixvim
            nix-index-database.hmModules.nix-index
          ] ++ modules;
        };
      in
      {
        "mxkrsv@fallback-hostname" = makeHomeConfiguration [ ];

        "mxkrsv@sayaka" = makeHomeConfiguration [
          agenix.homeManagerModules.age
        ];

        "mxkrsv@homura" = makeHomeConfiguration [
          agenix.homeManagerModules.age
        ];
      };
  };
}
