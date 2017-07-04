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
<html:form action="/kms/multidoc/kms_multidoc_knowledge_config/kmsMultidocKnowledgeConfig.do">
	<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitForm('update');">
	</div>
	<p class="txttitle">
		<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig"/>
	</p>
	<center>
		<table class="tb_normal" width="90%">
				<tr class="tr_normal_title">
					<td width="40%">
						<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.selectTree"/>
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
					<td>
						<center>
							<input type=button class="btnopt" value="<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.view"/>" onclick="openCategory();">
							<br><br>
							<input type=button class="btnopt" value="<bean:message bundle="sys-home" key="sysHomeMain.nav.button.add"/>" onclick="addNavs()">
						</center>
					</td>
					<td>
						<html:textarea property="fdCategoryIds" style="display:none"/>
						<html:textarea property="fdCategoryNames" style="display:none"/>
						<select name="tmpSelectList" multiple ondblclick='deleteNav();' style='width:100%' size='15'></select>
					</td>
					<td>
						<center>
							<input type=button class="btnopt" value="<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.view"/>" onclick="openNav(document.getElementsByName('tmpSelectList')[0])">
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
Com_IncludeFile("select.js|tree_page.js");
							var LKSTree;
							function generateTree()
							{
								LKSTree = new TreeView("LKSTree", "<bean:message bundle='kms-multidoc' key='kmsMultidocTemplate.commonConfig.selectCategory'/>", document.getElementById("treeDiv"));
								LKSTree.isShowCheckBox=true;
								LKSTree.isMultSel=true;
								LKSTree.isAutoSelectChildren = false;
								LKSTree.DblClickNode = addNav;
								var n1, n2;
								n1 = LKSTree.treeRoot;	
								var modelName = "com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate";
								n2 = n1.AppendSimpleCategoryData(modelName);
								LKSTree.Show();
								//initSelField();
							}
							function addNav(id){
								if(id==null) return false;
								var node = Tree_GetNodeByID(this.treeRoot,id);
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
									alert('<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.selectCategory.notNull"/>');
									return;
								}
								for(var i=selList.length-1;i>=0;i--){
									selField = document.getElementsByName("tmpSelectList")[0];
									var canAdd = true;
									for(var j=0; j<selField.options.length; j++){
										if(selField.options[j].value==selList[i].value)
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
								Com_OpenWindow("<c:url value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=view&fdId="/>"+obj.options[obj.selectedIndex].value, "_blank");
							}
							function openCategory(){
								var selList = LKSTree.GetCheckedNode();
								if(selList == "")
									alert('<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.selectCategory.notNull"/>');
								else(selList.length >= 0)
									Com_OpenWindow("<c:url value="/kms/multidoc/kms_multidoc_template/kmsMultidocTemplate.do?method=view&fdId="/>"+selList[0].value, "_blank");
							}
							function setSelField(rtnData){
								var navIds = document.getElementsByName("fdCategoryIds")[0].value.split("\r\n");
								if(rtnData){
									var objs = rtnData.GetHashMapArray();
									var field = document.getElementsByName("tmpSelectList")[0];
									for(var i=0;i<navIds.length;i++){
										for(var j=0; j<objs.length; j++){
											var obj = objs[j];
											alert("navIds["+i+"]="+navIds[i]+"obj[value]="+obj["value"]);
											if(navIds[i] == obj["value"]){
												field.options[field.options.length] = new Option(obj["text"],obj["value"]);
											}
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
								document.getElementsByName("fdCategoryIds")[0].value = ids;
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
								generateTree();
								//var modelName = "com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate";
								//var cateUrl = 'sysSimpleCategoryTreeService&authType=00&categoryId=all&modelName=' + modelName;
								//var data = new KMSSData();
								//data.SendToBean(cateUrl, setSelField);
								var categoryIdVal = document.getElementsByName("fdCategoryIds")[0].value;
								var categoryNameVal = document.getElementsByName("fdCategoryNames")[0].value;
								if(categoryNameVal != "" && categoryNameVal != null){
									var categoryIds = categoryIdVal.split("\r\n");
									var categoryNames = categoryNameVal.split(";");
									var field = document.getElementsByName("tmpSelectList")[0];
									for(var i=0; i<categoryIds.length; i++){
										field.options[field.options.length] = new Option(categoryNames[i],categoryIds[i]);
									}
								}
							}
							//generateTree();
							//generateTree();
						</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
