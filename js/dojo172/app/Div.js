// Generated by CoffeeScript 1.3.3

dojo.provide('app.Div');

dojo.require('dijit._Widget');

dojo.require('dijit._Templated');

dojo.declare('app.Div', [dijit._Widget, dijit._Templated], {
  widgetsInTemplate: true,
  templateString: dojo.cache('app', 'templates/Div.html'),
  body: '',
  style: 'display:none;',
  constructor: function() {
    return this.inherited(arguments);
  },
  postCreate: function() {
    var _this = this;
    this.inherited(arguments);
    if (this.toggle) {
      $(this.btToggle).bind('click', function() {
        if ($(_this.divBody).css('display') === 'none') {
          $(_this.divBody).slideDown(250);
          return $(_this.btToggle).text('[hide]');
        } else {
          $(_this.divBody).slideUp(250);
          return $(_this.btToggle).text('[show]');
        }
      });
    } else {
      $(this.btToggle).remove();
    }
    if (this.close) {
      $(this.btClose).bind('click', function() {
        return $(_this.top).slideUp(300, function() {
          return _this.destroyRendering();
        });
      });
    } else {
      $(this.btClose).remove();
    }
    if (this.body === '') {
      return $(this.divBody).remove();
    }
  },
  startup: function() {
    this.inherited(arguments);
    return $(this.top).fadeIn(200);
  }
});
