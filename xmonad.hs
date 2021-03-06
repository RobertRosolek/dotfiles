import XMonad
import XMonad.Util.EZConfig
import XMonad.Actions.WindowNavigation
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Reflect
import XMonad.Layout.WorkspaceDir
import XMonad.Prompt (defaultXPConfig, XPConfig(..))
import XMonad.Prompt.Shell
import XMonad.Layout.Column
import XMonad.Actions.RotSlaves
import XMonad.Layout.Grid
import XMonad.Layout.ToggleLayouts
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import qualified XMonad.Layout.GridVariants as GridVariants
import XMonad.Actions.GridSelect
import System.IO
import Data.List (isPrefixOf)
import qualified XMonad.StackSet as W

myManageHook =
  composeAll $ map (genWSHook . show) [0..9]
  where
    genWSHook i =(fmap (isPrefixOf $ "@" ++ i) title) --> doShift i

myConfig xmobarPipe =
  withUrgencyHook FocusHook defaultConfig
    {
      terminal          = "terminal --hide-menubar -e 'ssh dev'",
      focusFollowsMouse = False,
      workspaces        = myWorkspaces,
      layoutHook        = myLayoutHook,
      startupHook       = spawn
      "setxkbmap -option caps:escape && xmodmap /home/rrosolek/dotfiles/.Xmodmap && pidgin",
      manageHook        = composeAll [
                            className =? "Buddy List" --> doShift "9",
                            className =? "@jabber" --> doShift "0",
                            className =? "focus@will" --> doShift "9",
                            myManageHook,
                            manageDocks,
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

{-myWorkspaces = (map show $ [1 .. 2] ++ [8,9,0])-}
myWorkspaces = ["y", "u", ";", "z", "'"]

myLayoutHook =
  avoidStruts $ toggleLayouts Full $ workspaceDir "~" $
    (reflectVert $ GridVariants.SplitGrid GridVariants.T 1 1 (55/100) (4/3) (5/100) ) |||
    (reflectVert $ Column 1.5) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    (reflectHoriz $ Tall 1 (3/100) (1/2)) |||
    (reflectVert $ Mirror (Tall 1 (3/100) (1/2))) |||
    Full

myKeys =
  {- bindings below are for both qwerty and dvorak -}
  [
    ("M-o", sendMessage Expand),
    ("M-i", sendMessage Shrink),
    ("M-f", sendMessage ToggleStruts >> sendMessage ToggleLayout),
    ("M-r", shellPrompt defaultXPConfig),
    ("M-t", withFocused $ windows . W.sink),
    ("M-S-a", spawn "xscreensaver-command -l"),
    ("M-s", scratchpadSpawnActionTerminal "xterm +sb -bg black -fg white"),
    ("M-<Print>", spawn "import screen.png")
    , ("M-j"  , windows W.focusDown)
    , ("M-k"  , windows W.focusUp  )
    , ("M-S-j", windows W.swapDown )
    , ("M-S-k", windows W.swapUp   )
    , ("M-p"  , rotAllUp           )
    , ("M-n"  , rotAllDown         )
    , ("M-S-p", rotSlavesUp        )
    , ("M-S-n", rotSlavesDown      )
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
    config <- withWindowNavigation (xK_k, xK_h, xK_j, xK_l)
            $ myConfig xmobarPipe 
    xmonad config

