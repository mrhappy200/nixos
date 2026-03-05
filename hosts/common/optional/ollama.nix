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
      "granite4:tiny-h"
      "qwen3-vl:8b"
    ];
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "64000";
    };
  };
}
