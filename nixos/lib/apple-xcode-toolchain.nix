let
  developerDir = "/Applications/Xcode.app/Contents/Developer";
in
{
  appPath = "/Applications/Xcode.app";
  inherit developerDir;
  toolchainIdentifier = "com.apple.dt.toolchain.XcodeDefault";
  sdkRoot = "${developerDir}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
  toolchainBin = "${developerDir}/Toolchains/XcodeDefault.xctoolchain/usr/bin";
  xcodeSelect = "/usr/bin/xcode-select";
  xcrun = "/usr/bin/xcrun";

  environmentVariables = {
    DEVELOPER_DIR = developerDir;
    SDKROOT = "${developerDir}/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk";
    TOOLCHAINS = "com.apple.dt.toolchain.XcodeDefault";
  };
}
