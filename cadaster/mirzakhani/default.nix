{ dns, ... }: with dns.lib.combinators; {
  subdomains = {
    mirzakhani.A = [(a "10.255.1.7")];
  };
}
