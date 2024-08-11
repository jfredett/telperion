{ dns, ... }: with dns.lib.combinators; let
  nsIP = "10.255.0.2";
in {
  SOA = {
    nameServer = "ns.emerald.city.";
    serial = 2024081021;
    adminEmail = "jfredett@gmail.com";
  };

  subdomains = {
    "jellyfin".CNAME = [(cname "barge.emerald.city.")];
    "dashy".CNAME = [(cname "barge.emerald.city.")];
    "torrent".CNAME = [(cname "barge.emerald.city.")];
    "sonarr".CNAME = [(cname "barge.emerald.city.")];
    "radarr".CNAME = [(cname "barge.emerald.city.")];
    "lidarr".CNAME = [(cname "barge.emerald.city.")];
    "bazarr".CNAME = [(cname "barge.emerald.city.")];
    "ns".CNAME = [(cname "ns.canon.")];
  };
}
