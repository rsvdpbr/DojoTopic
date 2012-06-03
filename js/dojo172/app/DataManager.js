// Generated by CoffeeScript 1.3.3

dojo.provide('app.DataManager');

dojo.require('app.LoginDialog');

dojo.require('app.RegisterDialog');

dojo.require('dojox.encoding.digests.MD5');

dojo.declare('app.DataManager', [app.Common], {
  app: 'app.DataManager',
  data: {
    func: {}
  },
  user: null,
  loginDlg: null,
  registerDlg: null,
  constructor: function() {
    this.inherited(arguments);
    console.log('app.DataManager->Constructor');
    this.setSubscribe();
    return dojo.publish('app/Hash/addCallback', ['app/DataManager/onHashChange']);
  },
  setSubscribe: function() {
    var h, handles;
    handles = [];
    handles.push(dojo.subscribe('app/DataManager/clearCache', this, this.clearCache));
    handles.push(dojo.subscribe('app/DataManager/getCategoryList', this, this.getCategoryList));
    handles.push(dojo.subscribe('app/DataManager/getTable', this, this.getTable));
    handles.push(dojo.subscribe('app/DataManager/getTopicList', this, this.getTopicList));
    handles.push(dojo.subscribe('app/DataManager/getPost', this, this.getPost));
    handles.push(dojo.subscribe('app/DataManager/onHashChange', this, this.onHashChange));
    handles.push(dojo.subscribe('app/DataManager/login', this, this.login));
    handles.push(dojo.subscribe('app/DataManager/getUser', this, this.getUser));
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
  clearCache: function(type, hash) {
    if (type === 'all') {
      return this.data = {
        func: {}
      };
    } else if (this.data.func[type] != null) {
      if ((hash != null) && (this.data.func[type][hash] != null)) {
        return this.data.func[type] = {};
      } else {
        return this.data.func[type][hash] = {};
      }
    } else if (this.data[type] != null) {
      return this.data[type] = {};
    }
  },
  saveTable: function(table, data) {
    var key, temp, val, _ref;
    temp = {};
    _ref = dojo.clone(data);
    for (key in _ref) {
      val = _ref[key];
      temp[val.id] = val;
    }
    if (this.data[table] != null) {
      return this.data[table] = $.extend(this.data[table], temp);
    } else {
      return this.data[table] = temp;
    }
  },
  getTable: function(table, id, publish) {
    console.log('getTable', table);
    if (this.data[table] != null) {
      if (id != null) {
        return dojo.publish(publish, [this.data[table][id]]);
      } else {
        return dojo.publish(publish, [this.data[table]]);
      }
    } else {
      return dojo.publish(publish, [null]);
    }
  },
  onHashChange: function(hash) {
    if (hash.register != null) {
      return this.register();
    }
  },
  getUser: function(publish) {
    if (this.user != null) {
      return dojo.publish(publish, [dojo.clone(this.user)]);
    } else {
      return dojo.publish(publish, [null]);
    }
  },
  login: function(publish) {
    if (this.user != null) {
      return dojo.publish(publish, [dojo.clone(this.user)]);
    }
    return this._getHashData(function(data) {
      if (data.nologin != null) {
        return dojo.publish(publish, [true]);
      }
      if (!(this.loginDlg != null)) {
        this.loginDlg = new app.LoginDialog();
        dojo.connect(this.loginDlg, 'onExecute', this, function() {
          this.user = this.loginDlg.getData();
          dojo.publish('app/Menubar/setUser', [dojo.clone(this.user)]);
          dojo.publish('app/Hash/changeHash', [
            {
              user: this.user.username
            }
          ]);
          return dojo.publish(publish, [this.user]);
        });
        dojo.connect(this.loginDlg, 'onCancel', this, function() {
          dojo.publish('app/Hash/changeHash', [
            {
              mode: 'topic'
            }
          ]);
          return dojo.publish(publish, [null]);
        });
      }
      return this.loginDlg.show();
    });
  },
  register: function() {
    if (!(this.registerDlg != null)) {
      this.registerDlg = new app.RegisterDialog();
    }
    return this.registerDlg.show();
  },
  getCategoryList: function(publish) {
    var that;
    dojo.publish('app/App/layerFadeIn');
    that = this;
    return dojo.xhrPost({
      url: 'php/access.php',
      handleAs: 'json',
      content: {
        "class": 'topic',
        method: 'getCategoryList'
      },
      load: function(data) {
        console.log('SENDED CATEGORY DATA:', data);
        that.saveTable('category', data);
        dojo.publish(publish, [data]);
        return dojo.publish('app/App/layerFadeOut');
      },
      error: function(error) {
        console.log('app.DataManager->getCategoryList [error]', error);
        return dojo.publish('app/App/layerFadeOut');
      }
    });
  },
  getTopicList: function(options, publish) {
    var that;
    dojo.publish('app/App/layerFadeIn');
    that = this;
    return dojo.xhrPost({
      url: 'php/access.php',
      handleAs: 'json',
      content: {
        "class": 'topic',
        method: 'getTopicList',
        value: dojo.toJson(options)
      },
      load: function(data) {
        console.log('SENDED TOPIC DATA:', data);
        that.saveTable('topic', data);
        dojo.publish(publish, [data]);
        return dojo.publish('app/App/layerFadeOut');
      },
      error: function(error) {
        console.log('app.DataManager->getTopicList [error] ', error);
        return dojo.publish('app/App/layerFadeOut');
      }
    });
  },
  getPost: function(options, publish) {
    var hashkey, that;
    hashkey = dojox.encoding.digests.MD5(dojo.toJson(options));
    if (!(this.data.func['getPost'] != null)) {
      this.data.func['getPost'] = {};
    } else {
      if (this.data.func['getPost'][hashkey] != null) {
        console.log('RETURN CACHE DATA ABOUT POST');
        return dojo.publish(publish, [this.data.func['getPost'][hashkey]]);
      }
    }
    dojo.publish('app/App/layerFadeIn');
    that = this;
    return dojo.xhrPost({
      url: 'php/access.php',
      handleAs: 'json',
      content: {
        "class": 'topic',
        method: 'getPost',
        value: dojo.toJson(options)
      },
      load: function(data) {
        console.log('SENDED POST DATA:', data);
        that.saveTable('post', data);
        that.data.func['getPost'][hashkey] = data;
        dojo.publish(publish, [data]);
        return dojo.publish('app/App/layerFadeOut');
      },
      error: function(error) {
        console.log('app.DataManager->getPost [error] ', error);
        return dojo.publish('app/App/layerFadeOut');
      }
    });
  }
});
