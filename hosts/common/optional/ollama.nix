{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    host = "0.0.0.0";
    openFirewall = true;
    models = "/persist/ollama/models";
    syncModels = true;
    user = "ollama";
    loadModels = [
      "gemma4:e2b"
      "gemma4:26b"
    ];
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "64000";
    };
  };
}
