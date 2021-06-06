import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ docks defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , startupHook = setWMName "LG3D"
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        , ((0, 0x1008ff11), spawn "amixer -c 1 -q sset 'Master',0 2%-; amixer -c 1 -q sset 'Headphone',0 2%-")
        , ((0, 0x1008ff13), spawn "amixer -c 1 -q sset 'Master',0 2%+; amixer -c 1 -q sset 'Headphone',0 2%+")
        , ((0, 0x1008ff12), spawn "amixer -c 1 -q set Master toggle; amixer -c 1 set Headphone toggle")
        ]
