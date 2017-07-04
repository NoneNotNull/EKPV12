
/**
 * 弹出选择文件对话框
 */
function form_impt_import() {
	var event = Com_GetEventObject();
	var div = $("#div_upload_frame" );
	var x = $(document.body).width()/2;
	var iframe= null;
	if(div.length<=0){
		div = $("<div id='div_upload_frame' class='form_impt_div'></div>");
		
		$("<div class='form_impt_tilte'>excel导入</div>").appendTo(div);
		
		$("<div class='form_impt_close' title='关闭'></div>").click(function(){
			form_impt_close();
		}).appendTo(div);
		
		iframe = $("<iframe style='width:100%' height='100%' scrolling='no' frameBorder='0'></iframe>");
		iframe.appendTo(div);
		
		$("<div class='form_impt_help' title='帮助'>?</div>").click(function(){
			window.open(Com_Parameter.ContextPath+'sys/xform/impt/help.jsp','_blank');
		}).appendTo(div);
		
		div.appendTo($(document.body));
		Designer.addEvent(window , 'scroll' , function() {
			div.css({"top":(document.body.scrollTop + 100)+"px"});
		});
	}else{
		iframe = div.find("iframe");
	}
	iframe.attr("src",Com_Parameter.ContextPath + "sys/xform/impt/upload.jsp?callback=form_impt_callback&seq="+Math.random());
	div.css({"top":(document.body.scrollTop + 100)+"px","left":(x-250)+"px"});
	div.show();
}

function form_impt_close(){
	$("#div_upload_frame").hide();
}

function form_impt_callback(data,optType){
	form_impt_close();
	if(data){
		if(data.success){
			if(window && window.Designer){
				var designer = window.Designer;
				var domEle = null;
				if(designer && designer.instance){
					if(optType=='0'){//追加
						domEle = designer.instance.builderDomElement;
					}else if(optType=='1'){//替换
						designer.instance.builder.deleteControls();
						domEle = designer.instance.builderDomElement;
					}else if(optType=='2'){//插入
						domEle = designer.instance.builderDomElement;
						if(designer.instance.builder && designer.instance.builder.owner.control){
							var domEles = designer.instance.builder.owner.control.selectedDomElement;
							if(domEles && domEles.length==1 && domEles[0].tagName=='TD'){
								domEle = domEles[0];
							}else{
								var currNode = designer.instance.builder.owner.control.options.domElement;
								if(currNode.parentNode){
									domEle = currNode.parentNode;
								}
								designer.instance.builder.deleteControl();
							}
						}
					}
				}
				var controlsData = data.data;
				for(var i=0;i<controlsData.length;i++){
					if(window.__xform_impt_parser[controlsData[i].type].callback){
						window.__xform_impt_parser[controlsData[i].type].callback(controlsData[i],{parent:domEle});
					}else{
						if(window.console)
							window.console.error("无控件：" + controlsData[i].type + "的支持");
					}
				}
			}else{
				alert("表单未初始化完，暂不支持导入。");
			}
		}else{
			alert("解析数据错误信息为：" + data.message);
		}
	}else{
		alert("解析数据为空。");
	}
} 