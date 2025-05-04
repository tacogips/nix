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

    # Include ollama with CUDA support
    (pkgs.ollama.override {
      acceleration = "cuda";
    })
  ];

  # CUDA environment variables
  environment.variables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    CUDA_HOME = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L${pkgs.cudatoolkit}/lib/stubs";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.cudatoolkit
      pkgs.cudaPackages.cudnn
      pkgs.cudaPackages.cuda_cudart
      pkgs.linuxPackages.nvidia_x11
      pkgs.stdenv.cc.cc.lib
    ];
  };
}