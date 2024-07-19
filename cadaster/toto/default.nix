{ dns }: with dns.lib.combinators; {
  subdomains = {
    toto.A = [(a "10.255.1.9")];
  };
}
