/**********************************************************
功能：导入时，文本的前端处理
**********************************************************/
__xform_impt_parser.label = {
		callback:function(data,context){
			var itemStr =  data.name;
			var items = [];
			if(itemStr.indexOf("\r\n")>-1){
				items = itemStr.split("\r\n");
			}else{
				items = itemStr.split("\n");
			}
			itemStr = items.join("\r\n");
			var initControlSetting  = function(control){
				control.options.values.content = itemStr;
				if(context.parent && context.parent.tagName=='TD'){
					var tdObj =  $(context.parent);
					if(data.align){
						tdObj.prop("align",data.align);
						tdObj.prop("style_textAlign",data.align);
						tdObj.css('text-align',data.align);
					}
					if(data.valign){
						tdObj.prop("valign",data.valign);
						tdObj.prop("style_verticalAlign",data.valign);
						tdObj.css('vertical-align',data.valign);
					}
				}
				if(data.italic){
					control.options.values.i = data.italic;
				}
				if(data.bold){
					control.options.values.b = data.bold;
				}
				if(data.underline){
					control.options.values.underline = data.underline;
				}
				if(data.color){
					control.options.values.color = data.color;
				}
				if(data.fontSize){
					control.options.values.size = data.fontSize; 
				}
			};
			if($.trim(itemStr)!=''){
				Designer.instance.builder.createControl('textLabel',context.parent,initControlSetting);
			}
		}
};