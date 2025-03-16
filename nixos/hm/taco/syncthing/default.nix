{
  config,
  pkgs,
  lib,
  ...
}:

{
  # 基本的なSyncthing設定
  services.syncthing = {
    enable = true;

    #  other way "/run/user/1000/syncthing.sock"
    guiAddress = "127.0.0.1:8384";

    # option :cert
    # cert = "/path/to/cert.pem";
    # key = "/path/to/key.pem";

    # password file
    # passwordFile = "/path/to/password/file";

    overrideDevices = true;
    overrideFolders = true;

    # SOCKSプロキシ等の設定（オプション）
    # allProxy = "socks5://192.168.1.100:1080";

    # 追加のコマンドラインオプション
    extraOptions = [
      # "--reset-deltas"
      # "--verbose"
    ];

    # トレイアプリの設定（オプション）
    tray = {
      enable = true;
      package = pkgs.syncthingtray-minimal;
      command = "syncthingtray --wait";
    };

    settings = {
      # グローバルオプション
      options = {
        localAnnounceEnabled = true;
        globalAnnounceEnabled = false;
        relaysEnabled = false;
        limitBandwidthInLan = false;
        maxFolderConcurrency = 10;
        urAccepted = -1;
        natEnabled = false;
        upnpNeabled = false;
      };

      gui = {
        theme = "default"; # または "dark"
        # user = "admin"; # GUI認証用ユーザー名
        # password = "hashedpassword"; # ハッシュ化されたパスワード
      };

      devices = {
        #"laptop" = {
        #  id = "ABCDEFG-HIJKLMN-OPQRSTU-VWXYZAB-CDEFGHI-JKLMNOP-QRSTUV-WXYZ123"; # 実際のデバイスIDに置き換え
        #  # 接続先アドレス設定（オプション、自動検出もできる）
        #  # addresses = [ "tcp://192.168.1.10:22000" "dynamic" ];
        #  introducer = false; # このデバイスをイントロデューサーとして使用するか
        #  autoAcceptFolders = false; # このデバイスから共有されるフォルダを自動的に受け入れるか
        #};
        #"desktop" = {
        #  id = "ZYXWVUT-SRQPONM-LKJIHGF-EDCBAZY-XWVUTSR-QPONMLK-JIHGFE-DCBA987"; # 実際のデバイスIDに置き換え
        #  # addresses = [ "dynamic" ];
        #};
      };

      folders = {
        #zz"documents" = {
        #zz  enable = true; # このマシンでこのフォルダを有効にするか
        #zz  path = "~/Documents/Sync"; # フォルダのパス
        #zz  id = "documents"; # フォルダID（すべてのデバイスで共通）
        #zz  label = "ドキュメント"; # 表示名
        #zz  type = "sendreceive"; # sendreceive, sendonly, receiveonly, receiveencrypted
        #zz  # このフォルダを共有するデバイス（devices内のIDと一致する必要あり）
        #zz  devices = [ "laptop" "desktop" ];
        #zz  # ファイル変更監視設定
        #zz  fsWatcherEnabled = true;
        #zz  # ファイルのパーミッション設定を同期するか
        #zz  ignorePerms = false;
        #zz  # 親ディレクトリから所有権をコピーするか
        #zz  copyOwnershipFromParent = false;

        #zz  # バージョン管理設定（オプション）
        #zz  versioning = {
        #zz    type = "simple"; # simple, trashcan, staggered, external
        #zz    params.keep = "5"; # 保持するバージョン数
        #zz  };

        #zz  # フォルダスキャン設定
        #zz  rescanIntervalS = 3600; # 1時間ごとにスキャン
        #zz},
        #zz"photos" = {
        #zz  enable = true;
        #zz  path = "~/Pictures/SyncPhotos";
        #zz  id = "photos";
        #zz  label = "写真";
        #zz  type = "sendreceive";
        #zz  devices = [ "laptop" ];

        #zz  # ゴミ箱方式のバージョン管理
        #zz  versioning = {
        #zz    type = "trashcan";
        #zz    params.cleanoutDays = "30"; # 30日後に削除
        #zz  };
        #zz}
      };
    };
  };
}
#
### 注意点と説明
#
#1. **デバイスID**: 実際のデバイスIDに置き換える必要があります。デバイスIDは既存のSyncthingインスタンスのウェブUIから確認できます。
#
#2. **証明書とキー**: 固定のノードIDを使用したい場合、既存の`cert.pem`と`key.pem`へのパスを指定します。
#
#3. **フォルダパス**: `~/`はホームディレクトリを表し、実際のパスに置き換えてください。
#
#4. **バージョン管理**: シンプル、ゴミ箱、段階的、外部の4つのタイプから選択できます。
#
#5. **同期タイプ**:
#   - `sendreceive` - 双方向同期
#   - `sendonly` - このデバイスから他へのみ同期
#   - `receiveonly` - 他デバイスからこのデバイスへのみ同期
#   - `receiveencrypted` - 暗号化された受信専用フォルダ
#
#6. **トレイアプリ**: デスクトップ環境でSyncthingのステータスを確認するためのトレイアイコンを有効にします。
#
#必要に応じて設定をカスタマイズして、実際の環境に合わせて調整してください。
#
