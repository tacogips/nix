{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.podman = {
    enable = true;

    # 例: Podmanのコンテナ定義
    containers = {
      example-container = {
        image = "nginx:latest";
        autoStart = true;
        ports = [
          "8080:80" # ホスト:コンテナ
        ];
        volumes = [
          "${config.home.homeDirectory}/nginx-data:/usr/share/nginx/html:Z"
        ];
        labels = {
          "app" = "example";
        };
      };
    };

    # Podmanネットワークを定義（オプション）
    networks = {
      podman-network = {
        labels = {
          "network-type" = "application";
        };
      };
    };
  };

  # decomment out here if you need to custom below
  #home.file.".config/containers/storage.conf".text = ''
  #  [storage]
  #  driver = "overlay"
  #  runroot = "/run/user/1000"
  #  graphroot = "${config.home.homeDirectory}/.local/share/containers/storage"
  #'';

  #home.file.".config/containers/registries.conf".text = ''
  #  [registries.search]
  #  registries = ['docker.io', 'quay.io']

  #  [registries.insecure]
  #  registries = []
  #'';

}
