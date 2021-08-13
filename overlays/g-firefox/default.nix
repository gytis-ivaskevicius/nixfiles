{ pkgs, lib, wrapFirefox, firefox-unwrapped, ... }:
with lib;
with builtins;
let
  #https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig
  # ~/.mozilla/firefox/HASH_ID.default/prefs.js
  defaultPrefs = {
    "app.normandy.first_run" = false;
    "app.shield.optoutstudies.enabled" = false;
    "browser.aboutConfig.showWarning" = false;
    "browser.ctrlTab.recentlyUsedOrder" = false;
    "browser.download.viewableInternally.typeWasRegistered.svg" = true;
    "browser.download.viewableInternally.typeWasRegistered.webp" = true;
    "browser.download.viewableInternally.typeWasRegistered.xml" = true;
    "browser.fullscreen.autohide" = false;
    "browser.proton.enabled" = true;
    "browser.search.hiddenOneOffs" = "Google,Amazon.com,Bing,DuckDuckGo,Wikipedia (en)";
    "browser.shell.checkDefaultBrowser" = false;
    "browser.startup.page" = 3; #Resume the previous browser session
    "browser.tabs.closeWindowWithLastTab" = false;
    "browser.uidensity" = 1; # Compact
    "devtools.accessibility.enabled" = false;
    "devtools.cache.disabled" = true;
    "devtools.chrome.enabled" = true;
    "devtools.command-button-fission-prefs.enabled" = false;
    "devtools.command-button-measure.enabled" = true;
    "devtools.command-button-rulers.enabled" = true;
    "devtools.command-button-screenshot.enabled" = true;
    "devtools.debugger.prefs-schema-version" = 11;
    "devtools.editor.keymap" = "vim";
    "devtools.inspector.activeSidebar" = "ruleview";
    "devtools.inspector.three-pane-enabled" = false;
    "devtools.memory.enabled" = false;
    "devtools.netmonitor.columnsData" = "[{\"name\":\"status\",\"minWidth\":30,\"width\":5.79},{\"name\":\"method\",\"minWidth\":30,\"width\":5.79},{\"name\":\"domain\",\"minWidth\":30,\"width\":7.54},{\"name\":\"file\",\"minWidth\":30,\"width\":39.2},{\"name\":\"url\",\"minWidth\":30,\"width\":20},{\"name\":\"initiator\",\"minWidth\":30,\"width\":17.54},{\"name\":\"type\",\"minWidth\":30,\"width\":4.51},{\"name\":\"transferred\",\"minWidth\":30,\"width\":16.78},{\"name\":\"contentSize\",\"minWidth\":30,\"width\":29.21},{\"name\":\"waterfall\",\"minWidth\":150,\"width\":44.71},{\"name\":\"cookies\",\"minWidth\":30,\"width\":7.41},{\"name\":\"setCookies\",\"minWidth\":30,\"width\":7.41},{\"name\":\"remoteip\",\"minWidth\":30,\"width\":7.41},{\"name\":\"scheme\",\"minWidth\":30,\"width\":7.41},{\"name\":\"protocol\",\"minWidth\":30,\"width\":7.41}]";
    "devtools.netmonitor.filters" = "[\"xhr\"]";
    "devtools.netmonitor.visibleColumns" = "[\"status\",\"method\",\"file\",\"type\",\"waterfall\"]";
    "devtools.performance.enabled" = false;
    "devtools.screenshot.clipboard.enabled" = true;
    "devtools.styleeditor.enabled" = false;
    "devtools.theme" = "dark";
    "devtools.toolbox.host" = "right";
    "devtools.toolbox.previousHost" = "bottom";
    "devtools.toolbox.sidebar.width" = 1471;
    "devtools.toolbox.splitconsoleHeight" = 387;
    "devtools.toolsidebar-height.inspector" = 350;
    "devtools.toolsidebar-width.inspector" = 704;
    "devtools.toolsidebar-width.inspector.splitsidebar" = 704;
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "extensions.webcompat.enable_picture_in_picture_overrides" = true;
    "extensions.webcompat.enable_shims" = true;
    "extensions.webcompat.perform_injections" = true;
    "extensions.webcompat.perform_ua_overrides" = true;
    "gfx.webrender.all" = true;
    "gfx.webrender.enabled" = true;
    "media.ffmpeg.vaapi.enabled" = true;
    "network.allow-experiments" = false;
    "privacy.donottrackheader.enabled" = true;
    "signon.rememberSignons" = false;
    #"browser.startup.homepage" = "https://nixos.org";
    #"extensions.pocket.enabled" = false;
    #"extensions.update.enabled" = false;
    #"widget.wayland-dmabuf-vaapi.enabled" = true;

    "browser.newtabpage.enabled" = false;
    "browser.newtabpage.enhanced" = false;
    "browser.newtabpage.activity-stream.enabled" = false;
    "experiments.supported" = false;
    "experiments.enabled" = false;


    # Disable some not so useful functionality.
    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
    "extensions.shield-recipe-client.enabled" = false;
    "dom.battery.enabled" = false;
    # Disable "beacon" asynchronous HTTP transfers (used for analytics)
    # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
    "beacon.enabled" = false;

    # Disable pinging URIs specified in HTML <a> ping= attributes
    # http://kb.mozillazine.org/Browser.send_pings
    "browser.send_pings" = false;

    # Disable gamepad API to prevent USB device enumeration
    # https://www.w3.org/TR/gamepad/
    # https://trac.torproject.org/projects/tor/ticket/13023
    "dom.gamepad.enabled" = false;
    # Disable health reports (basically more telemetry)
    # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
    # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
    "datareporting.healthreport.uploadEnabled" = false;
    "datareporting.healthreport.service.enabled" = false;
    "datareporting.policy.dataSubmissionEnabled" = false;
    "browser.search.firstRunSkipsHomepage" = true;

    "extensions.formautofill.available" = "off";
    "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
    "browser.newtabpage.activity-stream.feeds.snippets" = false;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.toolbars.bookmarks.visibility" = "always";
    "browser.urlbar.shortcuts.bookmarks" = false;
    "browser.urlbar.shortcuts.history" = false;
    "browser.urlbar.shortcuts.tabs" = false;
    "findbar.highlightAll" = true;

    "browser.uiCustomization.state" = toJSON {
      "placements" = {
        "widget-overflow-fixed-list" = [ ];
        "nav-bar" = [
          "back-button"
          "forward-button"
          "stop-reload-button"
          "urlbar-container"
          "downloads-button"
          "library-button"
          "sidebar-button"
          "fxa-toolbar-menu-button"
        ];
        "toolbar-menubar" = [
          "menubar-items"
        ];
        "TabsToolbar" = [
          "tabbrowser-tabs"
          "new-tab-button"
          "alltabs-button"
        ];
        "PersonalToolbar" = [
          "personal-bookmarks"
        ];
      };
      "seen" = [
        "developer-button"
      ];
      "dirtyAreaCache" = [
        "nav-bar"
        "PersonalToolbar"
        "toolbar-menubar"
        "TabsToolbar"
      ];
      "currentVersion" = 16;
      "newElementCount" = 4;
    };

  };

  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #    audio-fingerprint-defender
    #    bitwarden
    #    browserpass
    #    canvas-fingerprint-defender
    #    certificate_pinner
    #    dark-reader
    #    darkreader
    #    font-fingerprint-defender
    #    foxyproxy-standard
    #    https-everywhere
    #    languagetool
    #    lastpass-password-manager
    #    link-cleaner
    #    org-capture
    #    privacy-badger
    #    reddit-enhancement-suite
    #    sidebery
    #    stylus
    ublock-origin
    #    unpaywall
    #    user-agent-switcher
    #    vim-vixen
    vimium
    #    webgl-fingerprint-defender
  ];

in
wrapFirefox firefox-unwrapped {

  #nixExtensions = extensions;
  extraPolicies = {
    CaptivePortal = false;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    #EncryptedMediaExtensions.Enable = false;
    #SearchSuggestEnabled = false;
    #OfferToSaveLogins = false;
    #NetworkPrediction = false;
    #OverridePostUpdatePage = "";
    #FirefoxHome = {
    #  Search = false;
    #  Pocket = false;
    #  Snippets = false;
    #  Highlights = false;
    #  TopSites = true;
    #};
    UserMessaging = {
      ExtensionRecommendations = false;
      SkipOnboarding = true;
    };
    #SupportMenu = {
    #  Title = "navi's browser";
    #  URL = "https://govanify.com";
    #};
    #SearchBar = "unified";
    #PictureInPicture.Enabled = false;
    #PasswordManagerEnabled = false;
    NoDefaultBookmarks = false;
    DontCheckDefaultBrowser = true;
    DisableSetDesktopBackground = true;
    # probably handled by nix extensions but oh well
    DisableSystemAddonUpdate = true;
    ExtensionUpdate = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };

    DisableFeedbackCommands = true;
    SearchEngines.Default = "Google";
    #BlockAboutAddons = true;
    #DisableFormHistory = true;
  };
  extraPrefs = ''
        // Gytis
        ${concatStrings (mapAttrsToList
    (name: value: ''
          lockPref("${name}", ${builtins.toJSON value});
        '')
    defaultPrefs)}
  '';

}

#    extensions = with  [
