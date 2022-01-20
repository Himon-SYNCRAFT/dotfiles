import System.Exit
import XMonad
import XMonad.Hooks.EwmhDesktops
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad.Layout.Spacing (spacingRaw, Border (Border))
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.ManageDocks (manageDocks, avoidStruts, docksEventHook, docks)
import XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat, isFullscreen)
import Data.ByteString.Char8 (isPrefixOf)

main :: IO ()
main = xmonad . docks . ewmh $ def
    { modMask = mod1Mask
    , normalBorderColor = "#312e39"
    , focusedBorderColor = "#3e518e"
    , borderWidth = 2
    , terminal = "st"
    , startupHook = startup
    , layoutHook = avoidStruts $ spacingRaw True (Border 16 0 20 0) True (Border 0 20 0 20) True layout
    -- , layoutHook = layout
    , handleEventHook = docksEventHook <+> ewmhDesktopsEventHook <+> fullscreenEventHook
    , keys = keyBindings
    , manageHook = myManageHook <+> manageDocks
    , workspaces = myWorkspaces
    }

startup :: X ()
startup = do
    setWMName "LG3D"
    -- spawnOnce "pgrep -x sxhkd > /dev/null || sxhkd"
    spawnOnce "$HOME/.config/polybar/launch.sh"
    spawnOnce "nm-applet"
    spawnOnce "nitrogen --restore"
    spawnOnce "picom"
    spawnOnce "dunst"
    spawnOnce "thunderbird"
    spawnOnce "electron-mail"
    spawnOnce "caffeine"
    spawnOnce "unclutter --timeout 1 --jitter 50 --ignore-scrolling"
    spawnOnce "redshift-gtk"
    spawnOnce "xmodmap ~/.Xmodmap"
    spawnOnce "setxkbmap -layout pl,pl -variant ,dvorak"
    spawnOnce "setxkbmap -option caps:escape"
    spawnOnce "xset r rate 300 40"
    spawnOnce ""
    spawnOnce "rclone mount syncraft_at_google:/ /home/himon/Remote/syncraft@google/ --vfs-cache-mode full --daemon"
    spawnOnce "keepassxc"

layout = tiled ||| Mirror tiled ||| Full
    where
        -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio

        -- The default number of windows in the master pane
        nmaster = 1

        -- Default proportion of screen occupied by master pane
        ratio   = 5/10

        -- Percent of screen to increment by when resizing panes
        delta   = 3/100

keyBindings :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
keyBindings conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask .|. controlMask, xK_t), spawn "tabbed -n 'st' -d -r 2 st -w '' -e fish") -- %! Launch terminal
    , ((modMask .|. controlMask, xK_r), spawn "st -w '' -e ranger") -- %! Launch ranger
    , ((mod4Mask, xK_l), spawn "betterlockscreen -s dim") -- %! suspend
    , ((modMask,               xK_d     ), spawn "dmenu_run -b -l 10 -p 'run:'") -- %! Launch dmenu
    , ((modMask,               xK_t     ), spawn "~/.config/scripts/openinterminal.sh") -- %! Launch dmenu
    , ((controlMask, xK_x     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_h     ), windows W.focusMaster  ) -- %! Move focus to the master window
    , ((modMask,               xK_l     ), windows W.focusDown  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask .|. shiftMask, xK_h     ), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_l     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((mod4Mask,               xK_h     ), sendMessage Shrink) -- %! Shrink the master area
    , ((mod4Mask,               xK_l     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io exitSuccess) -- %! Quit xmonad
    , ((modMask .|. shiftMask, xK_r     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad

    ]
    ++
    -- mod-[0..9] %! Switch to workspace N
    -- mod-shift-[0..9] %! Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat

     , className =? "microsoft teams - preview"   --> doShift "0"
     , className =? "Microsoft Teams - Preview"   --> doShift "0"
     , className =? "Mail"   --> doShift "9"
     , className =? "Thunderbird"   --> doShift "9"
     , className =? "GG"   --> doShift "8"
     , className =? "Gg"   --> doShift "8"
     , title =? "cmus v2.9.1"   --> doShift "7"
     , isFullscreen  -->  doFullFloat
     ]

myWorkspaces :: [WorkspaceId]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
