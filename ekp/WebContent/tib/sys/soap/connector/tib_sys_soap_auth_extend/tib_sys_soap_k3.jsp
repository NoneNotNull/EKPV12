<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>

<xform:editShow>
<!-- k3登录方式 -->
	<tr id="k3Login_1" <c:if test="${tibSysSoapSettingForm.fdCheck eq 'false' || tibSysSoapSettingForm.fdAuthMethod!='k3Type'}">style="display: none"</c:if> >
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapAuth.k3FdUserName"/>
		</td>
		<c:if test="${tibSysSoapSettingForm.extendInfoList!=null}">
			<c:forEach items="${tibSysSoapSettingForm.extendInfoList}" var="currentObject" varStatus="vstatus">
				  <c:if test="${currentObject.key=='k3UserName' }">
				     <td width="35%">
					       <input type="text" name="k3UserName" value="${currentObject.value}" class="inputsgl"  style="width:85%" />
				     </td>
				  </c:if>
			</c:forEach>
		</c:if>
		
		<c:if test="${tibSysSoapSettingForm.extendInfoList==null}">
		       <td width="35%">
					 <input type="text" name="k3UserName" value="" class="inputsgl"  style="width:85%" />
			   </td>
		</c:if>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapAuth.k3FdPassword"/>
		</td>
		
		<c:if test="${tibSysSoapSettingForm.extendInfoList!=null}">
			<c:forEach items="${tibSysSoapSettingForm.extendInfoList}" var="currentObject" varStatus="vstatus">
				  <c:if test="${currentObject.key=='k3Password' }">
				     <td width="35%">
					       <input type="password" name="k3Password" value="${currentObject.value}" class="inputsgl"  style="width:85%" />
				     </td>
				  </c:if>
			</c:forEach>
		</c:if>
		
		<c:if test="${tibSysSoapSettingForm.extendInfoList==null}">
		       <td width="35%">
					 <input type="password" name="k3Password" value="" class="inputsgl"  style="width:85%" />
			   </td>
		</c:if>
	</tr>

	<tr id="k3Login_2" <c:if test="${tibSysSoapSettingForm.fdCheck eq 'false' || tibSysSoapSettingForm.fdAuthMethod!='k3Type'}">style="display: none"</c:if> >
		<td class="td_normal_title" width=15%>
				<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapAuth.k3FdIAisID"/>
		</td>
		
     <c:if test="${tibSysSoapSettingForm.extendInfoList!=null}">
	    <c:forEach items="${tibSysSoapSettingForm.extendInfoList}" var="currentObject3" varStatus="vstatus">
		   <c:if test="${currentObject3.key=='k3IAisID' }">
		      <td width="85%" colspan="3">
			          <input type="text" name="k3IAisID" value="${currentObject3.value}" class="inputsgl"  style="width:85%" />
			  </td>
		  </c:if>
	   </c:forEach>
	  </c:if>
	  
	  <c:if test="${tibSysSoapSettingForm.extendInfoList==null}">
		       <td width="85%" colspan="3">
					 <input type="text" name="k3IAisID" value="" class="inputsgl"  style="width:85%" />
			   </td>
	</c:if>
	   
	</tr>
</xform:editShow>

<xform:viewShow>
<c:if test="${tibSysSoapSettingForm.fdCheck eq 'true' }">
<c:if test="${tibSysSoapSettingForm.fdAuthMethod == 'k3Type' }">
<!-- k3登录方式 -->
	<tr id="k3Login_2" <c:if test="${tibSysSoapSettingForm.fdCheck eq 'false' || tibSysSoapSettingForm.fdAuthMethod!='k3Type'}">style="display: none"</c:if> >
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapAuth.k3FdUserName"/>
		</td>
		 <c:if test="${tibSysSoapSettingForm.extendInfoList!=null}">
			<c:forEach items="${tibSysSoapSettingForm.extendInfoList}" var="currentObject" varStatus="vstatus">
				  <c:if test="${currentObject.key=='k3UserName' }">
				     <td width="35%">
					       <input type="text" name="k3UserName" value="${currentObject.value}" class="inputread"  readonly="readonly" style="width:85%" />
				     </td>
				  </c:if>
			</c:forEach>
		</c:if>
	
		 <c:if test="${tibSysSoapSettingForm.extendInfoList==null}">
		      <td width="35%">
				 <input type="text" name="k3UserName" value="" class="inputread" readonly="readonly" style="width:85%" />
		   </td>
		</c:if>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapAuth.k3FdPassword"/>
		</td>
	
		 <c:if test="${tibSysSoapSettingForm.extendInfoList!=null}">	
			<c:forEach items="${tibSysSoapSettingForm.extendInfoList}" var="currentObject" varStatus="vstatus">
				  <c:if test="${currentObject.key=='k3Password' }">
				     <td width="35%">
					       <input type="password" name="k3Password" value="${currentObject.value}" class="inputread" readonly="readonly" style="width:85%" />
				     </td>
				  </c:if>
			</c:forEach>
		</c:if>
	
	 	<c:if test="${tibSysSoapSettingForm.extendInfoList==null}">
		       <td width="35%">
					 <input type="password" name="k3Password" value="" class="inputread" readonly="readonly" style="width:85%" />
			   </td>
		</c:if>
		
	</tr>

	<tr id="k3Login_2" <c:if test="${tibSysSoapSettingForm.fdCheck eq 'false' || tibSysSoapSettingForm.fdAuthMethod!='k3Type'}">style="display: none"</c:if> >
		<td class="td_normal_title" width=15%>
				<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapAuth.k3FdIAisID"/>
		</td>
		
	    <c:if test="${tibSysSoapSettingForm.extendInfoList!=null}">	
		    <c:forEach items="${tibSysSoapSettingForm.extendInfoList}" var="currentObject3" varStatus="vstatus">
			   <c:if test="${currentObject3.key=='k3IAisID' }">
			      <td width="85%" colspan="3">
				          <input type="text" name="k3IAisID" value="${currentObject3.value}" class="inputread"  readonly="readonly" style="width:85%" />
				  </td>
			  </c:if>
		   </c:forEach>
		 </c:if>
	   
	   <c:if test="${tibSysSoapSettingForm.extendInfoList==null}">
		       <td width="85%" colspan="3">
					 <input type="text" name="k3IAisID" value="" class="inputread" readonly="readonly" style="width:85%" />
			   </td>
	   </c:if>
	
	</tr>
</c:if>
</c:if>	
</xform:viewShow>
	