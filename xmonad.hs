{-# OPTIONS_GHC -Wall -fno-warn-missing-signatures #-}
import XMonad

import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook

import XMonad.Actions.GridSelect

import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Prompt.Man

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.Run

import XMonad.Layout.NoBorders

import XMonad.Actions.CycleWS

import System.IO

myWorkspaces    = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 "]

myManageHook = composeAll
    [
        className =? "Firefox"          --> doShift " 1 ",
        className =? "Xmessage"         --> doCenterFloat,
        isFullscreen                    --> (doF W.focusDown <+> doFullFloat)
    ]

myKeys = [
    -- xmonad stuff
    ("M-]",                         nextWS),
    ("M-[",                         prevWS),
    ("M-z",                         toggleWS),
    ("M-g",                         goToSelected defaultGSConfig),
    ("M-u",                         focusUrgent),
    ("M-p",                         spawn "dmenu_run -l 5"),

    -- miscelleaneous stuff
    ("M-S-l",                       spawn "slock"),

    -- applications
    ("M-b",                         spawn "$BROWSER"),
    ("M-i",                         runInTerm "" "sudo htop"),
    ("M-c",                         runInTerm "" "mc"),

    -- prompts
    ("M-s",                         sshPrompt defaultXPConfig),
    ("M-<F1>",                      manPrompt defaultXPConfig),

    -- mpd stuff
    ("M-f",                         spawn "mpc seek +10"),
    ("M-S-f",                       spawn "mpc seek -10"),
    ("M-S-.",                       spawn "mpc next"),
    ("M-S-,",                       spawn "mpc prev"),

    -- xf86 keys
    ("<XF86Tools>",                 runInTerm "" "ncmpcpp"),
    ("<XF86AudioPlay>",             spawn "mpc toggle"),
    ("<XF86AudioMute>",             spawn "amixer set Master toggle"),
    ("<XF86AudioLowerVolume>",      spawn "amixer set Master playback 1-"),
    ("<XF86AudioRaiseVolume>",      spawn "amixer set Master playback 1+"),
    ("M-<XF86AudioLowerVolume>",    spawn "mpc volume -5"),
    ("M-<XF86AudioRaiseVolume>",    spawn "mpc volume +5"),
    ("<XF86HomePage>",              spawn "$BROWSER")
 ]

myLogHook xmobar = dynamicLogWithPP xmobarPP {
    ppOutput            = hPutStrLn xmobar,
    ppCurrent           = xmobarColor "#D7D0C7" "#870E0E",
    ppVisible           = xmobarColor "#D7D0C7" "#536175",
    ppUrgent            = xmobarColor "#D7D0C7" "#3F9E6C" . xmobarStrip,
    ppHidden            = xmobarColor "#D7D0C7" "#3B3A3A",
    ppHiddenNoWindows   = xmobarColor "#D7D0C7" "",
    ppTitle             = xmobarColor "#D7D0C7" "" . shorten 80,
    ppSep               = " : ",
    ppWsSep             = ""
}

myConfig xmobar = defaultConfig {
    terminal            = "urxvt",
    modMask             = mod4Mask,
    focusFollowsMouse   = False,
    borderWidth         = 2,
    normalBorderColor   = "#7D7C7C",
    focusedBorderColor  = "#FF5781",
    workspaces          = myWorkspaces,
    manageHook          = manageDocks <+> myManageHook,
    layoutHook          = avoidStruts $ smartBorders $ layoutHook defaultConfig,
    logHook             = myLogHook xmobar
}

myUrgencyConfig = UrgencyConfig { suppressWhen = Focused, remindWhen = Dont } 

main = do
    xmobar <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ withUrgencyHookC NoUrgencyHook myUrgencyConfig
           $ myConfig xmobar `additionalKeysP` myKeys
