<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
   Com_IncludeFile("jquery.js");
</script>

<script type="text/javascript">
<!--
 $(document).ready(function(){
	 
	 $("#del_button").click(function(){
	  	  if(!window.confirm("你<bean:message key='kmCollaborate.jsp.confirm.delete.seleteData' bundle='km-collaborate' />"))
	  		   return;
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
		    	alert("<bean:message key='kmCollaborate.jsp.confirm.select' bundle='km-collaborate' />");
		    	return;
		    }
		    var url="../km_collaborate_main/kmCollaborateMain.do?method=deleteall&docIds="+docIds;
		 
		    $.post(url,function(data){
		    	
		    	  if(data.indexOf("true")>-1){		    		 
		    		  alert("<bean:message key='kmCollaborate.jsp.del.success' bundle='km-collaborate' />");
		    		 window.location.reload();
		    	  }else{
		    		  alert("<bean:message key='kmCollaborate.jsp.del.failure' bundle='km-collaborate' />");
		    	  }		    	  		    		   		    	
		    });		    		 
	  });
	 
 });


//-->
</script>

<html:form action="/km/collaborate/km_collaborate_main/kmCollaborateMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
			<input id="del_button" type="button" value="<bean:message key="button.delete"/>"/>
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
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
					<img   src="../img/gt.png" style="margin:4px 0 0 0;width:13px;height:13px;">
				</td>
				<td width="10pt">
					<img   src="../img/fjh.png"  style="margin:4px 0 0 0;width:13px;height:13px;">
				</td>
				
				<sunbor:column property="kmCollaborateMain.docSubject">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.fdCategory.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdCategory"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.docCreator.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="kmCollaborateMain.docCreateTime">
					<bean:message bundle="km-collaborate" key="kmCollaborateMain.docCreateTime"/>
				</sunbor:column>
			
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCollaborateMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=view&fdId=${kmCollaborateMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCollaborateMain.fdId}">
				</td>
				<td>
					<center>${vstatus.index+1}</center>
				</td>
				<td width="10pt">
				   <c:if test="${kmCollaborateMain.fdIsPriority }">
					   <img  src="../img/gt_zy.png" width="13px" height="13px">
				   </c:if>
				   <c:if test="${!kmCollaborateMain.fdIsPriority }">
				       &nbsp;
				   </c:if>
				</td>
				<td width="10pt">
				  <c:if test="${kmCollaborateMain.fdHasAttachment }">
				       <img style="width:13px; height:13px;"  src="../img/fj.png">
				   </c:if>
				
				</td>
				<td>
					<c:out value="${kmCollaborateMain.docSubject}" />
				</td>
				<td width="180pt"><center>
					<c:out value="${kmCollaborateMain.fdCategory.fdName}" /></center>
				</td>
				<td width="80pt"><center>
					<c:out value="${kmCollaborateMain.docCreator.fdName}" /></center>
				</td>
				<td width="120pt"><center>
					<kmss:showDate value="${kmCollaborateMain.docCreateTime}" /></center>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>