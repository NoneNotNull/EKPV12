<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@page import="java.util.*,com.landray.kmss.util.*,net.sf.json.JSONArray,net.sf.json.JSONObject"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|dialog.js|json2.js");
Com_IncludeFile("select.js|doclist.js");

	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = setFdModelNames;

	function setFdModelNames(){
		var names = [];
		var tmp_MNameSel = document.getElementsByName("tmp_MNameSel")[0];
		if(tmp_MNameSel.length>10){
			alert("<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames.note"/>");
			return false;
		}
		var n = 0;
		for(var i=0;i<tmp_MNameSel.length;i++){
			var param={};
			param["name"]=tmp_MNameSel[i].value;
			param["label"]=tmp_MNameSel[i].text;
			names[n++]=param;
		}

		var count = document.getElementsByName("other.param.name").length;
		if(count>10){
			alert("<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames.note"/>");
			return false;
		}
		for(var i=0;i<count;i++){
			var param={};
			param["name"]=document.getElementsByName("other.param.name")[i].value;
			param["label"]=document.getElementsByName("other.param.label")[i].value;
			param["type"]="outer";
			names[n++]=param;
		}

		document.getElementsByName("fdModelNames")[0].value=JSON.stringify(names);
		return true;
	}

</script>

<script>DocList_Info.push('paramTable');</script>

<kmss:windowTitle
	subject="${sysNotifyCategoryForm.fdName}"
	moduleKey="sys-notify:table.sysNotifyCategory" />

<html:form action="/sys/notify/sys_notify_category/sysNotifyCategory.do">
<div id="optBarDiv">
	<c:if test="${sysNotifyCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysNotifyCategoryForm, 'update');">
	</c:if>
	<c:if test="${sysNotifyCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysNotifyCategoryForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysNotifyCategoryForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-notify" key="table.sysNotifyCategory"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdName"/>
		</td>
		<td width=35% >
			<xform:text property="fdName" style="width:85%" required="true"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdOrder"/>
		</td>
		<td width=35%>
			<xform:text property="fdOrder" style="width:85%" validators="number"/>
		</td>
	</tr>
	
	<!--
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdNo"/>
		</td>
		<td width=35%>
			<xform:text property="fdNo" style="width: 65%;" required="true"/><bean:message bundle="sys-notify" key="sysNotifyCategory.fdNo.tip"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdOrder"/>
		</td>
		<td width=35%>
			<xform:text property="fdOrder" style="width:85%" validators="number"/>
		</td>
	</tr>
	-->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames"/>
		</td>
		<td colspan="3" align="center">

			<table class="tb_normal" width="60%">
				<tr class="tr_normal_title">
					<td><bean:message key="dialog.optList"/></td>
					<td>&nbsp;</td>
					<td><bean:message key="dialog.selList"/></td>
				</tr>
				<tr>
					<td style="width:280px">
						<select name="tmp_MNameOpt" multiple="true" size="15" style="width:280px"
							ondblclick="Select_AddOptions('tmp_MNameOpt', 'tmp_MNameSel');">
							<%
							List<Map<String,String>> optMNames = (List<Map<String,String>>)request.getAttribute("optMNames");
							for(Map<String,String> optMName:optMNames){
								out.print("<option value='"+optMName.get("value")+"'>"+optMName.get("text")+"</option>");
							}
							%>
						</select>
					</td>
					<td>
						<center>
							<input class="btnopt" type="button" value="<bean:message key="dialog.add"/>"
								onclick="Select_AddOptions('tmp_MNameOpt', 'tmp_MNameSel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.delete"/>"
								onclick="Select_DelOptions('tmp_MNameSel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.addAll"/>"
								onclick="Select_AddOptions('tmp_MNameOpt', 'tmp_MNameSel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.deleteAll"/>"
								onclick="Select_DelOptions('tmp_MNameSel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveUp"/>"
								onclick="Select_MoveOptions('tmp_MNameSel', -1);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveDown"/>"
								onclick="Select_MoveOptions('tmp_MNameSel', 1);">
						</center>
					</td>
					<td style="width:280px">
						<select name="tmp_MNameSel" multiple="true" size="15" style="width:280px"
							ondblclick="Select_DelOptions('tmp_MNameSel');">
							<%
							JSONArray selMNames = (JSONArray)request.getAttribute("selMNames");
							if(selMNames!=null){
								for(int i=0;i<selMNames.size();i++){
									JSONObject selMName = selMNames.getJSONObject(i);
									out.print("<option value='"+selMName.getString("name")+"'>"+selMName.getString("label")+"</option>");
								}
							}
							%>
						</select>
					</td>
				</tr>
			</table>
			<html:hidden property="fdModelNames" />
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-notify" key="sysNotifyCategory.outer.fdModelNames"/>
		</td>
		<td colspan="3" width="85%">
				<table class="tb_normal" id="paramTable" style="width:100%">
					<tr class="tr_normal_title">
						<td style="width:30px"><span style="white-space:nowrap;"><bean:message key="page.serial"/></span></td>
						<td style="width:40%"><bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames"/></td>
						<td style="width:55%"><bean:message bundle="sys-notify" key="sysNotifyCategory.fdClassNames"/></td>
						<td style="width:100px"><div style="text-align:center"><img style='cursor:pointer' class=optStyle src='<c:url value='/resource/style/default/icons/add.gif'/>' onclick='DocList_AddRow();' alt="<bean:message key="button.insert"/>"></div></td>
					</tr>
					<tr KMSS_IsReferRow="1" style="display:none">
						<td KMSS_IsRowIndex="1"></td> 
						<td>
							<input type="text" name="other.param.label" subject="<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames"/>" validate="required" style="width:90%" class="inputSgl"><span class="txtstrong">*</span>
						</td>
						<td>
							<input type="text" name="other.param.name" subject="<bean:message bundle="sys-notify" key="sysNotifyCategory.fdClassNames"/>" validate="required" style="width:90%" class="inputSgl"><span class="txtstrong">*</span>
						</td>
						<td>
							<div style="text-align:center">
							<img src="<c:url value="/resource/style/default/icons/delete.gif" />" alt="<bean:message key="button.delete"/>" onclick="DocList_DeleteRow();" style="cursor:pointer">&nbsp;&nbsp;
							<img src="<c:url value="/resource/style/default/icons/up.gif" />" alt="<bean:message key="dialog.moveUp"/>" onclick="DocList_MoveRow(-1);" style="cursor:pointer">&nbsp;&nbsp;
							<img src="<c:url value="/resource/style/default/icons/down.gif" />" alt="<bean:message key="dialog.moveDown"/>" onclick="DocList_MoveRow(1);" style="cursor:pointer">&nbsp;&nbsp;
							</div>
						</td>
					</tr>

					<%
					JSONArray others = (JSONArray)request.getAttribute("others");
					if(others!=null){
						for(int i=0;i<others.size();i++){
							JSONObject other = others.getJSONObject(i);
					%>
					<tr KMSS_IsContentRow="1">
						<td><%=(i+1)%></td>
						<td>
							<input type="text" name="other.param.label" subject="<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModelNames"/>"  validate="required" value="<%=other.getString("label")%>" style="width:90%" class="inputSgl"><span class="txtstrong">*</span>
						</td>
						<td>
							<input type="text" name="other.param.name"  subject="<bean:message bundle="sys-notify" key="sysNotifyCategory.fdClassNames"/>" validate="required" value="<%=other.getString("name")%>"  style="width:90%" class="inputSgl"><span class="txtstrong">*</span>
						</td>
						<td>
							<div style="text-align:center">
							<img src="<c:url value="/resource/style/default/icons/delete.gif" />" alt="<bean:message key="button.delete"/>" onclick="DocList_DeleteRow();" style="cursor:pointer">&nbsp;&nbsp;
							<img src="<c:url value="/resource/style/default/icons/up.gif" />" alt="<bean:message key="dialog.moveUp"/>" onclick="DocList_MoveRow(-1);" style="cursor:pointer">&nbsp;&nbsp;
							<img src="<c:url value="/resource/style/default/icons/down.gif" />" alt="<bean:message key="dialog.moveDown"/>" onclick="DocList_MoveRow(1);" style="cursor:pointer">&nbsp;&nbsp;
							</div>
						</td>
					</tr>
				<%
							}
						}
				%>
				</table>
		</td>
	</tr>
	
	<%-- 创建时间 --%>
	<c:if test="${sysNotifyCategoryForm.method_GET=='edit'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.fdCreatorName"/>
			</td><td>
				<html:text property="fdCreatorName" readonly="true" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.docCreateTime"/>
			</td><td>
				<html:text property="docCreateTime" readonly="true" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModifyName"/>
			</td><td>
				<html:text property="fdModifyName" readonly="true" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-notify" key="sysNotifyCategory.fdModifyTime"/>
			</td><td>
				<html:text property="fdModifyTime" readonly="true" />
			</td>
		</tr>
	</c:if>
</table>
</center>
<html:hidden property="method_GET"/>
<script>
	$KMSSValidation();
</script>

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
