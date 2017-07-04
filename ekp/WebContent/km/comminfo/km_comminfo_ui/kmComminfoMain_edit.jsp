<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>

<template:include ref="default.edit" sidebar="no" width="980px">
	<template:replace name="head">
		<link href="${LUI_ContextPath}/km/comminfo/resource/css/com_datum.css" rel="stylesheet" type="text/css" />
		<script>
			Com_IncludeFile("doclist.js|dialog.js");
		</script>
		 <script type="text/javascript">
				function ID(id){
					return document.getElementById(id);
				}
				
				function getInputCount(){
					var obj = ID("TABLE_DocList");
					return obj.getElementsByTagName("input").length;
				}
			
				seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
					LUI.ready( function() {
				    	var docCategoryId = document.getElementsByName("docCategoryId")[0];
						//编辑页面的title
						if(${kmComminfoMainForm.method_GET == 'edit' }){
				    		document.title = "${kmComminfoMainForm.docSubject}" + " - ${lfn:message('km-comminfo:module.km.comminfo')}";
						}
					});
					
					//获取富文本框内容
				    window.RTF_GetContent = function(prop){
				    	    var instance=CKEDITOR.instances[prop];
				    	    if(instance){
				    	          return instance.getData();
				    	    }
				    	    return "";
				    };
					//标题限制
				    window.checkNumberOfSubject=function(maxN,len){
					    var isRule = true;
				        if (len <= maxN) {
				        	$("#tip1").html("${lfn:message('km-comminfo:kmComminfo.docSubject.canmore')}");
				         	var remainNum = Math.abs(parseInt((maxN - len) / 2));
				        }else{
				        	$("#tip1").html("${lfn:message('km-comminfo:kmComminfo.docSubject.nomore')}");
				        	var remainNum = Math.abs(parseInt((maxN - len) / 2))+1;
				        	isRule = false;
					        }
				    	$("#restrictNum").html(remainNum);
				    	$("#tip2").html("${lfn:message('km-comminfo:kmComminfo.docSubject.word')}");
				    	return isRule;
				    };
				  //获取主题的长度 
			        window.getNumberOfSubject =function(){
			        	  var docSubject = $('input[name="docSubject"]').val(),
			        	  len = (function(s) {
								var l = 0;
								var a = s.split("");
								for (var i = 0; i < a.length; i++) {
									if (a[i].charCodeAt(0) < 299) {
										l++;
									} else {
										l += 2;
									}
								}
								return l;
							})(docSubject);
						return len;
			           };
			        //提交表单
			  	    window.submitKmComminfoPostForm=function(method) {
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
				    		var v=RTF_GetContent("docContent");
				    		//附件列表个数 attachmentObject_attachment.fileList.length
				    		if(attachmentObject_attachment.fileList.length <= 0){
					    		if(v==null ||v=="") {
									dialog.alert("<bean:message  bundle='km-comminfo' key='kmComminfo.topicNotEmpty'/>");
									return;
								}
				    		}
				    		var formObj = document.kmComminfoMainForm;
				    		var url = formObj.action;
				    		url = Com_SetUrlParameter(url,"method",method);
				    		url = Com_SetUrlParameter(url,"categoryId", $("#docCategoryId").val());
				    		formObj.action = url;
				    		formObj.submit();
			  			};
				});
			</script>
	</template:replace>
	<template:replace name="title">
		<c:choose>
			<c:when test="${kmComminfoMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('km-comminfo:kmComminfo.newComminfo') } - ${ lfn:message('km-comminfo:module.km.comminfo') }"></c:out>
			</c:when>
			<c:when test="${kmComminfoMainForm.method_GET == 'edit' }">
				<c:out value="${document.title}"></c:out>
			</c:when>
		</c:choose>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;" id="pathNav">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" >
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-comminfo:module.km.comminfo') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	
	<template:replace name="content">
		<div class="lui_comm_table">
		<html:form action="/km/comminfo/km_comminfo_main/kmComminfoMain.do">
			<table class="lui_sheet_c_table tb_simple" style="width:100%">
				<tr>
					<td colspan="4">
						<div class="i_bar">
	                     	<c:if test="${kmComminfoMainForm.method_GET=='add'}">
								<xform:select htmlElementProperties="id=docCategoryId" property="docCategoryId" showPleaseSelect="true" showStatus="edit" style="width: 140px;height:26px" required="true" subject="${ lfn:message('km-comminfo:kmComminfoMain.categoryName') }"> 
									<c:if test="${isAdmin== true || flag == true}">
										<xform:beanDataSource serviceBean="kmComminfoCategoryService" orderBy="kmComminfoCategory.fdOrder"/>
									</c:if>
								    <c:if test="${isAdmin!= true}">
										<xform:beanDataSource serviceBean="kmComminfoCategoryService" orderBy="kmComminfoCategory.fdOrder" whereBlock="authEditors.fdId='${userId}'" />
									</c:if>
								</xform:select>
							</c:if>
							<c:if test="${kmComminfoMainForm.method_GET=='edit'}">
								<xform:select property="docCategoryId" showPleaseSelect="true" showStatus="edit" style="width: 140px;height:26px" required="true" >
									<xform:beanDataSource serviceBean="kmComminfoCategoryService" orderBy="kmComminfoCategory.fdOrder" />
								</xform:select>
							</c:if>
						</div>
	                     <html:hidden property="fdId" />
	                     <xform:text property="docSubject" subject="${lfn:message('km-comminfo:kmComminfoMain.docSubject')}" validators="maxLength(200)" 
							className="input_1" style="width: 768px; margin-left: 10px;" required="true" />
					</td>
				</tr>
				<%-- 资料内容 --%>
				<tr>
					<td colspan="4">
						<kmss:editor property="docContent"/>
					</td>
				</tr>
				<%-- 附件机制 --%>
				<tr>
					<td >
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="fdKey" value="attachment"/>
						</c:import>
					</td>
				</tr>	
				<tr>
					<!-- 排序号 -->
					<td >
					<bean:message
						bundle="km-comminfo" key="kmComminfoMain.fdOrder" />
						&nbsp;
					<xform:text property="fdOrder" style="width:18%;margin-left: 10px;" />
					</td>
				</tr>
				<tr>
					<%-- 提交者 --%>
					<td >
					    <html:hidden property="docCreatorId"/>
						<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreatorId"/>
						&nbsp;&nbsp;&nbsp;
						<c:out value="${kmComminfoMainForm.docCreatorName}" />
					</td>
					<%-- 提交时间 --%>
					<td >
						<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreateTime"/>
						&nbsp;&nbsp;&nbsp;
						<c:out value="${kmComminfoMainForm.docCreateTime}" />
					</td>
				</tr>
				<c:if test="${not empty kmComminfoMainForm.docAlterorName}">
					<tr>
						<%-- 修改者 --%>
						<td >
						    <html:hidden property="docAlterorId"/>
							<bean:message  bundle="km-comminfo" key="kmComminfoMain.docAlterorId"/>
							&nbsp;&nbsp;&nbsp;
							<c:out value="${kmComminfoMainForm.docAlterorName}" />
						</td>
						<%-- 修改时间 --%>
						<td>
						    <html:hidden property="docAlterTime"/>
							<bean:message  bundle="km-comminfo" key="kmComminfoMain.docAlterTime"/>
							&nbsp;&nbsp;&nbsp;
							<c:out value="${kmComminfoMainForm.docAlterTime}" />
						</td>
					</tr>	
				</c:if>
				<!--保存按钮-->
				<tr>
					<td colspan="4">
						<c:if test="${kmComminfoMainForm.method_GET=='add'}">
							<ui:button styleClass="com_bgcolor_d com_fontcolor_d com_bordercolor_d comm_button" 
										text="${lfn:message('button.save')}" onclick="submitKmComminfoPostForm('save')">
							</ui:button>
						</c:if>
						<c:if test="${kmComminfoMainForm.method_GET=='edit'}">
							<ui:button styleClass="com_bgcolor_d com_fontcolor_d com_bordercolor_d comm_button" id="updateBtn"
										text="${lfn:message('button.update')}" onclick="submitKmComminfoPostForm('update')">
							</ui:button>
						</c:if>
					</td>
				</tr>		
			</table>
			</html:form>
		</div>
		<script language="JavaScript">
		$KMSSValidation(document.forms['kmComminfoMainForm']);
		</script>
	</template:replace>
</template:include>
