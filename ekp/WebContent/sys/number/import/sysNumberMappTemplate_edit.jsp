<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request"></c:set>
<c:set var="sysNumberMainMappForm" value="${mainModelForm.sysNumberMainMappForm}" scope="request"/>
<c:set var="sysNumberMainMappPrefix" value="sysNumberMainMappForm." scope="request"/>
<script type="text/javascript">
Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js|json2.js|formula.js|eventbus.js|xform.js");
</script>
<table class="tb_normal" width="100%" id="TB_Template_sysNumberMainMapp" border=1>
	<tr>
		<td width="25%" class="td_normal_title" valign="top">
			<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType" />
		</td>
		<td width="75%">
			<xform:radio property="fdType" 
				value="${sysNumberMainMappForm.fdType == null ? '0' : sysNumberMainMappForm.fdType}" 
				onValueChange="number_showInputType" showStatus="edit">
				<xform:simpleDataSource value="0">
					<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType0" /> 
				</xform:simpleDataSource>
				<xform:simpleDataSource value="1">
					<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType1" /> 
				</xform:simpleDataSource>
				<xform:simpleDataSource value="2">
					<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType2" /> 
				</xform:simpleDataSource>
				<c:if test="${param.isUnlimit=='true'}">
					<xform:simpleDataSource value="3">
						<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.inType3" /> 
					</xform:simpleDataSource>
				</c:if>
				
			</xform:radio>
		</td>
	</tr>
	<tr id="TR_ID_sysNumberMainMapp_numberId" style="display:none"> 
		<td width="25%" class="td_normal_title" valign="top">
			<bean:message bundle="sys-number" key="sysNumberMainMapp.tab.numberTemplateName" />
		</td>
		<td width="75%">
			<xform:select property="sysNumberMainMappNumberId" value="${sysNumberMainMappForm.fdNumberId}" showStatus="edit">
				<xform:customizeDataSource className="com.landray.kmss.sys.number.service.spring.SysNumberMainDataSource"></xform:customizeDataSource>
			</xform:select>
			<div id="divErrorNotSerlectNumberMain" style="display:none;color:red">
				<bean:message bundle="sys-number" key="sysNumber.error.noNumbersIsSelected"/>
			</div>
		</td>
	</tr>
	<!-- 选择特定编号规则时展示 -->
	<c:set var="number_iframe" value="${KMSS_Parameter_ContextPath}sys/number/sys_number_main/sysNumberMain.do?method=add&isCustom=1&modelName=${param.modelName}"/>
	<c:if test="${sysNumberMainMappForm.fdNumberId!=null && fn:length(sysNumberMainMappForm.fdNumberId)>1}">
		<c:set var="number_iframe" value="${KMSS_Parameter_ContextPath}sys/number/sys_number_main/sysNumberMain.do?method=edit&isCustom=1&fdId=${sysNumberMainMappForm.fdNumberId}"/>
	</c:if>
	<tr  id="TR_ID_sysNumberMainMapp_showNumber"  style="display:none">
		<td width="100%" colspan="2"  onresize="number_LoadIframe();">
			 <iframe id="iframeNumberCustomPage" src=""
			 	width="100%" height="100%" scrolling="no" frameborder="0">
			 </iframe>
		</td>
	</tr>
</table>
 
<html:hidden property="${sysNumberMainMappPrefix}fdNumberId" value="1"/>
<html:hidden property="${sysNumberMainMappPrefix}fdMainModelName" value="${param.modelName}"/>
<html:hidden property="${sysNumberMainMappPrefix}fdContent"/>
<!-- 流水号补零信息 -->
<html:hidden property="${sysNumberMainMappPrefix}fdFlowContent"/>

<script type="text/javascript">
	var temp_control_commit = 0;
	function number_LoadIframe(){
		Doc_LoadFrame("TR_ID_sysNumberMainMapp_showNumber","${number_iframe}");
	}
	function number_showInputType(val,obj) {
		if (val == "0"){
			$("#TR_ID_sysNumberMainMapp_numberId").hide();
			$("#TR_ID_sysNumberMainMapp_showNumber").hide();
			document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value="1";	//1为默认值
		} else if(val == "1") {
			$("#TR_ID_sysNumberMainMapp_numberId").show();
			$("#TR_ID_sysNumberMainMapp_showNumber").hide();
		} else if(val == "2") {
			$("#TR_ID_sysNumberMainMapp_numberId").hide();
			$("#TR_ID_sysNumberMainMapp_showNumber").show();
			if("${mainModelForm.method_GET}"=="add"){
			  number_LoadIframe();
			}
			document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value="-1";	//-1为自定义
		}else if(val == '3'){
			$("#TR_ID_sysNumberMainMapp_numberId").hide();
			$("#TR_ID_sysNumberMainMapp_showNumber").hide();
			document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value="-2";	//-2为不限制
			document.getElementsByName("${sysNumberMainMappPrefix}fdContent")[0].value = '';
			document.getElementsByName("${sysNumberMainMappPrefix}fdFlowContent")[0].value = '';
		}
	}

	function number_isExists(str){
		var dataObj = new Object();
		dataObj.modelName = "${param.modelName}";
		dataObj.templateId = $("input[name='fdId']").val();
		dataObj.fdContent = encodeURIComponent(str);
		dataObj.s_seq = Math.random(); 
		$.ajax({
            type: "post", 
            url: "${KMSS_Parameter_ContextPath}sys/number/sys_number_main/sysNumberMain.do?method=isExistsNumberRule",
            data: dataObj, 
            dataType: "text", 
            async:false,
            contentType:"application/x-www-form-urlencoded;charset=utf-8",
            success: function (data) {
                if(data == null || data===undefined || data=='null'){
                	temp_control_commit = 1 ;
                    return;
                }
                if(confirm('<bean:message bundle="sys-number" key="sysNumber.sysConfirmInfo"/><bean:message bundle="sys-number" key="sysNumber.isContinue"/>')){
                	temp_control_commit = 1;
                }else{
                	temp_control_commit = 2;
                }
            }
		});
	}
	
	function number_showData(){
		var fdTypeDom = document.getElementsByName("fdType");
		for(var i = 0; i < fdTypeDom.length; i++){
			 if(fdTypeDom[i].checked){
				 number_showInputType(fdTypeDom[i].value);
			}
		 }	
	}
	
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function(){
		var mName = document.getElementsByName("${sysNumberMainMappPrefix}fdMainModelName")[0];
		if(mName.value == ""){
			mName.value = "${param.modelName}";
		}
		var redioNumberId = "0";
		for (var i = 0; i < document.getElementsByName("fdType").length; i++){
			 if(document.getElementsByName("fdType")[i].checked){
				 redioNumberId = document.getElementsByName("fdType")[i].value;
			}
		 }
		if(redioNumberId == "1"){	//引用模板
		 	var id = document.getElementsByName("sysNumberMainMappNumberId")[0].value;
		 	if(id == ""){
			 	jQuery("#divErrorNotSerlectNumberMain").show();
			 	alert('<bean:message bundle="sys-number" key="sysNumber.error.noNumbersIsSelected"/>');
				return false;
			 }
			document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value = id;
		}else if(redioNumberId == "0"){	//默认
		 	document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value = "1";
		}else if(redioNumberId=="2"){	//自定义
		 	document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value = "-1";
            var frameObj = window.frames['iframeNumberCustomPage'].contentWindow?window.frames['iframeNumberCustomPage'].contentWindow:window.frames['iframeNumberCustomPage'];
            var fdFlowContentDom = frameObj.document.getElementsByName("fdFlowContent")[0];
            var frameFdFlowContent = fdFlowContentDom ? fdFlowContentDom.value : '';
            document.getElementsByName("${sysNumberMainMappPrefix}fdFlowContent")[0].value = frameFdFlowContent;
            
		 	if(frameObj.document.getElementsByName("fdContent").length>0){
		 		var iframeRuleValue = frameObj.document.getElementsByName("fdContent")[0].value;
		 		frameObj.eleNotInit(iframeRuleValue);
			 	if(frameObj.Page_CanCommit){
					alert('<bean:message bundle="sys-number" key="sysNumber.error.OneIsNotEmpty"/>');
					return false;
			 	}
			 	document.getElementsByName("${sysNumberMainMappPrefix}fdContent")[0].value = iframeRuleValue;
			}else{
				iframeRuleValue = document.getElementsByName("${sysNumberMainMappPrefix}fdContent")[0].value ;
			}
		 	if(!iframeRuleValue || iframeRuleValue=='[]'){
		 		alert('<bean:message bundle="sys-number" key="sysNumber.error.numberIsNotEmpty"/>');
				return false;
			}
		 	number_isExists(iframeRuleValue);
			if(temp_control_commit==1)
				return true;
			else
				return false;
		}else if(redioNumberId=="3"){
			document.getElementsByName("${sysNumberMainMappPrefix}fdNumberId")[0].value = "-2";
			document.getElementsByName("${sysNumberMainMappPrefix}fdContent")[0].value = '';
			document.getElementsByName("${sysNumberMainMappPrefix}fdFlowContent")[0].value = '';
		}
	 	return true;
	};
	
	$(document).ready(number_showData);
</script>
