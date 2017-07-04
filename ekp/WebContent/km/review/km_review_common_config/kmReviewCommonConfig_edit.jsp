<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style>
.treediv{}
.treediv table{border: 0px;}
.treediv table tr{border: 0px;}
.treediv table tr td{border: 0px;padding-top: 0px;padding-bottom: 0px;}
</style>
<script>
function submitForm(method){
	Com_Submit(document.forms[0], method);
}
</script>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<html:form action="/km/review/km_review_common_config/kmReviewCommonConfig.do">
	<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitForm('update');">
	</div>
	<p class="txttitle">
		<bean:message  bundle="km-review" key="kmReviewMain.commonConfig"/>
	</p>
	<center>
		<table class="tb_normal" width="90%">
				<tr class="tr_normal_title">
					<td width="40%">
						<bean:message  bundle="km-review" key="kmReviewMain.commonConfig.selectTree"/>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="40%">
						<bean:message bundle="sys-home" key="sysHomeMain.nav.selectList"/>
					</td>
					<td width="10%">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
						<div id=treeDiv class="treediv"></div>
					</td>
					<td width="100px">
						<center>
							<input type=button class="btnopt" value="<bean:message  bundle="km-review" key="kmReviewMain.commonConfig.view"/>" onclick="openCategory();">
							<br><br>
							<input type=button class="btnopt" value="<bean:message bundle="sys-home" key="sysHomeMain.nav.button.add"/>" onclick="addNavs()">
						</center>
					</td>
					<td>
						<html:textarea property="fdTemplateIds" style="display:none"/>
						<html:textarea property="fdTemplateNames" style="display:none"/>
						<select name="tmpSelectList" multiple ondblclick='deleteNav();' style='width:100%' size='15'></select>
					</td>
					<td width="100px">
						<center>
							<input type=button class="btnopt" value="<bean:message  bundle="km-review" key="kmReviewMain.commonConfig.view"/>" onclick="openNav(document.getElementsByName('tmpSelectList')[0])">
							<br><br>
							<input type=button class="btnopt" value="<bean:message bundle="sys-home" key="sysHomeMain.nav.button.delete"/>" onclick="deleteNav(false)">
							<br><br>
							<input type=button class="btnopt" value="<bean:message bundle="sys-home" key="sysHomeMain.nav.button.clear"/>" onclick="deleteNav(true)">
							<br><br>
							<input type=button class="btnopt" value="<bean:message bundle="sys-home" key="sysHomeMain.nav.button.up"/>" onclick="moveNav(-1)">
							<br><br>
							<input type=button class="btnopt" value="<bean:message bundle="sys-home" key="sysHomeMain.nav.button.down"/>" onclick="moveNav(1)">
						</center>
					</td>
				</tr>
			</table>
	</center>
	<html:hidden property="method_GET" />
	<input type="hidden" name="modelName" value="com.landray.kmss.sys.notify.model.SysNotifyConfig" />
</html:form>
<script>
	Com_IncludeFile("select.js");
	var modelName = "com.landray.kmss.km.review.model.KmReviewTemplate";
	var categoryIncludeValue=[], propertyIncludeValue=[];
	function loadAuthNodesValue() { // 过滤没权限或者没有模板的分类节点
		var nodesValue = new KMSSData().AddBeanData("sysCategoryAuthTreeService&modelName="+modelName).GetHashMapArray();
		for(var val in nodesValue[0]) {
			categoryIncludeValue.push(nodesValue[0][val]); // 分类
		}
		for(var v in nodesValue[1]) {
			propertyIncludeValue.push(nodesValue[1][v]); // 辅分类
		}
	}
	var LKSTree;
	function generateTree()
	{
		LKSTree = new TreeView("LKSTree", "<bean:message  bundle='km-review' key='kmReviewMain.commonConfig.selectCategory'/>", document.getElementById("treeDiv"));
		LKSTree.isShowCheckBox=true;
		LKSTree.isMultSel=true;
		LKSTree.isAutoSelectChildren = false;
		LKSTree.DblClickNode = addNav;
		var n1, n2;
		n1 = LKSTree.treeRoot;	
		//n2 = n1.AppendCategoryData(modelName,null,"1");
		n1.authType = "02";
		n2 = n1.AppendCategoryData(modelName, null, 1, null, null, null, null, null, categoryIncludeValue);
		LKSTree.Show();
		//initSelField();
	}
	function addNav(id){
		if(id==null) return false;
		var node = Tree_GetNodeByID(this.treeRoot,id);
		if(!(node.nodeType == "TEMPLATE"))
			return;
		var canAdd = true;
		if(node!=null && node.value!=null) {
			selField = document.getElementsByName("tmpSelectList")[0];
			for(var j=0; j<selField.options.length; j++){
				if(selField.options[j].value==node.value)
					canAdd = false;
			}
			if(canAdd)
				selField.options[selField.options.length] = new Option(node.text, node.value)
		}
		refreshNavField();
	}
	function addNavs(){
		var selList = LKSTree.GetCheckedNode();
		if(selList == ""){
			alert('<bean:message  bundle="km-review" key="kmReviewMain.commonConfig.selectCategory.notNull"/>');
			return;
		}
		for(var i=selList.length-1;i>=0;i--){
			selField = document.getElementsByName("tmpSelectList")[0];
			var canAdd = true;
			for(var j=0; j<selField.options.length; j++){
				if(selField.options[j].value==selList[i].value || !(selList[i].nodeType == "TEMPLATE"))
					canAdd = false;
			}
			if(canAdd)
				selField.options[selField.options.length] = new Option(selList[i].text, selList[i].value);
		}
		refreshNavField();	
	}
	function openNav(obj){
		if(obj.selectedIndex==-1)
			return;
		Com_OpenWindow("<c:url value="/km/review/km_review_template/kmReviewTemplate.do?method=view&fdId="/>"+obj.options[obj.selectedIndex].value, "_blank");
	}
	function openCategory(){
		var selList = LKSTree.GetCheckedNode();
		if(selList == "")
			alert('<bean:message  bundle="km-review" key="kmReviewMain.commonConfig.selectCategory.notNull"/>');
		else(selList.length >= 0)
			Com_OpenWindow("<c:url value="/km/review/km_review_template/kmReviewTemplate.do?method=view&fdId="/>"+selList[0].value, "_blank");
	}
	function initSelField(){
		var cateUrl = 'sysSimpleCategoryTreeService&authType=00&categoryId=all&modelName=' + modelName;
		var data = new KMSSData();
		data.SendToBean(cateUrl, setSelField);
	}
	function setSelField(rtnData){
		var navIds = document.getElementsByName("fdTemplateIds")[0].value.split("\r\n");
		if(rtnData){
			var objs = rtnData.GetHashMapArray();
			var field = document.getElementsByName("tmpSelectList")[0];
			for(var i=0;i<navIds.length;i++){
				for(var j=0; j<objs.length; j++){
					var obj = objs[j];
					if(navIds[i] == obj["value"])
						field.options[field.options.length] = new Option(obj["text"],obj["value"]);
				}
				
			}
		}
	}
	function refreshNavField(){
		var selectOptions = document.getElementsByName("tmpSelectList")[0].options;
		var ids = "";
		var names = "";
		for(var i=0; i<selectOptions.length; i++){
			if(i>0){
				ids += "\r\n";
				names += "\r\n";
			}
			ids += selectOptions[i].value;
			names += selectOptions[i].text;
		}
		document.getElementsByName("fdTemplateIds")[0].value = ids;
	}
	function deleteNav(isAll){
		Select_DelOptions("tmpSelectList", isAll);
		refreshNavField();
	}
	function moveNav(direct){
		Select_MoveOptions("tmpSelectList", direct);
		refreshNavField();
	}
	window.onload = function(){
		loadAuthNodesValue();
		generateTree();
		//var modelName = "com.landray.kmss.km.doc.model.KmDocTemplate";
		//var cateUrl = 'sysSimpleCategoryTreeService&authType=00&categoryId=all&modelName=' + modelName;
		//var data = new KMSSData();
		//data.SendToBean(cateUrl, setSelField);
		var templateIdVal = document.getElementsByName("fdTemplateIds")[0].value;
		var templateNameVal = document.getElementsByName("fdTemplateNames")[0].value;
		if(templateNameVal != "" && templateNameVal != null){
			var templateIds = templateIdVal.split("\r\n");
			var templateNames = templateNameVal.split(";");
			var field = document.getElementsByName("tmpSelectList")[0];
			for(var i=0; i<templateIds.length; i++){
				field.options[field.options.length] = new Option(templateNames[i],templateIds[i]);
			}
		}
	}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>