{
  description = "Custom cachix.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ayugram-desktop = {
      type = "git";
      submodules = true;
      url = "https://github.com/ndfined-crp/ayugram-desktop/";
    };
  };

  outputs = { self, nixpkgs, ayugram-desktop }:
  let
    systems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
  in {
    packages = forAllSystems (system:
    let 
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.hello;
      htop = pkgs.htop;
      tree = pkgs.tree;
      ayugram-desktop = ayugram-desktop.packages.${system}.default;

      # Custom package that won't be on cache.nixos.org
      nixcache-test = pkgs.writeShellScriptBin "nixcache-test" ''
        echo "Hello from nixcache-oci! Cache is working."
        echo "Built at: 2026-04-05"
      '';
    });

    # nixosConfigurations.my-host = nixpkgs.lib.nixosSystem { ... };
  };
}
