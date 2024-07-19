# Import all the non-nixos things so that I can import this instead of directly importing the
# canon-zone.nix root file.
{ dns, ... }: [
  (import ./canon-zone.nix { inherit dns; })
  (import ./condorcet { inherit dns; })
  (import ./voltaire { inherit dns; })
  (import ./hedges { inherit dns; })
  (import ./kepler { inherit dns; })
  (import ./mirzakhani { inherit dns; })
  (import ./nancy { inherit dns; })
  (import ./work { inherit dns; })
]
