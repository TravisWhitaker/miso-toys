let fetcher = { owner
              , repo
              , rev
              , sha256
              }:
    builtins.fetchTarball
    {
        inherit sha256;
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    };
    nixpkgs-src = fetcher
    {
        owner = "nixos";
        repo = "nixpkgs";
        rev = "21fe4fd17677412ea9fcd8c2198baeff83b2edd3";
        sha256 = "00669nma2z797ss3gy1f1lqzkrjbijasli98nilimy0ggiivccfq";
    };
in x: import nixpkgs-src x
