{ ... }:
{
  # Combined CA certificate bundle for Netskope SSL inspection.
  # Requires bootstrap: generate the bundle before first `makers apply`.
  # See activation script below for auto-regeneration on subsequent applies.
  #
  # Bootstrap (one-time manual setup):
  #   security find-certificate -a -p \
  #     /System/Library/Keychains/SystemRootCertificates.keychain \
  #     /Library/Keychains/System.keychain \
  #     > /tmp/nix_ca_combined.pem
  #   cat /tmp/nix_ca_combined.pem \
  #     "/Library/Application Support/Netskope/STAgent/data/nscacert.pem" \
  #     | sudo tee /etc/nix/ca_cert.pem > /dev/null
  #   rm /tmp/nix_ca_combined.pem
  #   sudo sh -c 'echo "ssl-cert-file = /etc/nix/ca_cert.pem" >> /etc/static/nix/nix.conf'
  #   sudo launchctl kickstart -k system/org.nixos.nix-daemon
  nix.settings."ssl-cert-file" = "/etc/nix/ca_cert.pem";

  system.activationScripts.postActivation.text = ''
    # Regenerate combined CA certificate bundle (system CAs + Netskope CA)
    NETSKOPE_CERT="/Library/Application Support/Netskope/STAgent/data/nscacert.pem"
    TARGET="/etc/nix/ca_cert.pem"
    if [ -f "$NETSKOPE_CERT" ]; then
      security find-certificate -a -p \
        /System/Library/Keychains/SystemRootCertificates.keychain \
        /Library/Keychains/System.keychain \
        > /tmp/nix_ca_combined.pem
      cat /tmp/nix_ca_combined.pem "$NETSKOPE_CERT" > "$TARGET"
      rm -f /tmp/nix_ca_combined.pem
      echo "Netskope SSL: updated $TARGET"
    else
      echo "Netskope SSL: $NETSKOPE_CERT not found, skipping"
    fi
  '';
}
