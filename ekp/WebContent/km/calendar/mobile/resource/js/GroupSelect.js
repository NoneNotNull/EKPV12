define(['dojo/_base/declare','dijit/_WidgetBase','mui/form/_StoreFormMixin','dojox/mobile/Tooltip',
        'dojo/dom-construct','dojo/dom-class','dojo/dom-attr','dojo/query','mui/util'],
		function(declare,WidgetBase,_StoreFormMixin,Tooltip,domConstruct,domClass,domAttr,query,util){
	
	return declare('km.calendar.mobile.resource.js.GroupSelect',[WidgetBase,_StoreFormMixin],{
		
		prefix:'_GroupSelectItem_',
		
		openUrl:'',
		
		buildRendering : function() {
			this.inherited(arguments);
			domClass.add(this.domNode,'muiCalendarGroupSelect');
			this.textNode=domConstruct.create('span',{className:'muiCalenarGroupSelectText'},this.domNode);
			domConstruct.create('i',{className:'mui mui-down-n'},this.domNode)
			this.bindEvent();
		},
		
		generateList : function(items) {
			this.formatValues(items);
			this.set('value', this.value);
		},
		
		// 格式化数据
		formatValues : function(values) {
			this.values=values;
		},
		
		_setValueAttr:function(value){
			this.textNode.innerHTML=this.getTextByValue(value);
		},
		
		getTextByValue:function(value){
			var text = '';
			if (value == undefined)
				return text;
			for(var i=0;i<this.values.length;i++){
				if(value==this.values[i].id){
					text=this.values[i].name;
					break;
				}
			}
			return text;
		},
		
		bindEvent:function(){
			this.connect(this.domNode, 'touchend', 'toggleOpener');
		},
		
		toggleOpener:function(){
			var self=this;
			if(!this.opener){
				//构建opener
				this.opener = new Tooltip();
				domConstruct.place(this.opener.domNode,document.body, "last");
				domClass.add(this.opener.domNode, 'muiNavBarGroup muicalendarGroup');
				var cover = this.opener.containerNode;
				domConstruct.create('div', {className : 'muiCalendarGroupontainer muiNavBarGroupContainer'}, cover);
				//构建opener内容
				for(var i=0;i<this.values.length;i++){
					var _item=domConstruct.create('div',{
						className:'muiCalendarGroupItem muiNavBarGroupItem' 
					});
					if(this.values[i].id==this.value){
						domClass.add(_item,'selected');
					}
					this.connect(_item,'click',function(evt){
						var url=util.setUrlParameter(self.openUrl,'groupId',domAttr.get(evt.target,'groupId'));
						window.open(url,'_self');
					});
					
					domConstruct.create('div',{
						groupId:this.values[i].id,
						innerHTML:this.values[i].name,
						className:'muiNavBarGroupItemInner'
					},_item);
					
					domConstruct.place(_item,query('.muiCalendarGroupontainer',self.opener.containerNode)[0] ,"last");
				}
			}
			if (this.opener.resize) {
				this.opener.hide();
			}else {
				this.opener.show(this.domNode,['below']);
			}
			this.handle = this.connect(document.body, 'touchend', 'unClick');
			this.handle = this.connect(document.body, 'click', 'unClick');
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
				}, 1);
			this.disconnect(this.handle);
		}
		
		
		
		
	});
	
	
});