#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require "base64"

if ARGV[0] == "c"
  height = 18
  width = 75
  msg = " can you read this"
  height.times {|i| puts i.to_s.rjust(2) + msg + "?"*(width-msg.size-3) }
  exit
end
slides = []

starwars = TTY::Font.new(:starwars)
font = TTY::Font.new(:standard)
pastel = Pastel.new

def show_over
  File.delete ".current" if File.exists? ".current"
  puts '\o/ show over \o/'
  exec "afplay starwars.midi.mp3"
end

def blink(s)
  "\e[5m#{s}\e[0m"
end

@triggered = false
def async_loop
  @triggered = false
  Thread.new { STDIN.gets; @triggered = true }
  loop do
    yield
    break if @triggered
  end
end

def head(s)
  p = Pastel.new
  p.bold.magenta("➸ ") + p.bold.magenta.underline(s) + "\n\n"
end

def image(path,w="100%",h="100%")
  img = Base64.encode64(File.read(path))
  #puts "\x1B]1337;File=inline=1;#{img}\x07"
  puts "\033]1337;File=inline=1;width=#{w};height=#{h}:#{img}\x07"
end

def add_stars(s)
  color = Pastel.new.bold.green.detach
  new_s = []
  s.split(/\n/).map { |line| line.ljust(TTY::Screen.width) }.join("\n").split(//).each do |c|
    if c == " "
      if rand > 0.7
        new_s << rand_star
      else
        new_s << c
      end
    else
      new_s << color.(c)
    end
  end
  new_s.join('')
end

def rand_star
  c = rand > 0.5  ? "." : "*"
  c = blink(c) if rand > 0.5
  c = Pastel.new.yellow(c) if rand > 0.5
  Pastel.new.dim(c)
end

slides << ->() {
  wrap = ->(n, s) { "❦ "*n + s + "❦ "*n }
  async_loop do
    puts wrap.(10, pastel.magenta('using psql to \watch'))
    puts add_stars starwars.write "Star "
    puts add_stars starwars.write "Wars"
    puts wrap.(5, pastel.magenta("And other silly things! by Will Leinweber"))
    sleep 1 + rand
    print TTY::Cursor.up(16)
  end
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
  puts head 'bundle update!'
  print "2015: 1,396,073"; STDIN.gets
  puts "2018: 3,968,675"
}

slides << ->() {
  puts head 'bundle update!'
  puts <<-GRAPH

  3,968,675 |        _,-'
  2,682,374 |    _,-'
  1,396,073 | ,-'
          0 |____________
              15 16 17 18
  GRAPH
}


slides << ->() {
  puts head 'story time'
  puts "90 children"
  puts "names = (1..90).map(&:to_s)"
}

slides << ->() {
  puts add_stars starwars.write "coding"
  puts add_stars starwars.write "for fun"
}

slides << ->() {
  puts head 'themes'
  puts "automation"
  puts "terminal things"
}

slides << ->() {
  puts head 'automation'
  puts "chatbots"
}

slides << ->() {
  puts head 'automation'
  puts "chatbots"
}



slides << ->() {
  puts head 'slack typing'
  puts <<-RUBY
  client = Slack::RealTime::Client.new(token: token)

  client.on(:user_typing) do |data|
    logger.info data
    client.typing channel: data.channel
    #client.message channel: data.channel,
    #  text: "What are you typing <@\#{data.user}>?"
  end

  client.start_async
  RUBY
}

slides << ->() {
  puts head "demo"
  # ffmpeg -i ../slacktyping/will_typing.mov -s 320:108 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > out.gif > slacktyping.gif
  puts image "slacktyping.gif"
}

slides << ->() {
  puts head 'asciimation.co.nz'
  puts "by Simon Jansen"
}


slides << ->() {
puts <<-STARWARS
                                        ====
          Help me,                      o o~~
      Obi-Wan Kenobi!                  _\\O /_
                           ___        / \\ /  \\
                          /() \\      //| |  |\\\\
                        _|_____|_   // | |  |//
            ,@         | | === | | //  | |  //
            /=-        |_|  O  |_|('   |===(|
            ||          ||  O  ||      | || |
            ||          ||__*__||      (_)(_)
          --~~---      |~ \\___/ ~|     |_||_|
          |     |      /=\\ /=\\ /=\\     |_||_|
 _________|_____|______[_]_[_]_[_]____/__][__\\______________________
STARWARS
}

slides << ->() {
puts <<-STARWARS
                                        ====
      You're my only                    o o~~
           hope!                       _\\- /_
                           ___        / \\ /  \\
                          /() \\      //| |  |\\\\
                        _|_____|_   // | |  |//
            ,@         | | === | | //  | |  //
            /=-        |_|  O  |_|('   |===(|
            ||          ||  O  ||      | || |
            ||          ||__*__||      (_)(_)
          --~~---      |~ \\___/ ~|     |_||_|
          |     |      /=\\ /=\\ /=\\     |_||_|
 _________|_____|______[_]_[_]_[_]____/__][__\\______________________
STARWARS
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
$ curl -sH 'Accept-encoding: gzip' asciimation.co.nz | gunzip - > site.html
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
  print 'raw = File.readlines("site.html")'; STDIN.gets
  print '  .find {|line| line.start_with? "var film"}'; STDIN.gets
  print "  .encode('UTF-8','binary',invalid: :replace,undef: :replace,replace: '')"; STDIN.gets
  print %q{  .gsub(%q{\'},"'")[12..-16]}; STDIN.gets
  print %q{  .split('\n')}; STDIN.gets
  print "  .each_slice(14)"
}

slides << ->() {
  puts head "ETL!"
  puts <<-'EOF'
require 'sequel'
db = Sequel.connect("postgres:///")

raw.each do |data|
  count, *frame = data
  db[:film] << {count: count.to_i, frame: frame.join("\n")}
end
  EOF
}

slides << ->() {
  puts head "we are"
  puts add_stars starwars.write "almost"
  puts add_stars starwars.write "there!"
}

slides << ->() {
  puts head "postgres functions!"
  puts <<-SQL.gsub(/speed|ctr/) {|s| pastel.cyan.bold(s)}
CREATE OR REPLACE FUNCTION go(speed numeric, ctr bigint)
RETURNS text AS $$
  begin
    PERFORM pg_sleep(count*speed) FROM film WHERE i=ctr-1; -- 😴
    RETURN (SELECT frame FROM film WHERE i=ctr);           -- 👀
  end
$$ LANGUAGE plpgsql;
SQL
}

slides << ->() {
  puts head "postgres sequences!"
  puts <<-SQL.gsub(/--.*$/) {|s| pastel.cyan.bold(s) }
CREATE SEQUENCE ctr;
SELECT nextval('ctr'); -- 1
SELECT nextval('ctr'); -- 2
SELECT nextval('ctr'); -- 3

ALTER SEQUENCE ctr RESTART 200;
SELECT nextval('ctr'); -- 200
SELECT nextval('ctr'); -- 201
SQL
}

slides << ->() {
  puts head "Are we done?"
  puts "SELECT go(0.01, nextval('ctr'));"
  puts "SELECT go(0.01, nextval('ctr'));"
  puts "SELECT go(0.01, nextval('ctr'));"
  puts "SELECT go(0.01, nextval('ctr'));"
  puts; STDIN.gets
  puts head "NO! there HAS to be a better way!"

}

slides << ->() {
  puts add_stars font.write '\watch'
  puts "💓 💕 💖 💗 💘 💙 💚 💛 💜 💝 "
  puts "   postgres 9.3"
  puts "💓 💕 💖 💗 💘 💙 💚 💛 💜 💝 "
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

  <authors>, reviewed by <reviewers>
EOF
  STDIN.gets
  print TTY::Cursor.up(2)
  puts "  Will Leinweber, reviewed by Peter Eisentraut, Daniel Farina, and Tom Lane"
  h = "😇" + ' '
  puts "  " + h*7
}


slides << ->() {
  puts add_stars starwars.write "demo"
}

slides << ->() {
  puts add_stars starwars.write "thanks"
  puts head "@leinweber"
  puts head "github.com/will/psqlstarwars"
  show_over
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
  elsif input == "r"
    # noop
  else
    @current += 1
  end
end

show_over
