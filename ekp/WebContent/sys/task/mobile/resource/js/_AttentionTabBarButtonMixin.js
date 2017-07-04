/**
 * 关注任务按钮组件
 */
define(	["dojo/_base/declare", "dojo/_base/lang", "dojo/request", "mui/util",
				"dojo/dom-class", "mui/dialog/Tip"], function(declare, lang,
				req, util, domClass, Tip) {

			return declare("sys.task.mixin._AttentionTabBarButtonMixin", null, {
				// 关注
				attentionUrl : '/sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&forward=lui-source',
				// 取消关乎
				disAttentionUrl : '/sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&isAttention=true&forward=lui-source',

				hasAttention : false,

				fdId : null,

				scaleClass : 'muiAttentionMaskScale',

				attentionClass : 'mui-focus-on',

				disAttentionClass : 'mui-focus-off',

				buildRendering : function() {
					this.inherited(arguments);
				},

				startup : function() {
					if (this._started)
						return;
					this.inherited(arguments);
					this.toggleAttention(this.hasAttention);
				},

				replaceClass : function(flag) {
					var i1 = this["iconNode" + 1], i2 = this["iconNode" + 2];
					var class1 = flag ? this.attentionClass : this.disAttentionClass, class2 = flag
							? this.disAttentionClass 
							: this.attentionClass;
					domClass.replace(i1, class1 + ' ' + this.scaleClass, class2
									+ ' ' + this.scaleClass);
					domClass.replace(i2, class1 + ' ' + this.scaleClass, class2
									+ ' ' + this.scaleClass);
				}, 

				removeScaleClass : function() {
					var i1 = this["iconNode" + 1], i2 = this["iconNode" + 2];
					this.defer(lang.hitch(this, function() {
										domClass.remove(i1, this.scaleClass);
										domClass.remove(i2, this.scaleClass);
									}), 300);
				},

				toggleAttention : function(hasAttention) {
					
					this.replaceClass(hasAttention);
					this.removeScaleClass();
					this.set('hasAttention', hasAttention);
					this.set('lock', false);
				},

				rq : function(url, data, handleAs, callback) {
					req(util.formatUrl(url), {
								handleAs : handleAs,
								method : 'post',
								data : data
							}).then(lang.hitch(this, callback));
				},

				// 切换关注
				onClick : function(evt) {
					if (this.lock)
						return false;

					this.set('lock', true);
					if (!this.hasAttention)
						this.rq(this.attentionUrl, {
								fdTaskId : this.fdId,
								}, 'json', function(data) {
									this.toggleAttention(true);
									Tip.tip({
												icon : 'mui '
														+ this.attentionClass,
												text : '加入关注'
											});

								});
					else
						this.rq(this.disAttentionUrl, {
								fdTaskId : this.fdId
								}, 'json', function(data) {
									this.toggleAttention(false);
									Tip.tip({
												icon : 'mui '
														+ this.disAttentionClass,
												text : '取消关注'
											});
								});
					return false;
				}
		});
});