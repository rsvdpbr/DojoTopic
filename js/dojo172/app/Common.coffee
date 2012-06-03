
dojo.provide 'app.Common'

dojo.declare(
	'app.Common'
	[]

	_countSubscribe: 0

	# 一時的にAPIを登録する
	_registerTempSubscribe: (func)->
		# 未定義エラー
		if !@app?
			alert '@app is undefined'
			console.log @
		# カウンタ設定
		@_countSubscribe++
		# 登録
		console.log 'Common->registerSubscribe:','/temp/'+@app+'/'+@_countSubscribe
		h = dojo.subscribe('/temp/'+@app+'/'+@_countSubscribe, @, (data)->
			dojo.unsubscribe(h)
			func.apply(@, [data])
		)

	# Hashクラスとの連携を行う
	_getHashData: (func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/Hash/getHash', ['/temp/'+@app+'/'+@_countSubscribe])

	# DataManagerクラスとの連携を行う
	_login: (func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/login', ['/temp/'+@app+'/'+@_countSubscribe])
	_getUser: (func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getUser', ['/temp/'+@app+'/'+@_countSubscribe])
	_getTable: (table, id, func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getTable', [table, id, '/temp/'+@app+'/'+@_countSubscribe])
	_getTopicList: (options, func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getTopicList', [options, '/temp/'+@app+'/'+@_countSubscribe])
	_getCategoryList: (func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getCategoryList', ['/temp/'+@app+'/'+@_countSubscribe])
	_getPost: (options, func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getPost', [options, '/temp/'+@app+'/'+@_countSubscribe])

)
# 循環参照
# デザインパターン
# PHPで学ぶデザインパターン（ウェブ上にある）