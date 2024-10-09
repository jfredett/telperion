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
