# Import all the non-nixos things so that I can import this instead of directly importing the
# canon-zone.nix root file.
{ dns, ... }: [
  (import ./canon-zone.nix { inherit dns; })
  (import ./condorcet { inherit dns; })
]
