<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<center>
<table id="relationEntry" width=95% style="border: 0px;">
	<tr>
		<td width="16%" style="border: 0px;" nowrap="nowrap">
			<bean:message bundle="sys-relation" key="sysRelationEntry.select.type" />
		</td>
		<td style="border: 0px;">
			<nobr>
			<input type="hidden" name="fdOtherUrl" />
			<label>
			<input type="radio" name="fdType" value="4" onclick="changeRelationType(this.value);" />
			<bean:message bundle="sys-relation" key="sysRelationEntry.fdType4" />
			</label>
			<label>
			<input type="radio" name="fdType" value="1" onclick="changeRelationType(this.value);"/>
			<bean:message bundle="sys-relation" key="sysRelationEntry.fdType1" />
			</label>
			<label>
			<input type="radio" name="fdType" value="2" onclick="changeRelationType(this.value);" />
			<bean:message bundle="sys-relation" key="sysRelationEntry.fdType2" />
			</label>
			<%-- 
			<label>
			<input type="radio" name="fdType" value="3" onclick="changeRelationType(this.value);" />
			<bean:message bundle="sys-relation" key="sysRelationEntry.fdType3" />
			</label>
			 --%>
			</nobr>
		</td>
	</tr>
	<tr>
		<td valign="top" colspan="2">
			<iframe id="sysRelationEntry" 
				frameborder="0" scrolling="no" width="100%"></iframe>
		</td>
	</tr>
</table>
</center>
<%@ include file="sysRelationEntry_script.jsp"%>
<%@ include file="/resource/jsp/view_down.jsp"%>