// Generated by CoffeeScript 1.3.3

dojo.provide('app.Common');

dojo.declare('app.Common', [], {
  _countSubscribe: 0,
  _registerTempSubscribe: function(func) {
    var h;
    if (!(this.app != null)) {
      alert('@app is undefined');
      console.log(this);
    }
    this._countSubscribe++;
    console.log('Common->registerSubscribe:', '/temp/' + this.app + '/' + this._countSubscribe);
    return h = dojo.subscribe('/temp/' + this.app + '/' + this._countSubscribe, this, function(data) {
      dojo.unsubscribe(h);
      return func.apply(this, [data]);
    });
  },
  _getHashData: function(func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/Hash/getHash', ['/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _login: function(func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/login', ['/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _getUser: function(func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/getUser', ['/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _getTable: function(table, id, func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/getTable', [table, id, '/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _getTopicList: function(options, func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/getTopicList', [options, '/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _getCategoryList: function(func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/getCategoryList', ['/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _getPost: function(options, func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/getPost', [options, '/temp/' + this.app + '/' + this._countSubscribe]);
  },
  _setPostCheck: function(options, func) {
    this._registerTempSubscribe(func);
    return dojo.publish('app/DataManager/setPostCheck', [options, '/temp/' + this.app + '/' + this._countSubscribe]);
  }
});
