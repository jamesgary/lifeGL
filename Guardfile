@quiet = true
notification :growl

# compile app coffeescript to public/dev/js
guard 'coffeescript', {
  :all_on_start => true,
  :output => "public/dev/js",
  :hide_success => @quiet,
} do
  watch(%r{^app/(.+\.coffee)$})
end

# compile haml to public
guard 'haml', {
  :all_on_start => true,
  :input => 'markup',
  :hide_success => @quiet,
  :output => 'public/dev',
} do
  watch(%r{^.+(\.haml)$})
end

# compile sass to public/css
guard 'compass', {
  :all_on_start => true,
  :css_dir => 'public/dev/css',
  :sass_dir => 'style',
  :hide_success => @quiet,
} do
  watch(/^(.*)\.s[ac]ss$/)
end

def ditto(source, target, type)
  watch(source) do |m|
    src = m[0]
    tgt = "public/dev/#{target}/#{m[1]}"

    if system("ditto #{src} #{tgt}")
      n "Copied #{src} to #{tgt}", "Copied #{type} file", :success unless @quiet
    else
      n "Couldn't copy #{src} to #{tgt}", "Failed to copy #{type} file", :failed
    end
  end
end

# copy plain javascript in app to public, just like coffeescript
guard 'shell', {
  :all_on_start => true,
} do
  ditto(%r{^app/(.*\.((js)|(glsl)))$}, 'js', 'js/glsl')
  ditto(%r{^style/(.*\.css)$}, 'css', 'css')
  ditto(%r{^images/(.*)$}, 'css/images', 'image')
end
