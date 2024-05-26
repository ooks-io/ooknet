{ 
  perSystem = { system, pkgs, inputs, ... }: {
    packages = {  
      live-buds-cli = pkgs.callPackage ./live-buds-cli {};
    };
  };
}
