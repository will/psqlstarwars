raw = File.readlines("site.html")
          .find {|line| line.start_with? "var film"}
          .encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')[12..-16]
          .split('\n')
          .each_slice(14)


require 'sequel'
db = Sequel.connect("postgres:///")

raw.each do |data|
  count, *frame = data
  db[:film] << {count: count.to_i, frame: frame.join("\n")}
end

