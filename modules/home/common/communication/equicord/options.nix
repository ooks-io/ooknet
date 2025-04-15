{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) listOf str int enum numbers oneOf bool strMatching;
  mkBoolOption = default: description:
    mkOption {
      type = bool;
      inherit default description;
    };

  mkLabelOption = default:
    mkOption {
      type = str;
      inherit default;
      description = "${default} label";
    };

  mkEquibopSelect = attr: v: attr.${v};
  listToString = sep: list: builtins.concatStringsSep sep list;

  rgbValue = ''([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])'';
  rgbDecimal = strMatching ''${rgbValue}, *${rgbValue}, *${rgbValue}'';
  hexColor = strMatching "#[[:xdigit:]]{6}";

  mkHexColorOption = name:
    mkOption {
      type = oneOf [hexColor (enum [""])];
      default = "";
      description = "${name} color in hex format";
      example = "#ea6962";
    };

  cfg = config.programs.equicord;
in {
  options.programs.equicord = {
    enable = mkEnableOption "Enable Equicord, for of Vencord";
    package = mkPackageOption pkgs "equibop" {
      default = "equibop";
      example = pkgs.equicord;
    };
    settings = {
      autoUpdate = mkEnableOption "Enable auto updating for Equicord" // {default = true;};
      autoUpdateNotification = mkEnableOption "Notify when Equicord automatically updates";
      useQuickCss = mkEnableOption "Enable custom CSS";
      themeLinks = mkOption {
        type = listOf str;
        default = [];
        description = "List of Discord CSS themes to install via link";
        example = ["https://refact0r.github.io/midnight-discord/midnight.css"];
      };
      enabledThemes = mkOption {
        type = listOf str;
        default = [];
        description = "List of themes to enable from XDG_CONFIG_HOME/equibop/themes";
      };
      enableReactDevtools = mkEnableOption "Enable react dev tools extension";
      frameless = mkEnableOption "Enable frameless mode";
      transparent = mkEnableOption "Enable transparent mode. Requires a theme that supports transparency";
      disableMinSize = mkEnableOption "Disable minimum window size";
      notifications = {
        timeout = mkOption {
          type = int;
          default = 5000;
          description = "Notification timeout in ms, set to 0 to never automatically time out";
          example = 0;
        };
        position = mkOption {
          type = enum ["bottom-right" "top-right"];
          default = "bottom-right";
          description = "Position of notifications";
          example = "top-right";
        };
        useNative = mkOption {
          type = enum ["always" "never" "not-focused"];
          default = "not-focused";
          description = "When should notifications be used";
          example = "always";
        };
        logLimit = mkOption {
          type = int;
          default = 50;
          description = ''
            The amount of notifications to save in the log until old ones are removed.
            Set to 0 to disable log. Set to 0 to to disable notification log and 200 to
            never automatically remove old notifcations
          '';
        };
      };
      plugins = {
        # API plugins
        ChatInputButtonsAPI.enabled = mkBoolOption true "Chat Input API";
        CommandsAPI.enabled = mkBoolOption true "";
        DynamicImageModalAPI.enabled = mkBoolOption false "";
        MemberListDecoratorsAPI.enabled = mkBoolOption false "";
        MessageAccessoriesAPI.enabled = mkBoolOption true "";
        MessageDecorationsAPI.enabled = mkBoolOption false "";
        MessageEventsAPI.enabled = mkBoolOption false "";
        MessageUpdaterAPI.enabled = mkBoolOption false "";
        ServerListAPI.enabled = mkBoolOption false "";
        UserSettingsAPI.enabled = mkBoolOption true "";

        AccountPanelServerProfile = {
          enabled = mkEnableOption ''
            Right click your account panel in the bottom left to
            view your profile in the current server.
          '';
          prioritizeServerProfile = mkEnableOption ''
            Prioritize Server Profile when left clicking your account panel.
          '';
        };
        AllCallTimers = {
          enabled = mkEnableOption ''
            Add call timer to all users in a server voice channel.
          '';
          showWithoutHover = mkEnableOption ''
            Always show the timer without needing to hover.
          '';
          showRoleColor = mkEnableOption ''
            Show the users role color.
          '';
          trackSelf = mkEnableOption ''
            Also track yourself.
          '';
          showSeconds = mkEnableOption ''
            Show seconds in the timer.
          '';
          format = mkOption {
            type = enum ["stopwatch" "human"];
            default = "human";
            description = ''
              Compact or human readable format:
              - stopwatch: 30:23:00:42
              - human: 30d 23h 00m 42s
            '';
          };
          watchLargeGuilds = mkEnableOption ''
            Track users in large guild. Warning this may cause lag if your in a lot
            of guilds with active voice users.
          '';
        };
        AltKrispSwitch.enabled = mkEnableOption ''
          Makes the Noise Suppression Popout switch between None and Krisp instead
          of Krisp and Strandard.
        '';
        AlwaysAnimate = {
          enable = mkEnableOption ''
            Animates anything that can be animated.
          '';
        };
        AlwaysExpandRoles = {
          enabled = mkEnableOption "Always expand the role list in profile popouts.";
          hideArrow = mkEnableOption "Hide Arrows.";
        };
        AlwaysTrust = {
          enabled = mkEnableOption ''
            Remove the untrusted domain and suspicious file popup.
          '';
          domain = mkEnableOption ''
            Remove the untrusted domain popup when opening links.
          '';
          file = mkEnableOption ''
            Remove the "Potentially Dangerous Download" popup when opening links.
          '';
        };
        AmITyping.enabled = mkEnableOption "Shows you if other people can see you typing.";
        Anammox = {
          enabled = mkEnableOption ''
            A microbial process that plays an important part in the nitrogen cycle.
            Hide various discord nitro excusive features.
          '';
          dms = mkEnableOption "Remove shops above DMs list";
          billing = mkEnableOption "Remove billings settings";
          gift = mkEnableOption "Remove gift button";
          emojiList = mkEnableOption "Remove unavailable catagories from the emoji picker";
        };
        AnonymiseFileNames = {
          enabled = mkEnableOption "Anonymise uploaded file names";
          anonymiseByDefault = mkEnableOption "Whether to anonymise file names by default";
          method = mkOption {
            type = enum ["random characters" "consistant" "timestamp"];
            default = "random characters";
            apply = mkEquibopSelect {
              "random characters" = 0;
              "consistent" = 1;
              "timestamp" = 2;
            };
          };
          randomizedLength = mkOption {
            type = int;
            default = 7;
            description = "Random character length.";
          };
          consistent = mkOption {
            type = str;
            default = "image";
            description = "Consistant filename.";
            # doesn't appear to be an option you can change
            readOnly = true;
          };
        };
        AtSomeone.enabled = mkEnableOption "Mention someone randomly.";
        BANger = {
          enabled = mkEnableOption "Replaces the GIF i nthe ban dialogue with a custom one.";
          source = mkOption {
            type = str;
            default = "";
            description = "Source to replace ban GIF with (video or GIF).";
            example = "https://i.imgur.com/wp5q52C.mp4";
          };
        };
        BannersEverywhere = {
          enabled = mkEnableOption "Display banners in the member list.";
          animate = mkEnableOption "Animate banners.";
        };
        BetterActivities = {
          enabled = mkEnableOption ''
            Shows activity icons in the member list and allows showing all activities.
          '';
          memberList = mkEnableOption "Show activity icons in the member list";
          iconSize = mkOption {
            type = int;
            default = 15;
            description = "Size of the activity icons.";
          };
          specialFirst = mkEnableOption "Show special activities first (Currently Spotify and Twitch).";
          renderGifs = mkEnableOption "Allow rendering GIFs.";
          showAppDescription = mkEnableOption "Show application descriptions in the activity tooltip.";
          userPopout = mkEnableOption "Show all activities in the profile popout/sidebar.";
          allActivitiesStyle = mkOption {
            type = enum ["corousel" "list"];
            default = "corousel";
            description = "Style for showing all activities";
          };
        };
        BetterAudioPlayer = {
          enabled = mkEnableOption ''
            Adds a spectograph and oscilloscope visualizer to audio attachment players.
          '';
          oscilloscope = mkEnableOption "Enable oscilloscope visualizer.";
          spectograph = mkEnableOption "Enable spectograph visualizer.";
          oscilloscopeSolidColor = mkEnableOption "Use colid color for oscilloscope.";
          oscilloscopeColor = mkOption {
            # not 100% sure if a hex color value can be set via json here
            type = rgbDecimal;
            default = "255, 255, 255";
            description = "RGB Color for the oscilloscope.";
            example = "10, 200, 130";
          };
          spectographSolidColor = mkEnableOption "Use solid color for spectograph.";
          spectographColor = mkOption {
            type = rgbDecimal;
            default = "33, 150, 243";
            example = "10, 200, 130";
          };
        };
        BetterBanReasons = {
          enabled = mkEnableOption ''
            Create custom reasons to use in the Discord Ban modal, and/or
            show a test input by default instead of the options.
          '';
          reasons = mkOption {
            type = listOf str;
            default = [];
            description = "List of ban reasons";
            example = [
              "uses nix"
              "arch user"
            ];
          };
          textInputDefault = mkEnableOption ''
            Shows a text input instead of a select menu by default. (Equivalent to clicking the "Other" option).
          '';
        };
        BetterFolders = {
          enabled = mkEnableOption ''
            Shows server folders on dedicated sidebar and adds folder related improvements.
          '';
          sidebar = mkEnableOption "Display servers from folder on dedicated sidebar.";
          sidebarAnim = mkEnableOption "Animate opening the folder sidebar.";
          closeAllFolders = mkEnableOption "Close all folders when selecting a server not in a folder.";
          closeOthers = mkEnableOption "Close other folders when opening a folder.";
          forceOpen = mkEnableOption "Force a folder to open when switching to a server of that folder.";
          keepIcons = mkEnableOption ''
            Keep showing guild icons in the primary guild bar folder when it's open
            in the BetterFolders sidebar.
          '';
          showFoldersIcon = mkOption {
            type = enum ["never" "always" "when more than one folder is expanded"];
            default = "always";
            description = ''
              Show the folder icon above the folder guilds in the BetterFolders sidebar.
              Available options:
              - "never"
              - "always"
              - "when more than one folder is expanded"
            '';
            apply = mkEquibopSelect {
              "never" = 0;
              "always" = 1;
              "when more than one folder is expanded" = 2;
            };
          };
        };
        BetterGifAltText = mkEnableOption ''
          Change GIF alt text from simply being 'GIF' to containing the gif tags/filename.
        '';
        BetterGifPicker = mkEnableOption "Makes the GIF picker open the favourite category by default";
        BetterInvites = mkEnableOption ''
          See invites expiration date, view inviter profile and preview discoverable servers before joining
          by clicking their name.
        '';
        BetterNotesBox = {
          enabled = mkEnableOption "Hide notes or disable spellcheck.";
          hide = mkEnableOption "Hide notes.";
          noSpellCheck = mkEnableOption "Disable spellcheck in notes";
        };
        BetterQuickReact = {
          enabled = mkEnableOption "Improves the quick react buttons in the message context menu";
          frequentEmojis = mkEnableOption "Use frequently used emojis instead of favorite emojis";
          rows = mkOption {
            type = numbers.between 1 16;
            default = 2;
            description = "Rows of quick reactions to display. Number between 1-16";
            example = 4;
          };
          columns = mkOption {
            type = numbers.between 1 12;
            default = 4;
            description = "Columns of quick reactions to display. Number betwen 1-12";
            example = 6;
          };
          compactMode = mkEnableOption ''
            Scales the buttons to 75% of their original scale, whilst increasing the inner emoji to 125% scale.
            Emojis will be 93.75% of the original size. Reccomended to have a minimum of 5 columns.
          '';
          scroll = mkEnableOption "Enable scrolling the list of emojis";
        };
        BetterRoleContext = {
          enabled = mkEnableOption ''
            Adds options to copy role color / edit role / view role icon when right clicking roles in
            in the user profile
          '';
          roleIconFileFormat = mkOption {
            type = enum ["webp" "png" "jpg"];
            default = "png";
            description = "File formate to use when viewing role icons";
          };
        };
        BetterRoleDot = {
          enabled = mkEnableOption ''
            Copy role colour on RoleDot (accessibility setting) click. Also allows using both
            RoleDot and coloured names simultaneously.
          '';
          bothStyles = mkEnableOption "Show both role dot and coloured names";
          copyRoleColorInProfilePopout = mkEnableOption "Allow click on role dot in profile popout to copy role color";
        };
        BetterSession = {
          enabled = mkEnableOption ''
            Enhances the sessions (devices) menu. Allows you to view exact timestamps, give each session a
            custom name, and receive notifications about new sessions.
          '';
          backgroundCheck = mkEnableOption ''
            Check for new sessions in the background, and display notifications when they are detected.
          '';
          checkInterval = mkOption {
            type = int;
            default = 20;
            description = "How often to check for new sessions in the background (if enabled), in minutes.";
          };
        };
        BetterSettings = {
          enabled = mkEnableOption "Enhances your settings-menu-opening experience.";
          disableFade = mkEnableOption "Disable the crossfade animation.";
          organizeMenu = mkEnableOption "Organizes the settings cog context menu into categories.";
          eagerLoad = mkEnableOption "Removes the loading delay when opening the menu for the first time.";
        };
        BetterUploadButton.enabled = mkEnableOption "Upload with a single click, open menu with right click";
        BetterUserArea.enabled = mkEnableOption ''
          Reworks the user area styling to fit more buttons and overall look nicer
        '';
        BetterStreamPreview.enabled = mkEnableOption "Allows you to enlarge stream previews";
        BlockKeywords = {
          enabled = mkEnableOption ''
            Blocks messages containing specific user-defined keywords, as if the user sending them was blocked.
          '';
          blockedWords = mkOption {
            type = str;
            default = "";
            description = "Comma-seperated list of words to block.";
            example = "arch,home-manager";
          };
          useRegex = mkEnableOption "Use each value as a regular expression when checking message content (advanced)";
          caseSensitive = mkEnableOption "Whether to use a case sensitive search or not.";
          ignoreBlockedMessages = mkEnableOption "Completely ignores (recent) new messages bar";
        };
        BlockKrisp.enabled = mkEnableOption "Prevent Krist from loading";
        BlurNSFW = {
          enabled = mkEnableOption "Blur attachments in NSFW channels until hovered.";
          blurAmount = mkOption {
            type = int;
            default = 10;
            description = "Blur amount";
          };
        };
        BypassStatus = {
          enabled = mkEnableOption ''
            Still get notifications from specific sources when in do not disturb mode.
            Right-click on users/channels/guilds to set them to bypass do not disturb mode.
          '';
          guilds = mkOption {
            type = listOf str;
            default = [];
            description = ''
              Guilds to let bypass (notified when pinged anywhere in guild).
              List of comma seperated guild IDs.
            '';
            example = [
              "123451234512345123"
              "456456456456456456"
            ];
            apply = listToString ",";
          };
          channels = mkOption {
            type = listOf str;
            default = [];
            description = ''
              channels to let bypass (notified when pinged anywhere in channel).
              List of .
            '';
            example = [
              "123451234512345123"
              "456456456456456456"
            ];
            apply = listToString ",";
          };
          users = mkOption {
            type = listOf str;
            default = [];
            description = ''
              users to let bypass (notified when pinged anywhere in guild).
              List of comma seperated user IDs.
            '';
            example = [
              "123451234512345123"
              "456456456456456456"
            ];
            apply = listToString ",";
          };
          notificationSound = mkEnableOption "Whether the notification sound should be played";
          statusToUse = mkOption {
            type = enum ["dnd" "invisible" "idle"];
            default = "dnd";
            description = "Status to use for whitelist.";
          };
          allowOutsideOfDm = mkEnableOption ''
            Allow selected users to bypass status outside of DMs too
            (acts like a channel/guild bypass, but it's for all messages sent by the selected users).
          '';
        };
        CallTimer = {
          enabled = mkEnableOption "Adds a timer to vcs.";
          format = mkOption {
            type = enum ["human" "stopwatch"];
            default = "human";
            description = "The timer format.";
          };
        };
        ChannelBadges = {
          enabled = mkEnableOption "Adds badges to channels based on their type.";
          oneBadgePerChannel = mkEnableOption "Show only one badge per channel.";
          showTextBadge = mkEnableOption "Show Text badge";
          showVoiceBadge = mkEnableOption "Show Voice badge";
          showCategoryBadge = mkEnableOption "Show Category badge";
          showDirectoryBadge = mkEnableOption "Show Directory badge";
          showAnnouncementThreadBadge = mkEnableOption "Show Announcement Thread badge";
          showPublicThreadBadge = mkEnableOption "Show Public Thread badge";
          showPrivateThreadBadge = mkEnableOption "Show Private Thread badge";
          showStageBadge = mkEnableOption "Show Stage badge";
          showAnnouncementBadge = mkEnableOption "Show Announcement badge";
          showForumBadge = mkEnableOption "Show Forum badge";
          showMediaBadge = mkEnableOption "Show Media badge";
          showNSFWBadge = mkEnableOption "Show NSFW badge";
          showLockedBadge = mkEnableOption "Show Locked badge";
          showRulesBadge = mkEnableOption "Show Rules badge";
          showUnknownBadge = mkEnableOption "Show Unknown badge";
          textBadgeLabel = mkLabelOption "Text";
          voiceBadgeLabel = mkLabelOption "Voice";
          categoryBadgeLabel = mkLabelOption "Category";
          announcementBadgeLabel = mkLabelOption "News";
          announcementThreadBadgeLabel = mkLabelOption "News Thread";
          publicThreadBadgeLabel = mkLabelOption "Thread";
          privateThreadBadgeLabel = mkLabelOption "Private Thread";
          stageBadgeLabel = mkLabelOption "Stage";
          directoryBadgeLabel = mkLabelOption "Directory";
          forumBadgeLabel = mkLabelOption "Forum";
          mediaBadgeLabel = mkLabelOption "Media";
          nsfwBadgeLabel = mkLabelOption "NSFW";
          lockedBadgeLabel = mkLabelOption "Locked";
          rulesBadgeLabel = mkLabelOption "Rules";
          unknownBadgeLabel = mkLabelOption "Unknown";
          lockedBadgeColor = mkHexColorOption "Locked badge";
          rulesBadgeColor = mkHexColorOption "Rules badge";
          unknownBadgeColor = mkHexColorOption "Unknown badge";
          nsfwBadgeColor = mkHexColorOption "NSFW badge";
          mediaBadgeColor = mkHexColorOption "Media badge";
          forumBadgeColor = mkHexColorOption "Forum badge";
          directoryBadgeColor = mkHexColorOption "Directory badge";
          stageBadgeColor = mkHexColorOption "Stage badge";
          privateThreadBadgeColor = mkHexColorOption "Private Thread badge";
          publicThreadBadgeColor = mkHexColorOption "Public Thread badge";
          announcementThreadBadgeColor = mkHexColorOption "Announcement Thread badge";
          announcementBadgeColor = mkHexColorOption "Announcement badge";
          categoryBadgeColor = mkHexColorOption "Category badge";
          voiceBadgeColor = mkHexColorOption "Voice badge";
          textBadgeColor = mkHexColorOption "Text Badge";
        };
        # doesn't seem to work for me. May require window decorations?
        ChannelTabs.enabled = mkEnableOption ''
          Group our commonly visited channels in tabs. Warning: this doesnt appear to be working.
        '';
        CharacterCounter = {
          enabled = mkEnableOption "Adds a character counter to the chat input.";
          colorEffects = mkEnableOption "Turn on or off color effects for getting close to the character limit";
          position = mkEnableOption "Move the character counter to the left side of the chat input";
        };
        CleanChannelName.enabled = mkEnableOption "Remove all emoji and decor from channel names";
        ClearURLs.enabled = mkEnableOption "Remove tracking garbage from URLs";
        ClientSideBlock = {
          enabled = mkEnableOption "Allows you to locally hide almost all content from any user";
          usersToBlock = mkOption {
            type = listOf str;
            default = [];
            description = "List of User IDs to block";
            example = [
              "123456789"
              "987654321"
            ];
            apply = listToString ", ";
          };
          hideBlockedUser = mkEnableOption "Should blocked users also be hidden everywhere.";
          hideBlockedMessages = mkEnableOption "Should messages from blocked users be hidden fully.";
          hideEmptyRoles = mkEnableOption "Should role headers be hidden if all of their member are blocked.";
          blockedReplyDisplay = mkOption {
            type = enum ["displayText" "hideReply"];
            default = "displayText";
            description = ''
              What should display instead of the message when someone replies to someone you have hidden.
              - "displayText": Display text saying a hidden message was replied to.
              - "hideReply": Literally nothing
            '';
          };
          guildBlackList = mkOption {
            type = listOf str;
            default = [];
            description = "List of guild IDs to disable functionality in";
            apply = listToString ", ";
          };
          guildWhiteList = mkOption {
            type = listOf str;
            default = [];
            description = "List of guild IDs to enable functionality in";
            apply = listToString ", ";
          };
        };
        ClientTheme = {
          enabled = mkEnableOption "Recreation of the old client theme experiment. Add color to your Discord client theme";
          color = mkOption {
            type = strMatching "[[:xdigit:]]{6}";
            description = "Themes Color";
            default = "282828";
          };
        };
        ColorSighted.enabled = mkEnableOption "Removes the colorblind-friendly icons from statuses, just like 2015-2017 Discord";
        CommandPalette = {
          enabled = mkEnableOption "Allows you to navigate the UI with a keyboard.";
          hotkey = mkOption {
            # TODO: Regex this
            type = listOf str;
            default = [
              "control"
              "shift"
              "p"
            ];
            description = "HotKey to toggle the command palette.";
            example = [
              "control"
              "h"
            ];
          };
        };
        ConsoleJanitor = {
          enabled = mkEnableOption "Disables annoying console messages/errors";
          disableLoggers = mkEnableOption "Disables Discord loggers";
          disableSpotifyLoggers = mkEnableOption "Disable the Spotify logger, which leaks account information and access token";
          whitlistedLoggers = mkOption {
            type = listOf str;
            default = [
              "GatewaySocket"
              "Routing/Utils"
            ];
            description = "List of loggers to allow even if others are hidden.";
            apply = listToString "; ";
          };
        };
        ConsoleShortcuts.enabled = mkEnableOption ''
          Adds shorter Aliases for many things on the window. Run 'shortcutList' for a list.
        '';
        CopyEmojiMarkdown = {
          enabled = mkEnableOption "Allows you to copy emojis as formatted string (<:blobcatcozy:1026533070955872337>).";
          copyUnicode = mkEnableOption "Copy the raw unicode character instead of :name: for default emojis.";
        };
        CopyFileContents.enabled = mkEnableOption "Adds a button to text file attachments to copy their contents.";
        CopyUserMention.enabled = mkEnableOption ''
          Adds a button to copy user's mention on the user context menu, works best with ValidUser.
        '';
        CopyUserURLs.enabled = mkEnableOption "Adds a 'Copy User URL' option to the user context menu.";
        CrashHandler = {
          enabled = mkBoolOption true "Utility for handling and possibly recovering from chrashes without restart.";
          attemptToPreventCrashes = mkBoolOption true "Whether to attempt to prevent Discord crashes.";
          attemptToNavigateToHome = mkEnableOption "Whether to attempt to navigate to the home when preventing Discord crashes.";
        };
        CtrlEnterSend = {
          enabled = mkEnableOption "Use Ctrl+Enter to send messages (customizable).";
          submitRule = mkOption {
            type = enum ["ctrl+enter" "shift+enter" "enter"];
            default = "ctrl+enter";
            description = ''
              The way to send a messages.
              Available options:
              - "ctrl+enter" (Enter of Shift+Enter for new line) (cmd+enter on macOS)
              - "shift+enter" (Enter for a new Line)
              - "enter" (Shift+Enter for new line; Discord default)
            '';
          };
          sendMessageInTheMiddleOfACodeBlock = mkEnableOption "Whether to send a message in the middle of a code block.";
        };
        CustomIdle = {
          enabled = mkEnableOption "Allows you to set the time before Discord goes idle (or disable auto-idle)";
          idleTimeout = {
            type = numbers.between 0 60;
            default = 20;
            description = "Minutes before Discord goes idle (0 to disable auto-idle). 0.0 - 60.0";
          };
          remainInIdle = mkEnableOption "When you come back to Discord, remain idle until you confirm you want to go online";
        };
        CustomSounds.enabled = mkEnableOption "Replace Discord's sounds with your own, custom sounds must be defined via client";
        CustomTimestamps = let
          mkTimestampOption = default: description:
            mkOption {
              type = str;
              inherit default description;
            };
        in {
          enabled = mkEnableOption ''
            Custom timestamps on mesages and tooltips.
            See <https://momentjs.com/docs/#/displaying/format/> for documentation on formatting.
          '';
          cozyFormat = mkTimestampOption "[calander]" "Time format to use in messages on cozy mode.";
          compactFormat = mkTimestampOption "LT" "Time format on compact mode and hovering messages.";
          tooltipFormat = mkTimestampOption "LLLL • [relative]" "Time format to use on tooltips.";
          sameDayFormat = mkTimestampOption "HH:mm:ss" "[calander] format for today.";
          lastDayFormat = mkTimestampOption "[yesterday] HH:mm:ss" "[calander] format for yesterday.";
          lastWeekFormat = mkTimestampOption "ddd DD.MM.YYYY HH:mm:ss" "[calander] format for last week.";
          sameElseFormat = mkTimestampOption "ddd DD.MM.YYYY HH:mm:ss" "[calander] format for older dates.";
        };
        # why weebs, why
        CuteAnimeBoys.enabled = mkEnableOption "Add a command to send cute anime boys in the chat";
        CuteNekos.enabled = mkEnableOption "Send Nekos to others";
        CutePats.enabled = mkEnableOption "Sending head pats.";
        DeadMembers.enabled = mkEnableOption "Shows when the sender of a message has left the guild.";
        Dearrow = {
          enabled = mkEnableOption "Makes YouTube embed titles and thumbnails less sensationalist, powered by Dearrow.";
          hideButton = mkEnableOption "Hides the Dearrow button from Youtube embeds.";
          replaceElements = mkOption {
            type = enum ["everything" "titles" "thumbnails"];
            default = "everything";
            description = ''
              Choose which elements of the embed will be replaced.
              Available options:
              - "everything"
              - "titles"
              - "thumbnails"
            '';
            apply = mkEquibopSelect {
              "everything" = 0;
              "titles" = 1;
              "thumbnails" = 2;
            };
          };
          dearrowByDefault = mkEnableOption "Dearrow videos automatically";
        };
        DecodeBase64 = {
          enabled = mkEnableOption "Decode base64 content of any message and copy the decoded content.";
          clickMethod = mkOption {
            type = enum ["Left" "Right"];
            default = "Left";
          };
        };
      };
    };
  };
  config = mkIf cfg.enable {
    # test file until module is complete
    xdg.configFile."equibop/test.json".text = builtins.toJSON cfg.settings;
  };
}
