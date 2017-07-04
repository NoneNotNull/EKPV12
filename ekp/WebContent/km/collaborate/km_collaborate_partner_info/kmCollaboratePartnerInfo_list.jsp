<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style>
<!--
    .atten{ width:16px; height:16px; background:url('../img/gz_n.png')}
    .atten_fasle{ width:16px; height:16px; background:url('../img/gz_n.png')}

-->
</style>
<script type="text/javascript">
   Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">

/****
   异步提交文档关注/ 取消关注功能
 **/
$(document).ready(function(){
	
	setTimeout(dyniFrameSize,100);
	
});
function getEvent(event){
	return event || window.event;
}
function getTarget(event){
    event=getEvent(event);
	var source=event.target|| event.srcElement;
	return source;
}
function stopPropagation(event){
	event=event ||getEvent(event);
	if(event.stopPropagation)
		 event.stopPropagation();
	else 
		event.cancelBubble=true;
	
	
}
function ajaxAtten(event,fdId){
	     var attenSrc="gz_y.png";
	     var disAttenSrc="gz_n.png";
   	     event = event|| window.event;
   	     var target= getTarget(event);
   	     var src=target.src;
   	     var flag="";
   	     if(src.indexOf(attenSrc)!=-1) {
   	    	flag="cancleAttention";
   	    	
   	     }
   	     else if(src.indexOf(disAttenSrc)!=-1) {
   	    	flag="attention";
   	    	
   	     }
   	     var url="../km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=isRead&flag="+flag+"&docid="+fdId;
   	     
   	      $.get(url,function(data){
   	    	   if(data.indexOf("true")){
   	    		if(src.indexOf(attenSrc)!=-1) {
   	    	    	target.src=src.replace(attenSrc,disAttenSrc) ;
   	    	    	target.alt="<bean:message key='kmCollaborate.jsp.signToAtt' bundle='km-collaborate' />";
   	    	    	alert("<bean:message key='kmCollaborate.jsp.calcelAtt.success' bundle='km-collaborate' />");
   	    	     }
   	    	     else if(src.indexOf(disAttenSrc)!=-1) {
   	    	    	target.src=src.replace(disAttenSrc,attenSrc) ;
   	    	    	target.alt="<bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate' />";
   	    	    	alert("<bean:message key='kmCollaborate.jsp.attention.success' bundle='km-collaborate' />");
   	    	     }
   	    		   
   	    	   }
   	    	   else{
   	    		   
   	    		alert("<bean:message key='kmCollaborate.jsp.modify.failure' bundle='km-collaborate' />");
   	    	   }
   	    	 
   	     }); 
   
   	   stopPropagation(event);
   	
   	
   	
   }
 
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById("result");
		
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			if(${queryPage.totalrows}==0){
				window.frameElement.style.height ="500px";
			}else{
			window.frameElement.style.height = (arguObj.offsetHeight + 100) + "px";
			}
		}
	  } catch(e) {
	}
}

function Km_DeleteAll(){
	/**
	 var cBox=document.getElementsByName("List_Selected");
	  var docIds="";
	    for(var i=0;i<cBox.length;i++)
	    	if(cBox[i].checked)
	    		{
	    		   if(docIds=="") docIds=cBox[i].value;
	    		   else 
	    			   docIds +=";"+cBox[i].value;
	    		}
	    if(docIds==""){
	    	alert("<bean:message key='kmCollaborate.jsp.confirm.select' bundle='km-collaborate'/>");
	    	return;
	    }
	    var url_="<c:url value='/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=deleteall&docIds=' />"+docIds;
	    Com_OpenWindow(url_,"_self");
	    */
		if(List_ConfirmDel())
			Com_Submit(document.kmCollaboratePartnerInfoForm, 'deleteall');
	    
}
//-->
</script>

<html:form action="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do">
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
<div id="result">
<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<td width="10pt">
					<img   src="../img/yj_yd.png" style="margin:6px 0 0 0;">
				</td>
				<td width="10pt">
					<img   src="../img/gt.png" style="margin:4px 0 0 0;">
				</td>
				<td width="10pt">
					<img   src="../img/fjh.png"  style="margin:4px 0 0 0;">
				</td>
				
				<sunbor:column property="kmCollaboratePartnerInfo.fdCommunicationMain.docSubject">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmCollaboratePartnerInfo.fdCommunicationMain.fdCategory">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/>
				</sunbor:column>
				<sunbor:column property="kmCollaboratePartnerInfo.fdCommunicationMain.docCreator">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmCollaboratePartnerInfo.fdCommunicationMain.docReadCount">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docReadCount"/>
				</sunbor:column>
				<sunbor:column property="kmCollaboratePartnerInfo.fdCommunicationMain.docReplyCount">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docReplyCount"/>
				</sunbor:column>
				<sunbor:column property="kmCollaboratePartnerInfo.fdCommunicationMain.docCreateTime">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/>
				</sunbor:column>
				<td width="50pt" align="center">
					<center><bean:message key='kmCollaborate.jsp.attention' bundle='km-collaborate' /></center>
				</td>
			
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCollaboratePartnerInfo" varStatus="vstatus">
			<tr style="<c:if test='${!kmCollaboratePartnerInfo.fdIsLook }'>font-weight:bold;</c:if>"
				kmss_href="<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=view&fdId=${kmCollaboratePartnerInfo.fdCommunicationMain.fdId}">
				<td>
				  
					<input type="checkbox" name="List_Selected" value="${kmCollaboratePartnerInfo.fdCommunicationMain.fdId}">
				</td>
				<td><center>${vstatus.index+1}</center></td>
				<td width="10pt">
				      <c:if test="${kmCollaboratePartnerInfo.fdIsLook }" >
					    <img  src="../img/yj_yd.png">
					  </c:if>
					   <c:if test="${!kmCollaboratePartnerInfo.fdIsLook }" >
					    <img  src="../img/yj_wd.png">
					  </c:if>
				</td>
				<td width="10pt">
				   <c:if test="${kmCollaboratePartnerInfo.fdCommunicationMain.fdIsPriority }">
					   <img  src="../img/gt_zy.png" >
				   </c:if>
				   <c:if test="${!kmCollaboratePartnerInfo.fdCommunicationMain.fdIsPriority }">
				       &nbsp;
				   </c:if>
				</td>
				<td width="10pt">
				   <c:if test="${kmCollaboratePartnerInfo.fdCommunicationMain.fdHasAttachment}">
				       <img  src="../img/fjh.png">
				   </c:if>
				
				</td>
				<td  align="left" style="text-align:left;">
				    <c:if test="${kmCollaboratePartnerInfo.fdCommunicationMain.docStatus==40 }">
					<img src="../img/end.gif" border="0">
				    </c:if>
					 <c:out value="${kmCollaboratePartnerInfo.fdCommunicationMain.docSubject}" />
				</td>
				<td width="180pt"><center>
					<c:out value="${kmCollaboratePartnerInfo.fdCommunicationMain.fdCategory.fdName}" /></center>
				</td>
				<td width="80pt"><center>
					<c:out value="${kmCollaboratePartnerInfo.fdCommunicationMain.docCreator.fdName}" /></center>
				</td>
				<td width="80pt"><center>
				<c:if test="${kmCollaboratePartnerInfo.fdCommunicationMain.docReadCount==null}">
				0
				</c:if>
					<c:out value="${kmCollaboratePartnerInfo.fdCommunicationMain.docReadCount}" /></center>
				</td>
				<td width="80pt"><center>
				<c:if test="${kmCollaboratePartnerInfo.fdCommunicationMain.docReplyCount==null}">
				0
				</c:if>
					<c:out value="${kmCollaboratePartnerInfo.fdCommunicationMain.docReplyCount}" /></center>
				</td>
				<td width="120pt"><center>
					<kmss:showDate value="${kmCollaboratePartnerInfo.fdCommunicationMain.docCreateTime}" /></center>
				</td>
			    <td><center>			          
					 <c:if test="${!kmCollaboratePartnerInfo.fdIsFollow }" >
				          <img  alt="<bean:message key='kmCollaborate.jsp.signToAtt' bundle='km-collaborate' />" src="../img/gz_n.png" onclick="ajaxAtten(event,'${kmCollaboratePartnerInfo.fdCommunicationMain.fdId}')">
				    </c:if>
				     <c:if test="${kmCollaboratePartnerInfo.fdIsFollow }" >
				          <img alt="<bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate' />" src="../img/gz_y.png" onclick="ajaxAtten(event,'${kmCollaboratePartnerInfo.fdCommunicationMain.fdId}')">
				    </c:if>
				    </center>
				</td>
			</tr>
		</c:forEach>
		
	</table>

	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
	</div>
</c:if>
</html:form>
<div style="display:none;">
		   <img src="../img/gz_n.png" >
		     <img src="../img/gz_y.png" >
</div>
<%@ include file="/resource/jsp/list_down.jsp"%>