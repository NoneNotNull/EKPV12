<tr>
	<td
		class="td_normal_title"
		width="15%"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docReaders" /></td>
	<td width="85%"><html:hidden property="docEnableChangeRightFlag" /> <html:hidden property="docReaderIds" /> <html:textarea
		property="docReaderNames"
		readonly="true"
		style="width:90%;height:90px"
		styleClass="inputmul" /> <c:if test="${sysDocBaseInfoForm.disableRightButton != 'true'}">
		<a
			href="#"
			onclick="Dialog_Address(true, 'docReaderIds','docReaderNames', ';', ORG_TYPE_ALL);"> <bean:message key="dialog.selectOrg" /> </a>
	</c:if></td>
</tr>
<tr>
	<td class="td_normal_title"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docEditors" /></td>
	<td><html:hidden property="docEditorIds" /> <html:textarea
		property="docEditorNames"
		style="width:90%;height:90px"
		styleClass="inputmul"
		readonly="true" /> <c:if test="${sysDocBaseInfoForm.disableRightButton != 'true'}">
		<a
			href="#"
			onclick="Dialog_Address(true, 'docEditorIds','docEditorNames', ';', ORG_TYPE_ALL);"> <bean:message key="dialog.selectOrg" /> </a>
	</c:if></td>
</tr>
<tr>
	<td colspan="2"><bean:message
		key="sysDocBaseInfo.allowRight.showMessage"
		bundle="sys-doc" /></td>
</tr>
