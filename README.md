Kevbot
======

A robot for a turntable.fm room.

Setting Up
==========

First, you need to download the [Turntabler gem](https://github.com/obrie/turntabler/):
http://rubygems.org/gems/turntabler

Second, you need to set up your `config.yaml`. Copy `config.yaml.example` to `config.yaml` (in the same directory) and replace its values with the ones your room and bot uses.

Running Locally
===============

This project was written using Ruby 2.0.0 and is not tested on other versions of Ruby.

Set these environment variables:

 - `ENV["EMAIL"]`: The email for your robot account.
 - `ENV["PASSWORD"]`: The password for your robot account.
 - `ENV["ROOM"]`: Your room's ID.

Look at https://github.com/alaingilbert/Turntable-API/wiki/How-to-find-the:-auth,-userid-and-roomid for instructions on how to find your room's ID.

From the command line in the `src` directory, run

    $ ruby main.rb

Or, if you're planning on hosting with Heroku, go to the project root and run

    $ foreman start

Hosting on Heroku
=================

To host this project on Heroku, set up a new Heroku app on Heroku's website, then add Heroku's git repo as a remote to your local fork of thsi repo:

    $ git add remote heroku git@heroku.com:your_heroku_app.git

Then set the environment variables:

    $ heroku config:set EMAIL=<robot's email>
    $ heroku config:set PASSWORD=<robot's password>
    $ heroku config:set ROOM=<room id>

Finally, spin up the app:

    $ heroku ps:scale console=1
