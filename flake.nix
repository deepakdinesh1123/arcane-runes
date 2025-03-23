{
  description = "Arcane Runes";

  outputs = {self}: let
    mkWelcomeText = {
      name,
      description,
      path,
      buildTools ? null,
      additionalSetupInfo ? null,
    }: {
      inherit path;

      description = name;

      welcomeText = ''
        # ${name}
        ${description}

        ${
          if buildTools != null
          then ''
            Comes bundled with:
            ${builtins.concatStringsSep ", " buildTools}
          ''
          else ""
        }
        ${
          if additionalSetupInfo != null
          then ''
            ## Additional Setup
            To set up the project run:
            ```sh
            flutter create .
            ```
          ''
          else ""
        }
        ## Other tips
        If you use direnv run:

        ```
            echo "use flake" > .envrc
        ```
      '';
    };
  in {
    templates = {
      rust = mkWelcomeText {
        path = ./rust;
        name = "Rust Template";
        description = ''
          A basic rust application template with a package build.
        '';
        buildTools = [
          "All essential rust tools"
          "rust-analyzer"
        ];
      };
      go = mkWelcomeText {
        path = ./go;
        name = "Go template";
        description = "A basic go project";
        buildTools = [
          "go"
          "gopls"
        ];
      };
    };
  };
}