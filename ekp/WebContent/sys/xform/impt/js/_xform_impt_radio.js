/**********************************************************
功能：导入时，单选按钮的前端处理
**********************************************************/
__xform_impt_parser.radio = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
				var itemStr = data.items;
				var items = [];
				if(itemStr.indexOf("\r\n")>-1){
					items = itemStr.split("\r\n");
				}else{
					items = itemStr.split("\n");
				}
				control.options.values.items = items.join("\r\n");
				control.options.values.defaultValue = "";
			};
			Designer.instance.builder.createControl('inputRadio',context.parent,initControlSetting);
		}
};