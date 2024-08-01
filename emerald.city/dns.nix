{ dns, ... }: with dns.lib.combinators; let 
  nsIP = "10.255.0.2";
in {
  subdomains = {
    "jellyfin.emerald.city".CNAME = "barge.canon";
  };
}
