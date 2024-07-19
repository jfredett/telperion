{ dns }: with dns.lib.combinators; {
  subdomains = {
    nancy.A = [(a "10.255.1.7")];
  };
}
