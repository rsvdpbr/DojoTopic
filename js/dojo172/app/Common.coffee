
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
	_getTableData: (table,func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getData', [table, '/temp/'+@app+'/'+@_countSubscribe])
	_getUserData: (func)->
		@_registerTempSubscribe(func)
		dojo.publish('app/DataManager/getUserData', ['/temp/'+@app+'/'+@_countSubscribe])

)
