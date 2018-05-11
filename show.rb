#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require "base64"

slides = []

starwars = TTY::Font.new(:starwars)
font = TTY::Font.new(:standard)
pastel = Pastel.new

def blink(s)
  "\e[5m#{s}\e[0m"
end

def head(s)
  p = Pastel.new
  p.bold.magenta("➸ ") + p.bold.magenta.underline(s) + "\n\n"
end
#def image(path)
  #img = Base64.encode64(File.read(path))
  #puts "\x1B]1337;File=inline=1;#{img}\x07"
#end

slides << ->() {
  wrap = ->(n, s) { "❦ "*n + s + "❦ "*n }
  puts wrap.(10, pastel.magenta('using psql to \watch'))
  puts starwars.write "Star"
  puts starwars.write "Wars"
  puts wrap.(11, pastel.magenta("Will Leinweber"))
}

slides << ->() {
  puts head("Bio")
  puts "     name: Will Leinweber"
  puts "  twitter: @leinweber"
  puts "Home Page: bitfission.com " + pastel.yellow('/!\warning/!\ midis autoplay')
  puts "     work: citusdata.com"
  puts "   slides: github.com/will/psqlstarwars"
}


slides << ->() {
  puts font.write '\watch'
  puts "postgres 9.3"
}

slides << ->() {
  puts head("Best contribution in the history of computer science?")
  puts "Some say yes"
  STDIN.gets
  puts <<-EOF
commit c6a3fce7dd4dae6e1a005e5b09cdd7c1d7f9c4f4
Author: Tom Lane <tgl@sss.pgh.pa.us>
Date:   Thu Apr 4 19:56:33 2013 -0400

Add \watch [SEC] command to psql.

This allows convenient re-execution of commands.
EOF
  STDIN.gets
  puts "Will Leinweber, reviewed by Peter Eisentraut, Daniel Farina, and Tom Lane"
}


slides << ->() {
  puts head 'asciimation.co.nz'
  puts "by Simon Jansen"
}

slides << ->() {
  puts head "can't just curl"
  puts <<-EOF
<script type="text/javascript">
<!--
Sorry your browser doesn't support compressed web pages. Click the link below for the original Java version.
EOF
}

slides << ->() {
  puts head "use compression!"
  puts <<-EOF
$ curl -sH 'Accept-encoding: gzip' www.asciimation.co.nz | gunzip - > site.html
$ du -hs site.html
2.0M	site.html
EOF
}

start = (ARGV[0] || 1).to_i - 1

i = start
loop do
  break if i >= slides.size
  print "\e[H\e[2J"
  puts pastel.dim.italic "slide #{i+1}/#{slides.size}"

  slides[i].call

  input = STDIN.gets.strip
  if input == "b"
    i -= 1
  else
    i += 1
  end
end
