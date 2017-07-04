<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="com.landray.kmss.sys.person.forms.SysPersonCfgLinkForm"%>
<%@page import="com.landray.kmss.sys.person.interfaces.LinkInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="linkType" value="${empty param.linkType ? 'fdSettings' : param.linkType}" scope="page" />
<c:set var="linkForm" value="${requestScope[param.linkForm]}" scope="page" />

<xform:config isLoadDataDict="false" showStatus="edit">
<script>DocList_Info.push('${linkType }');</script>

<table id="${linkType }" class="tb_normal" width="100%">
	<tr class="tr_normal_title">
		<td width="20px;">
			<span style="white-space:nowrap;"><bean:message key="page.serial"/></span>
		</td>
		<td width="200px"><kmss:message key="sys-person:sysPersonCfgLink.name" /></td>
		<td><kmss:message key="sys-person:sysPersonCfgLink.url" /></td>
		<td width="90px"><kmss:message key="sys-person:sysPersonCfgLink.fdTarget" /></td>
		<td width="90px">
			<a href="javascript:;" class="com_btn_link" onclick="SysLinksDialog('${linkType }', '${lfn:message('sys-person:add.cfg.link.title') }');"><bean:message bundle="sys-person" key="sysPersonSysNavLink.fromSys"/></a>
			<a href="javascript:;" class="com_btn_link" onclick="DocList_AddRow('${linkType }');"><bean:message bundle="sys-person" key="sysPersonSysNavLink.fromInput"/></a>
		</td>
	</tr>
	<%-- 模版行 --%>
	<tr style="display:none;" KMSS_IsReferRow="1">
		<td KMSS_IsRowIndex="1">
			!{index}
		</td>
		<td>
			<xform:text property="${linkType }[!{index}].fdName" style="width:95%" subject="${lfn:message('sys-person:sysPersonCfgLink.name') }" required="true" />
		</td>
		<td>
			<xform:text property="${linkType }[!{index}].fdUrl" style="width:95%" subject="${lfn:message('sys-person:sysPersonCfgLink.url') }" required="true" />
		</td>
		<td>
			<xform:select property="${linkType }[!{index}].fdTarget" showPleaseSelect="false">
				<xform:enumsDataSource enumsType="sysPerson_cfgTarget" />
			</xform:select>
		</td>
		<td>
			<input type="hidden" name="${linkType }[!{index}].fdId" value="">
			<input type="hidden" name="${linkType }[!{index}].fdLinkId" value="">
			<div style="text-align:center">
			<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow(this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
			<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
			<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">
			</div>
		</td>
	</tr>
	<%-- 内容行 --%>
	<c:forEach items="${linkForm[linkType]}" var="link" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>
			${vstatus.index + 1}
		</td>
		<td>
			<c:if test="${empty link.fdLinkId }">
			<xform:text property="${linkType }[${vstatus.index}].fdName" required="true" style="width:95%" value="${link.fdName }" showStatus="${readOnly ? 'view' : 'edit' }"  subject="${lfn:message('sys-person:sysPersonCfgLink.name') }"/>
			</c:if>
			<c:if test="${not empty link.fdLinkId }">
				<c:out value="${link.name }" />
				<% 
				if(LinkInfo.isMultiServer()){
					SysPersonCfgLinkForm xinfo = (SysPersonCfgLinkForm)pageContext.getAttribute("link");
					String xid = xinfo.getFdLinkId();
					if(xid.indexOf(SysUiConstant.SEPARATOR)>0){

						String server = xid.substring(0,xid.indexOf(SysUiConstant.SEPARATOR));
						out.print("(");
						out.print(LinkInfo.getServerNameByKey(server));
						out.print(")");
						
					}
				}
				%>
			</c:if>
			
		</td>
		<td>
			<c:if test="${empty link.fdLinkId }">
			<xform:text property="${linkType }[${vstatus.index}].fdUrl" required="true" style="width:95%" value="${link.fdUrl }" showStatus="${readOnly ? 'view' : 'edit' }"  subject="${lfn:message('sys-person:sysPersonCfgLink.url') }"/>
			</c:if>
			<c:if test="${not empty link.fdLinkId }">
				<c:out value="${link.url }" />
			</c:if>
		</td>
		<td>
			<xform:select property="${linkType }[${vstatus.index}].fdTarget" showPleaseSelect="false" value="${link.fdTarget }">
				<xform:enumsDataSource enumsType="sysPerson_cfgTarget" />
			</xform:select>
		</td>
		<td>
			<input type="hidden" name="${linkType }[${vstatus.index}].fdId" value="${link.fdId }" >
			<input type="hidden" name="${linkType }[${vstatus.index}].fdLinkId" value="${link.fdLinkId }" >
			<div style="text-align:center">
			<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow(this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
			<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
			<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">
			</div>
		</td>
	</tr>
	</c:forEach>
</table>
</xform:config>