// Generated by CoffeeScript 1.3.3

dojo.provide('app.Register');

dojo.require("dijit._Widget");

dojo.require("dijit._Templated");

dojo.require("dijit.layout.BorderContainer");

dojo.require("dijit.layout.ContentPane");

dojo.require("dijit.layout.AccordionContainer");

dojo.declare('app.Register', [dijit._Widget, dijit._Templated, app.Common], {
  app: 'app.Register',
  widgetsInTemplate: true,
  templateString: dojo.cache('app', 'templates/Register.html'),
  constructor: function() {
    this.inherited(arguments);
    return console.log('app.Register->Constructor');
  },
  postCreate: function() {
    this.inherited(arguments);
    return console.log('app.Register->postCreate');
  }
});
