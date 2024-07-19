{ dns }: with dns.lib.combinators; {
  subdomains = {
    kepler.A = [(a "10.255.1.6")];
  };
}
