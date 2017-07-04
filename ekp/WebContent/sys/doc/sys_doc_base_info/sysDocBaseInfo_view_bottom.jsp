<tr>
	<td
		width="11%"
		class="td_normal_title"
		valign="top"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.fdDescription" /></td>
	<td
		width="89%"
		colspan="3"><kmss:showText value="${sysDocBaseInfoForm.fdDescription}" /></td>
</tr>
<tr>
	<td
		width="11%"
		class="td_normal_title"
		valign="top"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docContent" /></td>
	<td
		width="89%"
		colspan="3">${sysDocBaseInfoForm.docContent }</td>
</tr>
<tr>
	<td
		width="11%"
		class="td_normal_title"
		valign="top"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docAttachments" /></td>
	<td
		width="89%"
		colspan="3"><c:import
		url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formBeanName"
			value="sysDocBaseInfoForm" />
		<c:param
			name="fdKey"
			value="attachment" />
	</c:import></td>
</tr>
