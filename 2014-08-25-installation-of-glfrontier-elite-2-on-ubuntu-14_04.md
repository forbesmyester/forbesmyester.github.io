# Installation of glFrontier: Elite 2 on Ubuntu 14.04


## Why

When I saw the [Elite Kickstarter](https://www.kickstarter.com/projects/1461411552/elite-dangerous) I knew about the old Elite games which I never played but I knew had an amazing reputation. I looked around the page watched some video's and decided to back it. Since then I have read all the news releases and watched all the video's Frontier have put out and I'm really getting quite excited by now!

Due to my pledge level I should be able to play the beta however because I am a Linux user I am probably going to have to wait a bit longer than most to be able to play it :-( For the time being I have decided to download one of the older Elite games to see what all the fuss was about.

## Steps

This page documents the process of getting glFrontier Elite 2 working on a modern Ubuntu 14.04 system, I expect that this process is what will also work for Mac's however I am guessing it's a bit tougher to get the development libraries etc installed.

1. Install the required development libraries with `apt-get install build-essential libvorbis-dev`
2. Download "source code (OpenGL, SD:: unix, mingw)" from [http://tom.noflag.org.uk/glfrontier.html](http://tom.noflag.org.uk/glfrontier.html)
3. Extract it with `tar -jxf frontvm2-20060623.tar.bz2`
4. Enter the newly extracted directory
5. Type `make -f Makefile-C` to compile the code, it does print out quite a few warnings, but did work (at least for me)
6. At this point typing `./frontier` should launch the game, though it won't yet have any sound and will print lots of warnings about those missing sound files, so...
7. We now need to download and install the sound files, these are hosted on the same [http://tom.noflag.org.uk/glfrontier.html](http://tom.noflag.org.uk/glfrontier.html) page under thane mame "Sound effects and music (optional with the above). Download it.
8. While still in the extracted game directory untar the sound file, for me it was `tar -jxf ../frontvm-audio-20060222.tar.bz2` which rather annoyingly created a sub directory, so I had to `mv frontvm-audio-20060222/* .; rm -rf frontvm-audio-20060222` to clean that up.
9. Type `./frontier` and you have a fully working version of Frontier Elite 2!

## Links

- [http://tenleftfingers.blogspot.co.uk/2014/01/playing-tom-mortons-glfrontier-on.html](This%20page) was really helpful in getting the compile steps working.
- I used [http://www.frontierastro.co.uk/Hires/hiresfe2.html](http://www.frontierastro.co.uk/Hires/hiresfe2.html) for how to setup the sound
- The main downloads are stored on [http://tom.noflag.org.uk/glfrontier.html](http://tom.noflag.org.uk/glfrontier.html)

