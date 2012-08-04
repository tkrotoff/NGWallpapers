# Downloads wallpapers from National Geographic website

Totally inspired by [Morgan Lefieux's script](http://gerard.geekandfree.org/blog/2011/01/04/telechargez-simplement-les-fonds-decran-du-site-national-geo/). [Original idea](http://blog.stackr.fr/2011/01/rotation-fond-ecrans-wallpapers-national-geographic/) taken from [Romain Bochet](https://github.com/rbochet/National-Geographic-Wallpaper-Download).

Downloads the wallpapers from http://ngm.nationalgeographic.com/wallpaper/download. Works only for wallpapers between 2009-09 and 2011-09, resolution is 1600x1200.

Run it inside a terminal/command prompt without arguments, it will show you the help and available options:

    ./ng_wallpapers.rb 
    Usage: ng_wallpapers.rb [options] output_dir

    Downloads wallpapers from National Geographic website

    Options:
        -y, --year YEAR          Downloads wallpapers for the given year, ex: 2010, 2011
        -m, --month MONTH        Downloads wallpapers for the given month, ex: 5, 6
        -a, --all                Download all wallpapers since september 2009

## Example

    ./ng_wallpapers.rb --all Pictures
	File already exists: Pictures/NationalGeographic-2009-11-n1.jpg

	File already exists: Pictures/NationalGeographic-2009-11-n2.jpg

	Try downloading http://ngm.nationalgeographic.com/wallpaper/img/2010/10/oct10wallpaper-10_1600.jpg...
	Wallpaper saved: Pictures/NationalGeographic-2010-10-n10.jpg

	Try downloading http://ngm.nationalgeographic.com/wallpaper/img/2010/10/oct10wallpaper-11_1600.jpg...
	Wallpaper saved: Pictures/NationalGeographic-2010-10-n11.jpg

	Try downloading http://ngm.nationalgeographic.com/wallpaper/img/2010/10/oct10wallpaper-12_1600.jpg...
	Wallpaper saved: Pictures/NationalGeographic-2010-10-n12.jpg

	Try downloading http://ngm.nationalgeographic.com/wallpaper/img/2010/10/oct10wallpaper-13_1600.jpg...
	Wallpaper saved: Pictures/NationalGeographic-2010-10-n13.jpg

## License

Do whatever you like with it, this is public domain.
