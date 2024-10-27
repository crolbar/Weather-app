{
  stdenv,
  curl,
  gcc,
}:
stdenv.mkDerivation rec {
  name = "WeatherApp";
  src = ./.;

  buildInputs = [curl gcc];

  buildPhase = ''
    g++ ${src}/src/main.cpp -o ${name} -lcurl
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ${name} $out/bin
  '';
}
