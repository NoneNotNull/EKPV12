<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
 
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp" %>
<%
 
%>
<link rel="shortcut icon" href="${kmsResourcePath }/favicon.ico"> 
<link href="${kmsThemePath }/public.css" rel="stylesheet" type="text/css" />
<link href="${kmsThemePath }/navi_selector.css" rel="stylesheet" type="text/css" />
 
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
 
	<table class="tb_normals" border="1" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td class="td_normal_title">
				<bean:message key="sysReadLog.showText.readerList" bundle="sys-readlog" />
			</td>
			<td>
				<img id="listSrc" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" onclick="expandMethod('listSrc','readerList')" style="cursor:hand"><br>
				<div id="readerList"  style="display:none">
					<c:out value="${sysReadLogForm.fdReaderNameList}" />
				</div>
			</td>
		</tr>
		<tr>
			<td width="15%" class="td_normal_title"><bean:message key="sysReadLog.readRecord" bundle="sys-readlog" /> </td>	
			<td width="85%" >
				<img id="viewSrc" src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0" onclick="expandMethod('viewSrc','readlogDiv')" style="cursor:hand"><br>
				<div id="readlogDiv" style="display:none">
						
			<c:if test="${queryPage.totalrows ne 0 }">
				<table id="List_ViewTabless" class="t_b" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
		 
				<td width="10pt" class="t_b_b">
					NO.
				</td>

				<td>
					<bean:message key="sysReadLog.fdReaderId" bundle="sys-readlog" />
				</td>
				<td>
					<bean:message key="sysReadLog.fdReadTime" bundle="sys-readlog" />
				</td>
				<td>
					<bean:message bundle="sys-organization" key="sysOrgElement.dept" />
				</td>
				<td >
					<bean:message key="sysReadLog.fdReadType" bundle="sys-readlog" />			
				</td>
			 
		</tr>
		<c:forEach items="${queryPage.list}" var="sysReadLog" varStatus="vstatus">
			<c:choose>
                <c:when test="${vstatus.index%2==0}">
   				 <tr >
                </c:when>
                <c:otherwise>
                <tr class='t_b_a' >
                </c:otherwise>
            </c:choose>
				<td >
					${vstatus.index+1}
				</td>
				<td >
					<c:out value="${sysReadLog.fdReader.fdName}" />
				</td>
				<td >
					<kmss:showDate value="${sysReadLog.fdReadTime}" type="datetime" />
				</td>
				<td >
					<kmss:showText value="${sysReadLog.fdReader.fdParent.fdName}" />
				</td>
				<td  >
					<c:if test="${sysReadLog.readType==1}">
						<bean:message key="sysReadLog.fdReadType.process" bundle="sys-readlog" />
					</c:if>
					<c:if test="${sysReadLog.readType!=1}">
						<bean:message key="sysReadLog.fdReadType.publish" bundle="sys-readlog" />
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
			<c:set var="tableClass" value="class='tb_noborder'"/>
			<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
		</c:if>		
				</div>
			</td>
		</tr>
	</table>
 
<script>
function expandMethod(imgSrc,divSrc) {
	var imgSrcObj = document.getElementById(imgSrc);
	var divSrcObj = document.getElementById(divSrc);
	if(divSrcObj.style.display!=null && divSrcObj.style.display!="") {
		divSrcObj.style.display = "";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
		setParentDisFlag(divSrc,"true");
	}else{
		divSrcObj.style.display = "none";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
		setParentDisFlag(divSrc,"false");
	}
	iframeAutoFit();
}
 
 function setParentDisFlag(elMidName,elValue){
 	var elName = "_"+elMidName+"DisFlag";
 	var el = parent.document.getElementById(elName);
 	el.value = elValue;
 }
 function resetDivDisplay(){
 	var imgNames = ["listSrc","viewSrc"];
 	var divNames=["readerList","readlogDiv"];
 	for(var i=0;i<imgNames.length;i++){
	 	var elName = "_"+divNames[i]+"DisFlag";
 		var el = parent.document.getElementById(elName);
 		var imgSrcObj = document.getElementById(imgNames[i]);
		var divSrcObj = document.getElementById(divNames[i]);
 		if(el.value=="true"){
 			divSrcObj.style.display = "";
			imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
 		}else{
 			divSrcObj.style.display = "none";
			imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
 		}
 	}
 }
 
 function iframeAutoFit(){
 	try{
    	if(window!=parent){
        	var a = parent.document.getElementsByTagName("IFRAME");
            for(var i=0; i<a.length; i++){
            	if(a[i].contentWindow==window){
                	var h1=0, h2=0;
                    a[i].parentNode.style.height = a[i].offsetHeight +"px";
                    a[i].style.height = "0px";
                    if(document.documentElement&&document.documentElement.scrollHeight){
                    	h1=document.documentElement.scrollHeight;
                    }
                    if(document.body) h2=document.body.scrollHeight;
                    var h=Math.max(h1, h2);
                    if(document.all) {h += 4;}
                    if(window.opera) {h += 1;}
                    a[i].style.height = a[i].parentNode.style.height = h +"px";
                 }
             }
         }
     } catch (ex){}
 }
 window.onload = function() {
 	resetDivDisplay();
 	setTimeout(iframeAutoFit, "200");
 	expandMethod("listSrc","readerList");
 };
 //Com_AttachLKSEvent("onload",  iframeAutoFit);

</script>
<%@ include file="/resource/jsp/list_down.jsp"%>