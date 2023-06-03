Grogulator.prg: monkey.jungle manifest.xml source/GrogulatorApp.mc source/GrogulatorView.mc resources/bitmaps.xml resources/fonts.xml resources/myfont.fnt resources/myfont_0.png
	monkeyc -d fr55 -f monkey.jungle -o Grogulator.prg -y developer_key

install: Grogulator.prg
	cp Grogulator.prg /Volumes/GARMIN/GARMIN/APPS

# fontbm installed from here https://github.com/vladimirgamalyan/fontbm
# Sigma Five Marquee installed from https://www.dafont.com/sigma-five.font
resources/myfont.fnt resources/myfont_0.png:
	fontbm --verbose --font-file /Users/dan/Library/Fonts/Sigma\ Five\ Marquee.otf --font-size 64 --output resources/myfont

clean:
	-rm -rf gen
	-rm -rf mir
	-rm -rf internal-mir
	-rm Grogulator.prg
	-rm Grogulator.prg.debug.xml
	-rm resources/myfont*
