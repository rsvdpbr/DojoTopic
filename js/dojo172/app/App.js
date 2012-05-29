// Generated by CoffeeScript 1.3.3

dojo.provide('app.App');

dojo.require('app.Common');

dojo.require('app.Hash');

dojo.require('app.DataManager');

dojo.require('app.Menubar');

dojo.require('app.Div');

dojo.require('app.Top');

dojo.require('app.Sheet');

dojo.require('app.Bbs');

dojo.require('app.Data');

dojo.require('dijit.layout.BorderContainer');

dojo.require('dijit.layout.StackContainer');

dojo.require('dijit.layout.ContentPane');

dojo.declare('app.App', [app.Common], {
  app: 'app.App',
  YEAR: null,
  hash: null,
  data: null,
  components: [],
  layerCount: 0,
  constructor: function(YEAR) {
    this.inherited(arguments);
    this.YEAR = YEAR;
    this.hash = new app.Hash();
    this.setSubscribe();
    this.setLayout();
    return this.data = new app.DataManager();
  },
  afterLoginProcess: function() {
    return dojo.publish('app/Hash/addCallback', ['app/App/onHashChange']);
  },
  setLayout: function() {
    $('body').append('<div id="layer"></div>');
    $('body').append('<div id="layerAll"></div>');
    $('body').append('<div id="container"></div>');
    this.components.container = new dijit.layout.BorderContainer({
      design: 'headeline',
      style: 'width:100%;height:100%;padding:0;background:' + this.gBackground + ';'
    }, 'container');
    this.components.container.addChild(this.components.menubar = new app.Menubar({
      id: 'menubar',
      region: 'top',
      style: 'z-index:10;'
    }));
    this.components.container.addChild(this.components.contents = new dijit.layout.StackContainer({
      id: 'contents',
      region: 'center',
      style: 'padding:0;border:0;'
    }));
    this.components.innerContents = {};
    return this.components.container.startup();
  },
  setSubscribe: function() {
    var h, handles;
    handles = [];
    handles.push(dojo.subscribe('app/App/afterLoginProcess', this, this.afterLoginProcess));
    handles.push(dojo.subscribe('app/App/layerFadeOut', this, function() {
      this.layerCount--;
      if (this.layerCount === 0) {
        return $('#layer').fadeOut(250);
      }
    }));
    handles.push(dojo.subscribe('app/App/layerFadeIn', this, function() {
      this.layerCount++;
      return $('#layer').show();
    }));
    handles.push(dojo.subscribe('app/App/layerAllHide', this, function() {
      return $('#layerAll').hide();
    }));
    handles.push(dojo.subscribe('app/App/layerAllShow', this, function() {
      return $('#layerAll').show();
    }));
    handles.push(dojo.subscribe('app/App/onHashChange', this, this.onHashChange));
    return h = dojo.connect(this, 'uninitialize', this, function() {
      var handle, _i, _len, _results;
      dojo.disconnect(h);
      _results = [];
      for (_i = 0, _len = handles.length; _i < _len; _i++) {
        handle = handles[_i];
        _results.push(dojo.unsubscribe(handle));
      }
      return _results;
    });
  },
  onHashChange: function(hash) {
    var obj;
    dojo.publish('app/App/layerFadeIn');
    if (!(this.components.innerContents[hash.mode] != null)) {
      obj = {
        page: hash.mode,
        region: 'center',
        gBorder: 'border:1px #ccccdc solid;',
        gBackground: 'background:#fdfdfe;'
      };
      if (hash.mode === 'top') {
        this.components.innerContents[hash.mode] = new app.Top(obj);
      } else if (hash.mode === 'sheet') {
        this.components.innerContents[hash.mode] = new app.Sheet(obj);
      } else if (hash.mode === 'bbs') {
        this.components.innerContents[hash.mode] = new app.Bbs(obj);
      } else if (hash.mode === 'data') {
        this.components.innerContents[hash.mode] = new app.Data(obj);
      }
      this.components.contents.addChild(this.components.innerContents[hash.mode]);
    }
    this.components.contents.selectChild(this.components.innerContents[hash.mode]);
    this.components.innerContents[hash.mode].border.resize();
    return dojo.publish('app/App/layerFadeOut');
  }
});