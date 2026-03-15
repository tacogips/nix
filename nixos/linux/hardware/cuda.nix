{ config, lib, pkgs, ... }:

{
  # CUDA packages
  environment.systemPackages = with pkgs; [
    cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cupti
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvtx

    # Temporarily disabled: include again after ollama-related build/runtime issue is resolved
    # (pkgs.ollama.override {
    #   acceleration = "cuda";
    # })
  ];

  # CUDA environment variables
  # NOTE: LD_LIBRARY_PATH removed to fix Hyprland GLIBCXX_3.4.34 error
  # Investigation findings (2025-01-09):
  # - After nix flake update, Hyprland fails to start with "GLIBCXX_3.4.34 not found"
  # - Root cause: LD_LIBRARY_PATH with pkgs.stdenv.cc.cc.lib (GCC 14.3.0) conflicts
  # - NixOS handles library paths automatically via RPATH, manual LD_LIBRARY_PATH often problematic
  # - Solution: Remove LD_LIBRARY_PATH and let NixOS manage library paths properly
  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    CUDA_HOME = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L${pkgs.cudatoolkit}/lib/stubs";
    
    # Commented out LD_LIBRARY_PATH that caused Hyprland GLIBCXX_3.4.34 error:
    # LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    #   pkgs.cudatoolkit
    #   pkgs.cudaPackages.cudnn
    #   pkgs.cudaPackages.cuda_cudart
    #   pkgs.linuxPackages.nvidia_x11
    #   pkgs.stdenv.cc.cc.lib  # <- This GCC 14.3.0 lib caused the conflict
    # ];
  };
}
