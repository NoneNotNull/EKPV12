<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/hr/organization/hr_org_person/hrOrgPerson.do?method=delete&fdId=${r"${param.fdId}"}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('hrOrgPerson.do?method=delete&fdId=${r"${param.fdId}"}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="hr-organization" key="table.hrOrgPerson.card"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="hrOrgPersonForm" property="fdId"/>


	
	  	            <#list  listProperty  as listProperty>
	             	    <#if listProperty_index=0>
               	          <tr>
	                    </#if>	

	                     <td class="td_normal_title" width=15%>
                         		<bean:message  bundle="hr-organization" key="${listProperty.messageKey}"/>
                    	 </td> 

                   	    <#if listProperty.type="String">
                          <td width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if>
                        
                   	    <#if listProperty.type="Long">
                           <#if listProperty.enumType=="">
                               <td width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td width=35%><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>                   	    
                        </#if>
                        
                   	    <#if listProperty.type="Date">
                          <td width=35%><sunbor:date value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if>  
                        
                   	    <#if listProperty.type="DateTime">
                          <td width=35%><sunbor:date value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if> 

                   	    <#if listProperty.type="Integer">  
                           <#if listProperty.enumType=="">
                               <td width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td width=35%><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>                     	    
                        </#if>
                        
                   	    <#if listProperty.type="Boolean">
                   	       <#if listProperty.enumType=="">
                             <td width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td width=35%><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>  
                          </#if>
                        </#if>                        
                        
                        <#if listProperty.type!="Integer" && listProperty.type!="DateTime" && listProperty.type!="Date" &&  listProperty.type!="Long" && listProperty.type!="String" && listProperty.type!="Boolean">
                           <td width=35%>
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
                        
                        <#if listProperty_index%2=1>
             	          </tr><tr>
	                    </#if>
	                    
                    </#list>
 
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>