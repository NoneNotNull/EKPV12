<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/iframe_top.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("optbar.js|list.js");
	function iframeAutoFit(){
	 	try{
		 	var arguObj = document.getElementsByTagName("table")[0];
    		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
    			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
    		}
	     } catch (ex){}
	 }
	window.onload=function(){
		iframeAutoFit();
	};
</script>
</head>
<body>
	<table class="tb_normal" width=100%>
		<tr>
			<td width="15%" class="td_normal_title"><bean:message key="table.kmSmissiveCirculation" bundle="km-smissive" /></td>	
			<td width="85%">
				<c:if test="${empty circulationList}">
					<bean:message key="kmSmissiveMain.circulate.nolog" bundle="km-smissive" />
				</c:if>
				<c:if test="${not empty circulationList}">
					<table class="tb_normal" width=100%>
						<c:forEach items="${circulationList}" var="circulationLog" varStatus="vstatus">
							<tr><td>
							<kmss:showDate value="${circulationLog.docCreateTime }" type="datetime" />
							${circulationLog.docCreator.fdName }
							<bean:message key="kmSmissiveMain.circulate.record1" bundle="km-smissive" />
							${circulationLog.fdCirculationNames }
							<br>
							<bean:message key="kmSmissiveMain.circulate.record2" bundle="km-smissive" />
							${circulationLog.docSubject}
							</td></tr>
						</c:forEach>
					
					</table>
				</c:if>
			</td>
		</tr>
	</table>
</body>
</html>

