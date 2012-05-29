// Generated by CoffeeScript 1.3.3

dojo.provide("app.Hash");

dojo.require("dojo.hash");

dojo.declare("app.Hash", [app.Common], {
  app: 'app.Hash',
  callback: [],
  hash: null,
  constructor: function() {
    this.inherited(arguments);
    this._getTableData('members', function(data) {
      return console.log(data);
    });
    if (dojo.hash() === '') {
      this.changeHash({
        mode: 'top'
      });
    }
    return this.setSubscribe();
  },
  setSubscribe: function() {
    var h, handles;
    handles = [];
    handles.push(dojo.subscribe('/dojo/hashchange', this, this.onHashChange));
    handles.push(dojo.subscribe('app/Hash/addCallback', this, this.addCallback));
    handles.push(dojo.subscribe('app/Hash/changeHash', this, this.changeHash));
    handles.push(dojo.subscribe('app/Hash/getHash', this, this.getHash));
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
  addCallback: function(str) {
    this.callback.push(str);
    this._updateHashVar();
    return dojo.publish(str, [this.hash]);
  },
  getHash: function(publish) {
    return dojo.publish(publish, [this.hash]);
  },
  onHashChange: function() {
    var i, _i, _len, _ref, _results;
    this._updateHashVar();
    _ref = this.callback;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(dojo.publish(i, [this.hash]));
    }
    return _results;
  },
  _updateHashVar: function() {
    var i, tmp, _i, _len, _ref, _results;
    this.hash = {};
    _ref = dojo.hash().split("&");
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      if (i.indexOf("=") !== -1) {
        tmp = i.split('=');
        _results.push(this.hash[tmp[0]] = tmp[1]);
      } else {
        _results.push(this.hash[i] = 'NO-VALUE');
      }
    }
    return _results;
  },
  changeHash: function(status) {
    var hash, i, key, tmp, value, _i, _len, _ref;
    hash = {};
    _ref = dojo.hash().split('&');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      if (i.indexOf('=') !== -1) {
        tmp = i.split('=');
        hash[tmp[0]] = tmp[1];
      } else {
        hash[i] = '';
      }
    }
    for (key in status) {
      value = status[key];
      hash[key] = value;
    }
    tmp = [];
    for (key in hash) {
      value = hash[key];
      if (value != null) {
        if (value !== '') {
          tmp.push(key + '=' + value);
        } else {
          tmp.push(key);
        }
      }
    }
    hash = tmp.join('&');
    return location.hash = hash;
  }
});
