{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = { self, utils, nixpkgs }:
  (utils.lib.eachSystem [ "x86_64-linux" ] (system:
  let
    pkgsLut = {
      x86_64-linux = nixpkgs.legacyPackages.${system}.extend self.overlay;
    };
    pkgs = pkgsLut.${system};
    pkgsRiscv = import nixpkgs {
      system = "${toString system}";
      crossSystem = {
        config = "riscv64-none-elf";
      };
    };
  in {
    packages = {
      inherit (pkgs) minichlink;
    };
    hydraJobs = {
      inherit (self) packages;
    };
    devShell = pkgsRiscv.mkShell {
      buildInputs = [
        pkgs.minichlink
        pkgs.gnumake
      ];
      shellHook = ''
        export MINICHLINK="${pkgs.minichlink}/bin"
      '';
    };
  })) // {
    overlay = self: super: {
      minichlink = self.callPackage ./minichlink.nix {};
    };
  };
}
