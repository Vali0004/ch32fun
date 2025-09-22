{ stdenv
, gnumake
, lib
, libusb1
}:

stdenv.mkDerivation {
  name = "minichlink";

  src = ./.;

  nativeBuildInputs = [ gnumake ];
  buildInputs = [ libusb1 ];

  buildPhase = ''
    make -C minichlink all
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp -v minichlink/minichlink $out/bin/minichlink
    cp -v minichlink/minichlink.so $out/lib/minichlink.so
  '';
}
