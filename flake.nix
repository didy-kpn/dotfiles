{
  description = "kpn-didy's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents.url = "github:numtide/llm-agents.nix";
  };

  outputs = { self, nixpkgs, home-manager, llm-agents, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.kpn-didy-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/kpn-didy-nixos/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kpn-didy = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit llm-agents;
              inherit system;
            };
          }
        ];
      };
    };
}
