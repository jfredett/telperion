{ dns, ... }: with dns.lib.combinators; {
  subdomains = {
    "kansas.ifrit".A = [(a "192.168.1.1")];
    "condorcet.ifrit".A = [(a "10.255.0.1")];
  };
}
