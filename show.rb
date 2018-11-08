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
  puts head "warning"
  puts "teamwork makes the dreamwork"
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
  puts head "twitter bots"
  puts "Sometimes there are good jokes on twitter!"
}

slides << ->() {
  puts head "twitter bots"
}

slides << ->() {
  puts head "twitter bots"
  puts <<-RUBY
  def go
    since = REDIS.get "since"
    results = get_tweets since

    results.each { |t| reply_to t }

    REDIS.set("since", results.map(&:id).max || since)
  end
  RUBY
}

slides << ->() {
  puts head "twitter bots"
  puts <<-RUBY
   def reply_to(t)
    return unless rand > 0.95
    r = response_for(t)
    CLIENT.update("@\#{TARGET} \#{r}", in_reply_to_status: t)
  end
  RUBY
}

slides << ->() {
  puts head "twitter bots"
  puts <<-RUBY
  def response_for(t)
    text = t.lang == "ja" ? NAME : JA_NAME
    len = t.full_text.size
    text = text[0]*3 + text if len > 90
    text += text[-1]*10     if len > 140

    text = "…" + text if rand > 0.9
    text += (rand > 0.5 ? "!" : '.') if rand > 0.9
    text += " #\#{NAME}" if rand > 0.9
    text += " " + EMOJI.sample if rand > 0.9

    return text
  end
  RUBY
}

slides << ->() {
  puts head "twitter bots"
  puts <<-RUBY
    TARGET = "tenderlove"
    NAME = "aaron"
    JA_NAME = "アーロン"
    # @aaronautomatic
  RUBY
}

slides << ->() {
  puts head "twitter bots"
  puts image("aaron.png")
}

slides << ->() {
  puts head "twitter bots"
  puts image("aaronja.png")
}


slides << ->() {
  puts head 'Terminal stuff -> These slides!'
  puts <<-RUBY2
    slides << ->() {
      puts head 'Terminal stuff -> These slides!'
      puts <<-RUBY
        slides << ->() {
          puts head 'Terminal stuff -> These slides!'
          puts <<-RUBY
            # TODO figure out recursion
          RUBY
        }
      RUBY
    }
  RUBY2
}

slides << ->() {
  puts head "oh maybe this'll work?"
  File.readlines(__FILE__)[__LINE__-3,8].each{|l| puts l}
  # haha nice
}

slides << ->() {
  puts head "wasn't this about star wars?"
  puts 'asciimation.co.nz'
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
  puts head "what about the emoji‽ "
  puts "can't wait for all movies to be hand drawn into ascii"
}

slides << ->() {
  puts head "what about the emoji‽ "
  puts "have ffmpeg output PPM format!"
  puts
  puts "5036 0a38 3020 3430 0a32 3535 0a00"
  puts "P6.80 40.255"
  puts "format width height color_depth"
}

slides << ->() {
  puts head "initail testing with ansi control characters"
  puts <<-CRYSTAL
struct Pixel
  property r : UInt8
  property g : UInt8
  property b : UInt8

  def initialize(@r, @g, @b)
  end

  def to_c
    STDOUT << "\\x1b[38;2;\#{r};\#{g};\#{b}m█\\x1b[0m"
  end
  CRYSTAL
}

slides << ->() {
  puts head "ansi demo"
}

slides << ->() {
  puts head "no really, what about the emoji‽"
  puts "ok!"
  puts <<-EOF
1) find repo of PNGs of all apple emojis
2) use ffmpeg to turn them into 4 pixel images
3) go through them all manually to remove which ones
   you dont actually have because you are a mojave-not
EOF
}

slides << ->() {
  puts head "emoji.txt"
  puts <<-EOF
4c6c89536a82ae937cb8957b 1f3c2
6c635b695d54ad9b97ab9791 1f3c3-1f3fb-200d-2640-fe0f
936d68927068a28d90a08c8d 1f3c3-1f3fb-200d-2642-fe0f
936d68927068a28d90a08c8d 1f3c3-1f3fb
EOF
  puts
  puts "2624 total, 1065 I have"
}

slides << ->() {
  puts head "distance"
  puts <<-EOF
struct Pixel
  def -(other : Pixel)
    rbar = (self.r.to_f + other.r.to_f)/2.0
    dr = self.r.to_f - other.r.to_f
    dg = self.g.to_f - other.g.to_f
    db = self.b.to_f - other.b.to_f
    # Math.sqrt( ... )
    (2*dr*dr) + (4*dg*dg) + (3*db*db) + ((r * ((dr*dr) - (db*db)))/256)
  end
  EOF
}

slides << ->() {
  puts head "emoji demo"
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
