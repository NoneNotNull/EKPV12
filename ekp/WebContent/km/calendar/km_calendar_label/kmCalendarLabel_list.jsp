<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="head">
		<script type="text/javascript" src="<c:url value="/resource/js/jquery.js"/>"></script>
		<script type="text/javascript" src="<c:url value="/km/calendar/resource/js/jquery.colorpicker.js"/>"></script>
	</template:replace>
   <template:replace name="content">
   		<script type="text/javascript">
   			Com_IncludeFile("doclist.js");
   			var _dialog;
   			seajs.use(['lui/dialog'], function( dialog) {
   	   			_dialog=dialog;
   	   		});
   			var deleteLabels=new Array();//待删除标签列表
		   	 LUI.ready(function(){
		     	refreshList();//初始化标签列表
		     });
		     //初始化标签列表
		   	function refreshList() {
		    	$.ajax({
		            url: '<c:url value="/km/calendar/km_calendar_label/kmCalendarLabel.do?method=listJson"/>',
		            dataType: 'json',
		            data: {},
		            success: function(data) {
		            	if (data instanceof Array) {
		             		for (var i = 0; i < data.length; i++) {
		             			var color = data[i].fdColor;
		                 		var name = data[i].fdName;
		                 		var fdId = data[i].fdId;
		                 		var content = new Array();
		                 		content.push("<span style='display:inline-block;width:13px;height:13px;margin-right:10px;background-color:"+ color+";'></span>"+name);//标签名
						    	content.push("<div style='cursor:pointer;display:inline-block;width: 16px;height: 16px;' class='lui_icon_s_icon_arrow_up_blue' onclick=''></div>"+
								    					"<div style='cursor:pointer;display:inline-block;width: 16px;height: 16px;' class='lui_icon_s_icon_arrow_down_blue' onclick=''></div>"+
								    					"<div onclick='removeLabel(this);' id='"+fdId+"' name='"+name+"' style='cursor:pointer;display:inline-block;width: 16px;height: 16px;' class='lui_icon_s_icon_close_red' ></div>");//操作
								DocList_AddRow("TABLE_DocList",content);
		             		}
		             	}
		            }
		        });
		    }
		    //删除标签(数据库未移除)
		    function removeLabel(_this){
		    	deleteLabels.push({"id":$(_this).attr("id"),"name":$(_this).attr("name")});//放入待删除标签列表
		    	DocList_DeleteRow();//删除行
			}
			//确认
		    function save(){
			    if(deleteLabels.length>0){
			    	var confirmMsg="是否确认删除以下标签：";
			    	var values = [];
				    for(var i=0;i<deleteLabels.length;i++){
					    confirmMsg+=" "+deleteLabels[i].name+" ";
					    values.push(deleteLabels[i].id);
					}
		    		_dialog.confirm(confirmMsg,function(value){
		    			if(value==true){
							$.post('<c:url value="/km/calendar/km_calendar_label/kmCalendarLabel.do?method=deleteall"/>',
								$.param({"List_Selected":values},true),function(){
									window.$dialog.hide("true");
								},'json');
						}
			    	});
				}
			    else{
			    	$dialog.hide("false");
				}
		    }
		    function checkIsEmpty(param){  
			    return (param == '' || param == null || typeof (param) == 'undefined') ? true: false;
			}
   		</script>
   		<input type="hidden" id="fdLabelIds" />
   		<br/><p class="txttitle">标签管理</p>
   		<div style="width: 90%;margin: 5px auto;">您可以新建标签、编辑标签以及删除选定的标签</div>
   		<table class="tb_normal" id="TABLE_DocList" width="90%">
   			  <tr>
   			  	<%--标签名+颜色--%>
                 <td width="80%" class="td_normal_title">
                     名称
                 </td>
                 <%--操作--%>
                 <td align="center">
                 	<a onclick="parent.addCalendarLabel()" title="添加">
                 		<div style="cursor:pointer;width: 16px;height: 16px;" class="lui_icon_s_icon_add_green" ></div>
                 	</a>
                 </td>
             </tr>
             <%--基准行--%>
			<tr KMSS_IsReferRow="1" style="display: none" >
				<td width="80%"></td>
				<td width="20%" align="center"></td>
			</tr>
   		</table>
   		<div style="text-align: center;padding-top: 10px;">
   			<ui:button  text="${lfn:message('button.save')}"  onclick="save();" style="width:70px;"/>
   		</div>
   </template:replace>
</template:include>