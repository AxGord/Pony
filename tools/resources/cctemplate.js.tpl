var app = require("app");
cc.Class({
  extends: cc.Component,
  onLoad: function () {
    this.main = new app.Main(this.node);
  },
  start: function() {
    this.main.start();
  },
  update: function (dt) {
    this.main.update(dt);
  }
});