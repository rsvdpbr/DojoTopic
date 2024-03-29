// Generated by CoffeeScript 1.3.3

dojo.provide('app.Data');

dojo.require('dijit._Widget');

dojo.require('dijit._Templated');

dojo.require('dijit.layout.BorderContainer');

dojo.require('dijit.layout.ContentPane');

dojo.require('dijit.layout.AccordionContainer');

dojo.declare('app.Data', [dijit._Widget, dijit._Templated, app.Common], {
  app: 'app.Data',
  widgetsInTemplate: true,
  templateString: dojo.cache('app', 'templates/Data.html'),
  data: {},
  constructor: function() {
    this.inherited(arguments);
    return console.log('app.Data->Constructor');
  },
  getData: function(table, func) {
    var h;
    if (this._countSubscribe != null) {
      this._countSubscribe = 0;
    }
    this._countSubscribe++;
    h = dojo.subscribe('app/Data/temp-' + this._countSubscribe, this, function(data) {
      dojo.unsubscribe(h);
      return func.apply(this, [data]);
    });
    return dojo.publish('app/DataManager/getData', [table, 'app/Data/temp-' + this._countSubscribe]);
  },
  postCreate: function() {
    return this.inherited(arguments);
  }
});
