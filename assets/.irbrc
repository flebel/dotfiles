begin
  require "pry"
  Pry.start
  exit
rescue LoadError
  warn "=> Unable to load pry"
end

