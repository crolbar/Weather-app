{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    systems = ["x86_64-linux"];
    eachSystem = nixpkgs.lib.genAttrs systems;

    pkgsFor = eachSystem (
      system:
        import nixpkgs {inherit system;}
    );
  in {
    devShells = eachSystem (
      system: let
        pkgs = pkgsFor.${system};
        run = pkgs.writers.writeBashBin "run" "g++ ./src/main.cpp -o ./build/main -lcurl && ./build/main";
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            curl
            gdc
            run
          ];
        };
      }
    );
    packages = eachSystem (
      system: let
        pkgs = pkgsFor.${system};
      in {
        default = pkgs.callPackage ./default.nix {};
      }
    );
  };
}
