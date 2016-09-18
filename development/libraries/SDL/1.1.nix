{ stdenv, fetchurl, pkgconfig
, libX11, libXext, libXt, alsaLib, mesa_noglu, mesa_glu
}:

stdenv.mkDerivation rec {
  name = "SDL-${version}";
  version = "1.1.8";
      
  src = fetchurl {
    url = "https://www.libsdl.org/release/${name}.tar.gz";
    sha256 = "0fsfrmbymibxhrh0bcjxqbq7vb8fiakaw30w3hwkfa28shw7wp2l";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ 
    libX11 libXext libXt alsaLib mesa_noglu mesa_glu
  ];

  configureFlags = [ "--disable-oss" "--disable-video-fbcon" ];

  meta = with stdenv.lib; {
    description = "A cross-platform multimedia library";
    homepage = "http://www.libsdl.org/";
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
