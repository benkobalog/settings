builtInSoundCardName="pci-0000_00_1b.0.analog-stereo"
stuff=$(pactl list short sinks)
builtInSoundCardId=$(pactl list short sinks | grep "$builtInSoundCardName" | cut -c1)
volume=$(pactl list sinks |
         grep '^[[:space:]]Volume:' |
         head -n $(( $builtInSoundCardId + 1 )) |
         tail -n 1 |
         sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

echo "Vol: $volume"

exit 0