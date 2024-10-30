{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/5633bcff0c6162b9e4b5f1264264611e950c8ec7";

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

        run = pkgs.writers.writeBashBin "run" ''
          mkdir -p build
          cd build

          cmake ..
          make -j$(nproc)

          export QT_PLUGIN_PATH="${pkgs.qt6.qtbase}/lib/qt-6/plugins:${pkgs.qt6.qtdeclarative}/lib/qt-6/plugins:${pkgs.qt6.qtwayland}/lib/qt-6/plugins"
          export NIXPKGS_QT6_QML_IMPORT_PATH="${pkgs.qt6.qtdeclarative}/lib/qt-6/qml:${pkgs.qt6.qtwayland}/lib/qt-6/qml"

          ./WeatherApp
        '';
      in {
        default = pkgs.mkShell {
          packages = with pkgs; [
            curl
            gdc
            cmake
            ninja

            qt6.qtbase
            qt6.full
            pkg-config
            clang-tools
            run
          ];

          shellHook = ''
            CMAKE_EXPORT_COMPILE_COMMANDS=1 cmake -S . -B ./build
            ln -s build/compile_commands.json .
          '';
        };
      }
    );

    packages = eachSystem (
      system: let
        pkgs = pkgsFor.${system};
      in {
        default = pkgs.callPackage ./package.nix {};
      }
    );
  };
}
