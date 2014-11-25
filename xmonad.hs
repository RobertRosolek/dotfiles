import XMonad
import XMonad.Util.EZConfig
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Reflect
import XMonad.Layout.WorkspaceDir
import XMonad.Prompt (defaultXPConfig, XPConfig(..))
import XMonad.Prompt.Shell
import XMonad.Layout.Column
import XMonad.Layout.Grid
import XMonad.Layout.ToggleLayouts
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Actions.GridSelect
import System.IO
import Data.List (isPrefixOf)
import qualified XMonad.StackSet as W

myConfig xmobarPipe =
  withUrgencyHook NoUrgencyHook defaultConfig
    {
      terminal          = "terminal --hide-menubar -e 'ssh dev'",
      focusFollowsMouse = False,
      workspaces        = myWorkspaces,
      layoutHook        = myLayoutHook,
      manageHook        = composeAll [ manageDocks,
                            scratchpadManageHook (W.RationalRect 0.2 0.2 0.6 0.6) ] ,
      logHook           = dynamicLogWithPP $ xmobarPP {
                              ppOutput = hPutStrLn xmobarPipe,
                              ppTitle  = xmobarColor "green" "" . shorten 50,
                              ppOrder  = \(ws:l:t:_) -> [ws,l,t],
                              ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                            },
      modMask           = myModMask
    } `removeKeysP` [("M-p"), ("M-.")] `additionalKeysP` myKeys

myModMask = mod1Mask {- for alt key use: mod1Mask -}

myWorkspaces = (map show $ [1 .. 9] ++ [0])

myLayoutHook =
  avoidStruts $ toggleLayouts Full $ workspaceDir "~" $
    (reflectVert $ Column 1.5) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    (reflectHoriz $ Tall 1 (3/100) (1/2)) |||
    (reflectVert $ Mirror (Tall 1 (3/100) (1/2))) |||
    Full

myKeys =
  {- bindings below are for both qwerty and dvorak -}
  [
    ("M-=", sendMessage Expand),
    ("M--", sendMessage Shrink),
    ("M-f", sendMessage ToggleStruts >> sendMessage ToggleLayout),
    ("M-r", shellPrompt defaultXPConfig),
    ("M-t", withFocused $ windows . W.sink),
    ("M-S-l", spawn "xscreensaver-command -l"),
    ("M-s", scratchpadSpawnActionTerminal "xterm +sb -bg black -fg white"),
    ("M-o", spawn "cateye post-trade"),
    ("M-i", spawn "ssh tot-qws-u12134 cateye post-trade")
  ]
  ++
  [ ("M-" ++ ws, windows $ W.greedyView ws) | ws <- myWorkspaces ]
  ++
  [ ("M-S-" ++ ws, windows $ W.shift ws) | ws <- myWorkspaces ]
  ++
  [ ("M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . W.view))
    | (key, scr)  <- zip "hl" [0,1] -- change to match your screen order
  ]

main =
  do
    spawn "xscreensaver -no-splash"
    xmobarPipe <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ myConfig xmobarPipe

