define(['dojo/_base/declare',
        'dojo/topic',
        'dojo/_base/lang',
        "mui/i18n/i18n!sys-mobile",
        "mui/list/item/_TemplateItemMixin",
        'dojo/text!./item/NoDataTempl.html',
        'dojo/dom-style'
        ], function(declare, topic , lang , Msg ,TemplateItem, tmpl, domStyle) {

		return declare("mui.list._ListNoDataMixin", null, {
			startup : function() {
				if (this._started) {
					return;
				}
				this.inherited(arguments);
				this.subscribe("/mui/list/loaded",lang.hitch(this,function(evts){
						if(evts!=null && evts==this){
							this.buildNoDataItem(evts);
						}
					}));
			},
			
			buildNoDataItem:function(widget){
				if(this.tempItem){
					if(widget.removeChild)
						widget.removeChild(this.tempItem);
					this.tempItem.destroy();
					this.tempItem = null;
				}
				if(widget.totalSize==0){
					this.tempItem = new TemplateItem({
						templateString : tmpl,
						baseClass:"muiListNoData",
						icon:"mui mui-message",
						text:Msg['mui.list.msg.noData']
					});
					if(widget.addChild)
						widget.addChild(this.tempItem);
					widget.append = false;
					// 发布无数据事件
					topic.publish('/mui/list/noData',this);
					var parent = this.getParent();
					if (!parent)
						return;
					var h = parent.domNode.offsetHeight - this.domNode.offsetTop;
					if(!domStyle.get(this.tempItem.domNode,'line-height'))
						domStyle.set(this.tempItem.domNode, {
									'height' : h + 'px',
									'line-height' : h + 'px'
								});
				}
			}
		});
});