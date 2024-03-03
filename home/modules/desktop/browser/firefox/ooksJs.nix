{
  #Basic Settings
  "browser.disableResetPrompt" = true;
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  "browser.cache.disk.enable" = false;
  "browser.cache.memory.enable" = true;
  "browser.cache.memory.capacity" = 524288;
  "browser.sessionstore.interval" = 15000000;
  "extensions.pocket.enabled" = false;
  "reader.parse-on-load.enabled" = false;
  "accessibility.force_disabled" = 1;
  "browser.helperApps.deleteTempFileOnExit" = true;
  "browser.uitour.enabled" = false;

  #Startup
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  "browser.newtabpage.activity-stream.default.sites" = "";
  "browser.aboutConfig.showWarning" = false;

  #Disable recommendations
  "extensions.getAddons.showPane" = false;
  "extensions.htmlaboutaddons.recommendations.enabled" = false;
  "browser.discovery.enabled" = false;

  #Telemetry
  "datareporting.policy.dataSubmissionEnabled" = false;
  "datareporting.healthreport.uploadEnabled" = false;
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.newProfilePing.enabled" = false;
  "toolkit.telemetry.shutdownPingSender.enabled" = false;
  "toolkit.telemetry.updatePing.enabled" = false;
  "toolkit.telemetry.bhrPing.enabled" = false;
  "toolkit.telemetry.firstShutdownPing.enabled" = false;
  "toolkit.telemetry.coverage.opt-out" = true; 
  "toolkit.coverage.opt-out" = true;
  "toolkit.coverage.endpoint.base" = "";
  "browser.ping-centre.telemetry" = false;
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;
  "toolkit.telemetry.reportingpolicy.firstRun" = false;
  "toolkit.telemetry.shutdownPingSender.enabledFirstsession" = false;
  "browser.vpn_promo.enabled" = false;
  "app.shield.optoutstudies.enabled" = false;
  "app.normandy.enabled" = false;
  "app.normandy.api_url" = "";

  #Crash Reports
  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = false;
  "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

  #Other
  "captivedetect.canonicalURL" = "";
  "network.captive-portal-service.enabled" = false;
  "network.connectivity-service.enabled" = false;

  #Geolocation
  "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
  "geo.provider.use_gpsd" = false;
  "geo.provider.use_geoclue" = false;

  #Calculator
    "browser.urlbar.suggest.calculator" = true;
}
