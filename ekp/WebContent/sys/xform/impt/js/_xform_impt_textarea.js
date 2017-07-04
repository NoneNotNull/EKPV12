/**********************************************************
功能：导入时，多行输入框的前端处理
**********************************************************/
__xform_impt_parser.textarea = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
			};
			Designer.instance.builder.createControl('textarea',context.parent,initControlSetting);
		}
};