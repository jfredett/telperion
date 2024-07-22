{ dns, ... }: with dns.lib.combinators; {
  subdomains = {
    hedges.A = [(a "10.255.1.5")];
  };
}
