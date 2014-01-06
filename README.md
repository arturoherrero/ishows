# ishows

ishows is a [Sinatra] application to serve images with a determinate size. ishows use [MiniMagick] library to convert, edit or compose bitmap images.

## instalation

    $ bundle install
    $ brew install imagemagick

## usage

Resize an image

    http://imageServer.com/width/305/http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'

Crop an image

    http://imageServer.com/width/305x105/http://www.thetvdb.com/banners/fanart/original/81189-43.jpg'


## deployment

Using [Phusion Passenger] application server for Apache to deploy the Sinatra app.


[Sinatra]: http://www.sinatrarb.com/
[MiniMagick]: https://github.com/minimagic/minimagick
[Phusion Passenger]: https://www.phusionpassenger.com/
