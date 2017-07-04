/**********************************************************
功能：导入时，时间控件的前端处理
**********************************************************/
__xform_impt_parser.datetime = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
			};
			Designer.instance.builder.createControl('datetime',context.parent,initControlSetting);
		}	
};