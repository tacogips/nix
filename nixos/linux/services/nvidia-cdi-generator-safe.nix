{
  csv-files,
  device-name-strategy,
  discovery-mode,
  mounts,
  disable-hooks,
  enable-hooks,
  coreutils,
  glibc,
  gnugrep,
  jq,
  lib,
  nvidia-container-toolkit,
  nvidia-driver,
  runtimeShell,
  writeScriptBin,
  extraArgs,
}:
let
  mountToCommand =
    mount:
    "additionalMount ${lib.escapeShellArg (toString mount.hostPath)} ${lib.escapeShellArg mount.containerPath} ${lib.escapeShellArg (builtins.toJSON mount.mountOptions)}";
  mountsToCommands =
    mountList:
    if (builtins.length mountList) == 0 then
      lib.getExe' coreutils "cat"
    else
      lib.concatMapStringsSep " | \\\n" mountToCommand mountList;
in
writeScriptBin "nvidia-cdi-generator-safe" ''
  #! ${runtimeShell}
  set -e -u -o pipefail

  outputFile="$RUNTIME_DIRECTORY/nvidia-container-toolkit.json"
  tmpDir="$(${lib.getExe' coreutils "mktemp"} -d "$RUNTIME_DIRECTORY/nvidia-container-toolkit.XXXXXX")"
  rawFile="$tmpDir/raw.json"
  nextFile="$tmpDir/next.json"
  errFile="$tmpDir/stderr.log"

  cleanup() {
    ${lib.getExe' coreutils "rm"} -rf "$tmpDir"
  }

  cdiGenerate() {
    ${lib.getExe' nvidia-container-toolkit "nvidia-ctk"} cdi generate \
      --format json \
      ${
        if (builtins.length csv-files) > 0 then
          lib.concatMapStringsSep "\n" (file: "--csv.file ${lib.escapeShellArg (toString file)} \\") csv-files
        else
          "\\"
      }
      --discovery-mode ${lib.escapeShellArg discovery-mode} \
      --device-name-strategy ${lib.escapeShellArg device-name-strategy} \
      ${
        lib.concatMapStringsSep " \\\n" (hook: "--disable-hook ${lib.escapeShellArg hook}") disable-hooks
      } \
      ${
        lib.concatMapStringsSep " \\\n" (hook: "--enable-hook ${lib.escapeShellArg hook}") enable-hooks
      } \
      --ldconfig-path ${lib.escapeShellArg (lib.getExe' glibc "ldconfig")} \
      --library-search-path ${lib.escapeShellArg "${lib.getLib nvidia-driver}/lib"} \
      --nvidia-cdi-hook-path ${lib.escapeShellArg "${lib.getOutput "tools" nvidia-container-toolkit}/bin/nvidia-cdi-hook"} \
      ${lib.escapeShellArgs extraArgs}
  }

  additionalMount() {
    local hostPath="$1"
    local containerPath="$2"
    local mountOptions="$3"

    if [ -e "$hostPath" ]; then
      ${lib.getExe jq} \
        --arg hostPath "$hostPath" \
        --arg containerPath "$containerPath" \
        --argjson mountOptions "$mountOptions" \
        '.containerEdits.mounts[.containerEdits.mounts | length] = { "hostPath": $hostPath, "containerPath": $containerPath, "options": $mountOptions }'
    else
      echo "Mount $hostPath ignored: could not find path in the host machine" >&2
      ${lib.getExe' coreutils "cat"}
    fi
  }

  trap cleanup EXIT

  if cdiGenerate >"$rawFile" 2>"$errFile"; then
    <"$rawFile" ${mountsToCommands mounts} >"$nextFile"
    ${lib.getExe' coreutils "mv"} "$nextFile" "$outputFile"
    exit 0
  fi

  if ${lib.getExe' gnugrep "grep"} -Fq "Driver/library version mismatch" "$errFile"; then
    if [ -f "$outputFile" ]; then
      echo "nvidia-container-toolkit-cdi-generator: detected a transient NVIDIA driver/library mismatch; keeping the previous CDI spec. Reboot or reload the NVIDIA driver, then restart this service." >&2
    else
      echo "nvidia-container-toolkit-cdi-generator: detected a transient NVIDIA driver/library mismatch before any CDI spec was generated. GPU containers may stay unavailable until the mismatch is resolved and this service is restarted." >&2
    fi
    ${lib.getExe' coreutils "cat"} "$errFile" >&2
    exit 0
  fi

  ${lib.getExe' coreutils "cat"} "$errFile" >&2
  exit 1
''
