define([ "dojo/_base/declare", "dojo/dom-construct", "mui/form/_FormBase",
		"dojo/dom-class", "dojo/_base/lang", "mui/util", "dojo/_base/window", "dijit/registry" ], function(declare,
		domConstruct, _FormBase, domClass, lang, util, win, registry) {
	var _field = declare("mui.form._InputBase", [ _FormBase ], {
		
		placeholder:'',

		buildRendering : function() {
			this.inherited(arguments);
			this._buildValue();
		},

		buildOptIcon : function(optContainer) {
			domConstruct.create("i", {
				className : 'mui mui-insert mui-rotate-45'
			}, optContainer);
		},

		_buildValue : function() {
			var setBuildName = 'build' + util.capitalize(this.showStatus);
			this[setBuildName] ? this[setBuildName]() : '';

			var setMethdName = this.showStatus + 'ValueSet';
			this.showStatusSet = this[setMethdName] ? this[setMethdName]
					: new Function();
		},

		_setValueAttr : function(value) {
			this.inherited(arguments);
			this.showStatusSet(value);
		},
		
		_onFocus:function(evt){
			var textNode = evt.target;
			var _self = this;
			var tmpEvt = this.connect(win.body(), "click", function(evts){
				if(evts.target != textNode){
					setTimeout(function(){
						textNode.blur();
						_self.set("value",textNode.value);
						_self.disconnect(tmpEvt);
					},10);
				}
			});
		}
	});
	return _field;
});