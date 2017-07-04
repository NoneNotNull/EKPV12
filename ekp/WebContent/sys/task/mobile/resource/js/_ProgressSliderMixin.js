/**
 * 进度条组件mixin
 */
define([ "dojo/_base/declare","dojo/dom-construct","dojo/dom-style","dojo/dom-class","dojo/touch"],
		function(declare,domConstruct,domStyle,domClass,touch){
	
	return declare("sys.task.mobile._ProgressSliderMixin", null, {
		
		valueText:0,
		
		buildRendering:function(){
			this.inherited(arguments);
			if(!this.templateString){ // true if this widget is not templated
				this.valueTextNode = domConstruct.create("div", {className:'progressValueText'}, this.domNode, "last");
				
				this.valueTextInnerNode=domConstruct.create("div", {innerHTML:this.valueText+"%" ,className:'progressValueTextInner'}, this.valueTextNode);//显示百分比文本的节点
				domConstruct.create("div", {"class":"progressTriangle"}, this.valueTextNode);//向下箭头
				
				domStyle.set(this.domNode,"width","80%");
				if(this.valueText){
					this.set('value',this.valueText);
					var ___left=parseInt(this.valueText)+'%';
					domStyle.set(this.valueTextNode,{
						left:___left
					})
				}
			}
		},
		
		_setValueTextAttr:function(valueText){
			this.valueText=valueText;
			this.valueTextInnerNode.innerHTML=valueText+"%";
		},
		
		_setValueAttr:function(value){
			//滑动结束
			this.inherited(arguments);
			this.set("valueText",value);
			var ___left=parseInt(value)+'%';
			domStyle.set(this.valueTextNode,{
				left:___left
			})
		},
		
		show:function(){
			domStyle.set(this.domNode,"display","block");
		},
		
		hide:function(){
			domStyle.set(this.domNode,"display","none");
		},
		
		setDisabled:function(){
			this.disabled=true;
			this.disconnect(this.touchBox, touch.press);
			this.disconnect(this.handle, touch.press);
		}
		
	});
	
	
	
});