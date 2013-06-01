require 'rack'
require 'rack/contrib/try_static'
require './hullapp'

# First, `use` our hullapp middleware
use HullApp

# Then `use` the trystatic middleware
use Rack::TryStatic, :root => "tmp", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

# Lastly, fallback to a 404 - since it's the Last one, we `run` it.
run lambda{ |env|
  not_found_page = File.expand_path("./tmp/404/index.html", __FILE__)
  if File.exist?(not_found_page)
    [ 404, { 'Content-Type'  => 'text/html'}, [File.read(not_found_page)] ]
  else
    [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ]
  end
}