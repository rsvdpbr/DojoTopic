
dojo.provide "app.Hash"

dojo.require "dojo.hash"

dojo.declare(
	"app.Hash"
	[app.Common]

	app: 'app.Hash'
	callback: []		 # onHashChangeにてpublishされるコールバック関数名。
	hash: null       # 最新のハッシュを格納。onHashChangeにて更新。

	constructor: ()->
		@inherited arguments
		@_getTableData('members', (data)->
			console.log data
		)
		# @ 各コールバックは登録時にも呼ばれるため、初期値入力では呼ばれないよう、先に初期値を設定する
		if dojo.hash() == ''
			@changeHash(mode:'top')
		@setSubscribe()

	# APIをセットアップする
	setSubscribe: ->
		handles = []
		handles.push dojo.subscribe('/dojo/hashchange', @, @onHashChange)
		handles.push dojo.subscribe('app/Hash/addCallback', @, @addCallback)
		handles.push dojo.subscribe('app/Hash/changeHash', @, @changeHash)
		handles.push dojo.subscribe('app/Hash/getHash', @, @getHash)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# コールバック関数を登録する
	addCallback: (str)->
		@callback.push str
		@_updateHashVar()
		dojo.publish(str, [@hash])

	# ユーザ情報を取得する
	getHash: (publish)->
		dojo.publish(publish, [@hash])

	# ハッシュ変更時にコールされ、メンバ変数hashを更新する
	onHashChange: ->
		@_updateHashVar()
		for i in @callback
			dojo.publish(i, [@hash])
	_updateHashVar: ->
		@hash = {}
		for i in dojo.hash().split("&")
			if i.indexOf("=") != -1
				tmp = i.split('=')
				@hash[tmp[0]] = tmp[1]
			else
				@hash[i] = 'NO-VALUE'

	# ハッシュに変更を加える (nullを渡すと削除)
	changeHash: (status)->
		# @ 既存のハッシュ文字列を配列化
		hash = {}
		for i in dojo.hash().split('&')
			if i.indexOf('=') != -1
				tmp =i.split('=')
				hash[tmp[0]] = tmp[1]
			else
				hash[i] = ''
		# @ 既存ハッシュ文字列にマージ
		for key,value of status
			hash[key] = value
		# @ ハッシュ文字列を作成
		tmp = []
		for key,value of hash
			if value?
				if value != ''
					tmp.push key+'='+value
				else
					tmp.push key
		hash = tmp.join('&')
		# @ ハッシュ文字列を適用
		location.hash = hash

)

