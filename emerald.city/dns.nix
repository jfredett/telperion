{ dns, ... }: with dns.lib.combinators; let
  nsIP = "10.255.0.2";
in {
  SOA = {
    nameServer = "ns.emerald.city.";
    serial = 2024081021;
    adminEmail = "jfredett@gmail.com";
  };

  subdomains = {
    "ns".CNAME = [(cname "ns.canon.")];

    # TODO: Move this to the docker modules per container. That should just need this to be an
    # actual module setting actual config somewhere.
    "jellyfin".CNAME = [(cname "barge.emerald.city.")];
    "dashy".CNAME = [(cname "barge.emerald.city.")];
    "torrent".CNAME = [(cname "barge.emerald.city.")];
    "sonarr".CNAME = [(cname "barge.emerald.city.")];
    "prowlarr".CNAME = [(cname "barge.emerald.city.")];
    "readarr".CNAME = [(cname "barge.emerald.city.")];
    "radarr".CNAME = [(cname "barge.emerald.city.")];
    "lidarr".CNAME = [(cname "barge.emerald.city.")];
    "bazarr".CNAME = [(cname "barge.emerald.city.")];
    "grocy".CNAME = [(cname "barge.emerald.city.")];


    "grafana".CNAME = [(cname "daktylos.emerald.city.")];
    "prometheus".CNAME = [(cname "daktylos.emerald.city.")];
    "prom-exporter".CNAME = [(cname "daktylos.emerald.city.")];
    "loki".CNAME = [(cname "daktylos.emerald.city.")];
  };
}
