<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
   Com_IncludeFile("jquery.js|dialog.js");
</script>
<script type="text/javascript">
	function check(){
		var Selected = document.forms[0].List_Selected;
		if (Selected == null){
			return false;
		}
		
		var optlength = Selected.length;
		if(optlength == null){
			return Selected.checked ;
		}
		
		for (var i=0; i<optlength;i++){
			if (Selected[i].checked){
				return true;
			}
		}
		return false;
	}
	
	function deleteall(){
		if(check()){
			var truthBeTold = window.confirm("<bean:message  bundle="km-comminfo" key="kmComminfo.changeToOther"/>");
			if (truthBeTold) {
				Com_Submit(document.kmComminfoCategoryForm, 'deleteall');
			}
		}else{
			window.alert("<bean:message  bundle="km-comminfo" key="kmComminfo.selectDelCategory"/>");
		}
	}

	function selectCategory(){
		if(!window.confirm('<bean:message  bundle="km-comminfo" key="kmComminfoCategory.change.confirm"/>'))
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
			alert('<bean:message  bundle="km-comminfo" key="kmComminfoCategory.change.select"/>');
			return;
		}
		Dialog_Tree(false,null,null,null,'kmComminfoCategoryTreeService&parentId=!{value}',
				'<bean:message  bundle="km-comminfo" key="kmComminfoCategory.fdId"/>',null,afterSelectCategory,null); 
		
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
				var url="<c:url value='/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=transfer' />&cateId="+fdTemplateId+"&cateIds="+cateIds;

	             setTimeout("location.href='"+url+"';", 100);
				
		 } 
		  
	}
</script>

<html:form action="/km/comminfo/km_comminfo_category/kmComminfoCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/comminfo/km_comminfo_category/kmComminfoCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="deleteall();" >
		</kmss:auth>
		<kmss:auth requestURL="/km/comminfo/km_comminfo_category/kmComminfoCategory.do?method=transfer">
      	    <input type="button" value="<bean:message key="button.change" bundle="km-comminfo"/>"  onclick="selectCategory();"/>
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
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="kmComminfoCategory.fdName">
					<bean:message  bundle="km-comminfo" key="kmComminfoCategory.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmComminfoCategory.fdOrder">
					<bean:message  bundle="km-comminfo" key="kmComminfoMain.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="kmComminfoCategory.docCreator.fdName">
					<bean:message  bundle="km-comminfo" key="kmComminfoCategory.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="kmComminfoCategory.docCreateTime">
					<bean:message  bundle="km-comminfo" key="kmComminfoCategory.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		
		<c:forEach items="${queryPage.list}" var="kmComminfoCategory" varStatus="vstatus">
			<tr kmss_href="<c:url value="/km/comminfo/km_comminfo_category/kmComminfoCategory.do" />?method=view&fdId=${kmComminfoCategory.fdId}">
				<td style="width: 10px">
					<input type="checkbox" name="List_Selected" value="${kmComminfoCategory.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${kmComminfoCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmComminfoCategory.fdOrder}" />
				</td>
				<td>
					<c:out value="${kmComminfoCategory.docCreator.fdName}" />
				</td>
				<td>
					 <kmss:showDate value="${kmComminfoCategory.docCreateTime}" type="datetime" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>