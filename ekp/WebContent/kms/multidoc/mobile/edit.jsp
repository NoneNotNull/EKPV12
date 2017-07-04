<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="mobile.edit" compatibleMode="true">
	<template:replace name="title">
		<c:if test="${empty kmsMultidocKnowledgeForm.docSubject}">
			<c:out value="新建文档" />
		</c:if>
		<c:out value="${kmsMultidocKnowledgeForm.docSubject}"></c:out>
	</template:replace>
	<template:replace name="content">
		<html:form
			action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=save">
			<div data-dojo-type="mui/view/DocScrollableView"
				data-dojo-mixins="mui/form/_ValidateMixin" id="scrollView">
				<div data-dojo-type="mui/panel/AccordionPanel">
					<div data-dojo-type="mui/panel/Content"
						data-dojo-props="title:'基本信息',icon:'mui-ul'">
						<div class="muiFormContent">
							<html:hidden property="fdId" />
							<html:hidden property="fdModelId" />
							<html:hidden property="fdModelName" />
							<html:hidden property="docStatus" value="20" />
							<table class="muiSimple" cellpadding="0" cellspacing="0">
								<tr>
									<td class="muiTitle">${lfn:message('kms-multidoc:kmsMultidocKnowledge.docSubject') }</td>
									<td><xform:text property="docSubject" mobile="true" /></td>
								</tr>
								<tr>
									<td class="muiTitle">${lfn:message('kms-multidoc:kmsMultidocTemplate.docCategory') }</td>
									<td><html:hidden property="docCategoryId" /> <xform:text
											property="docCategoryName" mobile="true" showStatus="view" />
									</td>
								</tr>
								<tr>
									<td class="muiTitle">${lfn:message('kms-multidoc:kmsMultidocTemplate.docCreator') }</td>
									<td><xform:text property="docCreatorName" mobile="true"
											showStatus="view" /></td>
								</tr>
							</table>
							<c:import url="/sys/right/right_edit4pda.jsp"
								charEncoding="UTF-8">
								<c:param name="formName" value="kmsMultidocKnowledgeForm" />
								<c:param name="moduleModelName"
									value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
							</c:import>
						</div>
					</div>
					<div data-dojo-type="mui/panel/Content"
						data-dojo-props="title:'文档内容',icon:'mui-ul'">
						<div class="muiFormContent">
							<table class="muiSimple" cellpadding="0" cellspacing="0">
								<tr>
									<td colspan="2"><xform:textarea property="docContent"
											mobile="true"></xform:textarea></td>
								</tr>
								<tr>
									<td colspan="2">
										<c:import
											url="/sys/attachment/mobile/import/edit.jsp"
											charEncoding="UTF-8">
											<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
											<c:param name="fdKey" value="attachment" />
											<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
										</c:import>
									</td>
								</tr>
							</table>
						</div>
					</div>
					<div data-dojo-type="mui/panel/Content"
						data-dojo-props="title:'知识属性',icon:'mui-ul'">

						<div class="muiFormContent">
							<table class="muiSimple" cellpadding="0" cellspacing="0">
								<tr>
									<td class="muiTitle">摘要</td>
									<td><xform:textarea property="fdDescription"
											validators="maxLength(1500)" mobile="true" /></td>

								</tr>
								<c:import url="/sys/property/include/sysProperty_pda.jsp"
									charEncoding="UTF-8">
									<c:param name="formName" value="kmsMultidocKnowledgeForm" />
								</c:import>
							</table>
						</div>
					</div>

				</div>
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom"
					data-dojo-props='fill:"grid"'>
					<li data-dojo-type="mui/back/BackButton" edit="true"></li>
					<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnNext "
						data-dojo-props='colSize:2,moveTo:"lbpmView",transition:"slide"'>下一步</li>
					<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
						data-dojo-props="icon1:'mui mui-more'">
						<div data-dojo-type="mui/back/HomeButton"></div>
					</li>
				</ul>
			</div>

			<c:import url="/sys/lbpmservice/mobile/import/edit.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmsMultidocKnowledgeForm" />
				<c:param name="fdKey" value="mainDoc" />
				<c:param name="viewName" value="lbpmView" />
				<c:param name="backTo" value="scrollView" />
				<c:param name="onClickSubmitButton" value="knowledge_submit();" />
			</c:import>

			<script>
				require([ "mui/form/ajax-form!kmsMultidocKnowledgeForm" ]);
				function knowledge_submit() {
					var status = document.getElementsByName("docStatus")[0];
					Com_Submit(document.forms[0], 'save');
				}
			</script>
		</html:form>
	</template:replace>
</template:include>
