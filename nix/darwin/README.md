# First time execution

Run this to install nix:

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

(Restart the shell)

Run the following to build the profile:

```
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#air
```

Run the following to link your dotfiles (Homebrew packages like stow aren't yet in your path). This opens a nix shell with stow installed

```
nix shell nixpkgs#stow
```

# Command to Build Configuration After First Time

`darwin-rebuild switch --flake .#air`
