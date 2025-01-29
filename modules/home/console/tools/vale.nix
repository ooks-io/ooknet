{self, ...}: {
  imports = [
    self.homeManagerModules.vale
  ];
  programs.vale = {
    enable = true;
    styles = [
      "microsoft"
      "write-good"
      "alex"
      "readability"
      "proselint"
    ];
    globalSettings = {
      MinAlertLevel = "suggestion";
    };
    formatSettings = {
      "*.{md,txt,tex}" = {
        BasedOnStyles = [
          "proselint"
          "alex"
          "Readability"
          "Microsoft"
        ];
        "Microsoft.Acronyms" = "NO";
      };
    };
  };
}
