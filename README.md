# iShows

iShows is a [Sinatra] application to serve images with a determinate size. iShows use [MiniMagick] library to convert, edit or compose bitmap images.

## Instalation

    $ bundle
    $ apt-get install imagemagick (Ubuntu)
    $ brew install imagemagick (OSX)

## Usage

Resize an image

    http://server.com/width/305/http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'

Crop an image

    http://server.com/crop/305x105/http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'


## Deployment

Using [Phusion Passenger] application server for Apache to deploy the Sinatra app.


[Sinatra]: http://www.sinatrarb.com/
[MiniMagick]: https://github.com/minimagic/minimagick
[Phusion Passenger]: https://www.phusionpassenger.com/
