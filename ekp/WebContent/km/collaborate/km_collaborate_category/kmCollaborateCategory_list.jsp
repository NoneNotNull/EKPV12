<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
   Com_IncludeFile("jquery.js|dialog.js");
</script>
<script type="text/javascript">
<!--
 $(document).ready(function(){
	 $("#del_button").click(function(){
	  	  if(!window.confirm("您真的要删除所选记录吗？"))
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
		    	alert("请选择需要修改的数据");
		    	return;
		    }
		    var url="<c:url value = '/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=deleteall&docIds='/>"+docIds;
		    window.location.href=url;
		    /* 
		    $.post(url,function(data){
		    	  if(data.indexOf("true")>-1){		    		 
		    		  alert("删除成功");
		    		 window.location.reload();
		    	  }else{
		    		  alert("分类中存在工作沟通文档，删除失败");
		    	  }		    	  		    		   		    	
		    });    */		 
	  });
	 
 });

function selectCategory(){
	if(!window.confirm('<bean:message  bundle="km-collaborate" key="kmCollaborateCategory.change.confirm"/>'))
		   return;
	
	var cBox=document.getElementsByName("List_Selected");
	var cateIds="";
	
	for(var i=0;i<cBox.length;i++){
		if(!(cBox[i].checked)) continue;
		if(cateIds=="") cateIds=cBox[i].value;
		else cateIds+=";"+cBox[i].value;
	}
	
	if(cateIds=="" || cateIds==null) 
	{
		alert('<bean:message  bundle="km-collaborate" key="kmCollaborateCategory.change.select"/>');
		return;
	}
	 Dialog_Tree(false,null,null,null,'kmCollaborateCategoryTreeService&parentId=!{value}',
			'<bean:message  bundle="km-collaborate" key="table.kmCollaborateCategory"/>',null,afterSelectCategory,null); 
	
}
function afterSelectCategory(rtnVal){
	 
	if(rtnVal!=null && rtnVal.GetHashMapArray()[0] != null){
	
			var fdTemplateId=rtnVal.GetHashMapArray()[0].id;
			var cBox=document.getElementsByName("List_Selected");
			var cateIds="";
			
			for(var i=0;i<cBox.length;i++){
				if(!(cBox[i].checked)) continue;
				if(cateIds=="") cateIds=cBox[i].value;
				else cateIds+=";"+cBox[i].value;
			}
			var url="<c:url value='/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=transfer' />&cateId="+fdTemplateId+"&cateIds="+cateIds;

             setTimeout("location.href='"+url+"';", 100);
			
	 } 
	  
}




//-->
</script>

<html:form action="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=deleteall">
			<input id="del_button" type="button" value="<bean:message key="button.delete"/>" >
		</kmss:auth>
		<kmss:auth requestURL="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=transfer">
      	    <input type="button" value="<bean:message key="button.change" bundle="km-collaborate"/>"  onclick="selectCategory();"/>
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
				<sunbor:column property="kmCollaborateCategory.fdName">
					<bean:message bundle="km-collaborate" key="kmCollaborateCategory.fdName"/>
				</sunbor:column>
				
				<sunbor:column property="kmCollaborateCategory.fdDeleted">
					<bean:message bundle="km-collaborate" key="kmCollaborateCategory.fdDeleted"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmCollaborateCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do" />?method=view&fdId=${kmCollaborateCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmCollaborateCategory.fdId}">
				</td>
				<td style="text-align:center">
					${vstatus.index+1}
				</td>
				<td style="text-align:center">
					<c:out value="${kmCollaborateCategory.fdName}" />
				</td>
				
				<td style="text-align:center;width:100px;">
					<sunbor:enumsShow bundle="km-collaborate" value="${kmCollaborateCategory.fdDeleted}" enumsType="common_yesno" />
					<%-- <xform:radio value="${kmCollaborateCategory.fdDeleted}" property="fdDeleted" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio> --%>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>