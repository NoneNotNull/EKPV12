define(["dojo/_base/declare", "dojo/dom-construct", "dijit/_WidgetBase" ,"dojo/dom-attr", "dojo/dom-style", "dojo/topic"], 
		function(declare, domConstruct, WidgetBase, domAttr, domStyle, topic) {
		var _field = declare("mui.form._FormBase", [WidgetBase], {
			//标题
			subject : null ,
			
			//变更事件
			onValueChange : null,
			
			//校验
			validate : null,
			
			//可编辑
			edit : true,
			
			//显示状态,前端只需处理noShow edit readOnly view状态
			showStatus:'edit',
			
			//值
			value : '',
			
			required : false ,
			
			baseClass : "muiField",
			
			opt : true,
	
			align : "left" ,
			
			EVENT_VALUE_CHANGED : "/mui/form/valueChanged" ,
			
			buildRendering : function() {
				this.inherited(arguments);
				this.edit = this.showStatus=='edit';
				this.innerHTML = this.domNode.innerHTML;
				this.fieldItem = domConstruct.create("div",{'className':'muiFieldItem ' + this.showStatus },this.domNode);
				if(this.subject){
					this.subjectNode = domAttr.set(this.domNode,'subject',this.subject);
				}
				this.valueNode = domConstruct.create("div",{'className':'muiFieldValue'},this.fieldItem);
				if(this.edit && this.required){
					this.requiredNode = domConstruct.create("div",{'className':'muiFieldRequired',innerHTML:'*'},this.fieldItem);
				}
				if(this.edit && this.opt){
					this.optNode = domConstruct.create("div" ,{className:'muiFieldOpt'},this.fieldItem);
					this.buildOptIcon(this.optNode);
				}
			},
			//加载
			startup : function() {
				this.inherited(arguments);
				domStyle.set(this.domNode,{'text-align':this.align});
			},
			
			buildOptIcon:function(optContainer){
				
			},
			
			_setValueAttr : function(val) {
				var oldValue = this.value || '';
				this._set("value", val);
				if (this.edit && oldValue != val) {
					topic.publish(this.EVENT_VALUE_CHANGED, this, {
						oldValue : oldValue,
						value : val
					});
					if (this.onValueChange) {
						var scriptFun = this.onValueChange+"(this.get('value'),this);";
						new Function(scriptFun).apply(this, [this]);
					}
				}
				if(this._started){
					if(this.validate!='' && this.edit && this.validateImmediate){
						if(this.validation)this.validation.validateElement(this);
					}
				}
			}
		});
		return _field;
});