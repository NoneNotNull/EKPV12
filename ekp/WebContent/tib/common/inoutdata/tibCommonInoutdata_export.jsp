<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%@ include file="/resource/jsp/edit_top.jsp"%>

<script type="text/javascript">Com_IncludeFile("treeview.js|jquery.js");</script>
<script language="JavaScript">

	window.onload = function start(){
		//generateTreeIface();
		generateTreeSap();
		generateTreeSoap();
	};
	var LKSTreeIface, LKSTreeSap, LKSTreeSoap;
	<%--打开页面展开分类树--%>
	function generateTreeIface(){
		LKSTreeIface = new TreeView(
			"LKSTreeIface",
			"<bean:message key="imExport.iface" bundle="tib-common-inoutdata" />",
			document.getElementById("ifaceTreeDiv")
		);
		LKSTreeIface.isShowCheckBox=true;  			<%-- 是否显示单选/复选框 --%>
		LKSTreeIface.isMultSel=true;					<%-- 是否多选 --%>
		LKSTreeIface.isAutoSelectChildren = true;	<%-- 选择父节点是否自动选中子节点 --%>
		var n1, n2, n3, n4;
		n1 = LKSTreeIface.treeRoot;					<%-- 根节点 --%>
		<%--通过JavaBean的数据方式批量添加子结点,这里的bean填写前面的bean --%>
		// 总的bean
		var url = "tibCommonInoutdataBean&parentId=!{value}";
		n1.AppendBeanData(url + "&moduleType=iface");
		LKSTreeIface.EnableRightMenu();
		LKSTreeIface.Show();
	}
	
	function generateTreeSap(){
		LKSTreeSap = new TreeView(
			"LKSTreeSap",
			"<bean:message key="imExport.sap" bundle="tib-common-inoutdata" />",
			document.getElementById("sapTreeDiv")
		);
		LKSTreeSap.isShowCheckBox=true;  			<%-- 是否显示单选/复选框 --%>
		LKSTreeSap.isMultSel=true;					<%-- 是否多选 --%>
		LKSTreeSap.isAutoSelectChildren = true;	<%-- 选择父节点是否自动选中子节点 --%>
		var n1, n2, n3, n4;
		n1 = LKSTreeSap.treeRoot;					<%-- 根节点 --%>
		<%--通过JavaBean的数据方式批量添加子结点,这里的bean填写前面的bean --%>
		// 总的bean
		var url = "tibCommonInoutdataBean&parentId=!{value}";
		n1.AppendBeanData(url + "&moduleType=sap");
		LKSTreeSap.EnableRightMenu();
		LKSTreeSap.Show();
	}
	
	function generateTreeSoap(){
		LKSTreeSoap = new TreeView(
			"LKSTreeSoap",
			"<bean:message key="imExport.soap" bundle="tib-common-inoutdata" />",
			document.getElementById("soapTreeDiv")
		);
		LKSTreeSoap.isShowCheckBox=true;  			<%-- 是否显示单选/复选框 --%>
		LKSTreeSoap.isMultSel=true;					<%-- 是否多选 --%>
		LKSTreeSoap.isAutoSelectChildren = true;	<%-- 选择父节点是否自动选中子节点 --%>
		var n1, n2;
		n1 = LKSTreeSoap.treeRoot;					<%-- 根节点 --%>
		<%--通过JavaBean的数据方式批量添加子结点,这里的bean填写前面的bean --%>
		// 总的bean
		var url = "tibCommonInoutdataBean&parentId=!{value}";
		n1.AppendBeanData(url + "&moduleType=soap");	
		LKSTreeSoap.EnableRightMenu();
		LKSTreeSoap.Show();
	}
	
	// 打包下载
	function exportZip(){
		if (List_CheckSelect()) {
			var form = document.getElementsByName('tibCommonInoutdataForm')[0];
			form.submit();
		} 
	}

	// 判断选中
	function List_CheckSelect(){
		removeAllChild(document.tibCommonInoutdataForm);
		var selListIface = LKSTreeIface.GetCheckedNode();
		var selListSap = LKSTreeSap.GetCheckedNode();
		var selListSoap = LKSTreeSoap.GetCheckedNode();
		for(var i=selListIface.length-1;i>=0;i--){
			var input = document.createElement("INPUT");
			input.type="text";
			input.style.display="none";
			input.name="Inoutdata_List_Selected";	
			input.value = selListIface[i].value;
			document.tibCommonInoutdataForm.appendChild(input);	
		}
		for(var i=selListSap.length-1;i>=0;i--){
			var input = document.createElement("INPUT");
			input.type="text";
			input.style.display="none";
			input.name="Inoutdata_List_Selected";	
			input.value = selListSap[i].value;
			document.tibCommonInoutdataForm.appendChild(input);	
		}
		for(var j=selListSoap.length-1;j>=0;j--){
			var input = document.createElement("INPUT");
			input.type="text";
			input.style.display="none";
			input.name="Inoutdata_List_Selected";	
			input.value = selListSoap[j].value;
			document.tibCommonInoutdataForm.appendChild(input);	
		}
		if(selListIface.length > 0 || selListSap.length > 0 || selListSoap.length > 0){
			return true;
		}
		alert("<bean:message key="page.noSelect"/>");
		return false;
	}
	
	/**
	 * 删除带有INPUT的第一个子节点
	 */
	function removeAllChild(elementObj) {
		var childs = elementObj.childNodes;
		for (var i = 0; i < childs.length; i++) {
			var child = childs[i];
			if ("INPUT" == child.tagName) {
				elementObj.removeChild(child);
			}
		}
	}
	
</script>




<form
	action="<c:url value="/tib/common/inoutdata/tibCommonInoutdata.do?method=exportZip" />" name="tibCommonInoutdataForm"  method="POST">
	<div id="optBarDiv">
		<input type="button" value="<bean:message bundle="tib-common-inoutdata" key="imExport.dataExport" />"
			onclick="exportZip();">
	</div>
	
	<p class="txttitle">
		<bean:message bundle="tib-common-inoutdata"
			key="imExport.dataExport" />
	</p>
	
	<center>
		<table class="tb_normal" width=95%>
			<!-- 统一接口 -->
			<%--
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="tib-common-inoutdata" key="imExport.iface" />
				</td><td colspan="3" width="85%">
					<table class="tb_noborder">
						<tr>
							<td width="10pt"></td>
							<td>
								<div id=ifaceTreeDiv class="treediv"></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			--%>
			<!-- Sap组件 -->
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="tib-common-inoutdata" key="imExport.sap" />
				</td><td colspan="3" width="85%">
					<table class="tb_noborder">
						<tr>
							<td width="10pt"></td>
							<td>
								<div id=sapTreeDiv class="treediv"></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<!-- Soap组件 -->
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="tib-common-inoutdata" key="imExport.soap" />
				</td><td colspan="3" width="85%">
					<table class="tb_noborder">
						<tr>
							<td width="10pt"></td>
							<td>
								<div id=soapTreeDiv class="treediv"></div>
							</td>
						</tr>
					</table>
				</td>
			</tr>

		</table>
	</center>
	
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
