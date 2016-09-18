{ stdenv, fetchurl, alsaLib }:

stdenv.mkDerivation rec {
  name = "libmikmod-${version}";
  version = "3.1.12";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/${name}.tar.gz";
    sha256 = "0cpwpl0iqd5zsdwshw69arzlwp883bkmkx41wf3fzrh60dw2n6l9";
  };

  buildInputs = [ alsaLib ];

  configureFlags = [ "--disable-oss" ];

  NIX_CFLAGS_COMPILE = [ "-Wno-cpp" ];

  # Docs don't build
  postPatch = ''
    sed -i 's,docs,,g' Makefile.in
  '';

  meta = with stdenv.lib; {
    description = "A library for playing tracker music module files";
    homepage = http://mikmod.shlomifish.org/;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;

    longDescription = ''
      A library for playing tracker music module files supporting many formats,
      including MOD, S3M, IT and XM.
    '';
  };
}
