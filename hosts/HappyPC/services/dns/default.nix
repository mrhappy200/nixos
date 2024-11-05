{ ... }: {
  services.coredns.enable = true;
  services.coredns.config = ''
           . {
             # Cloudflare and Google
             forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
             cache
           }

           hap.py {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 127.0.0.1"
             }
           }
           searx.hap.py {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
          home.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.5"
             }
           }

           jellyfin.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
           request.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
       bazarr.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
       prowlarr.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
       sonarr.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
       radarr.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
       qbt.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
       lidarr.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
      grafana.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
      happypc.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
    auth.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
      lldap.hppy200.dev {
             template IN A  {
                 answer "{{ .Name }} 0 IN A 100.22.0.1"
             }
           }
  '';
}
