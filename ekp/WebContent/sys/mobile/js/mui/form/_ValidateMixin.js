define(["dojo/_base/declare", "dojo/_base/lang", "dojo/_base/array", "dojo/query", "dojo/on", "dojo/ready",
        "dojo/topic", "dojo/dom-geometry", "mui/form/_FormBase", "dijit/registry", 
        "mui/form/validate/Validation"], function(
		declare, lang, array, query, on, ready, topic, domGeometry, FormBase, registry, Validation) {
		return declare("mui.form._ValidateMixin",null,{
			
			validateImmediate: true,
			
			validateNext: true,
			
			//视图切换时校验
			performTransition: function(){
				if(this.validateNext){
					if(this.validate()){
						this.inherited(arguments);
						return true;
					}
					return false;
				}else{
					this.inherited(arguments);
					return true;
				}
			},
			
			buildRendering: function(){
				this.inherited(arguments);
				this._validation = new Validation();
			},
			
			startup:function(){
				this.inherited(arguments);
				if(this.validateImmediate){//等子组件都初始化完再注入
					var _self = this;
					if(!window.__validateInit){
						ready(function(){
							lang.extend(FormBase,{validateImmediate:true, validation:_self._validation});
							window.__validateInit = true;
						});
					}
				}
			},
			
			validate:function(elements){
				var elems = [];
				if(elements){
					elems = elems.concat(elements);
				}
				var extElems = this.getValidateElements();
				if(extElems){
					elems = elems.concat(extElems);
				}
				var result = true;
				var first = null;
				var errors=[];
				for ( var i = 0; i < elems.length; i++) {
					if (!this._validation.validateElement(elems[i])) {
						if(result){
							first = elems[i];
							result = false;
						}
						errors.push(elems[i]);
					}
				}
				if(first!=null){
					var scollDom = first;
					if(first instanceof FormBase){
						scollDom =  first.domNode;
					}
					var domOffsetTop=this._getDomOffsetTop(scollDom);
					if(domOffsetTop > 50 )
						topic.publish("/mui/list/toTop",this,{y: 0 - domOffsetTop + 50});
					else
						topic.publish("/mui/list/toTop",this,{y: 0 - domOffsetTop });
				}
				topic.publish("/mui/validate/afterValidate",this,errors);
				return result;
			},

			_getDomOffsetTop:function(node){
				 var offsetParent = node;
				 var nTp = 0;
				 while (offsetParent!=null && offsetParent!=document.body) { 
					 nTp += offsetParent.offsetTop; 
					 offsetParent = offsetParent.offsetParent; 
				 } 
				 return nTp;
			},
			
			getValidateElements : function(){
				var elems = [];
				if(this.domNode){
					array.forEach(query("[widgetid]",this.domNode),function(node){
						var w = registry.byNode(node);
						if((w instanceof FormBase) && w.edit==true){
							elems.push(w);
						}
					});
					array.forEach(query("[validate]",this.domNode),function(node){
							elems.push(node);
					});
				}
				return elems;
			}
			
	});
});