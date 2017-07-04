<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<c:set var="validateAuth" value="false" />
<kmss:auth requestURL="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do?method=delete&fdModelName=${param.fdModelName}&fdModelId=${param.fdModelId}" requestMethod="GET">
	<c:set var="validateAuth" value="true" />
</kmss:auth>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">
function resizeParent(){
	try {
		// 调整高度
		var arguObj = document.forms[0];
		if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch(e) {
	}
}
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
Com_AddEventListener(window,"load",function(){
	setTimeout("resizeParent();", 100);
});

function deleteEvaluationNum() {
	var iframeObj, parentObj;
	if (window.frameElement != null && window.frameElement.tagName == "IFRAME") {
		// 获取当前iframe
		iframeObj = window.frameElement;
		parentObj = $(iframeObj).parents("tr[LKS_LabelIndex]");
	}
	if (parentObj.length > 0) {
		// 标签table
		var tableId = parentObj.parents('table[LKS_CurrentLabel]').attr("id");
		// 当前索引
		var indexInt = parentObj.attr("LKS_LabelIndex");
		// 当前标签input
		var inpObj = $(parent.document).find(["#", tableId, "_Label_Btn_", indexInt].join(''));
		// 更新input中小括号中的值
		var label = inpObj.val(),
			num = label.match(/\([^\)]+\)/);
		num = num[0].substring(1, num[0].length-1);
		if (num > 1) {
			label = label.replace(/\([^\)]+\)/, '(' + (num - 1) + ')');
		} else {
			label = label.replace(/\([^\)]+\)/, '');
		}
		inpObj.val(label);
	}
}
</script>
<html:form action="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do">
	<table class="tb_noborder" width="100%">
		<tr>
			<td>
				<c:if test="${isSuccess=='true'}">
					<p class="txtstrong">
					<center>
						<bean:message key="return.optSuccess" />
					</center>
					</p>
				</c:if>
			</td>
		</tr>
	</table>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {%>
	<center>
		<bean:message key="sysEvaluationMain.showText.noneRecord" bundle="sys-evaluation" />
	</center>
	<%} else {%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="40pt">
					<bean:message key="page.serial" />
				</td>

				<sunbor:column property="sysEvaluationMain.fdEvaluationContent">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationContent" />
				</sunbor:column>
				<sunbor:column property="sysEvaluationMain.fdEvaluationScore">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationScore" />
				</sunbor:column>
				<sunbor:column property="sysEvaluationMain.fdEvaluator">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.sysEvaluator" />
				</sunbor:column>
				<sunbor:column property="sysEvaluationMain.fdEvaluationTime">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationTime" />
				</sunbor:column>
				<c:if test="${validateAuth=='true'}">
					<td>
						&nbsp;
					</td>
				</c:if>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysEvaluationMain" varStatus="vstatus">
			<tr kmss_href="<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do" />?method=view&fdId=${sysEvaluationMain.fdId}" kmss_target="_blank">
				<td>
					${vstatus.index+1}
				</td>
				<td width="60%" style="text-align:left">
					<c:out value="${sysEvaluationMain.fdEvaluationContent}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysEvaluationMain.fdEvaluationScore}" enumsType="sysEvaluation_Score"/>
				</td>
				<td>
					<c:out value="${sysEvaluationMain.fdEvaluator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysEvaluationMain.fdEvaluationTime}" type="date" />
				</td>
				<c:if test="${validateAuth=='true'}">
					<td>
						<a href="#" onClick="if(!confirmDelete())return;Com_OpenWindow('<c:url value="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do"/>?method=delete&fdId=${sysEvaluationMain.fdId}&fdModelId=${sysEvaluationMain.fdModelId}&fdModelName=${sysEvaluationMain.fdModelName}','_self');deleteEvaluationNum();"><bean:message key="button.delete" /></a>
					</td>
				</c:if>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
