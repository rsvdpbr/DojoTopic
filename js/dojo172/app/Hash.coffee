
dojo.provide "app.Hash"

dojo.require "dojo.hash"

dojo.declare(
	"app.Hash"
	[]

	hash: null										# 最新のハッシュを格納。onHashChangeにて更新。
	constructor: ->
		@setSubscribe()
		if dojo.hash() == ''
			dojo.publish('app/Hash/changeHash', [mode:'top'])

	# APIをセットアップする
	setSubscribe: ->
		handles = []
		handles.push dojo.subscribe('/dojo/hashchange', @, @onHashChange)
		handles.push dojo.subscribe('app/Hash/changeHash', @, @changeHash)
		h = dojo.connect(@, 'uninitialize', @, ->
			dojo.disconnect(h)
			for handle in handles
				dojo.unsubscribe(handle)
		)

	# ハッシュ変更時にコールされ、メンバ変数hashを更新する
	onHashChange: ->
		@hash = {}
		for i in dojo.hash().split("&")
			if i.indexOf("=") != -1
				tmp = i.split('=')
				@hash[tmp[0]] = tmp[1]

	# ハッシュに変更を加える
	changeHash:(status)->
		# @ 既存のハッシュ文字列を配列化
		hash = {}
		for i in dojo.hash().split('&')
			if i.indexOf('=') != -1
				tmp =i.split('=')
				hash[tmp[0]] = tmp[1]
		# @ 既存ハッシュ文字列にマージ
		for key,value of status
			hash[key] = value
		# @ ハッシュ文字列を作成
		tmp = []
		for key,value of hash
			tmp.push key+'='+value
		hash = tmp.join('&')
		# @ ハッシュ文字列を適用
		location.hash = hash

)

