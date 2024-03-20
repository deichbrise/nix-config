{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }: {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacBook-Pro-von-Pascal
    darwinConfigurations."MacBook-Pro-von-Pascal" = nix-darwin.lib.darwinSystem {
      modules = [ 
        home-manager.darwinModules.home-manager 
        ./hosts/MacBook-Pro-von-Pascal/default.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MacBook-Pro-von-Pascal".pkgs;
  };
}
