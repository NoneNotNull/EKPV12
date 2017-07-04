<html:hidden property="docStatus" />
<tr>
	<td
		width="15%"
		class="td_normal_title"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docSubject" /></td>
	<td
		width="85%"
		colspan="3"><xform:text isLoadDataDict="false" validators="maxLength(200)" property="docSubject" required="true" className="inputsgl" style="width:90%;"  /></td>
</tr>
<tr>
	<td
		width="15%"
		class="td_normal_title"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docCreator" /></td>
	<td width="39%"><html:text
		property="docCreatorName"
		readonly="true"
		style="width:80%" /></td>
	<td
		width="15%"
		class="td_normal_title"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docCreateTime" /></td>
	<td width="39%"><html:text
		property="docCreateTime"
		readonly="true" /></td>
</tr>
<tr>
	<td
		width="15%"
		class="td_normal_title"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docDept" />
	</td>
	<td width="39%">
		<xform:address isLoadDataDict="false" required="true" style="width:80%" propertyId="docDeptId" propertyName="docDeptName" orgType='ORG_TYPE_ORGORDEPT'></xform:address>
	</td>
	<td
		width="15%"
		class="td_normal_title"><bean:message
		bundle="sys-doc"
		key="sysDocBaseInfo.docAuthor" />
	</td>
	<td width="39%">
		<xform:address isLoadDataDict="false" required="true" style="width:80%" propertyId="docAuthorId" propertyName="docAuthorName" orgType='ORG_TYPE_PERSON'></xform:address>	
	</td>
</tr>
