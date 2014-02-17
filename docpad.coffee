# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

  # =================================
  # Template Data
  # These are variables that will be accessible via our templates
  # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

  templateData:

    # Specify some site properties
    site:
      # The production url of our website
      url: "http://website.com"

      # Here are some old site urls that you would like to redirect from
      oldUrls: [
        'www.website.com',
        'website.herokuapp.com'
      ]

      # The default title of our website
      title: "Your Website"

      # The website description (for SEO)
      description: """
        When your website appears in search results in say Google, the text here will be shown underneath your website's title.
        """

      # The website keywords (for SEO) separated by commas
      keywords: """
        place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
        """

      # The website's styles
      styles: [
        '/vendor/normalize.css'
        '/vendor/h5bp.css'
        '/styles/style.css'
      ]

      # The website's scripts
      scripts: [
        """
        <!-- jQuery -->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.0/jquery.min.js"></script>
        <script>window.jQuery || document.write('<scr'+'ipt src="/vendor/jquery-2.1.0.min.js"></scr'+'ipt>')</script>
        """
        """
        <!-- lodash -->
        <script src="//cdnjs.cloudflare.com/ajax/libs/lodash.js/2.4.1/lodash.min.js"></script>
        <script>window._ || document.write('<scr'+'ipt src="/vendor/lodash-2.4.1.min.js"></scr'+'ipt>')</script>
        """
        """
        <!-- Backbone -->
        <script src="//cdnjs.cloudflare.com/ajax/libs/backbone.js/1.1.0/backbone-min.js"></script>
        <script>window.Backbone || document.write('<scr'+'ipt src="/vendor/backbone-1.1.0.min.js"></scr'+'ipt>')</script>
        """

        '/scripts/bundle.js'
      ]


    # -----------------------------
    # Helper Functions

    # Get the prepared site/document title
    # Often we would like to specify particular formatting to our page's title
    # we can apply that formatting here
    getPreparedTitle: ->
      # if we have a document title, then we should use that and suffix the site's title onto it
      if @document.title
        "#{@document.title} | #{@site.title}"
      # if our document does not have it's own title, then we should just use the site's title
      else
        @site.title

    # Get the prepared site/document description
    getPreparedDescription: ->
      # if we have a document description, then we should use that, otherwise use the site's description
      @document.description or @site.description

    # Get the prepared site/document keywords
    getPreparedKeywords: ->
      # Merge the document keywords with the site keywords
      @site.keywords.concat(@document.keywords or []).join(', ')


	# =================================
	# Plugins

	plugins:
    browserifybundler:
      outFile: '/scripts/bundle.js'
      inFiles: '/scripts/script.js'
      excludes: ['jquery', 'backbone', 'lodash']

  # =================================
  # DocPad Events

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    # Server Extend
    # Used to add our own custom routes to the server before the docpad routes are added
    serverExtend: (opts) ->
      # Extract the server from the options
      {server} = opts
      docpad = @docpad

      # As we are now running in an event,
      # ensure we are using the latest copy of the docpad configuraiton
      # and fetch our urls from it
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      # Redirect any requests accessing one of our sites oldUrls to the new site url
      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect(newUrl+req.url, 301)
        else
          next()

  srcPath: 'public'
  outPath: 'dist'

  documentsPaths: ['views/templates', 'assets']
  layoutsPaths:   ['views/layouts']
  partialsPaths:  ['views/partials']
  filesPaths:     ['static']
}

# Export our DocPad Configuration
module.exports = docpadConfig