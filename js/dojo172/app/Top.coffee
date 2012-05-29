
dojo.provide 'app.Top'

dojo.require "dijit._Widget"
dojo.require "dijit._Templated"
dojo.require "dijit.layout.BorderContainer"
dojo.require "dijit.layout.ContentPane"
dojo.require "dijit.layout.AccordionContainer"
# dojo.require "dijit."


dojo.declare(
	'app.Top'
	[dijit._Widget, dijit._Templated, app.Common]

	app: 'app.Top'
	widgetsInTemplate: true
	templateString: dojo.cache('app', 'templates/Top.html')
	constructor: ->
		@inherited arguments
		console.log 'app.Top->Constructor'

	postCreate: ->
		console.log 'app.Top->postCreate'
		new app.Div(
			topic: 'Sankadantai.com For Administrator'
			body: """
				<div style='margin-bottom:12px;'>
					参加団体募集ウェブフォームの非標準の管理ページです。<br />
					標準の管理ページは、<a href=''>こちら</a>からアクセスしてください。<br />
				</div>
				<div style='margin-bottom:12px;'>
					標準管理ページとの棲み分けとしては、<br />
					標準ページは、最小限の機能だけを持たせ、主な機能をデータのダウンロードと設定の変更と位置づけているのに対して<br />
					非標準ページでは、ウェブ上でデータの管理を行うことに焦点をあてています。<br />
					つまり、データ管理だけに集中させることで、エクセルでは実現できない機能を作ってみようっていうことです。<br />
				</div>
				<div style='margin-bottom:12px;'>
					「何故非標準なのか？」ということに関しては、この機能を実際に完成・運用させるまで、本当に有用なのか必要なのかが判断できないため、とりあえず非標準としました。<br />
					設計的に次年度以降も運用することを考慮していないので、もし作ってみて良い感じだったら、次年度以降も対応できるように改良を加える予定です。
				</div>
				<div>
					とりあえず、少しだけ使ってみてから、エクセルで共有するorこのアプリを使う、どちらがやりやすいか考えてみてください。<br />
					別に、せっかく作ったんだから、とか考えなくても大丈夫だよん
				</div>
			"""
		).placeAt(@main.domNode)


)
