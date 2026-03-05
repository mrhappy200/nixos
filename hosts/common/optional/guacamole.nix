{
  config,
  pkgs,
  inputs,
  ...
}:
let
  guacVer = config.services.guacamole-client.package.version;
  pgsqlVer = "42.7.8"; # https://jdbc.postgresql.org/download/#latest-versions

  pgsqlDriverSrc = pkgs.fetchurl {
    url = "https://jdbc.postgresql.org/download/postgresql-${pgsqlVer}.jar";
    sha256 = "sha256-KjKp3LxC1npQrToN5e/RAsjSvkZyAEXyy9ZonxYKt8c=";
  };

  pgsqlExtension = pkgs.stdenv.mkDerivation {
    name = "guacamole-auth-jdbc-postgresql-${guacVer}";
    src = pkgs.fetchurl {
      url = "https://dlcdn.apache.org/guacamole/${guacVer}/binary/guacamole-auth-jdbc-${guacVer}.tar.gz";
      sha256 = "sha256-l7xf09Z9JcDpikddHf0wigN4WfVJ+sRxcccjt6cDk2Y=";
    };
    phases = "unpackPhase installPhase";
    unpackPhase = ''
      tar -xzf $src
    '';
    installPhase = ''
      mkdir -p $out
      cp -r guacamole-auth-jdbc-${guacVer}/postgresql/* $out
    '';
  };
in
{
  services.guacamole-server = {
    enable = true;
  };
  sops.secrets.guac-ssh-key = {
    sopsFile = ../secrets.yaml;
  };
  sops.templates."user-mapping.xml".content = ''
    <user-mapping>
      <authorize username="mrhappy200"
        password="${config.sops.placeholder.mrhappy200-password-md5}"
        encoding="md5">
          <connection name="SSH to euphrosyne">
              <protocol>ssh</protocol>
              <param name="hostname">euphrosyne</param>
              <param name="port">22</param>
              <param name="username">mrhappy200</param>
              <param name="private-key">${config.sops.placeholder.guac-ssh-key}</param>
              <param name="enable-sftp">true</param>
              <param name="sftp-root-directory">/home/mrhappy200</param>
          </connection>
          <connection name="VNC to euphrosyne">
              <protocol>vnc</protocol>
              <param name="hostname">localhost</param>
              <param name="port">5901</param>
          </connection>
      </authorize>
    </user-mapping>
  '';
  sops.templates."user-mapping.xml".owner = "tomcat";
  # By default it listens on 8080
  services.guacamole-client = {
    enable = true;
    userMappingXml = config.sops.templates."user-mapping.xml".path;
    settings = {
      openid-authorization-endpoint = "https://auth.hppy200.dev/api/oidc/authorization?state=1234abcdefdhf";
      openid-jwks-endpoint = "https://auth.hppy200.dev/jwks.json";
      openid-issuer = "https://auth.hppy200.dev";
      openid-client-id = "FPhtiDPk974mqbVe.2lkjpgP-5~JWLe1_rHAm4k7jIEcpL8wRGnXOJ.mLzIrVGn_B~yxVQ-o";
      openid-redirect-uri = "https://guac.hppy200.dev";
      openid-scope = "openid profile groups email";
      openid-username-claim-type = "preferred_username";
      openid-groups-claim-type = "groups";
      extension-priority = "postgresql, *, openid";
      # Postgresql
      postgresql-database = "tomcat";
      postgresql-username = "tomcat";
      postgresql-password = "guactomcat@123";
      postgresql-hostname = "pve-nix-vm-1";
      postgresql-auto-create-accounts = true;
    };
  };

  #services.tomcat = {
  #  serverXml = ''
  #    <Host>
  #      <Valve className="org.apache.catalina.valves.RemoteIpValve"
  #               internalProxies="127\.0\.0\.1|0:0:0:0:0:0:0:1"
  #               remoteIpHeader="x-forwarded-for"
  #               remoteIpProxiesHeader="x-forwarded-by"
  #               protocolHeader="x-forwarded-proto" />
  #    </Host>
  #  '';
  #};
  environment.etc = {
    "guacamole/extensions/guacamole-auth-sso-openid-${guacVer}.jar".source =
      "${inputs.guacamole-oidc-extension}/openid/guacamole-auth-sso-openid-${guacVer}.jar";
  };
  environment.etc."guacamole/lib/postgresql-${pgsqlVer}.jar".source = pgsqlDriverSrc;

  environment.etc."guacamole/extensions/guacamole-auth-jdbc-postgresql-${guacVer}.jar".source =
    "${pgsqlExtension}/guacamole-auth-jdbc-postgresql-${guacVer}.jar";
}
