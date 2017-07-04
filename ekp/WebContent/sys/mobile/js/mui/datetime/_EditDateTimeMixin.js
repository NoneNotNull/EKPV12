define([ "dojo/_base/declare", "dojo/html", "dojo/dom-construct",
		"dojo/dom-class", "dijit/registry", "dojo/query", "dojo/_base/array",
		"mui/dialog/Dialog", "dojo/dom-style" ], function(declare, html,
		domConstruct, domClass, registry, query, array, Dialog, domStyle) {
	var claz = declare("mui.datetime._EditDateTimeMixin", null, {

		// 编辑模式
		edit : true,

		// 时间类型 date,time,datetime
		type : '',

		tmpl : null,

		mixinId : null,

		title : '',

		value : '',
		
		//内容额外样式
		_contentExtendClass : null,

		// 显示弹出框类名
		showClass : 'muiDateTimeShow',

		getMixinIds : function() {
			if (this.mixinIds)
				return this.mixinIds;
			if(this.type=='date' || this.type=='time'){
				this.mixinIds = ['_' + this.type + '_' + 'picker'];
			}else{
				this.mixinIds = ['_date_picker', '_time_picker'];
			}
			return this.mixinIds;
		},

		setDateTimeValue : function(value) {
			var ids = this.getMixinIds();
			if(ids.length>0){
				if(ids.length==1){
					registry.byId(ids[0]).set('value', value);
				}else{
					var vals = this.splitValue();
					for(var i=0;i<ids.length;i++){
						registry.byId(ids[i]).set('value', vals[i]);
					}
				}
			}
		},
		
		bindSwitch:function(){
			var choices = query('.muiDateTimeDialogContent .muiDateTimeChoices > div', this.dialog);
			var _self = this;
			array.forEach(choices,function(tmpDom){
				_self.connect(tmpDom,'click',function(evt){
					_self._dateTimeSwitch(choices , evt);
				});
			});
		},
		
		_dateTimeSwitch:function(choices , evt){
			var thisDom = evt.target || evt.srcElement;
			if(domClass.contains(thisDom,"checked")){
				return;
			}
			array.forEach(choices,function(tmpDom){
				domClass.toggle(tmpDom, "checked");
			});
			var idx = array.indexOf(choices,thisDom);
			if(idx>-1){
				array.forEach(query('.muiDateTimeArea>div',this.dialog),function(trDom,index){
					if(idx==index){
						domStyle.set(trDom,{'z-index':'2','opacity':'1'});
					}else{
						domStyle.set(trDom,{'z-index':'1','opacity':'0'});
					}
				});
			}
		},
		
		getDateTimeValue : function() {
			var ids = this.getMixinIds();
			var rtnStr = '';
			if(ids.length>0){
				if(ids.length==1){
					rtnStr = registry.byId(ids[0]).get('value');
				}else{
					var vals = [];
					for(var i=0;i<ids.length;i++){
						vals.push(registry.byId(ids[i]).get('value'));
					}
					rtnStr = vals.join(' ');
				}
			}
			return rtnStr;
		},

		getDialogDiv : function() {
			var nodeList = query('.muiDateTimeDialogContent', this.dialog);
			return nodeList.length > 0 ? nodeList[0] : null;
		},

		// 弹出时间选择框
		openDateTime : function(evt) {
			if (this.dialog)
				return;
			this.dialog = domConstruct.create("div", {
				className : 'muiDateTimeDialog ' + this.showClass
			});
			this.dialogContentDiv = domConstruct.create("div", {
					className : 'muiDateTimeDialogContent' + (this._contentExtendClass? " "+ this._contentExtendClass:"")
				}, this.dialog);
			var vals= this.splitValue();
			this.dialogContentDiv.innerHTML = this.tmpl.replace('!{dateValue}',
							vals[0]).replace('!{timeValue}',vals[1]);
			var self = this;
			Dialog.element({
				'title' : this.title,
				'element' : this.dialog,
				'scrollable' : false,
				'parseable': true,
				'buttons' : [ {
					title : '取消',
					fn : function(dialog) {
						dialog.hide();
					}
				} ,{
					title : '确定',
					fn : function(dialog) {
						var value = self.getDateTimeValue();
						self.set('value', value);
						dialog.hide();
					}
				} ],
				'callback': function(dialog) {
					self.destroyDialog();
				},
				'onDrawed':function(dialog){
					self.bindSwitch();
				}
			});
		},
		
		splitValue : function() {
			var arr = [ '', '' ];
			if(this.value==null || this.value==''){
				return arr;
			}
			if(this.type=="date"){
				arr[0] = this.value;
			}else if(this.type=="time"){
				arr[1] = this.value;
			}else{
				arr = this.value.split(' ');
			}
			if (arr.length < 2)
				arr = [ '', '' ];
			return arr;
		},

		// 销毁弹出框对象
		destroyDialog : function() {
			if (this.dialog) {
				domConstruct.destroy(this.dialog);
				this.dialog = null;
			}
		},

		editValueSet : function(value) {
			if (this.valueDom)
				this.valueDom.value = value;
			this.textNode.innerHTML = value;
		},

		hiddenValueSet : function(value) {
			// this.editValueSet(value);
		},

		viewValueSet : function(value) {
			this.textNode.innerHTML = value;
		},

		readOnlyValueSet : function(value) {
			this.editValueSet(value);
		},

		buildRendering : function() {
			this.inherited(arguments);
			this.textNode = domConstruct.create('div', {
				className : 'muiFormDatetimeText'
			}, this.inputContent);
		},

		buildEdit : function() {
			this.inherited(arguments);
			this.valueDom = domConstruct.create('input', {
				readonly : 'readonly',
				name : this.valueField,
				style : 'display:none'
			}, this.inputContent, 'first');
			if (this.domNode)
				this.connect(this.domNode, 'click', 'openDateTime');
		},

		buildReadOnly : function() {
			this.valueDom = domConstruct.create('input', {
				readonly : 'readonly',
				name : this.valueField,
				style : 'display:none'
			}, this.inputContent, 'first');
		},

		buildView : function() {
			//this.buildReadOnly();无需构建表单元素input
		},

		buildHidden : function() {
			this.buildReadOnly();
			domStyle.set(this.domNode, {
				display : 'none'
			});
		},
		
		_getNameAttr:function(){
			return this._get('valueField');
		}

	});
	return claz;
});