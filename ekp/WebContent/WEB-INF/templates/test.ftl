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
		<kmss:auth requestURL="/hr/organization/hr_org_person/hrOrgPerson.do?method=edit&fdId=${r"${param.fdId}"}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('hrOrgPerson.do?method=edit&fdId=${r"${param.fdId}"}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/hr/organization/hr_org_person/hrOrgPerson.do?method=delete&fdId=${r"${param.fdId}"}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('hrOrgPerson.do?method=delete&fdId=${r"${param.fdId}"}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="hr-organization" key="table.hrOrgPerson"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="hrOrgPersonForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="hr-organization" key="hrOrgPerson.fdNo"/>
		</td><td width=35%>
			<bean:write name="hrOrgPersonForm" property="fdOrder"/>
		</td>
		<td class="td_normal_title" width=15%>
			
		</td><td width=35%>
			
		</td>
	</tr>
	
    
	             	<#list  listProperty  as listProperty>
	             	    <#if listProperty_index=0>
               	          <tr>
	                    </#if>	
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
                               <td>c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
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
                          <td><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r".fdName}"}" /></td>
                        </#if>                                                                                                                          
                        
                        <#if listProperty_index%2=0>
             	          </tr><tr>
	                    </#if>
                    </#list>    
 
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>