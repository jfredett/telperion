{ dns }: with dns.lib.combinators; {
  subdomains = {
    voltaire.A = [(a "10.255.0.11")];
  };
}
