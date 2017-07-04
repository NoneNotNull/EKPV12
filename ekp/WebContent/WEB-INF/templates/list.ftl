<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script language="JavaScript">Com_IncludeFile("calendar.js|dialog.js");</script>
<%@ include file="/hr/organization/hr_org_person/hrOrgPerson_script.jsp"%>

<html:form action="/hr/organization/hr_org_person/hrOrgPerson.do" >
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.add"/>"
		onclick="Com_OpenWindow('<c:url value="/hr/organization/hr_org_person/hrOrgPerson.do" />?method=add');">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!List_ConfirmDel())return;Com_Submit(document.hrOrgPersonForm, 'deleteall');">
</div>		

	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
            
			<sunbor:columnHead htmlTag="td">
			
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>

                   	<#list  listProperty  as listProperty>
					   <sunbor:column property="hrOrgPerson.${listProperty.name}">
						   <bean:message bundle="hr-organization" key="${listProperty.messageKey}" />
					    </sunbor:column>
                    </#list> 
			   								
			</sunbor:columnHead>
		</tr>
		
		<c:forEach items="${r"${queryPage.list}"}" var="hrOrgPerson"
			varStatus="vstatus">
			<tr    
				kmss_href="<c:url value="/hr/organization/hr_org_person/hrOrgPerson.do" />?method=viewcard&fdId=${r"${hrOrgPerson.fdId}"}&parent=${r"${hrOrgPerson.fdParent.fdId}}"}">
     
				<td><input type="checkbox" name="List_Selected"
					value="${r"${hrOrgPerson.fdId}"}"></td>

                   	<#list  listProperty  as listProperty>
                   	    <#if listProperty.type="String">
                          <td><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if>
                        
                   	    <#if listProperty.type="Long">
                           <#if listProperty.enumType=="">
                               <td><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>                   	    
                        </#if>
                        
                   	    <#if listProperty.type="Date">
                          <td><sunbor:date value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if>  
                        
                   	    <#if listProperty.type="DateTime">
                          <td><sunbor:date value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if> 
                         
                   	    <#if listProperty.type="Integer">
                           <#if listProperty.enumType=="">
                               <td><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>                     	    
                        </#if>
                        
                   	    <#if listProperty.type="Boolean">
                   	       <#if listProperty.enumType=="">
                             <td><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>
                        </#if>                        
                        
                        <#if listProperty.type!="Integer" && listProperty.type!="DateTime" && listProperty.type!="Date" &&  listProperty.type!="Long" && listProperty.type!="String" && listProperty.type!="Boolean">
                             <td>
                             <#if listProperty.name="hbmPosts">
                        	 
                                <c:forEach items="${r"${hrOrgPerson.hbmPosts}"}" var="hrOrgPost" varStatus="vstatus">
                                  <c:if test="${r"${vstatus.index==0}"}">
						           <kmss:showProperty property="hrOrgPost.fdName" />
                                  </c:if> 
                                 <c:if test="${r"${vstatus.index>0}"}">
                                    ;<kmss:showProperty property="hrOrgPost.fdName" />
                                  </c:if> 
                                </c:forEach>
                             <#elseif listProperty.name="hbmPosts.fdOrgPostCate">  
                               <c:forEach items="${r"${hrOrgPerson.hbmPosts}"}" var="hrOrgPost" varStatus="vstatus">
                                  <c:if test="${r"${vstatus.index==0}"}">
						           <kmss:showProperty property="hrOrgPost.fdOrgPostCate.fdName" />
                                  </c:if> 
                                 <c:if test="${r"${vstatus.index>0}"}">
                                    ;<kmss:showProperty property="hrOrgPost.fdOrgPostCate.fdName" />
                                  </c:if> 
                                </c:forEach>
						     <#else>
                                <c:out value="${r"${hrOrgPerson."}${listProperty.name}${r".fdName}"}" />
                             </#if> 
                            </td>
                        </#if>                                                                                                                          
                    </#list>                     						
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
    %>
   <input type=hidden name="fdOutputTemplet" />
   <input type=hidden name="fdListId"  value="${r"${param.fdListId}"}"/>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
