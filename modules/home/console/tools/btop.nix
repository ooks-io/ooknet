{
  lib,
  osConfig,
  hozen,
  ...
}: let
  inherit (lib) mkIf;
  inherit (hozen) color;
  cfg = osConfig.ooknet.console.tools.btop;
in {
  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        color_theme = "${color.slug}";
        rounded_corners = false;
        proc_gradient = false;
      };
    };
    xdg.configFile."btop/themes/${color.slug}.theme".text = ''
      theme[main_bg]="#${color.layout.body}"
      theme[main_fg]="#${color.typography.text}"

      theme[title]="#${color.typography.text}"
      theme[hi_fg]="#${color.primary.base}"
      theme[selected_bg]="#${color.typography.text}"
      theme[selected_fg]="#${color.typography.contrast-text}"
      theme[inactive_fg]="#${color.typography.contrast-text}"

      theme[graph_text]="#${color.typography.text}"
      theme[proc_misc]="#${color.green.base}"

      theme[cpu_box]="#${color.secondary.base}"
      theme[mem_box]="#${color.secondary.base}"
      theme[proc_box]="#${color.secondary.base}"
      theme[net_box]="#${color.secondary.base}"

      theme[temp_start]="#${color.green.base}"
      theme[temp_mid]="#${color.orange.base}"
      theme[temp_end]="#${color.red.base}"

      theme[cpu_start]="#${color.teal.base}"
      theme[cpu_mid]="#${color.teal.hard1}"
      theme[cpu_end]="#${color.teal.hard2}"

      theme[free_start]="#${color.blue.base}"
      theme[free_mid]="#${color.blue.hard1}"
      theme[free_end]="#${color.blue.hard2}"

      theme[available_start]="#${color.orange.base}"
      theme[available_mid]="#${color.orange.hard1}"
      theme[available_end]="#${color.orange.hard2}"

      theme[used_start]="#${color.green.base}"
      theme[used_mid]="#${color.green.soft1}"
      theme[used_end]="#${color.green.soft2}"

      theme[download_start]="#${color.purple.base}"
      theme[download_mid]="#${color.purple.hard1}"
      theme[download_end]="#${color.purple.hard2}"

      theme[upload_start]="#${color.yellow.base}"
      theme[upload_mid]="#${color.yellow.hard1}"
      theme[upload_end]="#${color.yellow.hard2}"

      theme[process_start]="#${color.green.base}"
      theme[process_mid]="#${color.orange.base}"
      theme[process_end]="#${color.red.base}"
    '';
  };
}
