import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)

import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

import XMonad.Prompt
import XMonad.Prompt.Ssh

import System.IO

myWorkspaces = ["1:www", "2:dev", "3:irc", "4:music", "5:video", "6:etc"]

myManageHook = composeAll
    [
        className =? "Firefox"          --> doShift "1:www",
        className =? "VLC media player" --> doShift "5:video"
    ]

myConfig = defaultConfig {
    terminal            = "urxvt",
    modMask             = mod4Mask,
    focusFollowsMouse   = False,
    workspaces          = myWorkspaces,
    manageHook          = manageDocks <+> manageHook defaultConfig,
    layoutHook          = avoidStruts $ smartBorders $ spacing 5 $ layoutHook defaultConfig

}

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ myConfig {
        logHook = dynamicLogWithPP xmobarPP {
                    ppOutput            = hPutStrLn xmproc,
                    ppCurrent           = xmobarColor "red" "",
                    ppTitle             = xmobarColor "#56c2d6" "" . shorten 50,
                    ppHidden            = wrap "[" "]",
                    ppHiddenNoWindows   = (\id -> id) . wrap "[" "]",
                    ppSep               = " | "
                }
    }
