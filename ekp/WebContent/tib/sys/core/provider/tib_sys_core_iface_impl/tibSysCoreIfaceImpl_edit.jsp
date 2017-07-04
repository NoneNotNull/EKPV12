<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="net.sf.json.JSONArray"%>
<%@ page import="org.springframework.web.util.HtmlUtils"%>
<%@ page import="com.landray.kmss.tib.sys.core.util.TibSysCoreUtil"%>
<%@ page import="com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins" %>

<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/tib/common/resource/plumb/jsp/includePlumb.jsp"%>

<%-- 引入js文件 --%> 
<%
List<Map<String, String>> pluginList = TibSysCoreProviderPlugins.getConfigs();
StringBuffer buf = new StringBuffer("{");
for (Map<String, String> map : pluginList) {
	buf.append("\""+map.get("providerKey")+"\":{");
	String convertXmlJsPath = map.get("convertXmlJsPath");
	if (StringUtil.isNotNull(convertXmlJsPath)) {
		String convertXmlJsFunc = map.get("convertXmlJsFunc");
		String jsPath = convertXmlJsPath.substring(0, convertXmlJsPath.lastIndexOf("/") + 1);
		String jsName = convertXmlJsPath.substring(convertXmlJsPath.lastIndexOf("/") + 1);
		buf.append("\"convertXmlJsFunc\":\""+ convertXmlJsFunc +"\",");
		buf.append("\"jsPath\":\""+ jsPath +"\",");
		buf.append("\"jsName\":\""+ jsName +"\",");
	}
	buf.append("\"providerName\":\""+ map.get("providerName") +"\"");
	buf.append("},");
}
buf = new StringBuffer(buf.substring(0, buf.length() - 1));
buf.append("}");
String handInfoStr = TibSysCoreUtil.addSprit(buf.toString());
%>

<link href="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/css/dtree.css" rel="StyleSheet" type="text/css" />
<script src="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/dtree.js" type="text/javascript"></script>
<script>
	Com_IncludeFile("dialog.js|data.js|json2.js");
</script>
<script>
	Com_IncludeFile("tib_validations.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);
	Com_IncludeFile("tib_sys_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
	Com_IncludeFile("tib_ifaceImpl.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
	var TibProvider_Lang = {
	    getError : "<bean:message bundle="tib-sys-core-provider" key="tibSysCore.lang.getError"/>",
	    fdName : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.required.fdName"/>",
	    fdImplRefName : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.required.fdImplRefName"/>",
	    tibSysCoreIfaceId : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.required.tibSysCoreIfaceId"/>",
	    fdOrderBy : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.required.fdOrderBy"/>"
	};
	
	var Plugin_HandInfo = eval("(<%=handInfoStr%>)");
	for (var key in Plugin_HandInfo) {
		var jsPath = Plugin_HandInfo[key]["jsPath"];
		var jsName = Plugin_HandInfo[key]["jsName"];
		if (jsPath != null && jsName != null) {
			// 引入扩展点js文件，作用是转换xml
			Com_IncludeFile(jsName, "${KMSS_Parameter_ContextPath}"+ jsPath, "js", true);
		}
	}
</script>
<html:form action="/tib/sys/core/provider/tib_sys_core_iface_impl/tibSysCoreIfaceImpl.do">
<div id="optBarDiv">
	<c:if test="${tibSysCoreIfaceImplForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="saveBefore('update');">
	</c:if>
	<c:if test="${tibSysCoreIfaceImplForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="saveBefore('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysCoreIfaceImplForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-core-provider" key="table.tibSysCoreIfaceImpl"/></p>
<html:messages id="messages" message="true">
	<table style="margin:0 auto" align="center"><tr><td><img src='${KMSS_Parameter_ContextPath}resource/style/default/msg/dot.gif'>&nbsp;&nbsp;<font color='red'>
      <bean:write name="messages" /></font>
	 </td></tr></table><hr />
</html:messages> 
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.fdName"/>
		</td><td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%;" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.fdOrderBy"/>
		</td><td width="35%">
			<xform:text property="fdOrderBy" style="width:85%;" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.fdFuncType"/>
		</td><td width="35%">
			<input type="text" name="fdFuncType" style="width:85%; display: none;" value="${tibSysCoreIfaceImplForm.fdFuncType }"/>
			<input type="text" name="fdFuncTypeName" id="fdFuncTypeName" readonly="readonly" class="inputread"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.tibSysCoreIface"/>
		</td><td width="35%">
			<xform:select htmlElementProperties="id='tibSysCoreIfaceId'" property="tibSysCoreIfaceId" onValueChange="ifaceChange();" value="${tibSysCoreIfaceImplForm.tibSysCoreIfaceId }">
				<xform:beanDataSource serviceBean="tibSysCoreIfaceService" selectBlock="fdId,fdIfaceName" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.fdImplRef"/>
		</td><td width="35%">
			<xform:dialog style="width:90%;"
					propertyId="fdImplRef" propertyName="fdImplRefName"
					dialogJs="Tib_treeDialog();"></xform:dialog>
		</td>
	</tr>
	<!-- 映射配置 -->
	<tr>
		<td width=100% colspan="4" align="center">
			<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.fdImplRefData"/>
		</td>
	</tr>
	<tr>
		<td width=50% colspan="2" valign="top">
			<div style="display: none;"><span class="tleft"></span></div>
			<div id="treeDiv"></div>
		</td><td width=50% colspan="2" valign="top">
			<div id="targetTreeDiv"></div>
			<div style="display: none;"><span class="tright"></span></div>
			<xform:textarea showStatus="noShow" property="fdImplRefData" style="width:85%" />
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script> 
function click(id, locaId, parID,nodeName) {
	// 空方法，防止树可以编辑
}

setTimeout("startLoadInfo();", 10);
function startLoadInfo() {
	// 验证加星*
	IfaceImplValid.init();
	// 编辑页面_选择所属接口
	ifaceChange();
	// 编辑页面_选择实现函数
	call_funcChange();
	//_jsPlumb_endpoint
	
}

function Tib_treeDialog() {
	var t_bean="tibSysCoreIfaceRefBean&selectId=!{value}&type=cate";
	var d_bean="tibSysCoreIfaceRefBean&selectId=!{value}&type=func";
	var s_bean="tibSysCoreIfaceRefBean&keyword=!{keyword}&type=search";
	//输入参数有点眼花,换成这种
	var data = {
		idField : "fdImplRef",
		nameField : "fdImplRefName",
		treeBean : t_bean,
		treeTitle :'<bean:message bundle="tib-sys-core-provider" key="tibSysCore.fdIfaceRef.treeTitle" />',
		dataBean : d_bean,
		action : function(rtn){
			if(rtn && rtn.GetHashMapArray().length>0){
				// 先移除模版
				//removeMapperTemplate();
				var data=rtn.GetHashMapArray()[0];
				var id = data["id"];
				var providerKey = data["providerKey"];
				var providerName = data["providerName"];
				$("input[name=fdFuncType]").val(providerKey);
				$("input[name=fdFuncTypeName]").val(providerName);
				// 选择函数后的操作
				call_funcChange(id, providerKey);
			}
		},
		searchBean : s_bean,
		winTitle : '<bean:message bundle="tib-sys-core-provider" key="tibSysCore.fdIfaceRef.winTitle" />'
	};
	TIB_SysUtil.tibTreeDialog(data);
}

$KMSSValidation();
</script>

</html:form>

<%@ include file="/resource/jsp/edit_down.jsp"%>

			