{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkgs,
}: let
  version = "2.0.0";
in
  buildGoModule {
    inherit version;
    pname = "zmk-viewer";

    src = fetchFromGitHub {
      owner = "MrMarble";
      repo = "zmk-viewer";
      rev = "v${version}";
      hash = "sha256-ZfRbC6FnT/7oUai8SVy4MRYQsvC8l8U7Zl7JCs9Lo5I=";
    };

    # nativeBuildInputs = with pkgs; [makeWrapper installShellFiles];

    vendorHash = "sha256-OW+2ON6fhCZoKVjNpujpQuhukv3Qmsmi4+t1gG4HHOg=";

    # ldflags = ["-X github.com/nib-group/rqp/util.Version=${version}"];

    # propagatedBuildInputs = with pkgs;
    #   [
    #     ssm-session-manager-plugin
    #     awscli2
    #   ]
    #   ++ lib.optionals withLastPass [lastpass-cli]
    #   ++ lib.optionals with1Password [_1password];

    # installPhase = ''
    #   runHook preInstall
    #
    #   mkdir -p $out
    #   dir="$GOPATH/bin"
    #   [ -e "$dir" ] && cp -r $dir $out
    #
    #   installShellCompletion --cmd rqp \
    #     --bash <($out/bin/rqp completion bash) \
    #     --fish <($out/bin/rqp completion fish) \
    #     --zsh <($out/bin/rqp completion zsh)
    #
    #   runHook postInstall
    # '';

    # meta = with lib; {
    #   description = "A simple CLI tool for performing common dev tasks on the Red Queen Platform.";
    #   homepage = "https://github.com/nib-group/rqp-cli";
    #   changelog = "https://github.com/nib-group/rqp-cli/releases";
    #   license = licenses.asl20;
    #   mainProgram = "rqp";
    #   platforms = platforms.unix;
    # };
  }
