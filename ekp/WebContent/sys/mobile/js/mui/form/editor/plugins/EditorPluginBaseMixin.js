define(
		[ "dojo/_base/declare", "dijit/_WidgetBase", "dojo/dom-style",
				"dojo/topic", "dojo/dom-class" ],
		function(declare, WidgetBase, domStyle, topic, domClass) {

			return declare(
					"mui.form.editor.plugins.EditorPluginBaseMixin",
					[ WidgetBase ],
					{
						EVENT_PLUGIN_CLICK : '/mui/editor/plugin/click',
						selectedClass : 'muiEditorPluginSelected',

						constructor : function() {
							this.subscribe(this.EVENT_PLUGIN_CLICK, '_unclick');
							this._isShow = false;
						},

						show : function() {
							topic.publish(this.EVENT_PLUGIN_CLICK, this, {
								target : this.iconNode
							});
							domClass.add(this.iconNode, this.selectedClass);
						},

						hide : function() {
							domClass.remove(this.iconNode, this.selectedClass);
							this._isShow = false;
						},

						_unclick : function(obj, evt) {
							if (!evt)
								return;
							var target = evt.target;
							if (!this.iconNode || target == this.iconNode)
								return;
							this.hide();
						},

						/*******************************************************
						 * 重复点击控制
						 ******************************************************/
						_faceHoldTime : 250,

						_faceLastTime : null,

						_faceFireClick : function(evt) {
							var time = this._faceLastTime;
							this._faceLastTime = new Date().getTime()
							if (time
									&& this._faceLastTime - time <= this._faceHoldTime)
								return false;
							return true;
						}
					});
		});