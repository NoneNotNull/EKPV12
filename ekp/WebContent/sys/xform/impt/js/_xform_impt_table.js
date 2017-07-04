/**********************************************************
功能：导入时，通用前端处理
**********************************************************/
__xform_impt_parser.table = {
		callback:function(data,context){
			var controls = data.controlers;
			var cols = data.cols;
			var tabControl = null;
			var initControlSetting = function(control){
				control.attrs.label.text = data.name;//未生效
				control.attrs.cell.value = cols;
				control.attrs.row.value = data.rows;
				control.attrs.cell.style = " ";//清空表格的样式
				tabControl = control;
			};
			Designer.instance.builder.createControl('standardTable',context.parent,initControlSetting); 
			//合并单元格处理
			for(var i=0;i<controls.length;i++){//控件行
				var tmpControls = controls[i];
				for ( var j = 0; j < tmpControls.length; j++) {//控件列
					if(tmpControls[j].rowSpan>1 || tmpControls[j].colSpan>1){
						var absX = j + tmpControls[j].colSpan - 1;
						var absY = tmpControls[j].ypos + tmpControls[j].rowSpan - 1;
						for(var k = tmpControls[j].ypos; k<=absY; k++){
							for(var m = j ; m<= absX ;m++){
								tabControl.selectedDomElement.push(tabControl.options.domElement.rows[k].cells[m]);
							}
						}
						tabControl.merge();
						tabControl.selectedDomElement=[];
					}
				}
			}
			//填充控件处理
			for(var i=0;i<controls.length;i++){
				var tmpControls = controls[i];
				for ( var j = 0; j < tmpControls.length; j++) {
					if(__xform_impt_parser[tmpControls[j].type].callback){
						__xform_impt_parser[tmpControls[j].type].callback(tmpControls[j],
							{parent:tabControl.options.domElement.rows[tmpControls[j].ypos].cells[j]});
					}else{
						if(window.console)
							window.console.error("无控件：" + tmpControls[j].type + "的支持.");
					}
				}
			}
		}
};
