# SCRIPT FORM
# https://gist.github.com/miyl/40cdf1a66b360ad8ec0b19e2ffa56194

get_all_sinks() {
  pactl list short sinks | cut -f 2
}

get_default_sink() {
  pactl info | grep 'Default Sink' | cut -d':' -f 2
}

DEF_SINK=$(get_default_sink)
for SINK in $(get_all_sinks) ; do
  if [ "$SINK" = "alsa_output.pci-0000_01_00.1.hdmi-stereo" -o "$SINK" = "alsa_output.usb-Sony_Interactive_Entertainment_DualSense_Wireless_Controller-00.analog-surround-40" ]; then
    continue
  fi
  [ -z "$FIRST" ] && FIRST=$SINK 
  if [ " $SINK" = "$DEF_SINK" ]; then
    NEXT=1;
  elif [ -n "$NEXT" ]; then
    NEW_DEFAULT_SINK=$SINK
    break
  fi
done

[ -z "$NEW_DEFAULT_SINK" ] && NEW_DEFAULT_SINK=$FIRST

pactl set-default-sink "$NEW_DEFAULT_SINK"