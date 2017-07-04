define([ "dojo/_base/declare", "dojo/_base/lang", "dojo/dom-construct", 
         "dojo/dom-style", "dojo/dom-attr", "dojo/dom-geometry", "dojo/query"], 
		function(declare, lang, domConstruct, domStyle,  domAttr, domGeometry, query) {
	var Reminder = declare("mui.form.validate.Reminder", null, {
		//提示宿主dom对象
		element : null,
		
		//提示信息
		error : null,
		
		//提示信息中对应参数
		context:{},
		
		serialAttrName:'__validate_serial',
		
		_prifix:'reminder_',
		
		constructor:function(element, error, context){
			this.inherited(arguments);
			this.element = element;
			this.error = error;
			this.context = context;
			this.reminderId =  this._prifix + domAttr.get(this.element , this.serialAttrName);
		},
		
		show:function(){
			var minder = query("#" + this.reminderId);
			if(minder.length>0){
				this.renderDom = minder[0];
				this._reDrawErrorMsg();
			}else{
				this._buildRenderDom(this.reminderId);
			}
			//var box = domGeometry.position(this.element,true);
			domStyle.set(this.renderDom,{'display':'block'});
		},
		
		hide:function(){
			var minder = query("#" + this.reminderId);
			if(minder.length>0){
				this.renderDom = minder[0];
				domStyle.set(this.renderDom,{'display':'none'});
			}
		},
		
		_reDrawErrorMsg:function(){
			var errorMsgDoms = query("#" + this.reminderId +" .muiValidateMsg");
			if(errorMsgDoms.length>0){
				domConstruct.empty(errorMsgDoms[0]);
				errorMsgDoms[0].innerHTML = this._resolverError();
			}
		},
		
		_buildRenderDom: function(id){
			this.renderDom = domConstruct.create("div", {'className':'muiValidate','id':id}, this.element,'after');
			this.contentDom = domConstruct.create("div", {className:'muiValidateContent'}, this.renderDom);
			domConstruct.create("div", {'className':'muiValidateShape'}, this.contentDom);
			var infoDiv = domConstruct.create("div", {className:'muiValidateInfo'}, this.contentDom);
			domConstruct.create("span", {'className':'muiValidateIcon'}, infoDiv);
			domConstruct.create("span", {'className':'muiValidateMsg',innerHTML:this._resolverError()}, infoDiv);
		},
		
		_resolverError:function(){
			return this.error.replace(/\{([\w\.]*)\}/gi, lang.hitch(this,function (_var , _key) {
				var value = null;	
				if(this.context)
			         value = this.context[_key];  
			     return (value === null || value === undefined) ? "" : ("<span class='muiValidateTitle'>" + value + "</span>");  
			  }));
		}
	});
	return Reminder;
});