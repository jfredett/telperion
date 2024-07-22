# 20-JUL-2024

## 1632

I've got `toto` set up to have two virtual interfaces, one for the DNS IP and on for the normal
canon address. Eventually I think it'd be better to do this at the firewall level (just map the IP
over), but for now it's easiest to do it here.

I'm getting the weird ssh-connection dropping I saw a while back, I thought it had to do with the
wrong default gateway, but I thought I'd fixed that.

## 1719

Ran a ssh session till it died on the 10.255.1.9 side, the 10.255.0.3 side has remained, but I was
running a `watch` for the whole time. Maybe that did something to keep the session live?

No useful info on the debug output w/ `-vvv`, so I'm really confused as to what's going on.

## 2304

Running another ssh session on the 10.255.1.9 side, just to see if it fixed itself (I suspect it may
have been DHCP leases contending, I cleared all the old leases and I think things should be stable
now, this will eventually be a fully static network anyway).

# 21-JUL-2024

## 1651

Moved the old `toto` config into this repo.
