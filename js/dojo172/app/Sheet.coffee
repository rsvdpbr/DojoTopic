
dojo.provide 'app.Sheet'

dojo.require 'dijit._Widget'
dojo.require 'dijit._Templated'

dojo.require 'dijit.layout.BorderContainer'
dojo.require 'dijit.layout.ContentPane'
dojo.require 'dijit.layout.AccordionContainer'

dojo.require 'dijit.Tree'
dojo.require 'dojo.data.ItemFileReadStore'
dojo.require 'dijit.tree.ForestStoreModel'

dojo.declare(
	'app.Sheet'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Sheet'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Sheet.html')
	data: {}											# 取得データオリジナル
	constructor: ->
		@inherited arguments
		console.log 'app.Sheet->Constructor'

	postCreate: ->
		@inherited arguments
		@createTree()
		body = """
左のメニューからデータを選択してください。<br />
表示される各データの右上のボタンから、以下の操作を行うことができます。<br />
　[hide] 一時非表示、表示<br />
　[bookmark] 個人ブックマークに追加・削除<br />
　[share] 共有ブックマークに追加・削除<br />
　[close] 非表示<br />
"""
		new app.Div(
			topic: '申請書確認'
			body: body
		).placeAt(@main.domNode)

	# ツリーを作成する
	createTree: ->
		# 役職情報を取得
		@_getTableData 'members', (data)->
			@data['members'] = data
		# 申請書区分を取得
		@_getTableData 'sheet_types', (data)->
			@data['sheet_types'] = data
			# 申請データを取得
			@_getTableData 'sheets', (data)->
				@data['sheets'] = data
				temp = {}
				# sheet_type_idでグループ化
				for key,i of dojo.clone(data)
					if !temp[i.sheet_type_id]?
						temp[i.sheet_type_id] = []
					temp[i.sheet_type_id].push i
				# フォーマット
				data = temp
				for key,list of data
					# 申請書データをリスト化
					sheet_list = []
					sheet_identifier_list = []
					for i in list
						if i.event_name.indexOf('デ') != -1
							i.event_name = '# '+i.event_name
						else
							i.event_name = '- '+i.event_name
						i.label = i.event_name
						i.type = 'sheet'
						sheet_list.push i
						sheet_identifier_list.push
							_reference: i.id
					# 規定の形に整形
					data[key] =
						identifier: 'id'
						label: 'label'
						items: sheet_list
					data[key].items.push
						id: 'summary'
						label: '全データ'
						type: 'top'
					data[key].items.push
						id: 'sheet_list'
						label: 'データ一覧 ('+sheet_identifier_list.length+')'
						type: 'top'
						children: sheet_identifier_list
					data[key].items.push
						id: 'bookmark'
						label: '個人ブックマーク'
						type: 'top'
						children: [
							{_reference:4}
						]
					data[key].items.push
						id: 'share'
						label: '共有ブックマーク'
						type: 'top'
						children: [
						]
					data[key].items.push
						id: 'comment'
						label: '未読コメント'
						type: 'top'
						children: [
						]
				# ツリーを作成
				for key,list of data
					h = new dijit.Tree(
						model: new dijit.tree.ForestStoreModel
							store: new dojo.data.ItemFileReadStore(data:list)
							query: {type:'top'}
						openOnClick: true
						showRoot: false
						title: @data['sheet_types'][key]['sheet_name']
						style: 'padding:0px;overflow-x:hidden;'
					).placeAt(@ac_menu)
					dojo.connect(h, 'onClick', @, (item)->
						@showSheet(item)
					)

	showSheet: (sheet)->
		# データ整理
		sheet = @data['sheets'][sheet['id'][0]]
		members = []
		for key,val of @data['members']
			if sheet.id == val.sheet_id
				members.push val
		# div追加関数
		addDiv = (key,value)->
			"""
				<div style='font-weight:bold;text-align:right;width:120px;float:left;padding-right:8px;'>
					#{key}：
				</div>
				<div style='float:left;'>#{value}</div>
				<div style='clear:both;'></div>
			"""
		# 水平線追加関数
		addHr = (h)->
			if h == undefined
				h = ''
				p = 3
				m = 0
			else
				h = '# '+h
				p = 0
				m = 8
			"""
				<div style='border-bottom:1px solid #aaa;padding-bottom:#{p}px;margin-bottom:3px;'>
					<p style='font-weight:bold;color:#137;margin:#{m}px 0 0 12px;'>
					#{h}
					</p>
				</div>
			"""
		# body要素作成（sheets）
		body = """
			<div style='float:right;'>申請日時：#{sheet.created}</div>
		"""
		body += addHr('企画概要')
		body += addDiv('企画名', sheet.event_name+'　('+sheet.event_name_kana+')')
		body += addDiv('企画詳細', sheet.event_description)
		body += addHr('団体概要')
		body += addDiv('団体名', sheet.group_name+'　('+sheet.group_name_kana+')')
		body += addDiv('団体活動内容', sheet.group_description)
		body += addDiv('団体構成人数', sheet.group_member_size)
		body += addDiv('団体活動場所', sheet.group_place)
		body += addDiv('団体活動曜日', sheet.group_day)
		body += addDiv('団体URL', sheet.group_url)
		# body要素作成（members）
		for i in members
			body += addHr(i.role)
			body += addDiv('氏名', i.name+'　('+i.name_kana+')')
			body += addDiv('学部学年', i.school+'学部 '+i.grade+'年')
			body += addDiv('学籍番号', i.student_id)
			body += addDiv('電話番号', i.telephone)
			body += addDiv('PCアドレス', i.mail_pc)
			body += addDiv('携帯アドレス', i.mail_keitai)
			if i.kennin != ''
				body += """
					<span style='color:#e57'>
				"""
				body += addDiv('役職兼任', i.kennin.split('_')[0])
				body += '</span>'
		# Div要素作成
		new app.Div(
			topic: sheet.event_name
			body: body
			sheetMenuEnable: true
		).placeAt(@main.domNode).startup()

)

