{
  language-server = {
    basedpyright = {
      command = "basedpyright-langserver";
      args = [ "--stdio" ];
    };

    rust-analyzer = {
      command = "rust-analyzer";
      config = {
        cargo = {
          allFeatures = true;
          targetDir = "target/rust-analyzer";
        };
        check = {
          command = "check";
          extraArgs = [
            "--target-dir"
            "target/ra"
          ];
        };
      };
    };

    gopls = {
      command = "gopls";
      config = {
        usePlaceholders = true;
        completeUnimported = true;
        staticcheck = true;
        gofumpt = true;
        analyses = {
          unusedparams = true;
          shadow = true;
        };
        codelenses = {
          generate = true;
          gc_details = true;
          test = true;
          tidy = true;
          upgrade_dependency = true;
          vendor = true;
        };
        hints = {
          assignVariableTypes = true;
          compositeLiteralFields = true;
          compositeLiteralTypes = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
    };

    typescript-language-server = {
      command = "typescript-language-server";
      args = [ "--stdio" ];
    };

    zls = {
      command = "zls";
    };
  };

  language = [
    {
      name = "rust";
      language-servers = [ "rust-analyzer" ];
    }
    {
      name = "go";
      language-servers = [ "gopls" ];
    }
    {
      name = "python";
      language-servers = [ "basedpyright" ];
    }
    {
      name = "typescript";
      language-servers = [ "typescript-language-server" ];
    }
    {
      name = "tsx";
      language-servers = [ "typescript-language-server" ];
    }
    {
      name = "zig";
      language-servers = [ "zls" ];
    }
  ];
}
