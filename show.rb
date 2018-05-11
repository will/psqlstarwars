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

slides << ->() {
  nl = ->(s) { s.gsub('\n', pastel.cyan('\n')) }
  puts head "downloaded site"
  puts pastel.dim.italic "… html and js"
  puts nl.(%q(var film = ') + pastel.magenta(2) + '\n\n\n\n\n\n\n\n\n\n\n\n\n\n' + pastel.magenta(15) + '\n\n\n\n\n                       WWW.ASCIIMATION.CO.NZ\n')
  puts pastel.dim.italic "  … and on and on"
  puts nl.("  " + pastel.magenta(14) + %q{\n====\n Help me, o o~~\n Obi-Wan Kenobi!  _\\- /_\n ___ / \\ / \\\n /() \\ //| | |\\\\\n _|_____|_ // | | |//\n ,@ | | === | | // | | //\n /=- |_| O |_|(\' |===(|\n || || O || | || |\n || ||__*__|| (_)(_)\n --~~--- |~ \\___/ ~| |_||_|\n | | /=\\ /=\\ /=\\ |_||_|\n_________|_____|______[_]_[_]_[_]____/__][__\\______________________\n} +
    pastel.magenta(15) + %q{\n====\n You\'re my only o o~~\n hope!  _\\- /_\n })
  puts pastel.dim.italic "  … and on and on"
  puts nl.('www.asciimation.co.nz\n\n\n\n\n' + pastel.magenta('1') + %q(\n\n\n\n\n\n\n\n\n\n\n\n\n\n�\n'.split('\n'); ))
  puts pastel.dim.italic "… more html and js"
}


slides << ->() {
  puts head "postgres schema"
  c = pastel.cyan.bold.detach
  puts "CREATE TABLE film ("
  puts "  #{c.('i')}     serial PRIMARY KEY,"
  puts "  #{c.('count')} int    NOT NULL,"
  puts "  #{c.('frame')} text   NOT NULL"
  puts ");"
}

slides << ->() {
  puts head "ETL!"

}

last_from_file = File.read(".current") rescue nil
@current = (ARGV[0] || last_from_file || 1).to_i - 1

Signal.trap("INT") do
  File.open(".current", "w") { |f| f.write @current+1 }
  puts "saved current slide"
  exit
end


loop do
  break if @current >= slides.size
  print "\e[H\e[2J"
  puts pastel.dim.italic "slide #{@current+1}/#{slides.size}"

  slides[@current].call

  input = STDIN.gets.strip
  if input == "b"
    @current -= 1
  else
    @current += 1
  end
end

File.delete ".current" if File.exists? ".current"
puts 'show over \o/'
