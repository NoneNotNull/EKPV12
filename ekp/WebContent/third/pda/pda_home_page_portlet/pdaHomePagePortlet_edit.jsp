<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/common.jsp"%>
<center>
<table class="tb_normal" width="100%" id="TABLE_DocList">
	<tr>
		<td KMSS_IsRowIndex="1" width="5%" class="td_normal_title"><bean:message key="page.serial" /></td>
		<td class="td_normal_title" align="center" width="20%"><bean:message bundle="third-pda" key="pdaHomePagePortlet.fdType"/></td>
		<td class="td_normal_title" align="center" width="25%"><bean:message bundle="third-pda" key="pdaHomePagePortlet.fdName"/></td>
		<td class="td_normal_title" align="center" width="35%"><bean:message bundle="third-pda" key="pdaHomePagePortlet.fdDataContent"/></td>
		<td class="td_normal_title" align="center" width="15%">
			<img src="${KMSS_Parameter_StylePath}icons/add.gif" style="cursor:pointer" onclick="addPortletCfg();" title='<bean:message key="button.insert"/>'>
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1">!{index+1}</td>
		<td align="center">
			<input type="hidden" name="fdPortlets[!{index}].fdId" />
			<input type="hidden" name="fdPortlets[!{index}].fdOrder" />
			<input type="hidden" name="fdPortlets[!{index}].fdModuleId"/>
			<input type="hidden" name="fdPortlets[!{index}].fdModuleName"/>
			<input type="hidden" name="fdPortlets[!{index}].fdDataUrl"/>
			<xform:select property="fdPortlets[!{index}].fdType" value="list" showPleaseSelect="false" showStatus="readOnly">
				<xform:simpleDataSource value="pic" bundle="third-pda" textKey="pdaHomeCustomPortlet.fdType.pic">
				</xform:simpleDataSource>
				<xform:simpleDataSource value="list" bundle="third-pda" textKey="pdaHomeCustomPortlet.fdType.list">
				</xform:simpleDataSource>
			</xform:select>
		</td>
		<td align="center">
			<input type="hidden" name="fdPortlets[!{index}].fdLabelId" />
			<input name="fdPortlets[!{index}].fdName" class="inputsgl" style="width:85%"/>
		</td>
		<td align="center">
			<input  type="hidden" name="fdPortlets[!{index}].fdDataUrl"/>
			<input  class="inputread" readonly="readonly" name="fdPortlets[!{index}].fdContent" class="inputsgl" style="width:85%"/>
		</td align="center">
		<td align="center">
			<input type="hidden" name="!{index}"> 
			<a href="javascript:void(0);" onclick="editPortletCfg(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/edit.gif" border="0" title="<bean:message key="button.edit"/>" /></a>
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0"  title='<bean:message key="button.delete"/>'/></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0"  title='<bean:message key="button.moveup"/>'/></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0"  title='<bean:message key="button.movedown"/>'/></a>
		</td>
	</tr>
	<!--内容行-->
	<c:forEach items="${pdaHomePageConfigForm.fdPortlets}" varStatus="vstatus" var="pdaHomePagePortletForm">
		<tr KMSS_IsContentRow="1">
			<td KMSS_IsRowIndex="1">${vstatus.index+1}</td>
			<td align="center">
				<input type="hidden" name="fdPortlets[${vstatus.index}].fdId" value="${pdaHomePagePortletForm.fdId}"/>
				<input type="hidden" name="fdPortlets[${vstatus.index}].fdOrder" value="${pdaHomePagePortletForm.fdOrder}"/>
				<input type="hidden" name="fdPortlets[${vstatus.index}].fdModuleId" value="${pdaHomePagePortletForm.fdModuleId}"/>
				<input type="hidden" name="fdPortlets[${vstatus.index}].fdModuleName" value="${pdaHomePagePortletForm.fdModuleName}"/>
				<xform:select property="fdPortlets[${vstatus.index}].fdType" value="${pdaHomePagePortletForm.fdType}" showPleaseSelect="false" showStatus="readOnly" >
					<xform:simpleDataSource value="pic" bundle="third-pda" textKey="pdaHomeCustomPortlet.fdType.pic">
					</xform:simpleDataSource>
					<xform:simpleDataSource value="list" bundle="third-pda" textKey="pdaHomeCustomPortlet.fdType.list">
					</xform:simpleDataSource>
				</xform:select>
			</td>
			<td align="center">
				<input type="hidden" name="fdPortlets[${vstatus.index}].fdLabelId" value="${pdaHomePagePortletForm.fdLabelId}"/>
				<input name="fdPortlets[${vstatus.index}].fdName" class="inputsgl" style="width:85%" value="${pdaHomePagePortletForm.fdName}" />
			</td>
			<td align="center">
				<input type="hidden"  name="fdPortlets[${vstatus.index}].fdDataUrl" value="${pdaHomePagePortletForm.fdDataUrl}"/>
				<input class="inputread" readonly="readonly" name="fdPortlets[${vstatus.index}].fdContent" style="width:85%" value="${pdaHomePagePortletForm.fdContent}"/>
			</td>
			<td align="center">
				<input type="hidden" name="${vstatus.index}">
				<a href="javascript:void(0);" onclick="editPortletCfg(this);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/edit.gif" border="0" title="<bean:message key="button.edit"/>" /></a>
				<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" title='<bean:message key="button.delete"/>' /></a>
				<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" title='<bean:message key="button.moveup"/>' /></a>
				<a href="javascript:void(0);" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" title='<bean:message key="button.movedown"/>' /></a>
			</td>
		</tr>
	</c:forEach>
</table>
</center>
<script>
		function replaceUrlInfo(url, cateid, nodeType){
			if(url==null)
				return null;
			var re = /!\{cateid\}/gi;
			url = url.replace(/!\{cateid\}/gi, cateid);
			return url;
		}
		function selectPortletDialog(index){
			var dialog = new KMSSDialog(false, false);
			var treeTitle = '<bean:message bundle="third-pda" key="pdaHomePageConfig.fdOrder"/>';
			var node = dialog.CreateTree(treeTitle);
			dialog.winTitle = treeTitle;
			node.AppendBeanData("pdaModulePortletTreeDialog", null, null, false);
			dialog.notNull = true;
			dialog.Show();
			var rtnVar=dialog.rtnData;
			if(rtnVar==null)
				return null;
			var rtnVal = new Object();
			rtnVal["SelectInfo"] = "";
			var node = Tree_GetNodeByID(dialog.tree.treeRoot, rtnVar.GetHashMapArray()[0].nodeId);
			var isBreak=false;
			var prentNode=null;
			for(var pNode = node; pNode.id!=dialog.tree.treeRoot.id; pNode = pNode.parent){
				rtnVal["SelectInfo"] = "/" + pNode.text + rtnVal["SelectInfo"];
				if(pNode.value !=null && pNode.value.indexOf("&")>-1 && isBreak!=true){
					prentNode=pNode;
					isBreak=true;
				}
			}
			var values = prentNode.value.split("&");
			for(var i=0; i<values.length; i++){
				var j = values[i].indexOf("=");
				rtnVal[values[i].substring(0,j)] = decodeURIComponent(values[i].substring(j+1));
			}
			
			var cateid = node==prentNode?"":node.value;
			rtnVal["dataURL"] = replaceUrlInfo(rtnVal["dataURL"], cateid, node.nodeType);
			document.getElementsByName("fdPortlets["+index+"].fdModuleId")[0].value=rtnVal["module"];
			document.getElementsByName("fdPortlets["+index+"].fdModuleName")[0].value=rtnVal["moduleName"];
			document.getElementsByName("fdPortlets["+index+"].fdType")[0].value=rtnVal["type"];
			var typeObj=document.getElementsByName("_fdPortlets["+index+"].fdType")[0];
			for(var i=0;i<typeObj.options.length;i++){
				if(rtnVal["type"]==typeObj.options[i].value)
					typeObj.options[i].selected=true;
				else
					typeObj.options[i].selected=false;
			}
			document.getElementsByName("fdPortlets["+index+"].fdLabelId")[0].value=(rtnVal["label"]==null?"":rtnVal["label"]);
			document.getElementsByName("fdPortlets["+index+"].fdName")[0].value=node.text;
			document.getElementsByName("fdPortlets["+index+"].fdDataUrl")[0].value=rtnVal["dataURL"];
			document.getElementsByName("fdPortlets["+index+"].fdContent")[0].value=rtnVal["SelectInfo"];
			
			return rtnVar;
		}
		
		function addPortletCfg(){
			var trObj = DocList_AddRow();
			var tbInfo= DocList_TableInfo["TABLE_DocList"];
			var index = tbInfo.lastIndex - tbInfo.firstIndex-1;
			var rtnVar= selectPortletDialog(index);
			if(rtnVar==null){
				DocList_DeleteRow(trObj);
				return ;
			}
		}
	
		
		function editPortletCfg(rowObj){
			var preObj=rowObj.previousSibling;
			while(preObj.tagName!="INPUT")
				preObj=preObj.previousSibling;
			var index=preObj.name;
			var rtnVar= selectPortletDialog(index);
			if(rtnVar==null)
				return ;
		}
		
</script>
