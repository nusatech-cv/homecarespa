
require_relative '../nusatech/renderer'

namespace :render do
  desc 'Render configuration and compose files and keys'
  task :config do
    renderer = Nusatech::Renderer.new
    renderer.render_keys
    renderer.render
  end
end