# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./lanzaboote.nix
      ./hmsetup.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "overseer"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable ZSH
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "bira";
    plugins = ["sudo" "git"];
  };

  # Display Manager
#  services.displayManager.sddm.wayland.enable = true;
#  services.displayManager.sddm.enable = true;
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha";
      package = pkgs.kdePackages.sddm;
    };
  };

  # Cursor
  #environment.variables = {
    #XCURSOR_THEME = "Catppuccin-Mocha-Dark-Cursors";
    #XCURSOR-SIZE = "24";
  #};

#  nixpkgs.config = {
#    xdg.cursor.theme = "Catppuccin-Mocha-Dark-Cursors";
#    xdg.cursor.size = 24;
#  };

  # Desktop Environment stuff
  programs = {
       hyprland = {
          enable = true;
          #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          #portal = pkgs.xdg-desktop-portal-hyprland;
          xwayland.enable = true;
      };
       xwayland.enable = true;
       #hyprlock.enable = true;
       #firefox.enable = true;
       git.enable = true;
       #dconf.enable = true;
       #waybar.enable = true;

  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];

  security.polkit.enable = true;
  programs.waybar.enable = true;
  programs.dconf.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-online-accounts.enable = true;
  services.gnome.gnome-keyring.enable = true;
  environment = {
    variables = {
#      XDG_CURRENT_DESKTOP = "Hyprland";
#      XDG_SESSION_TYPE = "wayland";
#      XDG_SESSION_DESKTOP = "Hyprland";
    };
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      T_QPA_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
    };
  };

  # Drive stuff
  services.udisks2.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.winter = {
    isNormalUser = true;
    description = "Winter";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Icons and themes
  environment.variables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    GTK_THEME = "Breeze";
    GTK_ICON_THEME = "Breeze";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     fastfetch
     wofi
     busybox
     pavucontrol
     kitty
     dolphin
     kate
     firefox
     discord
     #steam
     lutris
     lxqt.lxqt-policykit
     waybar
     dunst
     breeze-icons
     qt5.qtbase
     qt5ct
     unzip
     p7zip
     xz
     cava
     grim
     slurp
     swappy
     hyprlock
     gnome-calendar
     sway #Only used for pop ups
     networkmanager
     networkmanagerapplet
     qt6ct
     gtk-engine-murrine
     hyprcursor
     hypridle
     spotify
     python3
     pipx
     python312Packages.pip
     brave
     vesktop
     xwaylandvideobridge
     sbctl
     niv
     #pokeget-rs
     pokemon-colorscripts-mac
     qpwgraph
     easyeffects
     obs-studio
     nwg-look
     catppuccin-cursors
     (catppuccin-sddm.override {
      flavor = "mocha";
      font = "Noto Sans";
      fontSize = "14";
      #clockEnabled = true;
      #background = "${./wallpaper.png}";
      loginBackground = true;
    })
     lm_sensors
  ];

  # Fonts
  fonts.packages = with pkgs; [
     noto-fonts
     noto-fonts-cjk
     noto-fonts-emoji
     liberation_ttf
     fira-code
     fira-code-symbols
     mplus-outline-fonts.githubRelease
     dina-font
     proggyfonts
     nerdfonts
     font-awesome
     source-han-sans
     source-han-sans-japanese
     source-han-serif-japanese
     (nerdfonts.override {fonts = ["Meslo"];})
];

  fonts.fontconfig = {
     enable = true;
     defaultFonts = {
       monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
       serif = ["Noto Serif" "Source Han Serif"];
       sansSerif = ["Noto Sans" "Source Han Sans"];
  };
};


  # Automatic Garbage Collection
  nix.gc = {
     automatic = true;
     dates = "weekly";
     options = "--delete-older-than 7d";
  };

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; #Required for Steam Remote Play
    dedicatedServer.openFirewall = true; #Require for Source Dedicated Servers
  };

  programs.gamemode.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
