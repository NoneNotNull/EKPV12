<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
    Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("doclist.js|dialog.js|jquery.js|kms_tmpl.js|json2.js");
</script>
<style>
.tb_normal {
	border-color: #dddde5;
}
</style>
<html:form action="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do">

	<div id="optBarDiv">
	  <c:if test="${pdaTabViewConfigMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>" id="pdaTabViewConfigMainUpdateBut" />
	  </c:if> 
	  <c:if test="${pdaTabViewConfigMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>" id = "pdaTabViewConfigMainSaveBut" />
	  </c:if> 
	    <input type="button" value="<bean:message key="button.close"/>" id="pdaTabViewConfigMainCloseBut" />
    </div>

	<p class="txttitle"><bean:message bundle="third-pda" key="table.pdaTabViewConfigMain" /></p>

	<center>

	<table class="tb_normal" width=95%>
		<tr>
			<%-- 功能区名称 --%>
			<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdName" /></td>
			<td width="85%"><xform:text property="fdName" style="width:35%" /></td>
		</tr>
		<tr>
			<%-- 所属组件名称 --%>
			<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdModuleId" /></td>
			<td width="85%">
			   <html:hidden property="fdModuleId" />
			   <xform:text property="fdModuleName" style="width:35%" /> 
			    <a onclick="selectModule();return false;" href=""><bean:message key="dialog.selectOther" /></a>
			   <span class="txtstrong">*</span>
			</td>
		</tr>
		<tr>
			<%-- 是否启用 --%>
			<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdStatus" /></td>
			<td width="85%">
			  <xform:checkbox property="fdStatus">
				<xform:simpleDataSource value="1" textKey="message.yes"></xform:simpleDataSource>
			  </xform:checkbox>
			  <br>
			</td>
		</tr>
		<tr>
			<%-- 排序号,可为空 --%>
			<td class="td_normal_title" width=15%><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdOrder" /></td>
			<td width="85%"><xform:text property="fdOrder" style="width:15%" /></td>
		</tr>
		<%-- 类型为listTab 功能区配置 menglei begin --%>
		<tr id="tr_listArea">
			<td colspan="4" width=100%>
				<bean:message bundle="third-pda" key="table.pdaModuleLabelList"/><br/>
				<c:import url="/third/pda/pda_tabview_label_list/pdaTabViewLabelList_edit.jsp" charEncoding="UTF-8">
				</c:import>
				<bean:message bundle="third-pda" key="pdaTabViewConfigMain.tabViewList.summary"/>
			</td>
		</tr>
		<%-- 类型为listTab 功能区配置 menglei end --%>
	</table>
	</center>
	
<script>

   $(document).ready(function(){
    
       //新增按钮
       $("#pdaTabViewConfigMainSaveBut").click(function(){
    	  pdaTabViewConfigMainCommonValidation('save');
          return false;
       });

       //更新按钮
       $("#pdaTabViewConfigMainUpdateBut").click(function(){
    	   pdaTabViewConfigMainCommonValidation('update');
          return false;
       });

       //关闭按钮
       $("#pdaTabViewConfigMainCloseBut").click(function(){
    	  Com_CloseWindow();
          return false;
       });
 
    });
    
    //新增或者修改表单提交
    function pdaTabViewConfigMainCommonValidation(method){
	   if(!validate()){
         return;
       }else{
    	   Com_Submit(document.pdaTabViewConfigMainForm, method);
       }
	}
		
	//选择模块
	function selectModule() {
		Dialog_List(false,"fdModuleId","fdModuleName",null,"pdaModuleConfigSelectDialog&fdType=1",
				selectModuleCallBack,null,null,null,"<bean:message bundle='third-pda' key='pdaTabViewConfigMain.moduleSelectDilog'/>");
	};

	//选择模块后的回调事件
	function selectModuleCallBack(rtnVal){
		if (rtnVal && rtnVal.data.length > 0) {
			var dataObj = rtnVal.data[0];
			var fdUrlPrefix = dataObj.fdUrlPrefix;
			var fdModuleName = dataObj.name;
			$('#fdUrlPrefix').val(fdUrlPrefix);
			$('#fdModuleName').val(fdModuleName);
			var fdNameObj = $('input[name="fdName"]');
			if(fdNameObj.val()==''){
				fdNameObj.val(fdModuleName+'_功能区');
			}
		}
	}

	//根据当前模块id选择标签页
	function selectLabelListByFdModuleId(index) {
		var fdModuleId = $('input[name="fdModuleId"]').val();
		$('#select_label_List_By_Fd_ModuleId_Index').val(index);
		Dialog_List(false,null,null,null,"pdaModuleConfigSelectDialog&fdType=2&fdId="+fdModuleId,
				selectLabelListCallBack,null,null,null,"<bean:message bundle='third-pda' key='pdaTabViewLabelList.moduleLabelSelectDilog'/>");
	};

	//根据当前模块id选择标签页后的回调事件
	function selectLabelListCallBack(rtnVal){
		if (rtnVal && rtnVal.data.length > 0) {
			var dataObj = rtnVal.data[0];
			var fdDataUrl = dataObj.fdDataUrl;
			var index = $('#select_label_List_By_Fd_ModuleId_Index').val();
			var fdLabelList_index_fdTabUrl = $('input[name=fdLabelList['+index+'].fdTabUrl]');
			fdLabelList_index_fdTabUrl.val(fdDataUrl);
		}
    }

	//选择数据字典模型
	function selectDictModelByFdUrlPrefix(index){
		var urlPrefix =$('#fdUrlPrefix').val();
		Dialog_List(false, "fdLabelList["+index+"].fdTabBean", null, null, "pdaDictModelSelectDialog&urlPrefix="+urlPrefix,
				null,null,null,null,"<bean:message bundle='third-pda' key='pdaModuleConfigView.docSelectDilog'/>");
		loadDictPropertyData(index);
	}

	//加载数据字典里面属性数据
	function loadDictPropertyData(index){
		var modelName = $('input[name="fdLabelList['+index+'].fdTabBean"]').val();
		if(modelName == null && modelName == ""){
			return;
		}
		var data = new KMSSData();
		var url="pdaDictPropertySelectList&fdLabelList["+index+"].fdTabBean="+modelName;
		data.SendToBean(url,null);
	}

	//文档,分类选择（doc,listcategory）
	function selectDataUrl(index){
		//var fdUrlPrefix = document.getElementsByName("fdUrlPrefix")[0];
		var fdUrlPrefix = $('#fdUrlPrefix').val();
		if(fdUrlPrefix=="" || typeof(fdUrlPrefix)=='undefined'){
			alert('<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdModuleId"/><bean:message bundle="third-pda" key="validate.notNull"/>\n');
			return;
		}
		var linkType = "doc";
		if(index!= null){
			window._S_fdLabel_Index = index;
			linkType = "list";
		}
		Dialog_List(false,null,null, ';', 'pdaSysConfigDialog&urlPrefix='+ fdUrlPrefix+'&type='+linkType,afterSelectFun);
	}

	//文档连接地址 回调函数
	function afterSelectFun(dataObj){
		if(dataObj!=null){
			var rtnData=dataObj.GetHashMapArray();
			if(rtnData[0]!=null){
				if(window._S_fdLabel_Index!=null){
					var index =	window._S_fdLabel_Index;
					var url = rtnData[0]["url"]==null?"":rtnData[0]["url"].replace(/!{cateid}/,'');
					var tmpClass = rtnData[0]["tmpClass"];
					var fdTabUrl_index = $('input[name="fdLabelList['+index+'].fdTabUrl"]');
					fdTabUrl_index.val(url);
				}
			}
		}
	}

	//引入校验框架代码
	$KMSSValidation();

	// 新增或者修改时候的验证
	function validate() {
		var rtn = true, msg = "";
		if(!$('input[name="fdName"]').val()) {
			msg += '<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdName"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';	
		}
		if(!$('input[name="fdModuleId"]').val()) {
			msg += '<bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdModuleId"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
		}
		var dynRowObj = $('#TABLE_DocList').find('tr');
		var minDynRow = dynRowObj.length;
		if(minDynRow<=1){
			msg += '<bean:message bundle="third-pda" key="table.pdaModuleLabelList"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
		}else{
			$(dynRowObj.each(
				function(i) {
					if(i>0){//校验跳过表头行
						var index = (parseInt(i) - 1); //调整动态行元素下标
						var fdTabName_index = $(this).find('input[name="fdLabelList[' + index + '].fdTabName"]');
						var fdTabType_index = $(this).find('select[name="fdLabelList[' + index + '].fdTabType"]');
						var row = (parseInt(i));  //调整动态行提示内容下标
						var _this = $(this);
						msg  += getDynRowAlertMsg(fdTabName_index,fdTabType_index,row,index,_this);
				    }
				}));
		}
		if (msg!="") {
			alert(msg);
			rtn = false;
		}
		return rtn;
	}

	// 拼接动态行的错误消息提示
	function getDynRowAlertMsg(fdTabName_index,fdTabType_index,row,index,_this){
		var msg = "";
		if (fdTabName_index.length > 0) {
			if (!fdTabName_index.val()) {
				msg += '<bean:message bundle="third-pda" key="pdaTabViewLabelList.the"/>' + row + '<bean:message bundle="third-pda" key="pdaTabViewLabelList.row"/><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabName"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			}
		}
		if (fdTabType_index.length > 0) {
			if (!fdTabType_index.val()) {
				msg += '<bean:message bundle="third-pda" key="pdaTabViewLabelList.the"/>' + row + '<bean:message bundle="third-pda" key="pdaTabViewLabelList.row"/><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
			}
		}
		var fdTabType_index_value = fdTabType_index.val(); 
		if(fdTabType_index_value=='list'){
			var fdTabUrl_index = _this.find('input[name="fdLabelList[' + index + '].fdTabUrl"]');
			if (fdTabUrl_index.length > 0) {
				if (!fdTabUrl_index.val()) {
					msg += '<bean:message bundle="third-pda" key="pdaTabViewLabelList.the"/>' + row + '<bean:message bundle="third-pda" key="pdaTabViewLabelList.row"/><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdConfigurationItem"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
				}
			}
		}else if(fdTabType_index_value=='listcategory'){
			var fdTabBean_index = _this.find('input[name="fdLabelList[' + index + '].fdTabUrl"]');
			if (fdTabBean_index.length > 0) {
				if (!fdTabBean_index.val()) {
					msg += '<bean:message bundle="third-pda" key="pdaTabViewLabelList.the"/>' + row + '<bean:message bundle="third-pda" key="pdaTabViewLabelList.row"/><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdConfigurationItem"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
				}
			}
		}else if(fdTabType_index_value=='doc'){
			var fdTabUrl_index = _this.find('input[name="fdLabelList[' + index + '].fdTabUrl"]');
			if (fdTabUrl_index.length > 0) {
				if (!fdTabUrl_index.val()) {
					msg += '<bean:message bundle="third-pda" key="pdaTabViewLabelList.the"/>' + row + '<bean:message bundle="third-pda" key="pdaTabViewLabelList.row"/><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdConfigurationItem"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
				}
			}
		}else if(fdTabType_index_value=='search'){
			var fdTabBean_index = _this.find('input[name="fdLabelList[' + index + '].fdTabBean"]');
			if (fdTabBean_index.length > 0) {
				if (!fdTabBean_index.val()) {
					msg += '<bean:message bundle="third-pda" key="pdaTabViewLabelList.the"/>' + row + '<bean:message bundle="third-pda" key="pdaTabViewLabelList.row"/><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdConfigurationItem"/><bean:message bundle="third-pda" key="validate.notNull"/>\n';
				}
			}
		}
		return msg;
	}
	
</script>

<html:hidden property="fdId" />
<html:hidden property="method_GET" />

<input type="hidden" id="select_label_List_By_Fd_ModuleId_Index" value=""/>
<input type="hidden" id="fdUrlPrefix" value="${fdUrlPrefix}" />
<input type="hidden" id="fdModuleName" value="${pdaTabViewConfigMainForm.fdModuleName}" />

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>