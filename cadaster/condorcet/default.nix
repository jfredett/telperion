{ dns, ... }: with dns.lib.combinators; {
  subdomains = {
    condorcet.A = [(a "10.255.0.2")];
  };
}
