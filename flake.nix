{
  description = "A basic example robotnix configuration";

  inputs.robotnix.url = "github:mschwaig/robotnix/verify";

  outputs = { self, robotnix }: {
    # "dailydriver" is an arbitrary user-chosen name for this particular
    # configuration.  Change it to something meaningful for you, perhaps just
    # the device name if you only have one of this kind of device.
    robotnixConfigurations."dailydriver" = robotnix.lib.robotnixSystem ({ config, pkgs, ... }: {
      # These two are required options
      device = "oriole";
      flavor = "vanilla"; # "grapheneos" is another option
      apps.chromium.enable = false;
      # buildDateTime is set by default by the flavor, and is updated when those flavors have new releases.
      # If you make new changes to your build that you want to be pushed by the OTA updater, you should set this yourself.
      # buildDateTime = 1584398664; # Use `date "+%s"` to get the current time

      signing.enable = true;
      signing.keyStorePath = "/var/secrets/robotnix"; # A _string_ of the path for the key store.

      # Build with ccache
      # ccache.enable = true;
    });

    # This provides a convenient output which allows you to build the image by
    # simply running "nix build" on this flake.
    # Build other outputs with (for example): "nix build .#robotnixConfigurations.dailydriver.ota"
    defaultPackage.x86_64-linux = self.robotnixConfigurations."dailydriver".img;
  };
}
