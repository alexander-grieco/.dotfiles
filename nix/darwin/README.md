# First time execution

`nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#air`

# Command to Build Configuration After First Time

`darwin-rebuild switch --flake .#air`
