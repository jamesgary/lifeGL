js_folder = 'public/dev/js'
js_spec_folder = 'spec/js'
quiet = true

notification :growl

# compile app coffeescript to public/dev/js
guard 'coffeescript', {
  :all_on_start => true,
  :output => "#{js_folder}",
  :hide_success => quiet,
} do
  watch(%r{^app/(.+\.coffee)$})
end

# compile spec coffeescript to spec/js
guard 'coffeescript', {
  :all_on_start => true,
  :output => "#{js_spec_folder}",
  :hide_success => quiet,
} do
  watch(%r{^spec/(.+\.coffee)$})
end

# compile haml to public
guard 'haml', {
  :all_on_start => true, # TODO this doesn't work!
  :input => 'markup',
  :output => 'public/dev',
  :hide_success => quiet,
} do
  watch(%r{^.+(\.haml)$})
end

# compile sass to public/css
guard 'compass', {
  :all_on_start => true, # TODO this doesn't work either!
  :css_dir => 'public/dev/css',
  :sass_dir => 'style',
  :hide_success => quiet,
} do
  watch(/^(.*)\.s[ac]ss$/)
end

# run tests
#guard :jasmine, {
#  :jasmine_url => 'http://localhost:8888/',
#  :console => :always,
#  :all_after_pass => false,
#} do
#  watch(%r{spec/js/.+\.js$})       { "spec/javascripts" } #TODO? why spec/javascripts ?
#  watch(%r{public/dev/js/.+\.js$}) { "spec/javascripts" } #TODO? why spec/javascripts ?
#end

# copy plain javascript in app to public, just like coffeescript
guard 'shell', {
  :all_on_start => true,
} do
  watch(%r{app/(.*\.((js)|(glsl)))$}) do |m|
    source = m[0]
    target = "public/dev/js/#{m[1]}"

    if system("ditto #{source} #{target}")
      n "Copied #{source} to #{target}", "Copied plain file", :success unless quiet
    else
      n "Couldn't copy #{source} to #{target}", "Failed to copy plain file", :failed
    end
  end
end
