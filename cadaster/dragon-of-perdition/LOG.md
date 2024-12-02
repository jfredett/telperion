# 8-OCT-2024

## 2122

I set up my user config from archimedes on this machine. I think I'm going to move development of `hazel` at least
there, the compile times are getting sluggish and a dual-CPU, 54 core machine should be able to be a bit quicker about
it.

I'm going to have to figure out `impermanence`, but there's a pair of nvmes I'm just going to slap a filesystem on and
go from there. Ideally I'd have the code live in memory (since I have many hundreds of gigs available), and then have it
sync to some local storage relatively frequently, then sync that storage to nfs. That way an unplanned shutdown doesn't
lose much data, a drive corruption is at least two machines and all of github away.

I'll probably continue to use `archimedes` for `minas-tarwon` development, but `brocard` and `hazel` at a minimum need
the extra horsepower.

# 9-NOV-2024

## 1427

Working on the Netboot setup, I'm routinely creating images that are too large for the bootmodel I'm using, and I don't
think moving to EFI boot is either possible or advisable since it will also be limited.

Instead I think I need to move towards a netboot-to-NFS approach, I can have each machine have a RO copy of the nix
store with a RW copy hosted per-machine on the NFS server as well, similar to [this](https://xyno.space/post/nix-store-nfs) article.

To do this, though, I'll need to work a little bit better understanding the netboot model, because I more or less just
copied stuff until it worked the first time around.

I gather the majority of what it's building is the initrd image, so I think the first step is to move `pinky` towards a
'mount some NFS store on netboot' and go from there.

I think then the plan is 'make pinky mount the NFS store and boot to a 'generic' nix', then 'add a systemd to apply the
pinky-specific configuration to pinky after build'

once one machine does this, I can start to build `gehenna`, which will be the builder VMs on DOP and BTG that actually
populate the NFS store.

It's a 'we have tvix at home' sort of thing.
