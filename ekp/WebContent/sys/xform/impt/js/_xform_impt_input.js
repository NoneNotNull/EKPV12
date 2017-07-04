/**********************************************************
功能：导入时，单行输入框的前端处理
**********************************************************/
__xform_impt_parser.input = {
	callback:function(data,context){
		var initControlSetting = function(control){
			//初始化控件参数
		};
		Designer.instance.builder.createControl('inputText',context.parent,initControlSetting);
	}
};