/**
 * 自定义TabBar,按屏幕尽可能显示多的按钮,显示不下的塞进更多操作栏
 */
define([
        "dojo/_base/declare",
        "dojox/mobile/TabBar",
        "dojo/query",
        "dojo/parser",
        "dojo/dom-class",
        "dojo/dom-style",
    	"dojo/dom-geometry",
    	"dojo/dom-construct",
    	"dojo/_base/array",
    	"dojox/mobile/Tooltip",
    	"dojo/text!../tmpl/more_button.html",
    	"mui/util"
	], function(declare, TabBar, query, parser, domClass,domStyle ,domGeometry, domConstruct, array, Tooltip,template,util) {
	
	return declare("sys.task.mobile", [TabBar], {
		
		fill:'overflow',
		
		template:template,
		
		resize: function(size){},
		
		//按宽度显示个数,多余的隐藏在下拉Tip中
		startup:function(){
			this.inherited(arguments);
			this.resizeByWidth();
			this.subscribe('/mui/list/afterScroll','hideOpener');
		},
		
		resizeByWidth: function() {
			var self=this;
			
			if(this.getChildren().length == 0) {
				domStyle.set(this.domNode,'margin','0');
				domStyle.set(this.domNode,'padding','0');
			}
			
			domClass.add(this.domNode, "muiTabBarGrid");
			domClass.add(this.domNode, "taskTabBar");
			
			var container=domGeometry.getContentBox(this.domNode),
				tmpWidth=0;
			array.forEach(this.getChildren(), function(child, i) {
				tmpWidth+=domGeometry.getMarginBox(child.domNode).w;
				if(tmpWidth > (container.w-50) ){
					//初始化更多按钮和Tooltip
					if( !this.opener ){
						//button构造
						parser.parse(domConstruct.create('div', {innerHTML: this.template},this.domNode))
							.then(function(widgetList){
								array.forEach(widgetList, function(widget, index) {
									self.aroundNode=domConstruct.place(widget.domNode,self.domNode, "last");
									self.aroundWidget=widget;
								});
							});
						//tip构造
						this.opener = new Tooltip();
						domConstruct.place(this.opener.domNode,document.body, "last");
						domClass.add(this.opener.domNode, 'muiNavBarGroup taskNavBarGroup');
						var cover = this.opener.containerNode;
						domConstruct.create('div', {className : 'muiNavBarGroupContainer'}, cover);
						//绑定弹出tip事件
						this.connect(this.aroundNode, "click", '_openerClick');
					}
					//this.aroundWidget.addChild(child);
					var _button = domConstruct.create("div", {
						'innerHTML' : child.label,
						'className':'mblTabBarButton overflowBarButton'
					});
					if(child.href){
						this.connect(_button,'click',function(){
							location.href=util.formatUrl(child.href);
						});
					}
					domConstruct.place(_button,query('.muiNavBarGroupContainer',self.opener.containerNode)[0] ,"last");
					
					child.destroy();
					
				}
			},this);
			
		},
		
		_openerClick:function(){
			var opener = this.opener;
			if (!opener)
				return;
			if (opener.resize) {
				opener.hide();
			}
			else {
				opener.show(this.aroundNode,['below']);
			}
			this.handle = this.connect(document.body, 'touchend', 'unClick');
		},
		
		hideOpener:function(){
			var opener = this.opener;
			if(opener && opener.resize){
				opener.hide();
			}
		},
		// 点击页面其他地方隐藏弹出层
		unClick : function(evt) {
			var target = evt.target, isHide = true;
			while (target) {
				if (target == this.domNode) {
					isHide = false;
					break;
				}
				target = target.parentNode;
			}
			if (isHide) 
				this.defer(function() {
					this.hideOpener();
				}, 400);
			this.disconnect(this.handle);
		}
		
		
		
		
		
	});
});