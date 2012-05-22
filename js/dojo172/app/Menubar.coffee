
dojo.provide 'app.Manubar'

dojo.require 'app.MenubarButton'

dojo.require "dijit._Widget"
dojo.require "dijit._Templated"
dojo.require "dijit.Toolbar"


dojo.declare(
  'app.Menubar'
  [dijit._Widget, dijit._Templated]

  widgetsInTemplate: true
  templateString: dojo.cache('app', "templates/Menubar.html")

  constructor: ->
    @inherited arguments
    console.log 'テンプレートにボタン配置するよりも、スペースのみ配置して、postCreateで要素を生成するとかのほうがいいかも。'


)
