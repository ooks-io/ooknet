{
  # <type>.<family>.<model>

  # TODO: account for stepping <type>.<family>.<stepping>.<model>
  intel = {
    # only do big core client cpu now
    "6" = {
      "191" = {name = "raptor-lake";};
      "190" = {name = "raptor-lake";};
      "186" = {name = "raptor-lake";};
      "183" = {name = "raptor-lake";};

      "189" = {name = "lunar-lake";};
      "188" = {name = "lunar-lake";};

      "198" = {name = "arrow-lake";};
      "197" = {name = "arrow-lake";};
      "181" = {name = "arrow-lake";};

      "172" = {name = "meteor-lake";};
      "171" = {name = "meteor-lake";};
      "170" = {name = "meteor-lake";};

      "154" = {name = "alder-lake";};
      "151" = {name = "alder-lake";};

      "167" = {name = "rocket-lake";};

      "166" = {name = "comet-lake";};
      "165" = {name = "comet-lake";};

      "141" = {name = "tiger-lake";};
      "140" = {name = "tiger-lake";};

      "126" = {name = "ice-lake";};
      "125" = {name = "ice-lake";};

      "102" = {name = "cannon-lake";};

      "158" = {name = "coffee-lake";};
      "142" = {name = "coffee-lake";};

      "94" = {name = "skylake";};
      "78" = {name = "skylake";};

      "71" = {name = "broadwell";};
      "61" = {name = "broadwell";};

      "70" = {name = "haswell";};
      "69" = {name = "haswell";};
      "60" = {name = "haswell";};

      "58" = {name = "ivy-bridge";};

      "42" = {name = "sandy-bridge";};

      "37" = {name = "westmere";};

      "31" = {name = "nehalem";};
      "30" = {name = "nehalem";};

      "23" = {name = "penryn";};

      "22" = {name = "core";};
      "15" = {name = "core";};

      "14" = {name = "modified-pentium-m";};

      "21" = {name = "pentium-m";};
    };
  };
  amd = {
    # TODO: zen 5
    "25" = {
      "96" = {name = "zen4";};
      "112" = {name = "zen4";};
      "120" = {name = "zen4c";};
      "33" = {name = "zen3";};
      "80" = {name = "zen3";};
      "1" = {name = "zen3";};
    };
  };
}
