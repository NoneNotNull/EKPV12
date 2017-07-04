/**********************************************************
功能：导入时，明细表的前端处理
**********************************************************/
__xform_impt_parser.detailTable = {
		callback:function(data,context){
			var detailControl = null;
			var initControlSetting = function(control){
				//初始化控件参数
				control.attrs.cell.value = data.header.length + 2;
				detailControl =  control;
			};
			Designer.instance.builder.createControl('detailsTable',context.parent,initControlSetting);
			var detailTable = detailControl.options.domElement;
			for ( var i = 0; i < data.header.length; i++) {
				var tmpHeader = data.header[i];
				var tdContainer = detailTable.rows[0].cells[i + 1];
				if(__xform_impt_parser[tmpHeader.type].callback){
					__xform_impt_parser[tmpHeader.type].callback(tmpHeader,{parent:tdContainer});
				}else{
					if(window.console)
						window.console.error("无控件：" + tmpHeader.type + "的支持");
				}
			}
			for ( var i = 0; i < data.controls.length; i++) {
				var tmpControl = data.controls[i];
				var tdContainer = detailTable.rows[1].cells[i + 1];
				if(__xform_impt_parser[tmpControl.type].callback){
					__xform_impt_parser[tmpControl.type].callback(tmpControl,{parent:tdContainer});
				}else{
					if(window.console)
						window.console.error("无控件：" + tmpControl.type + "的支持");
				}
			}
		}	
};