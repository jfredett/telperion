# 23-JUL-2024

## 1832

I'm thinking I might be able to use [`netmiko`](https://github.com/ktbyers/netmiko) to act as a
backend for a switch configuration derivation tool. I would specify the config via a nix module,
then have it generate `netmiko` code to configure the switch from some known root state (ideally
factory settings, or maybe I can create something to backport an existing config, idk).

The idea would be something like:

1. Install switch
2. Reset to factory
3. Enable SSH w/ a pubkey
4. Copy running config back to the cadaster
5. Convert to nix
6. Use script to apply config to switch after compiling from nix.
