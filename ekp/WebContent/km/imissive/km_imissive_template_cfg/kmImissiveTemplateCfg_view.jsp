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
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmImissiveTemplateCfg.do?method=edit&fdId=${param.fdId}','_self');">
		<input type="button" value="<kmss:message key="km-imissive:button.copy"/>"
		    onclick="Com_OpenWindow('kmImissiveTemplateCfg.do?method=clone&cloneModelId=${param.fdId}','_blank');">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmImissiveTemplateCfg.do?method=delete&fdId=${param.fdId}','_self');">
	    <input type="button" value="<bean:message key="button.close"/>"  onclick="Com_CloseWindow();">
</div>
<p class="txttitle">公文交换</p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.fdName"/>
		</td><td width=35% colspan='3'>
			<c:out value="${kmImissiveTemplateCfgForm.fdName}"/> 
		</td>
	</tr>
		<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.fdTableHead"/>
		</td><td width=35% colspan='3'>
			<c:out value="${kmImissiveTemplateCfgForm.fdTableHead}"/> 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title"  width=15%>
			转换类型
		</td><td width=85% colspan=3>
			<xform:radio property="fdType" value="${kmImissiveTemplateCfgForm.fdType}">
			   <xform:enumsDataSource enumsType="kmImissiveTemplateCfg_type"></xform:enumsDataSource>
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.from"/>
		</td><td width=35%>
		    <c:out value="${kmImissiveTemplateCfgForm.fdSendTempOneName}"/> 
		    <c:out value="${kmImissiveTemplateCfgForm.fdReceiveTempOneName}"/> 
		</td>
		<td class="td_normal_title"  width=15%>
			<bean:message bundle="km-imissive" key="kmImissiveTemplateCfg.to"/>
		</td><td width=35%>
		    <c:out value="${kmImissiveTemplateCfgForm.fdSendTempTwoName}"/>
		    <c:out value="${kmImissiveTemplateCfgForm.fdReceiveTempTwoName}"/>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>