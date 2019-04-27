with import ./pinned-nixpkgs.nix {};

let noChecks = haskell.packages.ghcjs.override
    {
        overrides = self: super:
        {
            mkDerivation = args:
                super.mkDerivation (args // { doCheck = false; });
            haskeline = haskell.lib.disableCabalFlag (super.haskeline_0_7_5_0.override
            {
                terminfo = null;
            }) "terminfo";
            dhall = haskell.lib.disableCabalFlag (super.dhall.override
            {
                http-client = null;
                http-client-tls = null;
                http-types = null;
                # configureFlags = [ "-f-with-http" ];
            }) "with-http";
        };
    };
    thisghc = noChecks.ghcWithHoogle
    (p: with p; [ miso
                  dhall
                ]
    );
in runCommand "miso-toys-env"
{
    buildInputs = [ thisghc ];
} ""
