/**********************************************************
功能：导入时，地址本的前端处理
**********************************************************/
__xform_impt_parser.address = {
		callback:function(data,context){
			var initControlSetting = function(control){
				//初始化控件参数
			};
			Designer.instance.builder.createControl('address',context.parent,initControlSetting);
		}
};