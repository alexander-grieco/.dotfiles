{
  description = "Alexs system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
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
            pkgs.terraform
        ];

        homebrew = {
          enable = true;
          taps = [
            "jesseduffield/lazygit"
          ];
          brews = [
            "mas"
            "coreutils"
            "gh"
            "fzf"
            "joshmedeski/sesh/sesh"
            "dlv"
            "etcd"
            "fd"
            "libsigc++"
            "jesseduffield/lazygit/lazygit"
            "lua"
            "luajit"
            "neovim"
            "rg"
            "stow"
            "tmux"
            "tree-sitter"
            "vim"
            "wget"
            "zoxide"
            "zellij"
            "zsh"
          ];
          casks = [
            "anki"
            "homerow"
            "nikitabobko/tap/aerospace"
            "the-unarchiver"
            "alacritty"
            "kitty"
            "font-maple-mono"
            "font-fira-code-nerd-font"
            "ghostty"
            "arc"
            "raycast"
            "rectangle"
            "mactex"
            "notion-calendar"
            "notion"
            "1password"
            "nextcloud"
            "zen-browser"
          ];
          masApps = {
            "Tailscale" = 1475387142;
          };
          onActivation.autoUpdate = true;
          onActivation.upgrade = true;
        };

        fonts.packages = [
          (pkgs.nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
        ];

      # System settings defaults
      # Use `darwin-help` for documentation
      system = {
        defaults = {
          dock = {
            autohide = true; # autohides dock
            magnification = true; # Allows magnification of icons
            # Apps to keep in dock
            persistent-apps = [
              "/System/Applications/System Settings.app"
              "${pkgs.obsidian}/Applications/Obsidian.app/"
              "/Applications/Anki.app"
              "/Applications/Notion Calendar.app"
              "/Applications/Notion.app"
              "/Applications/Arc.app/"
              "/Applications/Ghostty.app"
            ];
            wvous-br-corner = 5; # Default bottom-right hot-corner -> start screen-saver
          };
          finder = {
            AppleShowAllFiles = true; # Show hidden files
            FXPreferredViewStyle = "clmv"; # Default view: column view
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
            "com.apple.swipescrolldirection" = false; # Disable "natural" scroll direction
            KeyRepeat = 2;
          };
        };
        keyboard = {
          enableKeyMapping = true; # Enable keymap settings
          remapCapsLockToEscape = true; # Make capslock another escape key (handy for laptop keyboards)
        };
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

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
            user = "alexgrieco";

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
