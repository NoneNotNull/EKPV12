define([ "dojo/_base/declare", "dojo/_base/array", "dojo/dom-construct",
		"dojo/_base/lang" ], function(declare, array, domConstruct, lang) {

	return declare("mui.form.editor.plugins.EditorPluginMixin", null, {

		plugins : [ 'face', 'image' ],

		holdTime : 250,

		lastTime : null,

		fireClick : function(evt) {
			if (!this.lastTime) {
				this.lastTime = new Date().getTime();
				return true;
			}
			var time = this.lastTime;
			this.lastTime = new Date().getTime()
			if (time && this.lastTime - time <= this.holdTime)
				return false;
			return true;
		},

		formatPlugin : function() {
			this.plugins = array.map(this.plugins, function(plugin) {
				var url = plugin;
				if (plugin.indexOf('/') < 0)
					url = 'mui/form/editor/plugins/' + plugin + '/Plugin';
				return url;
			}, this);
		},

		buildEdit : function() {
			this.inherited(arguments);
			this.formatPlugin();
			this.editorDeferred.then(lang.hitch(this, function() {
				var self = this;
				require(this.plugins, function() {
					array.forEach(arguments, function(Item) {
						var plugin = new Item({
							editor : this
						});
						var item = domConstruct.create('a', {
							className : plugin.icon + ' mui',
							href : 'javascript:;'
						}, this.pluginNode);
						if (plugin.event)
							this.connect(item, 'click', function(evt) {
								if (!this.fireClick(evt))
									return;
								this.defer(function() {
									this.__textNode.blur();
									plugin.event.call(plugin, evt)
								}, 1);
							});
						plugin.startup();
					}, self);
				});
			}));
		}
	});
});