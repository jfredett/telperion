# Cadaster/Canon Zone

See [[Concepts#Canon|the glossary]] for a definition of "canon". This directory contains
nixosconfigurations for all the nixos machines in the purview of telperion. There are some machines
that exist outside of that purview, they are:

1. `kepler`, a windows-based machine I use to drive my astrophotography rig. Much of the software is
   windows-only, so it can't be nixos-based.
2. `work` and `hedges` are both nix-darwin, the former is employer-issued and my ability to
   configure it is therefore limited, the latter is my studio machine and doesn't need any more than
   basic configuration. They both use nix-darwin and home-manager directly from `glamdring`.
3. `nancy` is a Synology NAS that I use for backups and media storage.

For these machines which are not fully nixos, the only thing in the `default.nix` is the
`laurelin.infra.dns` module, they are expected to have any backend IP configuration done by hand.

For the other machines, the `default.nix` pulls in all other relevant machine-level configuration to
set up any physical components of the machine, e.g., filesystems, etc.

Each machine directory may also have a few supporting files:

- README.mkd - Describes the machine, what it's used for, etc.
- CHANGELOG.mkd - Describes physical changes to the machine over time. (i.e., new disks, new NICs,
  etc).
- LOG.mkd - Any other notes about the machine that aren't necessarily changes, but are worth
  tracking.
