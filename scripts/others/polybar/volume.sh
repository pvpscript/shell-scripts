echo $(pactl list sinks |
    grep -E 'Volume|Mute') |
        awk '{
                is_muted = $2 == "yes" ? 1 : 0; 
                vol_perc = $7; vol = (vol_perc-0)*2.55;
                vol = (vol == int(vol)) ? vol : int(vol)+1; 
               
                red = 0x00;
                green = 0xFF;
                blue = 0x00;

                if (is_muted) { 
                    printf "<span foreground=\x27#0000FF\x27>MUTE</span>";
                } else {
                    if (vol_perc*1 <= 100) {
                        printf "<span foreground=\x27#%02x%02x%02x\x27>%s</span>", 0xFF * (vol_perc / 100), 0xFF - (0xFF * (vol_perc/100)), 0, vol_perc;
                    } else {
                        printf "<span foreground=\x27#FF0000\x27>%s</span>", vol_perc;
                    }
                }
            }';
