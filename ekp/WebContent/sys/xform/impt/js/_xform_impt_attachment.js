/**********************************************************
功能：导入时，附件的前端处理
**********************************************************/
__xform_impt_parser.attachment = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
			};
			Designer.instance.builder.createControl('attachment',context.parent,initControlSetting);
		}	
};