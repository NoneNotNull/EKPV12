<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
   <template:replace name="content">
   		<script language="JavaScript">
			Com_IncludeFile("doclist.js|dialog.js");
			var deleteLabels=new Array();//待删除标签列表

			seajs.use(['lui/dialog','lui/jquery'], function( dialog,jquery) {
   	   			window._dialog=dialog;
   	   			window.$ = jquery;
   	   		});
			
			function saveUserKmCalendarShareGroup2(formObj,method){
				Com_Submit(formObj, method);
			}

			function addLabel(){
		    	_dialog.iframe('/km/calendar/km_calendar_label/kmCalendarLabel_edit.jsp','${lfn:message("km-calendar:kmCalendarLabel.tab.add")}',function(){
					//更新左侧导航栏
					location.href="${LUI_ContextPath}/km/calendar/km_calendar_label/kmCalendarUserLabel.do?method=edit";
				 },{height:'340',width:'700'});
		    }

		    function editLabel(fdId){
			    var url = "/km/calendar/km_calendar_label/kmCalendarLabel.do?method=edit&fdId="+fdId;
		    	_dialog.iframe(url,"${lfn:message('km-calendar:kmCalendarLabel.tab.edit')}",function(result){
		    		location.href="${LUI_ContextPath}/km/calendar/km_calendar_label/kmCalendarUserLabel.do?method=edit";
					if(result!=null){}
				},{width:'600',height:'340'});
			}

		    function DocList_MoveRow2(direct, optTR){
			    var lastIndex = "${fn:length(kmCalendarUserLabelForm.kmCalendarLabelFormList)}";
			    lastIndex ++;
			    var firstIndex = 1;
		    	if(optTR==null)
		    		optTR = DocListFunc_GetParentByTagName("TR");
		    	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
		    	var tbInfo = DocList_TableInfo[optTB.id];
		    	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
		    	var tagIndex = rowIndex + direct;
		    	if(direct==1){
		    		if(tagIndex>=lastIndex)
		    			return;
		    		var tagIndexOrderValue=$(optTB.rows[tagIndex]).find(":input")[2].value;
		    		var rowIndexOrderValue=$(optTB.rows[rowIndex]).find(":input")[2].value;
		    		$(optTB.rows[tagIndex]).find(":input")[2].value = rowIndexOrderValue;
		    		$(optTB.rows[rowIndex]).find(":input")[2].value = tagIndexOrderValue;
		    		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[tagIndex], optTB.rows[rowIndex]);
		    	}else{
		    		if(tagIndex<firstIndex)
		    			return;
		    		var tagIndexOrderValue=$(optTB.rows[tagIndex]).find(":input")[2].value;
		    		var rowIndexOrderValue=$(optTB.rows[rowIndex]).find(":input")[2].value;
		    		$(optTB.rows[tagIndex]).find(":input")[2].value = rowIndexOrderValue;
		    		$(optTB.rows[rowIndex]).find(":input")[2].value = tagIndexOrderValue;
		    		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[rowIndex], optTB.rows[tagIndex]);
		    	}
		    	DocListFunc_RefreshIndex(tbInfo, rowIndex);
		    	DocListFunc_RefreshIndex(tbInfo, tagIndex);
		    }

			function moveUp(_this){
				DocList_MoveRow2(-1);
			}

			function moveDown(_this){
				DocList_MoveRow2(1);
			}

		    function removeLabel(_this){
		    	deleteLabels.push({"id":$(_this).attr("id"),"name":$(_this).attr("name")});//放入待删除标签列表
		    	DocList_DeleteRow();//删除行
			}

		  //删除标签(数据库未移除)
		    function removeLabel(index){
			    var idObject = "kmCalendarLabelFormList["+index+"].fdId";
		    	var nameObject = "kmCalendarLabelFormList["+index+"].fdName";
		    	var idValue = $("[name='"+idObject+"']").val();
		    	if(idValue!=null && idValue!=''){
		    		deleteLabels.push({"id":idValue,"name":$("[name='"+nameObject+"']").val()});//放入待删除标签列表
		    	}
		    	DocList_DeleteRow();//删除行
			}

			 function saveLabels(formObj,method){
				    if(deleteLabels.length>0){
				    	var confirmMsg="${lfn:message('km-calendar:kmCalendarLabel.delete.confirmMsg')}：";
				    	var values = [];
					    for(var i=0;i<deleteLabels.length;i++){
						    confirmMsg+=" "+deleteLabels[i].name+" ";
						    values.push(deleteLabels[i].id);
						}
			    		_dialog.confirm(confirmMsg,function(value){
			    			if(value==true){
								$("[name='deleteIds']").val(values);
								$.ajax({
									url: '${LUI_ContextPath}/km/calendar/km_calendar_label/kmCalendarUserLabel.do?method=updateJson',
									type: 'POST',
									dataType: 'json',
									async: false,
									data: $("[name='kmCalendarUserLabelForm']").serialize(),
									beforeSend:function(){
										//window.loading = _dialog.loading();
									},
									success: function(data, textStatus, xhr) {//操作成功
										//window.loading.hide();
										window.$dialog.hide("true");
									},
									error:function(xhr, textStatus, errorThrown){//操作失败
										//window.loading.hide();
										window.$dialog.hide("false");
									}
								});
							}
				    	});
					}else{
						$.ajax({
							url: '${LUI_ContextPath}/km/calendar/km_calendar_label/kmCalendarUserLabel.do?method=updateJson',
							type: 'POST',
							dataType: 'json',
							async: false,
							data: $("[name='kmCalendarUserLabelForm']").serialize(),
							beforeSend:function(){
								//window.loading = _dialog.loading();
							},
							success: function(data, textStatus, xhr) {//操作成功
								//window.loading.hide();
								window.$dialog.hide("true");
							},
							error:function(xhr, textStatus, errorThrown){//操作失败
								//window.loading.hide();
								window.$dialog.hide("false");
							}
						});
					}
			    }
			    
			//删除标签(数据库未移除)
		    function removeGroup(index){
			    var idObject = "kmCalendarLabelFormList["+index+"].fdId";
		    	var nameObject = "kmCalendarLabelFormList["+index+"].fdName";
		    	var idValue = $("[name='"+idObject+"']").val();
		    	if(idValue!=null && idValue!=''){
		    		deleteLabels.push({"id":idValue,"name":$("[name='"+nameObject+"']").val()});//放入待删除标签列表
		    	}
		    	DocList_DeleteRow();//删除行
			}
		</script>
       <html:form action="/km/calendar/km_calendar_label/kmCalendarUserLabel.do">
       <input type="hidden" name="deleteIds" value="">
       		<br/>
       		<table class="tb_normal" width=98% id="TABLE_DocList" align="center">
       			<tr>
       				<%--标签名--%> 
					<td width="80%" class="td_normal_title">
                     	 <bean:message bundle="km-calendar" key="kmCalendarLabel.fdName" />
                 	</td>
					<%--添加操作--%> 
					<td align="center">
                 		<a onclick="addLabel();" title="添加">
                 			<div style="cursor:pointer;width: 16px;height: 16px;" class="lui_icon_s_icon_add_green" ></div>
                 		</a>
                 	</td>
       			</tr>
				<c:forEach items="${kmCalendarUserLabelForm.kmCalendarLabelFormList}" var="kmCalendarLabelForm" varStatus="vstatus">
					<tr KMSS_IsContentRow="1" height="20px;">
						<input type="hidden" name="kmCalendarLabelFormList[${vstatus.index}].fdId" value="${kmCalendarLabelForm.fdId}"> 
						<input type="hidden" name="kmCalendarLabelFormList[${vstatus.index}].fdName" value="${kmCalendarLabelForm.fdName}">
						<input type="hidden" name="kmCalendarLabelFormList[${vstatus.index}].fdOrder" value="${vstatus.index}">
						<input type="hidden" name="kmCalendarLabelFormList[${vstatus.index}].fdColor" value="${kmCalendarLabelForm.fdColor}">
						<input type="hidden" name="kmCalendarLabelFormList[${vstatus.index}].fdModelName" value="${kmCalendarLabelForm.fdModelName}">
						<td width="85%">
							<div onclick="editLabel('${kmCalendarLabelForm.fdId}')" style="cursor: pointer;">
								<span style="display:inline-block;width:13px;height:13px;margin-right:10px;background-color:${kmCalendarLabelForm.fdColor}"></span>
								<c:out value="${kmCalendarLabelForm.fdName}"></c:out>
							</div>	
						</td>
						<td width="15%" align="center">
							<div onclick='moveUp(this)' style='cursor:pointer;display:inline-block;width: 16px;height: 16px;' class='lui_icon_s_icon_arrow_up_blue'></div>
							<div onclick='moveDown(this)' style='cursor:pointer;display:inline-block;width: 16px;height: 16px;' class='lui_icon_s_icon_arrow_down_blue'></div>
							<c:if test="${kmCalendarLabelForm.fdModelName==null || kmCalendarLabelForm.fdModelName==''}">
								<div onclick='removeLabel(${vstatus.index});' id='${kmCalendarShareGroupForm.fdId}' name='${kmCalendarLabelForm.fdName}' style='cursor:pointer;display:inline-block;width: 16px;height: 16px;' class='lui_icon_s_icon_close_red' ></div>
							</c:if>
						</td>
					</tr>
				</c:forEach>
       		</table>
       		<div id="msg"></div>
       		<div style="text-align: center;padding-top: 10px;">
   				<ui:button  text="${lfn:message('button.save')}"  onclick="saveLabels(document.kmCalendarUserLabelForm, 'update');" style="width:70px;"/>
   			</div>
       </html:form>
   </template:replace>
</template:include>