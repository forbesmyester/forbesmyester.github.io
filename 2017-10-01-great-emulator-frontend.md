# Great Emulator Frontend



After struggling with libretro / retroarch I've settled on Attract-Mode for my emulator frontend but couldn't find a good package for my Debian Stable system. Luckily compilation was easy...

```bash
sudo apt-get install libsfml-dev libopenal-dev zlib1g-dev vflib3-dev libavcodec-dev libavformat-dev libswscale-dev libopengl-dev libglu1-mesa-dev
checkinstall make checkinstall
```

Running was not immediately obvious... It could not find the default font, failing with `Error, could not find default font`. Launching with `attract -f Meslo` fixed it up.

