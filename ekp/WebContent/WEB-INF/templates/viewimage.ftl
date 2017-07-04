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
	  	                 <#assign colspan = "">
	  	                <#if listProperty_index gte 12>
	  	                    <#if listProperty_index%2=1>
	  	                     <#assign colspan = " colspan=3 ">
	  	                    </#if> 
	  	                </#if>	
	             	    <#if listProperty_index=0>
               	          <tr>
	                    </#if>	

	                     <td class="td_normal_title" width=15%>
                         		<bean:message  bundle="hr-organization" key="${listProperty.messageKey}"/>
                    	 </td> 

                   	    <#if listProperty.type="String">
                          <td ${colspan} width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if>
                        
                   	    <#if listProperty.type="Long">
                           <#if listProperty.enumType=="">
                               <td ${colspan} width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td ${colspan} width=35%><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>                   	    
                        </#if>
                        
                   	    <#if listProperty.type="Date">
                          <td ${colspan} width=35%><sunbor:date value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if>  
                        
                   	    <#if listProperty.type="DateTime">
                          <td ${colspan} width=35%><sunbor:date value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                        </#if> 

                   	    <#if listProperty.type="Integer">  
                           <#if listProperty.enumType=="">
                               <td ${colspan} width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td ${colspan} width=35%><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>
                          </#if>                     	    
                        </#if>
                        
                   	    <#if listProperty.type="Boolean">
                   	       <#if listProperty.enumType=="">
                             <td ${colspan} width=35%><c:out value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" /></td>
                           <#else>
                             <td ${colspan} width=35%><sunbor:enumsShow bundle="hr-organization"
								value="${r"${hrOrgPerson."}${listProperty.name}${r"}"}" enumsType="${listProperty.enumType}" /></td>  
                          </#if>
                        </#if>                        
                        
                        <#if listProperty.type!="Integer" && listProperty.type!="DateTime" && listProperty.type!="Date" &&  listProperty.type!="Long" && listProperty.type!="String" && listProperty.type!="Boolean">
                            <td  ${colspan} width=35%>
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
                        
                        <#if listProperty_index=1>
                        	<td width="20%" rowspan="6">
							   <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp">
                               <c:param name="fdKey" value="spic"/>
                				<c:param name="fdAttType" value="pic"/>
				            	<c:param name="fdMulti" value="false"/>
            					<c:param name="fdShowMsg" value="false"/>
			            		<c:param name="fdImgHtmlProperty" value="width=100 height=130"/>
            					<c:param name="fdModelId" value="${r"${param.fdId }"}"/>
			            		<c:param name="formBeanName" value="hrOrgPersonForm"/>
						        <c:param name="fdModelName"	value="com.landray.kmss.hr.organization.model.HrOrgPerson" />
						        <c:param name="fdImgHtmlProperty" value="width=100 height=100"/>	
					            </c:import>
						     </td>                                                                                                                       
	                    </#if>
	                                            
                        <#if listProperty_index%2=1>
             	          </tr><tr>
	                    </#if>
	                    
                    </#list>
 
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>