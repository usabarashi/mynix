{
  lib,
  stdenv,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation {
  pname = "gemini-cli-sandboxed";
  version = "0.2.1";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nodejs ];

  installPhase = ''
    mkdir -p $out/bin
    
    # Create a self-contained stub script that avoids node-pty build issues
    cat > $out/bin/gemini << 'EOF'
#!/usr/bin/env bash
# Gemini CLI sandboxed stub - installs on first use to avoid build issues
CACHE_DIR="$HOME/.cache/gemini-cli-sandboxed"
INSTALL_FLAG="$CACHE_DIR/.installed"

if [[ ! -f "$INSTALL_FLAG" ]]; then
  echo "Installing Gemini CLI on first use..." >&2
  mkdir -p "$CACHE_DIR"
  cd "$CACHE_DIR"
  npm install @google/gemini-cli@0.2.1 --no-save --prefer-offline 2>/dev/null || {
    echo "Warning: Could not install Gemini CLI. Using npx instead." >&2
    touch "$INSTALL_FLAG"
    exec npx --yes @google/gemini-cli@0.2.1 --sandbox "$@"
  }
  touch "$INSTALL_FLAG"
fi

if [[ -f "$CACHE_DIR/node_modules/.bin/gemini" ]]; then
  exec "$CACHE_DIR/node_modules/.bin/gemini" --sandbox "$@"
else
  exec npx --yes @google/gemini-cli@0.2.1 --sandbox "$@"
fi
EOF
    chmod +x $out/bin/gemini
  '';

  meta = with lib; {
    description = "AI agent that brings the power of Gemini directly into your terminal (sandboxed stub version)";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.usabarashi ];
  };
}
