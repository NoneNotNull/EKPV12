<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/edit.jsp">
	<template:replace name="title">
		新建知识
	</template:replace>
	<c:if test="${not empty param.fdTemplateId }">
		<template:replace name="header">
			<c:import url="/kms/common/pda/template/edit_header.jsp" charEncoding="UTF-8">
			</c:import>
		</template:replace>
	
		<template:replace name="content">
			<div class="lui-step-panel">
				<div class="global">
					<%
				  		session.setAttribute("S_DocLink","/kms/knowledge/pda/list/index.jsp");
				  	%>
				  	<html:form action="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" style="height: 100%">
				  	
				  		<section class="step" data-lui-title="基本信息">
					  		<section class="lui-content-section">
					  			<div onclick="selectCategory();" class="lui-input-select">
						  			<input type="text" name="docCategoryName" 
						  				readonly="readonly" placeholder="请选择分类" value="${kmsMultidocKnowledgeForm.docCategoryName }">	
					  				<input type="hidden" name="docCategoryId" value="${kmsMultidocKnowledgeForm.docCategoryId }">	
					  				<span></span>
					  			</div>
					  			
					  			<div class="lui-input">
						  			<table style="width: 100%">
						  				<tr>
							  				<td>
							  					<input type="text" name="docSubject" placeholder="请填写标题" validate="required maxLength(200)">
							  				</td>
						  				</tr>
						  			</table>
					  			</div>
					  			<input type="hidden" name="fdId" value="${ kmsMultidocKnowledgeForm.fdId}">
					  			<input type="hidden" name="docStatus" value="${ kmsMultidocKnowledgeForm.docStatus}">
					  			<div class="lui-step-content">
					  				<textarea class="docContent" name="docContent" placeholder="请填写内容"></textarea>
					  			</div>
					  		</section>
						  	<section class="lui-step-btn">
						  		<a class="next">下一步</a>
						  	</section>
				  		</section>
				  		
				  		<section class="step" data-lui-title="附件上传">
				  			<div class="lui-content-section" style="top:5px">
					  			<c:import url="/kms/common/pda/core/attachment/attachment_upload.jsp" charEncoding="UTF-8">
									<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId}"></c:param>
									<c:param name="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"></c:param>
									<c:param name="fdKey" value="attachment"></c:param>
									<c:param name="extParam" value="{'thumb':[{'name':'s1','w':'800','h':'800'},{'name':'s2','w':'2250','h':'1695'}]}" />
									<c:param name="toolbar" value="toolbar"></c:param>
								</c:import>
								<span class="lui-attachment-area">附件区域</span>
				  			</div>
							<section class="lui-step-btn">
								<a class="pre">上一步</a>
						  		<a class="next">下一步</a>
						  	</section>
					  	</section>
				  		
					  	<section class="step" data-lui-title="属性信息" >
					  		<section class="lui-content-section">
							  	<table class="tb_normal">
							  		<textarea class="fdDescription" name="fdDescription" placeholder="请填写描述"></textarea>
								  	<c:import url="/sys/property/include/sysProperty_pda.jsp" charEncoding="UTF-8">
											<c:param name="formName" value="kmsMultidocKnowledgeForm" />
											<c:param name="isPda" value="true" />
									</c:import>
							  	</table>
							</section>
							<section class="lui-step-btn">
								<a class="pre">上一步</a>
						  		<a class="next">下一步</a>
						  	</section>
					  	</section>
					  
						<section class="step" data-lui-title="流程信息">
							<section class="lui-content-section">
								<c:import url="/sys/workflow/include/sysWfProcess_pda_edit.jsp"
														charEncoding="UTF-8">
									<c:param name="formName" value="kmsMultidocKnowledgeForm" />
									<c:param name="fdKey" value="mainDoc" />
								</c:import>
							</section>
							<section class="lui-step-btn">
								<a class="pre">上一步</a>
						  		<a class="submit">提交</a>
						  	</section>
						</section>
						<c:import url="/kms/common/pda/core/right/right.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm" /> 
							<c:param name="moduleModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
						</c:import>
				  	</html:form>
				</div>
			</div>
		</template:replace>
	</c:if>
	
	<template:replace name="footer">
		<%@ include file="/kms/multidoc/pda/edit/edit_js.jsp" %>
	</template:replace>
</template:include>



