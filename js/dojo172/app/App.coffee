
dojo.provide 'app.App'

dojo.require 'app.Common'
dojo.require 'app.Hash'
dojo.require 'app.DataManager'
dojo.require 'app.Menubar'
dojo.require 'app.Div'

dojo.require 'app.Top'
dojo.require 'app.Sheet'
dojo.require 'app.Bbs'
dojo.require 'app.Data'

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
	components: []								# 要素リスト
	layerCount: 0									# レイヤーカウンタ
	constructor: (YEAR)->
		@inherited arguments
		@YEAR = YEAR
		@hash = new app.Hash()
		@setSubscribe()
		@setLayout()
		@data = new app.DataManager()
	afterLoginProcess: ->
		dojo.publish('app/Hash/addCallback', ['app/App/onHashChange'])

	# 画面をセットアップする
	setLayout:->
		# @ 要素の生成
		# レイヤーの作成
		$('body').append('<div id="layer"></div>')
		$('body').append('<div id="layerAll"></div>')
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
		# @ コンテンツ部作成
		@components.container.addChild(
			@components.contents = new dijit.layout.StackContainer(
				id: 'contents'
				region: 'center'
				style: 'padding:0;border:0;'
				# style: 'padding:2px 6px 6px;'
			)
		)
		# コンテンツ格納ハッシュ
		@components.innerContents = {}
		# @ スタートアップ
		@components.container.startup()

	# APIをセットアップする
	setSubscribe:->
		handles = []
		handles.push dojo.subscribe 'app/App/afterLoginProcess', @, @afterLoginProcess
		handles.push dojo.subscribe 'app/App/layerFadeOut', @, ->
			@layerCount--
			if @layerCount == 0
				$('#layer').fadeOut(250)
		handles.push dojo.subscribe 'app/App/layerFadeIn', @, ->
			@layerCount++
			$('#layer').show()
		handles.push dojo.subscribe 'app/App/layerAllHide', @, ->
			$('#layerAll').hide()
		handles.push dojo.subscribe 'app/App/layerAllShow', @, ->
			$('#layerAll').show()
		handles.push dojo.subscribe('app/App/onHashChange', @, @onHashChange)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# ハッシュ更新時にコールされる
	onHashChange: (hash)->
		dojo.publish('app/App/layerFadeIn')
		# 未ロードの場合、新規作成
		if !@components.innerContents[hash.mode]?
			obj =
				page: hash.mode
				region: 'center'
				gBorder: 'border:1px #ccccdc solid;'
				gBackground: 'background:#fdfdfe;'
			if hash.mode == 'top'
				@components.innerContents[hash.mode] = new app.Top(obj)
			else if hash.mode == 'sheet'
				@components.innerContents[hash.mode] = new app.Sheet(obj)
			else if hash.mode == 'bbs'
				@components.innerContents[hash.mode] = new app.Bbs(obj)
			else if hash.mode == 'data'
				@components.innerContents[hash.mode] = new app.Data(obj)
			@components.contents.addChild(@components.innerContents[hash.mode])
		# 表示
		@components.contents.selectChild(@components.innerContents[hash.mode])
		@components.innerContents[hash.mode].border.resize()
		dojo.publish('app/App/layerFadeOut')

)
