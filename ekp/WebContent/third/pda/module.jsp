<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.AutoArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.third.pda.forms.PdaModuleConfigMainForm"%>
<%@page import="com.landray.kmss.third.pda.forms.PdaModuleLabelListForm"%>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
	<script type="text/javascript" src="<c:url value="/third/pda/resource/script/list.js"/>">
	</script>
	<% 
		PdaModuleConfigMainForm moduleForm=(PdaModuleConfigMainForm)request.getAttribute("pdaModuleConfigMainForm");
		session.setAttribute("S_CurModule",moduleForm.getFdId());
		session.setAttribute("S_CurModuleName",moduleForm.getFdName());
		PdaRowsPerPageConfig pdaRow=new PdaRowsPerPageConfig();
	    String rowsize=pdaRow.getFdRowsNumber();
	    ArrayList<PdaModuleLabelListForm> fdLabelList = moduleForm.getFdLabelList();
	    if(fdLabelList!=null && fdLabelList.size()>0){
	    	for(int i=0;i<fdLabelList.size();i++){
	    		PdaModuleLabelListForm labelList = (PdaModuleLabelListForm)fdLabelList.get(i);
		    	String fdCreateUrlAll = PdaFlagUtil.formatUrl(request,labelList.getFdCreateUrl());
		    	String fdCountUrlAll = PdaFlagUtil.formatUrl(request,labelList.getFdCountUrl());
		    	String fdDataUrlAll = PdaFlagUtil.formatUrl(request,labelList.getFdDataUrl());
		    	labelList.setFdCreateUrl(fdCreateUrlAll);
		    	labelList.setFdCountUrl(fdCountUrlAll);
		    	labelList.setFdDataUrl(fdDataUrlAll);
		    }	
	    }
	%>
	<title>${pdaModuleConfigMainForm.fdName}</title>
</head>
<body>
<c:import charEncoding="UTF-8" url="/third/pda/banner.jsp">
	<c:param name="fdNeedHome" value="true"/>
	<c:param name="fdNeedNav" value="true" />
	<c:param name="fdNeedOtherInfo" value="true"/>
</c:import>
	<%-- 标签部分--%>
	<c:set var="labelSize"
		value="<%=moduleForm.getFdLabelList().size()%>" />
	<c:set var="labelList" value="${pdaModuleConfigMainForm.fdLabelList}" />
	<center>
		<c:choose>
			<c:when test="${labelSize > 1}">
				<div class="div_labelStyle" id="div_labelArea">
					<div class="div_labLeft" id="div_LabExpandLeft" onclick="labTurnToLeft();"></div>
					<div id="lab_group" class="div_listlabel">
						<c:forEach var="labelData" items="${labelList}" varStatus="vStatus">
							<div id="li_${labelData.fdId}"
								class="<c:out value="${vStatus.index==0?'select_lab':''}"/>" 
								onclick="changeShowData('${labelData.fdId}','${labelData.fdIsLink}');">
								<label>
									<c:choose>
										<c:when test="${fn:length(labelData.fdName)>5}">${fn:substring(labelData.fdName,0,4)}..</c:when>
										<c:otherwise>${labelData.fdName}</c:otherwise>
									</c:choose>
								</label>
							</div>
						</c:forEach>
					</div>
					<div class="div_labRight" id="div_LabExpandRight" onclick="labTurnToRight();"></div>
				</div>
			</c:when>
			<c:when test="${labelSize < 1}">
				<div class="lab_errorinfo"><bean:message key="phone.module.laberror" bundle="third-pda"/></div>
			</c:when>
		</c:choose>
		<c:if test="${labelSize > 0}">
			<%-- 视图数据部分 --%>
			<div id="div_view" class="div_view"></div>
			<div id="div_loading" class="div_loading"><bean:message key="phone.list.loading" bundle="third-pda"/></div>
			<%-- 分页显示部分 --%>
			<div id="div_page" class="div_page" onclick="gotoPage('next');">
				<bean:message key="phone.list.more" bundle="third-pda"/>
			</div>
		
			<%-- 请求数据信息返回 --%>
			<c:set var="labelData" value="${labelList[0]}" />
			<script type="text/javascript">
				<c:forEach var="tmpLabelData" items="${labelList}" varStatus="vStatus">
					addLabelInfo("${tmpLabelData.fdId}","${tmpLabelData.fdDataUrl}","${tmpLabelData.fdCreateUrl}");
				</c:forEach>
				
				var S_RowSize="<%=rowsize==null?"":rowsize%>";
				
				function moduleOnload(){
					var labelId= GetCookie("${pdaModuleConfigMainForm.fdId}_labelId");
					if(labelId==null){
						labelId = '${labelData.fdId}';
					}
					showLabel(labelId);
					changeShowData(labelId);
				}
				
				function moduleOnUnload(){
					if(S_CurrentLabelId !=null && S_CurrentLabelId!='')
						writeCookie("${pdaModuleConfigMainForm.fdId}_labelId",S_CurrentLabelId);
				}
				
				Com_AddEventListener(window,"load",moduleOnload);
				if("onpagehide" in window){
					Com_AddEventListener(window,"pagehide",moduleOnUnload);
				}else if("onunload" in window){
					Com_AddEventListener(window,"unload",moduleOnUnload);
				}
			</script>
		</c:if>
	</center>
</body>
</html>