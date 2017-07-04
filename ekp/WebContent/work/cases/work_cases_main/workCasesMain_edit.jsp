<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!--UI的前端呈现都是通过js来完成的。新ui的特点是使用自定义的jsp标签来生成js和html，这样做的好处是降低js编写的复杂程度,能让熟悉jsp的开发人员迅速制作ui  -->
<!--所有的jsp文件都要引入该文件，该文件主要引入了jsp页面要使用的标签和一些全局变量，例如使用${LUI_contextPath}来表示上下文/ekp  -->
<!--使用模板的原因:因为在开发jsp时一部门页面的界面布局往往是一样的，只是页面中的某一个区域的内容变化了,例如导航栏,页眉,页脚基本都不变的，模板就是抽取了页面上共同的区域，引用模板后，我们只需要填充不同的区域即可  -->
<!--模板的定义:1.可以定义多个可编辑区域 2.可编辑区域不能嵌套 3.可编辑区域可以有默认内容4.可编辑区域必须有个唯一的name  -->
<%@ include file="/sys/ui/jsp/common.jsp"%>
<!--引入id为default.edit的模板  -->
<template:include ref="default.edit">
	<!--替换模板name="title"的区域  -->
	<template:replace name="title">
		<c:choose>
			<c:when test="${workCasesMainForm.method_GET == 'add' }">
				<c:out value="${ lfn:message('operation.create') } - ${ lfn:message('work-cases:module.work.cases') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${workCasesMainForm.docSubject} - "/>
				<c:out value="${ lfn:message('work-cases:module.work.cases') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<!--替换模板name=toolbar的区域  -->
	<template:replace name="toolbar">
		<!--ui:toolbar是一个工具栏部件  -->
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3"> 
			<c:choose>
				<c:when test="${ workCasesMainForm.method_GET == 'edit' }">
					<c:if test="${ workCasesMainForm.docStatus == '10'}">
						<ui:button text="${ lfn:message('button.savedraft') }" onclick="commitMethod('update', 'true');"></ui:button>
					</c:if>
					<c:if test="${workCasesMainForm.docStatus=='10'||workCasesMainForm.docStatus=='11'||workCasesMainForm.docStatus=='20' }">
						<ui:button text="${ lfn:message('button.update') }" onclick="commitMethod('update');"></ui:button>
					</c:if>
				</c:when>
				<c:when test="${ workCasesMainForm.method_GET == 'add' }">
					<ui:button text="${ lfn:message('button.savedraft') }" onclick="commitMethod('save', 'true');"></ui:button>
					<ui:button text="${ lfn:message('button.submit') }" onclick="commitMethod('save');"></ui:button>
				</c:when>
			</c:choose>
			<!--ui:button表示一个按钮 ,text为按钮中的文字 -->
			<ui:button text="${ lfn:message('button.close') }" onclick="Com_CloseWindow();"></ui:button>	
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">			
		<ui:menu layout="sys.ui.menu.nav"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
			</ui:menu-item>	
			<ui:menu-item text="${ lfn:message('work-cases:module.work.cases') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	<template:replace name="content">
		<html:form action="/work/cases/work_cases_main/workCasesMain.do">
			<c:if test="${!empty workCasesMainForm.docSubject}">
				<p class="txttitle" style="display: none;">${workCasesMainForm.docSubject }</p>
			</c:if>
			<div class="lui_form_content_frame" style="padding-top:20px">
				<table class="tb_normal" width=100% >
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.docSubject"/>
						</td>
						<td colspan="3">
							<!--表示文本输入框  -->
							<xform:text property="docSubject" style="width:98%" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.docCategory"/>
						</td>
						<td width="35%">
							
							<html:hidden  property="docCategoryId"/>
							<bean:write name="workCasesMainForm" property="docCategoryName"/>
						</td>
						<td >
							<!--地址栏  -->
							<xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="hidden" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.fdWorkType"/>
						</td>
						<td width="35%">
							<!--单选按钮  -->
							<xform:radio property="fdWorkType" >
								<!--枚举类型  -->
								<xform:enumsDataSource enumsType="work_cases_main_fd_work" />
							</xform:radio>
						</td>
						<!-- <td class="td_normal_title" width=15%> -->
							<%-- <bean:message bundle="work-cases" key="workCasesMain.docCreator"/> --%>
						<!-- </td> -->
						
						<td >
							<%-- <xform:address propertyId="docCreatorId" propertyName="docCreatorName" orgType="ORG_TYPE_PERSON" showStatus="hidden" /> --%>
						</td>
					</tr>
					<tr>
					
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.notifyType"/>
						</td>
						<td colspan="3">
							<!--通知方式 -->
							<kmss:editNotifyType property="fdNotifyType"/>
						</td>
					</tr>
					
					</tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.fdNotifiers"/>
						</td>
						<td colspan="3">
							<xform:address propertyId="fdNotifierIds" propertyName="fdNotifierNames" mulSelect="true" orgType="ORG_TYPE_ALL" textarea="true" style="width:99%" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.docContent"/>
						</td>
						<td colspan="3">
							<!--大文本框  -->
							<xform:rtf property="docContent" />
						</td>
					</tr>
					
					
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="work-cases" key="workCasesMain.attachment"/>
						</td>
						<td colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment"/>
							</c:import>
						</td>
					</tr>
					
					
					
				</table>
				
			</div>
			<!--机制标签  -->
			<ui:tabpage expand="false">
					<%-- 以下代码为嵌入流程标签的代码 --%>
					<%--引入页面  --%>
					<c:import url="/sys/lbpmservice/import/sysLbpmProcess_edit.jsp" charEncoding="UTF-8">
						<%-- 123 --%>
						<c:param name="formName" value="workCasesMainForm" />
						<c:param name="fdKey" value="reviewMainDoc" />
					</c:import>
					<%-- 以上代码为嵌入流程标签的代码 --%>
					<!-- 以下代码为上传附件的代码 -->
					<%-- <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="fdKey" value="attachment"/>
					</c:import> --%>
					<!-- 以上代码为上传附件的代码 -->
					<!--权限机制 -->
					<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="workCasesMainForm" />
						<c:param name="moduleModelName" value="com.landray.kmss.work.cases.model.WorkCasesMain" />
					</c:import>
			</ui:tabpage>
			<html:hidden property="docStatus"/>
			<html:hidden property="fdId" />
			<html:hidden property="method_GET" />
		</html:form>
		<script>
			$KMSSValidation(document.forms['workCasesMainForm']);
			// 提交表单
			function commitMethod(method, saveDraft){
				var docStatus = document.getElementsByName("docStatus")[0];

				if (saveDraft != null && saveDraft == 'true'){
					docStatus.value = "10";
				} else {
					docStatus.value = "20";
				}
				Com_Submit(document.workCasesMainForm, method);
			}
			
			
			function confirmChgCate(modeName,url,canClose){
				seajs.use(['sys/ui/js/dialog'],	function(dialog) {
					dialog.confirm("${lfn:message('work-cases:workCases.changeCate.confirmMsg')}",function(flag){
					if(flag==true){
						window.changeDocCate(modeName,url,canClose);
					}},"warn");
				});
			};
			function changeDocCate(modeName,url,canClose,flag) {
				if(modeName==null || modeName=='' || url==null || url=='')
					return;
				seajs.use(['sys/ui/js/dialog'],	function(dialog) {
					dialog.simpleCategoryForNewFile(modeName,url,false,function(rtn) {
						// 门户无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
						if (!rtn && flag == "portlet")
							window.close();
					},null,null,"_self",canClose);
				});
			};
		</script>
	</template:replace>
	
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${ lfn:message('work-cases:work.cases.messages') }" toggle="false">
				<c:import url="/sys/evaluation/import/sysEvaluationMain_view_star.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="workCasesMainForm" />
				</c:import>
				<ul class='lui_form_info'>
					<li><bean:message bundle="work-cases" key="workCasesMain.docCreator" />：
						<xform:address propertyName="docCreatorName" propertyId="docCreatorId" orgType="ORG_TYPE_PERSON" showStatus="view"></xform:address>
					<%-- <ui:person personId="${workCasesMainForm.docCreatorId}" personName="${workCasesMain.docCreatorName}"></ui:person></li> --%>
					<%-- <li><bean:message bundle="work-cases" key="workCasesMain.docDept" />：${workCasesMainForm.docDeptName}</li> --%>
					<%-- <li><bean:message bundle="work-cases" key="workCasesMain.docStatus" />：<sunbor:enumsShow value="${workCasesMain.docStatus}" enumsType="common_status" /></li> --%>
					<li><bean:message bundle="work-cases" key="workCasesMain.docCreateTime" />：${workCasesMainForm.docCreateTime }</li>				
				</ul>
			</ui:content>
		</ui:accordionpanel>
		<%---关联机制 开始----%>
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="workCasesMainForm" />
		</c:import>
		<%---关联机制 结束----%>
	</template:replace>
	<%-- <ui:switch property="value(realTimeSearch)"></ui:switch> --%>
</template:include>