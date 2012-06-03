
dojo.provide 'app.Div'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'


dojo.declare(
	'app.Div'
	[dijit._Widget, dijit._Templated]

	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Div.html')
	body: ''
	style: 'display:none;'
	constructor: ->
		@inherited arguments

	postCreate: ->
		@inherited arguments
		# toggle button
		if @toggle
			$(@btToggle).bind 'click', =>
				if($(@divBody).css('display') == 'none')
					$(@divBody).slideDown(250)
					$(@btToggle).text '[hide]'
				else
					$(@divBody).slideUp(250)
					$(@btToggle).text '[show]'
		else
			$(@btToggle).remove()
		# close button
		if @close
			$(@btClose).bind 'click', =>
				$(@top).slideUp 300, =>
					@destroyRendering()
		else
			$(@btClose).remove()
		# body
		if @body == ''
			$(@divBody).remove()

	startup: ->
		@inherited arguments
		$(@top).fadeIn(200)


)

