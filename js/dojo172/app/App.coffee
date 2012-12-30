
dojo.provide 'app.App'

dojo.require 'app.Common'
dojo.require 'app.Hash'
dojo.require 'app.DataManager'
dojo.require 'app.Menubar'
dojo.require 'app.Div'

dojo.require 'app.Topic'

dojo.require 'dijit.layout.BorderContainer'
dojo.require 'dijit.layout.StackContainer'
dojo.require 'dijit.layout.ContentPane'

dojo.declare(
	'app.App'
	[app.Common]

	app: 'app.App'
	YEAR: null										# 年度
	hash: null										# ハッシュ。sub-pubで扱う
	data: null										# データクラス
	components: {}								# 要素リスト
	layerCount: 0									# レイヤーカウンタ
	constructor: (YEAR)->
		dojo.publish('app/App/layerFadeIn')
		@inherited arguments
		@YEAR = YEAR
		@hash = new app.Hash()
		@setSubscribe()
		@setLayout()
		@data = new app.DataManager()
		@setContent()
		dojo.publish('app/App/layerFadeOut')

	# 画面をセットアップする
	setLayout:->
		# @ 要素の生成
		# レイヤーの作成
		$('body').append('<div id="layer"></div>')
		$('body').append('<div id="layerAll"></div>')
		@layerCount = 1;
		# コンテンツルートの作成
		$('body').append('<div id="container"></div>')
		@components.container = new dijit.layout.BorderContainer(
			design: 'headeline'
			style: 'width:100%;height:100%;padding:0;background:'+@gBackground+';'
		'container')
		# メニューバーの作成
		@components.container.addChild(
			@components.menubar = new app.Menubar(
				id: 'menubar'
				region: 'top'
				style: 'z-index:10;'
			)
		)
		# @ コンテンツ格納部作成
		@components.container.addChild(
			@components.contents = new dijit.layout.StackContainer(
				id: 'contents'
				region: 'center'
				style: 'padding:0;border:0;'
				# style: 'padding:2px 6px 6px;'
			)
		)

		# @ スタートアップ
		@components.container.startup()

	# APIをセットアップする
	setSubscribe:->
		handles = []
		handles.push dojo.subscribe 'app/App/afterLoginProcess', @, @afterLoginProcess
		handles.push dojo.subscribe 'app/App/layerFadeOut', @, ->
			@layerCount--
			console.log 'out',@layerCount
			if @layerCount == 0
				$('#layer').fadeOut(250)
		handles.push dojo.subscribe 'app/App/layerFadeIn', @, ->
			@layerCount++
			console.log 'in',@layerCount
			$('#layer').show()
		handles.push dojo.subscribe 'app/App/layerAllHide', @, ->
			$('#layerAll').hide()
		handles.push dojo.subscribe 'app/App/layerAllShow', @, ->
			$('#layerAll').show()
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# BBSコンテンツを作成
	setContent:->
		obj =
			region: 'center'
			gBorder: 'border:1px #ccccdc solid;'
			gBackground: 'background:#fdfdfe;'
		@components.innerContent = new app.Topic(obj)
		@components.contents.addChild(@components.innerContent)
		@components.contents.selectChild(@components.innerContent)
		@components.innerContent.border.resize()

)
