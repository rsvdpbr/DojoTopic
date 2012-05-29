
dojo.provide 'app.Div'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'


dojo.declare(
	'app.Div'
	[dijit._Widget, dijit._Templated]

	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Div.html')
	style: 'display:none;'
	constructor: ->
		@inherited arguments

	postCreate: ->
		@inherited arguments
		# 申請書メニューの作成
		if @sheetMenuEnable
			$(@btBookmark).bind('click', =>
				console.log 'add to bookmark folder'
			)
			$(@btToggle).bind('click', =>
				if($(@divBody).css('display') == 'none')
					$(@divBody).slideDown(250)
					$(@btToggle).text '[hide]'
				else
					$(@divBody).slideUp(250)
					$(@btToggle).text '[show]'
			)
			$(@btClose).bind('click', =>
				$(@top).slideUp(300, =>
					@destroyRendering()
				)
			)
		else
			$(@sheetMenu).empty()

	startup: ->
		@inherited arguments
		$(@top).fadeIn(200)


)

