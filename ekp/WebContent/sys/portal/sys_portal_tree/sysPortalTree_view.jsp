<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/portal/sys_portal_tree/sysPortalTree.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('sysPortalTree.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/sys/portal/sys_portal_tree/sysPortalTree.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysPortalTree.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-portal" key="table.sysPortalTree"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.fdName"/>
		</td>
		<td width="35%">
			<xform:text property="fdName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.fdType"/>
		</td>
		<td width="35%">
			<xform:select property="fdType">
					<xform:enumsDataSource enumsType="sys_portal_tree_type" />
			</xform:select>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.fdContent"/>
		</td>
		<td width="35%" colspan="3">
			<script type="text/javascript">Com_IncludeFile("domain.js");</script>
			<script type="text/javascript">Com_IncludeFile("dialog.js");</script>
			<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
			<script type="text/javascript">
				var LKSTree;
				Tree_IncludeCSSFile();
				function generateTree(){
					var xmlTxt, treeData, nodeArr, i, lv;
					xmlTxt = document.getElementsByName("fdContent")[0].value;
					if(xmlTxt=="")
						treeData = [];
					else
						treeData = domain.toJSON(xmlTxt);
					if(LKSTree){
						document.getElementById("DIV_Tree").innerHTML = "";
						delete LKSTree;
					}
					LKSTree = new TreeView("LKSTree", '<bean:message  bundle="sys-portal" key="sysHomeNav.msg.node.root"/>', document.getElementById("DIV_Tree"));
					//debugger;
					generateChildrenTree(LKSTree.treeRoot,treeData);
					//LKSTree.ClickNode = onTreeNodeClick;
					LKSTree.Show();
					currentNode = null;
					currentOpt = null; 
				}
				function generateChildrenTree(root,data){
					for(var i =0;i<data.length;i++){
						var node = new TreeNode();
						node.text = data[i].text;
						node.isExpanded = true;
						node.nodeType = "node"; 
						if(data[i].href!=null){
							node.parameter = new Array();
							node.parameter[0] = data[i].href;
							if(data[i].target!=null){
								node.parameter[1] = data[i].target;
							}
						}
						root.AddChild(node);
						if(data[i].children!=null&&data[i].children.length >0){
							generateChildrenTree(node,data[i].children);
						}
					} 
				} 
			</script>
			<textarea name="fdContent" style="display:none"><c:out value="${sysPortalTreeForm.fdContent}" /></textarea>
			<table class="tb_noborder">
				<tr>
					<td>
			<div id="DIV_Tree"></div>
			<script>generateTree();</script></td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width="15%">可维护者</td>
		<td colspan="3">
			<xform:address textarea="true" mulSelect="true" propertyId="fdEditorIds" propertyName="fdEditorNames" style="width:96%;height:90px;" ></xform:address>
		</td>
	</tr> 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docCreator"/>
		</td><td width="35%">
			<c:out value="${sysPortalTreeForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docAlteror"/>
		</td><td width="35%">
			<c:out value="${sysPortalTreeForm.docAlterorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-portal" key="sysPortalTree.docAlterTime"/>
		</td><td width="35%">
			<xform:datetime property="docAlterTime" />
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>