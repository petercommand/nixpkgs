{ stdenv, fetchFromGitHub, python3, sass, glib, gdk-pixbuf, libxml2,
  inkscape, optipng, gtk-engine-murrine
}:

stdenv.mkDerivation rec {
  version = "20170810";
  name = "numix-solarized-gtk-theme-${version}";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "numix-solarized-gtk-theme";
    rev = version;
    sha256 = "0l4xvsiyg15kp6xwpvm3jckxyhr1lxd678lkhrcyf40n7rd4xinl";
  };

  nativeBuildInputs = [ python3 sass glib gdk-pixbuf libxml2 inkscape optipng ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
    substituteInPlace scripts/render-assets.sh \
      --replace /usr/bin/inkscape ${inkscape}/bin/inkscape \
      --replace /usr/bin/optipng ${optipng}/bin/optipng
  '';

  buildPhase = "true";

  installPhase = ''
    for theme in *.colors; do
      make THEME="''${theme/.colors/}" install
    done
  '';

  meta = with stdenv.lib; {
    description = "Solarized versions of Numix GTK2 and GTK3 theme";
    longDescription = ''
      This is a fork of the Numix GTK theme that replaces the colors of the theme
      and icons to use the solarized theme with a solarized green accent color.
      This theme supports both the dark and light theme, just as Numix proper.
    '';
    homepage = https://github.com/Ferdi265/numix-solarized-gtk-theme;
    downloadPage = https://github.com/Ferdi265/numix-solarized-gtk-theme/releases;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.offline ];
  };
}
