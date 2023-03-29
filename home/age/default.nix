{ config, ... }: {
  age = {
    secrets = {
      gh_hosts = {
        file = ../../secrets/gh_hosts.age;
        path = "${config.xdg.configHome}/gh/hosts.yml";
      };
      glab_config = {
        file = ../../secrets/glab_config.age;
        path = "${config.xdg.configHome}/glab-cli/config.yml";
      };
    };
  };
}
