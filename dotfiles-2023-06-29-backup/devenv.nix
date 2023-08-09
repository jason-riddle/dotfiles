{ pkgs, ... }:

{
  # https://devenv.sh/languages/
  languages.python = {
    enable = true;
    venv.enable = true;
  };

  # https://devenv.sh/packages/
  # packages = [
  #   pkgs.docker
  # ];

  # https://devenv.sh/basics/
  # env.FOO = "BAR";

  enterShell = ''
    pip install dotbot
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks.shellcheck.enable = false;
}
