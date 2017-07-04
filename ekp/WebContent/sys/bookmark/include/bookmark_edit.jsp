<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<script type="text/javascript">
<%-- 解决表单提交问题 --%>
window.name = "bookmark";
<%-- 解决超链接问题 --%>
var base = document.createElement("BASE");
base.target = "_self";
document.getElementsByTagName("head")[0].appendChild(base);

Com_IncludeFile("treeview.js");
window.onload = generateTree;
var LKSTree;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", 
		'<bean:message key="cate.tree.root" bundle="sys-bookmark"/>', 
		document.getElementById("treeDiv")
	);
	LKSTree.isShowCheckBox = true;
	LKSTree.isMultSel = false;
	LKSTree.isAutoSelectChildren = false;
	LKSTree.OnNodeCheckedPostChange = function(checkedNode) {
		if(checkedNode != null) {
			document.getElementsByName('docCategoryId')[0].value = checkedNode.value;
			document.getElementsByName('docCategoryName')[0].value = checkedNode.text;
		}
	};
	
	var n1;
	n1 = LKSTree.treeRoot;
	n1.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=all");
	
	LKSTree.Show();
	// 设置url和标题
	var obj = top.dialogArguments;
	document.getElementsByName('fdUrl')[0].value = obj.url;
	document.getElementsByName('docSubject')[0].value = obj.subject;
	document.getElementsByName('fdModelId')[0].value = obj.fdModelId;
	document.getElementsByName('fdModelName')[0].value = obj.fdModelName;
}
//新建个人收藏夹分类
function addCategory(){
	var url = '<c:url value="/sys/bookmark/sys_bookmark_person_category/sysBookmarkPersonCategory.do" />?method=add';
	Com_OpenWindow(url,"_blank");
}
//刷新分类
function refresh(){ 
       location = location; 
} 
</script>
<table class="tb_noborder">
	<tr>
		<td width="10pt"></td>
		<td>
			<div id=treeDiv class="treediv"
			 	style="height: 180px; overflow:auto;"></div>
		</td>
	</tr>
</table>
<center>
<html:form action="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" 
	onsubmit="return validateSysBookmarkMainForm(this);" target="bookmark">
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdUrl" />
		<html:hidden property="fdModelId" />
		<html:hidden property="fdModelName" />
	<%-- 收藏名 --%>
	<tr>
		<td class="td_normal_title" width=22%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docSubject"/>
		</td>
		<td>
			<html:text property="docSubject" style="width: 78%;"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<%-- 收藏分类 --%>
	<tr>
		<td class="td_normal_title" width=22%>
			<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCategoryId"/>
		</td>
		<td colspan="3">
			<html:hidden property="docCategoryId" />
			<html:text property="docCategoryName" readonly="true" style="width:55%" />
			<a style="cursor:pointer" onclick="addCategory();"><bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.addPersonCategory"/></a>&nbsp;&nbsp;&nbsp;
			<a style="cursor:pointer" onclick="refresh();"><bean:message bundle="sys-bookmark" key="sysBookmarkPersonCategory.refreshCategory"/></a>
		</td>
	</tr>
</table>
<div style="margin-top: 10px;">
	<input type="button" class="btnopt" style="margin-right: 10px" value="<bean:message key="button.save"/>" 
		onclick="Com_Submit(document.sysBookmarkMainForm, 'save');">
	<input type="button" class="btnopt" value="<bean:message key="button.close"/>" 
		onclick="Com_CloseWindow();">
</div>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysBookmarkMainForm" cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
