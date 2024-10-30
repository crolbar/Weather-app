{
  stdenv,
  curl,
  gcc,
  cmake,
  qt6,
}:
stdenv.mkDerivation rec {
  name = "WeatherApp";
  src = ./.;

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${name} $out/bin/
  '';
}
