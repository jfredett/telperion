{ dns }: with dns.lib.combinators; let
  nsIP = "10.255.0.2";
in {
  SOA = {
    nameServer = "ns.canon";
    # TODO: Ideally this is calculated for me at build time. Though it does make it
    # nonhermetic, can this be a hash, or does DNS rely on it being sequential?
    serial = 202407181252;
    adminEmail = "jfredett@gmail.com";
  };

  subdomains = {
    ns.A = [(a nsIP)];
  };
}
