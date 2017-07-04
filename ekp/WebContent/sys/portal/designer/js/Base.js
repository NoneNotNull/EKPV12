define(function(require, exports, module) {	 
	var $ = require("lui/jquery");
	var Class = require("lui/Class");
	var Evented = require('lui/Evented');
	var Designer = require('./Designer');
	var Base = new Class.create(Evented, {
		initialize : function(config) {
			this.config = config;
			this.body = config.body || $(document.body);		
			this.element = $(config.element);			
			this.key = this.element.attr("portal-key");
			this.children = [];
		},
		uuid : function (){
		    var i = 'xxxxxxxxxxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
		        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
		        return v.toString(16);
		    });
		    return "p_"+i;
		},
		addChild : function(obj){
			this.children.push(obj);
		},
		setParent : function(obj){
			this.parent = obj;
		},
		destroy : function(){
			for(var i=this.children.length-1;i>=0;i--){
				this.children[i].destroy();
			}
			this.off();
			this.element.remove();
			try{delete this;}catch(e){};
		},
		getDesigner : function(){
			var obj = this;
			while(obj){
				if(obj instanceof Designer){
					return obj;
				}else{
					obj = obj.parent;
				}
			}
		}
	});
	
	
	module.exports = Base;
});