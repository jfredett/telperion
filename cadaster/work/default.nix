{ dns, ... }: with dns.lib.combinators; {
  subdomains = {
    work.A = [(a "10.255.1.8")];
  };
}
