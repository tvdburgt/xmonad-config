import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myWorkspaces = ["term", "www", "irc"]

myStatusBar = "dzen2 -bg '#1a1a1a' -fg '#777777' -h 16 -w 550 -sa c -e '' -fn '-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*' -ta l"

myConfig = defaultConfig {
    terminal            = "urxvt",
    modMask             = mod4Mask,
    focusFollowsMouse   = False,
    workspaces          = myWorkspaces,
    manageHook          = manageDocks <+> manageHook defaultConfig,
    layoutHook          = avoidStruts  $  layoutHook defaultConfig

}

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ myConfig {
        logHook = dynamicLogWithPP xmobarPP {
                    ppOutput = hPutStrLn xmproc,
                    ppTitle = xmobarColor "#56c2d6" "" . shorten 20
                }
    }
