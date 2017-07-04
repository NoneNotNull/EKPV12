/**********************************************************
功能：导入时，审批记录的前端处理
**********************************************************/
__xform_impt_parser.auditShow = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
			};
			Designer.instance.builder.createControl('auditShow',context.parent,initControlSetting);
		}
};