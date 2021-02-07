# frozen_string_literal: true

require 'dotenv/load'
require 'slim'
require 'redcarpet'
require 'lib/array'
set :markdown_engine, :redcarpet
set :redcarpet, autolink: true, no_intra_emphasis: true,
                fenced_code_blocks: true, strikethrough: true

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = 'last 2 versions'
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# Ignore all templates. (This saves us from ignoring within the loop and
# protects us against an error if one of the data types doesn't exist.)
ignore 'templates/*.html'

# Checks to ensure pages data exists before trying to access it
if @app.data&.site&.pages
  # Loop through each page
  data.site.pages.each do |_id, page|
    # The path to the page gets set from the slug of the page
    path = (
      if page.slug == 'index'
        'index.html'
      else
        "#{page.slug}/index.html"
      end
    )
    # Use the appropriate template
    template = "templates/page/#{page.template.parameterize}.html"
    # Add the proxy
    proxy path, template, locals: { page: page }
  end
end

if @app.data&.site&.events
  data.site.events.each do |_id, event|
    path = "events/#{event.slug}/index.html"
    template =
      if !event.special_event?
        'templates/page/event.html'
      else
        'templates/page/event_special.html'
      end
    proxy path, template, locals: { event: event }
  end
end

# if @app.data.try(:site).try(:posts)
#   data.site.posts.each do |_id, post|
#     date = post.published_at
#     path = "blog/#{date.year}-#{'%02i' % date.month}-#{'%02i' % date.day}-#{post.slug}/index.html"
#     template = "templates/post.html"
#     proxy path, template, locals: { post: post }
#   end
# end

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

# Use relative URLs
activate :relative_assets
set :relative_links, true

activate :asset_hash
activate :gzip

# Turn this on if you want to make your url's prettier, without the .html
activate :directory_indexes

activate :sprockets
sprockets.append_path File.join(root, 'node_modules')

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :minify_html
end

activate :contentful do |f|
  f.space         = { site: ENV['CONTENTFUL_SPACE_ID'] }
  f.access_token  = ENV['CONTENTFUL_ACCESS_TOKEN']
  f.content_types = {
    pages: 'page',
    menu_items: 'menuItem',
    events: 'event'
  }
end
