{ dns, ... }: with dns.lib.combinators; let
  nsIP = "10.255.0.2";
in {
  SOA = {
    nameServer = "ns.canon.";
    serial = 2024072914;
    adminEmail = "jfredett@gmail.com";
  };

  subdomains = {
    "jellyfin".CNAME = [(cname "barge.canon.")];
    "dashy".CNAME = [(cname "barge.canon.")];
    "torrent".CNAME = [(cname "barge.canon.")];
    "sonarr".CNAME = [(cname "barge.canon.")];
    "radarr".CNAME = [(cname "barge.canon.")];
    "lidarr".CNAME = [(cname "barge.canon.")];
    "bazarr".CNAME = [(cname "barge.canon.")];
  };
}
