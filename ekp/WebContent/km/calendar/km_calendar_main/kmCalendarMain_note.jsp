<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
<template:replace name="content">
<script>
	Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js",null,"js");
	seajs.use(['theme!form']);
	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog,topic,toolbar) {
		
		//保存笔记
		window.save=function(){
			if(noteValidation.validate()==false){
				return false;
			}
			beforeSubmit(document.kmCalendarMainForm);
			var method = "saveNote";
			var last_method = Com_GetUrlParameter(window.location.href, "method");
			if("edit"==last_method){
				method = "updateNote";
			}
			var oEditor = eval("CKEDITOR.instances.docContent");
			$("[name='docContent']").val(oEditor.getData());
			$.ajax({
				url: '${LUI_ContextPath}/km/calendar/km_calendar_main/kmCalendarMain.do?method='+method,
				type: 'POST',
				dataType: 'json',
				async: false,
				data: $("#calendarDetailForm").serialize(),
				beforeSend:function(){
					//window.loading = dialog.loading();
				},
				success: function(data, textStatus, xhr) {//操作成功
					if(data['status']==true){
						window.$dialog.hide(data['schedule']);
					}
				},
				error:function(xhr, textStatus, errorThrown){//操作失败
					window.$dialog.hide(null);
					//window.loading.hide();
					dialog.success('<bean:message key="return.optFailure" />');
				}
			});
		};
		
		window.beforeSubmit=function(formObj){
			if(formObj.onsubmit!=null && !formObj.onsubmit()){
				return false;
			}
			//提交表单校验
			for(var i=0; i<Com_Parameter.event["submit"].length; i++){
				if(!Com_Parameter.event["submit"][i]()){
					return false;
				}
			}
			//提交表单消息确认
			for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
				if(!Com_Parameter.event["confirm"][i]()){
					return false;
				}
			}
			//过滤非法字符
			CKEDITOR.instances['docContent'].element.fire('updateEditorElement');
		};

	});

	//初始化校验框架
	var noteValidation=null;
	window.onload = function(){
		noteValidation=$KMSSValidation();
	};

</script>

<%--新增笔记--%>
<html:form action="/km/calendar/km_calendar_main/kmCalendarMain.do?method=saveNote" styleId="calendarDetailForm">
	<html:hidden property="fdId"/>
	<html:hidden property="docStartTime"/>
	<html:hidden property="fdType" value="note"/>
	<br/>
    <table class="tb_simple" width="98%">
     	<tr>
        	<%--主题--%>
	       	<td width="10%" class="td_normal_title">
	       		<bean:message bundle="km-calendar" key="kmCalendarMain.docSubject" />
	        </td>
            <td colspan="3">
				<xform:text  showStatus="edit"  htmlElementProperties="id='docSubject'"   required="true" 
                    subject="${lfn:message('km-calendar:kmCalendarMain.docSubject')}" property="docSubject"	style="width:95%;"/>
         	</td>
       </tr>
       <tr>
       		<%--内容--%>
      		<td width="10%" class="td_normal_title" valign="top">
      			<bean:message bundle="km-calendar" key="kmCalendarMain.docContent" />
            </td>
            <td colspan="3">
                <kmss:editor property="docContent" toolbarSet="Default" height="200"  width="95%" />
           </td>
        </tr>
        <tr>	
        	<%--附件--%>
           <td width="10%" class="td_normal_title">
             附件
           </td>
           <td colspan="3">
       		 	<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
					<c:param name="fdAttType" value="byte" />
					<c:param name="fdMulti" value="true" />
					<c:param name="fdShowMsg" value="true" />
					<c:param name="fdImgHtmlProperty" />
					<c:param name="fdKey" value="fdAttachment" />
					<c:param name="fdModelId" value="${kmCalendarMainForm.fdId }" />
					<c:param name="fdModelName" value="com.landray.kmss.km.calendar.model.KmCalendarMain" />
				</c:import>
		     </td>
          </tr>
          <tr>
          	<td colspan="4" align="center">
          		<ui:button text="${lfn:message('button.save')}"  onclick="save();"/> &nbsp;
          		<ui:button text="${lfn:message('button.close')}"  styleClass="lui_toolbar_btn_gray" onclick="window.$dialog.hide();"/>
          	</td>
          </tr>
      </table>
</html:form>
</template:replace>
</template:include>