import XMonad
import XMonad.Config.Gnome
import XMonad.Config.Azerty
import qualified Data.Map as M
import XMonad.Layout.Gaps
import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Util.EZConfig(additionalKeys)
--import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.EwmhDesktops

-- Declare config preferences
config_terminal = "gnome-terminal" -- Default terminal to run
config_focusFollowsMouse :: Bool -- Have focus not follow mouse
config_focusFollowsMouse = True 
 
-- Run xmonad with the specified configuration
main = xmonad myConfig

myLogHook :: X ()
myLogHook = do ewmhDesktopsLogHook
               return ()

-- Use the gnomeConfig, but change a couple things
myConfig = gnomeConfig {
  keys = \c -> azertyKeys c `M.union` keys gnomeConfig c,
  terminal = config_terminal,
  layoutHook = myLayouts, 
  manageHook = myManageHook,
  -- logHook = takeTopFocus,
  logHook = myLogHook,
  focusFollowsMouse = config_focusFollowsMouse
} `additionalKeys` myKeys

myKeys = [
    ((mod1Mask, xK_p), spawn "exe=`cat $HOME/.xmonad/dmenu_apps | dmenu` && eval \"exec $exe\"")
    ]

myManageHook = composeAll (
    [ manageHook gnomeConfig
    , className =? "Unity-2d-panel"    --> doIgnore
    , className =? "Unity-2d-launcher" --> doIgnore
    ])

myLayouts = gaps [(U, 24)] $
    desktopLayoutModifiers (Tall 1 0.03 0.5 ||| Full ||| Mirror (Tall 1 (3/100) (1/2)))
