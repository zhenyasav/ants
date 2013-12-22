// Generated by CoffeeScript 1.6.3
this.Visual = (function() {
  Visual.prototype._idctr = 0;

  Visual.prototype.newid = function() {
    return (this._idctr++).toString();
  };

  Visual.prototype.generators = function() {};

  Visual.prototype.visuals = function() {};

  Visual.prototype.initialize = function() {};

  function Visual(o) {
    var _ref, _ref1, _ref2;
    this.objects = {};
    this.addqueue = [];
    this.remqueue = [];
    _.extend(this, o);
    if (this.root == null) {
      this.root = new THREE.Object3D();
    }
    this.root.position.set((_ref = this.x) != null ? _ref : 0, (_ref1 = this.y) != null ? _ref1 : 0, (_ref2 = this.z) != null ? _ref2 : 0);
    this.initialize();
  }

  Visual.prototype.update = function(t) {
    var k, n, r, v, _ref, _results;
    while (n = this.addqueue.shift()) {
      this.addVisual(n[0], n[1]);
    }
    while (r = this.remqueue.shift()) {
      this.removeVisual(r);
    }
    _ref = this.visuals;
    _results = [];
    for (k in _ref) {
      v = _ref[k];
      if (v instanceof Visual) {
        _results.push(v != null ? typeof v.update === "function" ? v.update(t) : void 0 : void 0);
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Visual.prototype.addVisual = function(k, v) {
    this.visuals[k] = v;
    if (v != null) {
      v.scene = this.scene;
    }
    return v != null ? typeof v.render === "function" ? v.render() : void 0 : void 0;
  };

  Visual.prototype.removeVisual = function(k) {
    if (k in this.visuals) {
      this.scene.remove(this.visuals[k].root);
      return delete this.visuals[k];
    }
  };

  Visual.prototype.render = function() {
    var k, v, _ref, _ref1, _results;
    if (this.scene) {
      _ref = this.generators();
      for (k in _ref) {
        v = _ref[k];
        this.root.add(this.objects[k] = v.call(this));
      }
      this.scene.add(this.root);
      _ref1 = this.visuals();
      _results = [];
      for (k in _ref1) {
        v = _ref1[k];
        if (typeof v === 'function') {
          v = v.call(this);
        }
        _results.push(this.addVisual(k, v));
      }
      return _results;
    }
  };

  return Visual;

})();
