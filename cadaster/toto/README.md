# `toto.nix`

Toto is the central build server configuration. Ideally it's a small group
of VMs doing remote builds for the infra. It should also serve a common RO
nix store, and ideally operate as a general task-runner for the environment.


Design:

1. laminar as task runner
2. git repo host `git push toto:$repo`
3. builds run from toto (on push or on-demand)
4. get grafana set up on toto
5. port prometheus to BTG on a big-boat VM
4. InSpec runs from toto

-----------------------

## Build Process:

1. I push to internal VCS (_on toto_), hook notifies toto to check for updates
2. toto sees a change to `$hostname.nix`, proceeds to queue a build job

- The build job
  1. build a vm image and make sure it boots and is accessible via SSH
  2. look for a `$hostname-test.sh` in some canonical location, run it.
    - The tests should output TAP-compatible testing information
  3. if the tests above all pass, proceed to do the remote test build via
    `nixos-rebuild test`.
  4. run `$hostname-smoke-test.sh`, similar to above.
  5. if those tests pass, run `nixos-rebuild switch` on the remote.


Access is mitigated through a `toto` user that is otherwise locked down. Eventually reversing this process and having the hostname _ask_ toto to update it would mean
we could trigger these without having to maintain a `toto` user.

### Issues:

This doesn't track changes in dependencies of `$hostname.nix`, probably there
is some way to get nix to figure that out. Alternately, if nothing changed, the
job should be a no-op, though it might be an 'expensive' no-op if the job still
needs to run tests or w/e. Ideally noop work would be avoided.


-----


Pulled from bin/pandemonium/dns/deploy, a more worked-out version of things.


```
# TODO: I need toto.
#
# Here's the idea. `nixos-rebuild` supports two parameters: --build-host and
# --target-host
#
# If I can set up archimedes to either have `nixos-rebuild` available, or move
# all this stuff to a NixOS host, I could do a command like:
# 
#   nixos-rebuild --build-host $TOTO --target-host $TARGET -I
#   path/to/hostname.nix
# 
# and it should rebuild that host using $TOTO as the build host, I suppose this
# would be handy for cross-building, in this model, `toto` would be the build
# server and this is how I would execute the command manually, a `toto` could
# run jenkins or similar and then just run:
# 
#   nixos-rebuild --target-host $TARGET -I path/to/hostname.nix 
# 
# when the git repo updates.
# 
# The question then is where to host 'toto', I don't think I have any other
# RPi's lying around, but that'd be a nice choice. Otherwise probably just a VM
# on archimedes?
# 
# The upshot of all this is that it eliminates ansible from the setup entirely.
# Since I can apply nix remotely, so long as I store configuration in nix or in
# some non-local mechanism (etcd or w/e), should be no need for it.
#  
# Eventually it'd be good to have flying-monkey trigger something like:
#
#    nixos-rebuild --build-host $TOTO -I remote-file:///path/to/hostname.nix 
# 
# that is, have the machines pull configuration, so TOTO won't need
# root-over-ssh to all machines. there is `--use-remote-sudo` so it's not _too_
# bad, but a pull models is better for sure.
#
# Ooh, one other thing, since TOTO is doing all the builds, it can also add a
# local build-vm step and test the machine works before sending it to the real
# thing. The handshake would be something like:
# 
# 1. I push to git, updating BEATRICE and BERNARD, the DNS machines.
# 2. a githook notifies TOTO to update it's checkout of `ereshkigal`
# 3. toto identifies what has changed and acts in the following order:
#    3.1. if the physical server manifest has changed, and there are
#         hostname.nix files in place for the new machines, execute a rebuild
#         on those machines (see below)
#    3.2. if the terraform definition has changed, run `terraform apply`
#    3.3. if the helm configuration has changed, apply it
# 4. based on the result of the above, in the event of anything going awry,
#    toto reverts to last-good-config
#
# toto is the main build server, nix store, etc. It can provide RO copies
# of it's nix store over NFS to each machine, each machine would correspond 
# to a user so toto can grant permissions to each user to grant them access 
# to that part of the nix store.
#
# flying-monkey would run on the client machines and be responsible for
# managing the machine in terms of graceful application of new nix configs
# (described below), reporting metrics, etc.
#
#
# executing a rebuild:
#
# 1. identify the machine to be rebuilt, call it HOST:
#   A. by notification
#   B. by git change (see 3.1 above)
# 2. find the hostname.nix file for HOST, call it HOST.nix
# 3. run a `nixos-rebuild build-vm` for HOST.nix and deploy it to an
#    environment fully isolated from the rest of the network with no
#    internet access.
# 4. if there are tests associated in the `tests/HOST/no-internet/` directory,
#    run those tests against the sandboxed vm.
#   4.1. if those tests pass continue to step 5
#   4.2. if those tests fail raise an error in the appropriate venue based
#        on how it was identified
# 5. migrate the VM from the sandboxed-without-internet environment to a 
#    sandboxed-with-internet environment
# 6. if there are tests associated in the `tests/host/with-internet/` directory,
#    run those tests against the sandboxed vm
#   6.1. if those test pass continue to step 7
#   6.2. if those tests fail raise an error in the appropriate venue as in
#        step 4.2
# 7. clean up the VM
# 8. execute `nixos-rebuild --use-remote-sudo --target-host toto@HOST -I HOST.nix switch`
#     - NB. this will eventually be a call out to `flying-monkey` to notify it
#       an update is pending, then `fm` can prepare the system based on whatever
#       it may be configured to do (e.g., drain itself, execute a backup, whatever)
# 9. if there are tests associated in `test/host/post-switch`, run them,
#    notifying as in 4.1 and 6.1
#     - NB. this will eventually be a call out to `flying-monkey` to notify it
#       an update is pending, then `fm` can prepare the system based on whatever
#       it may be configured to do (e.g., drain itself, execute a backup, whatever)
# 9. if there are tests associated in `test/host/post-switch`, run them,
#    notifying as in 4.1 and 6.1
#
```
