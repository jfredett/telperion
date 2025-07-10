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
    "bazarr".CNAME = [(cname "barge.emerald.city.")];
    "dashy".CNAME = [(cname "barge.emerald.city.")];
    "foundry".CNAME = [(cname "barge.emerald.city.")];
    "grist".CNAME = [(cname "barge.emerald.city.")];
    "grocy".CNAME = [(cname "barge.emerald.city.")];
    "jellyfin".CNAME = [(cname "barge.emerald.city.")];
    "lidarr".CNAME = [(cname "barge.emerald.city.")];
    "odysseus".CNAME = [(cname "odysseus-01.emerald.city")];
    "outline".CNAME = [(cname "barge.emerald.city.")];
    "postgres".CNAME = [(cname "barge.emerald.city.")];
    "prowlarr".CNAME = [(cname "barge.emerald.city.")];
    "radarr".CNAME = [(cname "barge.emerald.city.")];
    "readarr".CNAME = [(cname "barge.emerald.city.")];
    "redis".CNAME = [(cname "barge.emerald.city.")];
    "sonarr".CNAME = [(cname "barge.emerald.city.")];
    "torrent".CNAME = [(cname "barge.emerald.city.")];

    # TODO: Move this to barge (or better, to k3s when I get it set up properly=
    "docker-registry".CNAME = [(cname "randy.emerald.city.")];

    "grafana".CNAME = [(cname "daktylos.emerald.city.")];
    "loki".CNAME = [(cname "daktylos.emerald.city.")];
    "prom-exporter".CNAME = [(cname "daktylos.emerald.city.")];
    "prometheus".CNAME = [(cname "daktylos.emerald.city.")];


    # K8s work in progress
    "foundry-k8s".CNAME = [(cname "odysseus-01.emerald.city.")];
  };
}
