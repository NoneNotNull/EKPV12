<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${kmForumPostForm.docSubject} - ${ lfn:message('km-forum:module.km.forum') }"></c:out>
	</template:replace>
	<template:replace name="head">
	     <script type="text/javascript">
			seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
			    window.deleteConfirm = function(){
			    	dialog.confirm("${lfn:message('km-forum:kmForumPost.topicDeleteConfirm')}",function(value){
						if(value==true){
							Com_OpenWindow('${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method=deleteDraft&fdId=${kmForumPostForm.fdTopicId}','_self');
  					    }
	  					    return false;
        	        });
			    };
			});
		 </script>
	</template:replace>
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<%--编辑--%>
			<ui:button text="${ lfn:message('button.edit') }" 
				onclick="Com_OpenWindow('${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=edit&fdForumId=${kmForumPostForm.fdForumId}&fdId=${kmForumPostForm.fdId}','_self');">
 			</ui:button>
	        <%--删除--%>		
			<kmss:auth requestURL="/km/forum/km_forum/kmForumTopic.do?method=deleteDraft&fdId=${param.fdTopicId}" requestMethod="GET">
				 <ui:button text="${ lfn:message('button.delete') }"
						onclick="deleteConfirm();">
		         </ui:button>	
			</kmss:auth>
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>
		</ui:toolbar>
	</template:replace>

	<%--导航路径--%>
     <template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('km-forum:module.km.forum') }" 
					modelName="com.landray.kmss.km.forum.model.KmForumCategory" 
					autoFetch="false"
					categoryId="${kmForumPostForm.fdForumId}" />
			</ui:combin>
	</template:replace>	
	
	<%--发帖信息--%>
	<template:replace name="content"> 
		    <script type="text/javascript" >
					function confirmDelete(msg){
					var del = confirm("<bean:message key="page.comfirmDelete"/>");
					return del;
				}
			</script>
		<html:form action="/km/forum/km_forum/kmForumPost.do">	
		  	<ui:tabpage width="95%" >
				<ui:content  title="${lfn:message('km-institution:kmInstitution.form.tab.main.label')}"  toggle="false">
						<table class="tb_normal" width=95%>
								<tr>
									<td width="15%" class="td_normal_title" valign="top"><bean:message
										bundle="km-forum" key="kmForumTopic.docSubject" /></td>
									<td colspan=3><c:out
										value="${kmForumPostForm.topicDocSubject}" /></td>
								</tr>
		
								<tr>
									<td width="15%" class="td_normal_title"><bean:message
										bundle="km-forum" key="kmForumTopic.fdForumId" /></td>
									<td colspan="3"><c:out value="${kmForumPostForm.fdForumName}" /></td>
								<%--	<td width="15%" class="td_normal_title" valign="top"><bean:message
										bundle="km-forum" key="kmForumTopic.fdIsAnonymous" /></td>
									<td><sunbor:enumsShow
										value="${kmForumPostForm.fdIsAnonymous}"
										enumsType="common_yesno" /></td>
										--%>
								</tr>
								<tr>
									<td width="15%" class="td_normal_title"><bean:message
										bundle="km-forum" key="kmForumTopic.fdPosterId" /></td>
									<td width="35%"><c:if
										test="${kmForumPostForm.fdIsAnonymous == false}">
										<c:out value="${kmForumPostForm.fdPosterName}" />
									</c:if> <c:if test="${kmForumPostForm.fdIsAnonymous == true}">
										<bean:message bundle="km-forum"
											key="kmForumTopic.fdIsAnonymous.title" />
									</c:if></td>
									<td width="15%" class="td_normal_title"><bean:message
										bundle="km-forum" key="kmForumTopic.docCreateTime" /></td>
									<td width="35%"><c:out
										value="${kmForumPostForm.docCreateTime}" />
										</td>
								</tr>
		
								<tr>
									<td width="15%" class="td_normal_title"><bean:message
										bundle="km-forum" key="kmForumPost.docContent" /></td>
									<td colspan=3>
											<xform:rtf property="docContent"></xform:rtf>
									</td>
								</tr>
		
								<tr>
									<td width="11%" class="td_normal_title"><bean:message
										bundle="sys-attachment" key="table.sysAttMain" /></td>
									<td width="89%" colspan="3"><c:import
										url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
										charEncoding="UTF-8">
										<c:param name="fdKey" value="attachment" />
										<c:param name="fdAttType" value="byte" />
										<c:param name="fdModelId" value="${kmForumPostForm.fdId}" />
										<c:param name="formBeanName" value="kmForumPostForm" />
										<c:param name="fdModelName"
											value="com.landray.kmss.km.forum.model.KmForumPost" />
									</c:import></td>
								</tr>
								<%--<tr>
									<td width="15%" class="td_normal_title"><bean:message
										key="KmForumPost.notify.title" bundle="km-forum" /></td>
									<td colspan=4><sunbor:enumsShow
										value="${kmForumPostForm.fdIsNotify=='1'? 'true':'false'}"
										enumsType="common_yesno" /></td>
								</tr>
								<c:if test="${kmForumPostForm.fdIsNotify == '1' }">
									<tr id="id_notify_type">
										<td width="15%" class="td_normal_title"><bean:message
											key="KmForumPost.notify.fdNotifyType" bundle="km-forum" /></td>
										<td colspan=3><kmss:showNotifyType
											value="${kmForumPostForm.fdNotifyType}" /></td>
									</tr>
								</c:if>--%>
							</table>
				</ui:content>
			</ui:tabpage>
		</html:form>
	</template:replace>
</template:include>
