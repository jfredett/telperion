# Import all the non-nixos things so that I can import this instead of directly importing the
# canon-zone.nix root file.
inputs@{ dns, ... }: [
  (import ./canon-zone.nix inputs)
  (import ./condorcet inputs)
  (import ./voltaire inputs)
  (import ./hedges inputs)
  (import ./kepler inputs)
  (import ./mirzakhani inputs)
  (import ./nancy inputs)
  (import ./work inputs)
]
