<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/template.tld" prefix="template"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.simple">
	<template:replace name="title">
		<kmss:message bundle="sys-zone" key="module.name" />
	</template:replace>
	
	<template:replace name="body">
		
		<div style="width: 95%; margin: 0 auto;">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<ui:button text="${lfn:message('button.update') }" onclick="com_submit();">
			</ui:button>
		</ui:toolbar>
		
		<p class="txttitle">
			<kmss:message bundle="sys-zone" key="path.page.setting" />
		</p>
				<ui:tabpanel layout="sys.ui.tabpanel.light" style="margin-top:10px;">
					<ui:content title="${lfn:message('sys-zone:sysZonePageTemplate.pc') }">
						<div style="left: 10px; right: 10px;">
						<c:forEach items="${pcTemplates}" var="template" varStatus="vstatus">
							<div style="display: inline-block;margin-top: 10px;margin-left: 20px;">
								<img style="width: 180px; " src="${LUI_ContextPath}${template.iconPath}" />
								<div style="display: block; width: 100%;text-align: center;">
									<input type="radio" name="pcJspPath"
										<c:if test="${vstatus.index == 0 }"> checked </c:if>
										value="${template.forwardPath}"></input>
								</div>
							</div>
						</c:forEach>
						</div>
					</ui:content>
					<ui:content title="${lfn:message('sys-zone:sysZonePageTemplate.mobile') }">
						<div style="left: 10px; right: 10px;">
						<c:forEach items="${mobileTemplates}" var="template" varStatus="vstatus">
							<div style="display: inline-block;margin-top: 10px;margin-left: 20px;">
								<img style="width: 180px; " src="${LUI_ContextPath}${template.iconPath}" />
								<div style="display: block; width: 100%;text-align: center;">
									<input type="radio" name="mobileJspPath"
										<c:if test="${vstatus.index == 0 }"> checked </c:if>
										value="${template.forwardPath}"></input>
								</div>
							</div>
						</c:forEach>
						</div>
					</ui:content>
				</ui:tabpanel>
		</div>
		<script>
		seajs.use(['theme!form']);
		function com_submit(){
			seajs.use(['lui/jquery'], function($) {
				var __pcPath = $("input[name='pcJspPath']:checked").val();
				var __mobilePath = $("input[name='mobileJspPath']:checked").val();
				if(__pcPath == null && __mobilePath == null){
					alert("请选择模板！");
					return;
				}		
				$.ajax({
					type: "POST",
					data: "pcJspPath=" + getNotNull(__pcPath) + "&mobileJspPath=" + getNotNull(__mobilePath),
					url: "${LUI_ContextPath}/sys/zone/sys_zone_page_template/sysZonePageTemplate.do?method=updateTemplate",
					dataType: "json",
					success: function(data){
						if(data != null && data.success == true){
							alert("操作成功！");
						}
					}
				});
			});
		}
		function getNotNull(value){
			if(null == value){
				return "";
			}
			return value;
		}
		</script>		
	</template:replace>
	
</template:include>