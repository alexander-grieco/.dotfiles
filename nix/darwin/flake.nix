{
  description = "Alexs system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew"; # May need to update - note "wip" label
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
            pkgs.tmux
            pkgs.obsidian
            # pkgs.terraform
        ];

        homebrew = {
          enable = true;
          taps = [
            "jesseduffield/lazygit"
            "hashicorp/tap"
            { name = "hashicorp/tap"; trusted = true; }
            { name = "danielfoehrkn/switch"; trusted = true; }
            { name = "dopplerhq/cli"; trusted = true; }
            { name = "typewhisper/tap"; trusted = true; }
            { name = "aws/tap"; trusted = true; }
          ];
          brews = [
            "coreutils"
            { name = "danielfoehrkn/switch/switch"; trusted = true; }
            "dlv"
            "docker"
            { name = "dopplerhq/cli/doppler"; trusted = true; }
            { name = "aws/tap/ec2-instance-selector"; trusted = true; }
            "etcd"
            "fd"
            "fzf"
            "gh"
            "go"
            { name = "hashicorp/tap/terraform"; trusted = true; }
            { name = "jesseduffield/lazygit/lazygit"; trusted = true; }
            "kubectx"
            "kustomize"
            "libsigc++"
            "lua"
            "luajit"
            "mas"
            "neovim"
            "nmap"
            "node"
            "pi-coding-agent"
      	    "pyenv"
            "rg"
            "sesh"
            "stow"
            "tailscale"
            "tmux"
            "tree-sitter"
            "vim"
            "wget"
            "wireguard-tools"
            "zoxide"
            "zsh"
          ];
          casks = [
            "1password"
            "claude-code"
            "dockdoor"
            "font-fira-code-nerd-font"
            "font-maple-mono"
            "gcloud-cli"
            "ghostty"
            "hyperkey"
            "linearmouse"
            "nextcloud"
            "notion"
            "notion-calendar"
            "raycast"
            "rectangle"
            "shottr"
            "zen"
          ];
          masApps = {
            # "Tailscale" = 1475387142;
            # "Due" = 524373870; # <- only available on my main Apple account
          };
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        fonts.packages = [
          pkgs.nerd-fonts.comic-shanns-mono
        ];

      # System settings defaults
      # Use `darwin-help` for documentation
      system = {
        primaryUser = "alex";

        defaults = {
          dock = {
            autohide = true; # autohides dock
            magnification = true; # Allows magnification of icons
            # Apps to keep in dock
            persistent-apps = [
              "/System/Applications/System Settings.app"
              "/Applications/Notion Calendar.app"
              "/Applications/Zen.app/"
              "/Applications/Ghostty.app"
              "/Applications/1password.app"
              "/Applications/Due.app"
            ];
            wvous-br-corner = 5; # Default bottom-right hot-corner -> start screen-saver
          };
          finder = {
            AppleShowAllFiles = true; # Show hidden files
            FXPreferredViewStyle = "clmv"; # Default view: column view
            NewWindowTarget = "Documents"; # New windows default to "Documents" folder
            QuitMenuItem = true; # Allow quitting Finder app
            ShowPathbar = true; # Show path breadcrumbs in finder windows
            _FXSortFoldersFirst = true; # Show folders first when sorting by name
          };
          loginwindow = {
            GuestEnabled = false; # Disable guest login
          };
          screencapture = {
            location = "~/Desktop/Screenshots/"; # default screenshot location
            type = "png"; # default screenshot image format
          };
          screensaver = {
            askForPassword = true; # Always require password when screensaver gets activated
            askForPasswordDelay = 60; # Allow 60 second grace period before asking for password
          };
          NSGlobalDomain = {
            AppleICUForce24HourTime = true; # Use 24hr time format
            AppleShowAllFiles = true; # Show hidden files
            AppleSpacesSwitchOnActivate = false; # Dont switch workspace when selecting application with open windows
            "com.apple.swipescrolldirection" = false; # Disable "natural" scroll direction
            KeyRepeat = 2;
            # NSWindowShouldDragOnGesture = true; # Not sure this works
          };
          WindowManager = {
            EnableTilingByEdgeDrag = false;
          };
        };
        keyboard = {
          enableKeyMapping = true; # Enable keymap settings
          # remapCapsLockToEscape = true; # Make capslock another escape key (handy for laptop keyboards)
        };
      };

      # Use Determinate installer config
      nix.enable = false;

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#air
    darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Apple silicon only installation
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "alex";

            # Since homebrew is already installed
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."air".pkgs;
  };
}
