# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # nixos-cosmic.nixosModules.default
    ];

#   nix = {
#  package = pkgs.nixFlakes;
#  extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
#    "experimental-features = nix-command flakes";
#      };

 # amdgpu setup
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.opengl.extraPackages = with pkgs; [
  amdvlk
  ];
  # For 32 bit applications 
  hardware.opengl.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
  ];
   
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["amdgpu"];
  
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bootloader 
   boot.loader = {
   grub = {
    enable = true;
    useOSProber = true;
    devices = [ "nodev" ];
    efiSupport = true;
    configurationLimit = 5;
  };
  efi.canTouchEfiVariables = true;
};
  boot.initrd.kernelModules = [ "amdgpu"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #direnv
  programs.direnv.enable = true;
  programs.direnv.loadInNixShell = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.silent = true;    

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

 #  # Configure network proxy if necessary
 # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # i3 window manager
  services.xserver.windowManager.i3.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.densetsu = {
    isNormalUser = true;
    description = "densetsu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
 
  # Enable Flakes and the command-line tool with nix command settings 
  nix.settings.experimental-features = [ "nix-command flakes" ];
  
  # xdg-portals
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-cosmic ];
  xdg.portal.config.common.default = "gtk";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    neovim
    neofetch
    git
    
  # nix applications
    nix-bash-completions
    nix-zsh-completions
    nixd
    nix-search-cli
    pkgs.nvd
    nix-output-monitor
    nix-top
    nix-doc
    nix-pin
    nix-tree
    nix-melt
    nix-info
    nix-diff
    nix-serve
    nix-index
    nix-update
    nix-script
    nix-bundle
    nixos-icons
    nixos-shell
    nix-plugins
    nixpkgs-lint
    nixos-option
    nom
    nitch
    nh

   # zsh
    zsh
    zsh-z
    zsh-bd
    zsh-abbr
    zsh-defer
    zsh-zhooks
    zsh-prezto
    zsh-forgit
    zsh-f-sy-h
    zsh-nix-shell
    zsh-clipboard
    zsh-completions
    zsh-git-prompt
    zsh-powerlevel10k
    zsh-autocomplete
    zsh-autosuggestions
    zsh-powerlevel10k
    zsh-syntax-highlighting
    zsh-history-substring-search
    zsh-fast-syntax-highlighting
  
  # bash 
    bash
    bash-completion

  # cosmic applications
    cosmic-bg
    cosmic-term
    cosmic-edit
    cosmic-comp
    cosmic-tasks
    cosmic-store
    cosmic-randr
    cosmic-panel
    cosmic-icons
    cosmic-files
    cosmic-applets
    cosmic-settings
    cosmic-session
    cosmic-launcher
   ## cosmic-protocols
    cosmic-screenshot
    cosmic-applibrary
    cosmic-design-demo
    cosmic-notifications
    cosmic-settings-daemon
    cosmic-workspaces-epoch

   # i3 window manager apps
     #i3wm pkgs
    dmenu
    rofi
    autotiling
    lxappearance
    xfce.xfce4-terminal
    xfce.xfce4-settings
    dunst
    pavucontrol
    jgmenu
    tmux
    fzf-zsh
    nitrogen
    pfetch
    neovim
    networkmanager_dmenu
    sweet
    clipmenu
    volumeicon
    brightnessctl

   # wallpapers
     pantheon.elementary-wallpapers
     deepin.deepin-wallpapers
   
   # custom wallpapers
     stylish
     fondo

   # cappucino
     catppuccinifier-gui
     catppuccinifier-cli
    
   # xdg-desktop-portal-cosmic

   # fonts
    jetbrains-mono
    jetbrains-toolbox
    udev-gothic
    hack-font

   # smartcard
    opensc
    scmccid
    ccid
    acsccid
    pcsclite
    pcsc-tools
    pcsc-scm-scl011
    pcscliteWithPolkit

   # docker applications
    distrobox
    docker
   
   # virtual machines
    virt-manager
    gnome.gnome-boxes
    kvmtool
    qemu_full
    qemu
  ];

   # fonts and folder themes
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      font-awesome
      font-awesome_5
      font-awesome_4
      source-han-sans
      open-sans
      openmoji-color
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Open Sans" "Source Han Sans" ];
      emoji = [ "openmoji-color" ];
    };
  };    

   # starship themes
    programs.starship.enable = true;


    environment.sessionVariables = {
     FLAKE = "/etc/nixos/configuration.nix";
   };

   # nix grub generations
   system.autoUpgrade.enable = true;
   system.autoUpgrade.operation = "boot";
   system.autoUpgrade.dates = "24:00";
   # nix.settings.auto-optimise-store = true;
   nix.gc = {
   automatic = true;
   dates = "Sun 24:00";
   options = "--delete-older-than 7d";
  };

    nixpkgs.config.permittedInsecurePackages = [
    "nodejs-12.22.12"
    "python-2.7.18.7"
    "nix-2.17.1"
  ];
    

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
   services.desktopManager.cosmic.enable = true;
   services.displayManager.cosmic-greeter.enable = true;
   services.pcscd.enable = true;
   services.pcscd.plugins = [ pkgs.ccid ];
   # security.pam.p11.enable = true;
   xdg.portal.enable = true;
  
 # bluetooth services
   hardware.bluetooth.enable = true;
   services.blueman.enable = true;  
 # docker services
 #  virtualisation.docker.enable = true;
 # zsh services
   programs.zsh.enableCompletion = true;
  

  # flatpak
  services.flatpak.enable = true;

  # for virtualization like gnome-boces or virt-manager
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
 
  #spices (virtualization)
  services.spice-vdagentd.enable = true; 

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
