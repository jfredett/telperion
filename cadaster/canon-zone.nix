{ dns, ... }: with dns.lib.combinators; let
  nsIP = "10.255.0.2";
in {
  SOA = {
    nameServer = "ns.canon.";
    # TODO: Ideally this is calculated for me at build time. Though it does make it
    # nonhermetic, can this be a hash, or does DNS rely on it being sequential?
    serial = 2024072312;
    adminEmail = "jfredett@gmail.com";
  };

  subdomains = {
    ns.A = [(a nsIP)];

    # TODO: This should be in the respective part of the cadaster, built into the laurelin.dns
    # module
    "drac.dragon-of-perdition".A = [(a "10.255.255.1")];
    "drac.babylon-the-great".A = [(a "10.255.255.2")];

    "loki".CNAME = [(cname "loki.emerald.city.")];
  };
}
