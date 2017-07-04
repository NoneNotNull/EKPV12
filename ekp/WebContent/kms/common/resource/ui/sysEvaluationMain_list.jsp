<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp" %>
<style type="text/css" >
p{color: blue} 
.staron,.staroff,.starhalf{display:inline-block; background:url("<c:url value='/kms/multidoc/resource/img/star_on_16.png'/>") no-repeat; width:16px; height:16px; margin:0 !important;}
.staroff{background:url("<c:url value='/kms/multidoc/resource/img/star_off_16.png'/>") no-repeat;}
.starhalf{background:url("<c:url value='/kms/multidoc/resource/img/star_half_16.png'/>") no-repeat;}
</style>
<script type="text/javascript">
function resizeEvaluationParent(){
	var arguObj = document.forms[0];
	if(arguObj!=null && window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
		window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
	}
}

Com_AddEventListener(window,"load",function(){
	setTimeout("resizeEvaluationParent();", 100);
	var num='<%=((Page)request.getAttribute("queryPage")).getTotalrows()%>';
	self.parent.refreshEvaluationNum(num) ;
	self.parent.updatePage();
});

var staron= "<span class='staron'></span>" ;
var staroff="<span class='staroff'></span>" ;
function showStar(starOnNum,starOffNum)  {
	var starons="" ;
	var staroffs="" ;
	for(i=0;i<starOnNum;i++){
		starons=starons+staron;
	}  
	for(j=0;j<starOffNum;j++){
		staroffs=staroffs+staroff;
	} 
	return starons+staroffs  ;
} 

function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}

function selectDelete(fdId,fdModelId,fdModelName){
		showConfirm("<bean:message key='page.comfirmDelete'/>",function(){
	    	Com_OpenWindow("<c:url value='/kms/common/resource/ui/kmsSysEvaluationMain.do'/>?method=delete&fdId="+fdId+"&fdModelId="+fdModelId+"&fdModelName="+fdModelName,"_self");  
	    	self.parent.setUpdateMark(true);
		},true);
}
	 
</script>
<html:form action="/kms/common/resource/ui/kmsSysEvaluationMain.do">
	<table class="tb_noborders" border=0 width="100%">
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
	<table id="List_ViewEvaluationTable" class="t_b" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td width="5%" class="t_b_b">
				NO.
			</td>
			<td width="50%">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationContent" /> 
			</td>
			<td width="15%">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationScore" />
			</td>
			<td width="15%">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.sysEvaluator" />
			</td>
			<td class="t_b_c" width="10%">
				<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationTime" />
			</td>
			<td class="t_b_c" width="5%">
			</td>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysEvaluationMain" varStatus="vstatus">
		    <c:choose>
                <c:when test="${vstatus.index%2==0}">
   				 <tr kmss_href="<c:url value="/kms/common/resource/ui/kmsSysEvaluationMain.do" />?method=view&fdId=${sysEvaluationMain.fdId}" kmss_target="_blank"  >
                </c:when>
                <c:otherwise>
                 <tr kmss_href="<c:url value="/kms/common/resource/ui/kmsSysEvaluationMain.do" />?method=view&fdId=${sysEvaluationMain.fdId}" kmss_target="_blank" class='t_b_a' >
                </c:otherwise>
            </c:choose>
		 
				<td> 
					${vstatus.index+1}
				</td>
				<td kmss_wordlength="60" style="text-align:left">
					<c:out value="${sysEvaluationMain.fdEvaluationContent}" />
				</td>
				<td style="vertical-align:middle; text-align:center;" > 
					<script type="text/javascript">
						document.write(showStar('${5-sysEvaluationMain.fdEvaluationScore}','${sysEvaluationMain.fdEvaluationScore}' )) ;
					</script>
				</td>
				<td>
					<c:out value="${sysEvaluationMain.fdEvaluator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysEvaluationMain.fdEvaluationTime}" type="date" />
				</td>
				 
				<td>
				 <kmss:auth requestURL="/kms/common/resource/ui/kmsSysEvaluationMain.do?method=delete&fdModelName=${param.fdModelName}&fdModelId=${param.fdModelId}" requestMethod="GET">
					 <a href="javascript:void(0)" onclick="selectDelete('${sysEvaluationMain.fdId}','${sysEvaluationMain.fdModelId}','${sysEvaluationMain.fdModelName}')">
					 <bean:message key="button.delete" /></a>
				 </kmss:auth>
				</td>
				 
				 
			</tr>
		</c:forEach>
	</table> 
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	
	<%}%>

</html:form>
 
<%@ include file="/resource/jsp/list_down.jsp"%>
