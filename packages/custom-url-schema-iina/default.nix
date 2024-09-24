{ stdenv }:

let
  appName = "OpenIINA.app";
  plistPath = "${appName}/Contents/Info.plist";
  urlIdentifier = "net.usabarashi.openiina";
  customURLScheme = "openiina";
in
stdenv.mkDerivation {
  name = "customed-url-schema-iina";
  version = "1.0.0";

  src = ./.;

  buildPhase = ''
    set -e

    /usr/bin/osacompile -o ${appName} custom_url_scheme.applescript
    /usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes array" ${plistPath}
    /usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0 dict" ${plistPath}
    /usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLName string ${urlIdentifier}" ${plistPath}
    /usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes array" ${plistPath}
    /usr/libexec/PlistBuddy -c "Add :CFBundleURLTypes:0:CFBundleURLSchemes:0 string ${customURLScheme}" ${plistPath}
  '';

  installPhase = ''
    set -e

    mkdir -p $out/Applications/
    cp -R ${appName} $out/Applications/
  '';

  meta = {
    platforms = [ "aarch64-darwin" ];
    homepage = "https://github.com/l3tnun/EPGStation";
  };
}
