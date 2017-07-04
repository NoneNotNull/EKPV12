/**********************************************************
功能：导入时，富文本的前端处理
**********************************************************/
__xform_impt_parser.rtf = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
			};
			Designer.instance.builder.createControl('rtf',context.parent,initControlSetting);
		}
};
