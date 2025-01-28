{ dns, ... }: with dns.lib.combinators; {
  subdomains = {
    bill.A = [(a "10.255.1.8")];
  };
}
