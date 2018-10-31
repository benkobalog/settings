import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.SpawnOn(spawnOn, manageSpawn)
import XMonad.Util.Run(spawnPipe, runProcessWithInput)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.SetWMName
import System.Process

import Data.List.Split
import Data.List(isInfixOf)
import Text.Regex

setKeyBoardLayout = "setxkbmap -layout 'us,hu(qwerty)' -option 'grp:alt_shift_toggle'"

data VolumeDirection = Up | Down

volume :: VolumeDirection -> X()
volume dir = do
    pactlStr <- liftIO $ soundSinks
    let idx = builtInCardId pactlStr
        sign = case dir of
            Up -> "+"
            Down -> "-"
        command = "pactl set-sink-volume " ++ (show idx) ++ " " ++ sign ++ "1.5%"
    spawn command


startupActions = 
    setWMName "LG3D" <+>
    spawn "google-chrome" <+>
    spawn "pidgin" <+>
    spawn "xscreensaver -no-splash" <+>
    spawn setKeyBoardLayout

soundSinks = runProcessWithInput "pactl" ["list", "short", "sinks"] ""

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ def
        { manageHook = manageHook def <+> manageDocks
        , layoutHook = avoidStruts  $  layoutHook def
        , logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "green" "" . shorten 50
            }
        , modMask = mod4Mask -- Rebind Mod to the Windows key
        , startupHook = startupActions
        , workspaces = ["1:chrome", "2:pidgin", "3:ide"] ++ map show [4..9]
        , focusedBorderColor = "#66ffff"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        , ((mod4Mask, xK_Page_Up), volume Up)
        , ((mod4Mask, xK_Page_Down), volume Down)        
        , ((mod4Mask .|. shiftMask, xK_f), sendMessage ToggleStruts)
        ]   


--- Functions

find :: (a -> Bool) -> [a] -> Maybe a
find _ [] = Nothing
find cond list = Just $ head $ filter cond list

builtInSoundCardName = "pci-0000_00_1b.0.analog-stereo"

builtInCardId :: String -> Int
builtInCardId pactlStr = 
    maybe 0 getIdFromLine builtInSoundCardLine
    where 
        builtInSoundCardLine = find (isInfixOf builtInSoundCardName) (lines pactlStr)
        getIdFromLine line =
            let idChar =  head line in
                read [idChar] :: Int

-- getVolume = do
--     content <- readFile "stuff"
--     let line = (filter (isInfixOf "\tVolume:") (lines content)) !! (builtInCardId pactlStr)
--     return $ extractPercentage line
--     where
--         extractPercentage line = 
--             maybe "--" head (matchRegex (mkRegex "([0-9][0-9])%") line)
