{
  # Enable acme for usage with nginx vhosts
  security.acme = {
    defaults.email = "ronan@hppy200.dev";
    acceptTerms = true;
  };

  environment.persistence = {
    "/persist" = {directories = ["/var/lib/acme"];};
  };
}
