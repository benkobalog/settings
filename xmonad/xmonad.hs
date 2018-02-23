import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ def
        { manageHook = manageDocks <+> manageHook def
        , layoutHook = avoidStruts  $  layoutHook def
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , startupHook = setWMName "LG3D" <+> spawn "python3 ~/.xmonad/autostart.py"
        , focusedBorderColor = "#66ffff"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        , ((mod4Mask, xK_Page_Up), spawn "pactl set-sink-volume 0 +1.5%")
        , ((mod4Mask, xK_Page_Down), spawn "pactl set-sink-volume 0 -1.5%")        
        , ((mod4Mask .|. shiftMask, xK_f), sendMessage ToggleStruts)
        ]   
