doctype 5
ie 'lt IE 7', ->
  html class: "no-js lt-ie9 lt-ie8 lt-ie7", lang: "en"
ie 'IE 7', ->
  html class: "no-js lt-ie9 lt-ie8", lang: "en"
ie 'IE 8', ->
  html class: "no-js lt-ie9", lang: "en"
ie 'gt IE 8', ->
  html class: "no-js", lang: "en"

html -> \
head ->
  meta charset: "utf-8"
  meta 'http-equiv': "X-UA-Compatible", content: "IE=edge,chrome=1"

  title: @getPreparedTitle()

  meta name: "description", content: @getPreparedDescription()
  meta name: "keywords", content: @getPreparedKeywords()
  
  # Mobile viewport optimized: h5bp.com/viewport
  meta name: "viewport", content: "width=device-width"

	# DocPad Meta
	@getBlock('meta').toHTML()

	# DocPad Styles + Our Own
	@getBlock('styles').add(@site.styles).toHTML()

	# Place favicon.ico and apple-touch-icon.png in the root directory
body ->
  # Prompt IE 6 users to install Chrome Frame. Remove this if you support IE 6.
  ie 'lt IE 7', ->
    p class: "chromeframe", ->
      "Your browser is #{cede -> em('ancient1')}. #{ cede -> (a href: 'http://browsehappy.com/', 'Upgrade to a different browser')} or #{ cede -> (a href: 'http://www.google.com/chromeframe/?redirect=true', 'install Google Chrome Frame')} to experience this site."

  header ->
 
    @content

  footer ->

  # JavaScript at the bottom for fast page loading
  @getBlock('scripts').add(@site.scripts).toHTML()
