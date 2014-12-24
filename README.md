# iShows

iShows is a [Sinatra] application to serve images with a determinate size.
iShows use [MiniMagick] library to convert, edit or compose bitmap images.


## Instalation

    $ bundle
    $ apt-get install imagemagick (Ubuntu)
    $ brew install imagemagick (OS X)


## Usage

Using Thin:

    $ thin start -R config.ru

Using Shotgun with an automatic reloading version:

    $ shotgun --server=thin --port=3000 config.ru

### Resize an image

Resize an image from a URL with a specific width:

    http://localhost:3000/width/305/http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'

### Crop an image

Crop an image from a URL with a specific dimensions:

    http://localhost:3000/crop/305x105/http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'


## Deployment

Using [Phusion Passenger] application server for Apache to deploy the Sinatra app.


[Sinatra]: http://www.sinatrarb.com/
[MiniMagick]: https://github.com/minimagic/minimagick
[Phusion Passenger]: https://www.phusionpassenger.com/
