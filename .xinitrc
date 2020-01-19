xmodmap ~/.Xmodmap
xrandr --output eDP1 --auto --primary --output VIRTUAL2 --auto --above eDP1

# eDP1 = 3840 x 2160
# HDMI = 1920 x 1080 (VIRTUAL2 since running through intel-virtual-output

# full width  = 3840 + 2*1920 = 7680
# full height = 2160 + 2*1080 = 4320

# HDMI scaled resolution = 2*1920 x 2*1080 = 3840x2160

# xrandr --dpi 260 --fb 7680x4320 \
#    --output eDP1 --mode 3840x2160 \
#    --output VIRTUAL2 --scale 2x2 --pos 3840x0 --panning 3840x2160

# HDMI disabled
# xrandr --dpi 260 --fb 7680x4320 \
#        --output eDP1 --mode 3840x2160 \
#        --output VIRTUAL2 --off
