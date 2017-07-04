<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib
	uri="/tib/sys/core/provider/resource/tld/tib-sys-provider.tld"
	prefix="tib"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.springframework.web.util.HtmlUtils"%>
<%@page import="com.landray.kmss.tib.sys.core.util.TibSysCoreUtil"%>

<link href="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/css/dtree.css" rel="StyleSheet" type="text/css" />
<link href="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/css/core.css" type="text/css" rel="stylesheet"/>
<script src="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/dtree.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/popup_layer.js" type="text/javascript" language="javascript"></script>

<script type="text/javascript">
	Com_IncludeFile("dialog.js");
	Com_IncludeFile("tib_sys_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
	Com_IncludeFile("tib_sys_core_tree.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
	Com_IncludeFile("tib_validations.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);
	Com_IncludeFile("tib_dialog.js", "${KMSS_Parameter_ContextPath}tib/common/resource/js/", "js", true);
	TibTree_Lang = {
		tibId : "<bean:message bundle="tib-sys-core-provider" key="tibSysCore.lang.tibId"/>",
		tibModelClassName : "<bean:message bundle="tib-sys-core-provider" key="tibSysCore.lang.tibModelClassName"/>",
		tagdb : "<bean:message bundle="tib-sys-core-provider" key="tibSysCore.lang.tagdb"/>",
	    deleteNode : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.deleteNode"/>",
	    editNode : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.editNode"/>",
	    addChildNode : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.addChildNode"/>",
	    isDelete : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.isDelete"/>",
	    isDeleteExistChildNode : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.isDeleteExistChildNode"/>",
	    nodeNameRequired : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.nodeNameRequired"/>",
	    nodeNameRepeat : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIfaceImpl.nodeNameRepeat"/>",
	    lengthRequired : "<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.lengthRequired"/>"
	};
</script>

<script type="text/javascript">
    var nodeID = 0; // 当前选中节点ID
    var nodePareID = 0; // 当前ID的父级ID
	var nodeLocaId = 0; // 当前位置的ID
	var popup = null;
    //节点点击事件
	function click(id, locaId, parID,nodeName) {
		var fdIfaceType = "${tibSysCoreIfaceForm.fdIfaceType}";
		// 通过数据初始化过来的数据限制编辑
		if ("1" != fdIfaceType) {
			operationStatus(locaId, nodeName, parID);
			// 选中后单击，且排除in节点编辑
			if (id == nodeID && 0 != parID) {
				$("#editId").trigger("click");
			} 
		    nodeID = id;
		    nodePareID = parID;
			nodeLocaId = locaId;
		}
	}

	$(function() {
		dTree2Xml("${tibSysCoreIfaceForm.fdIfaceXml}");
		FUN_AddValidates("fdIfaceName:required", "fdIfaceKey:required");
	});
</script>

<html:form
	action="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do">
	<div id="optBarDiv"><c:if
		test="${tibSysCoreIfaceForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.tibSysCoreIfaceForm, 'update');">
	</c:if> <c:if test="${tibSysCoreIfaceForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tibSysCoreIfaceForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.tibSysCoreIfaceForm, 'saveadd');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="tib-sys-core-provider"
		key="table.tibSysCoreIface" /></p>
<div id="delete_confirm" title="消息框" style="display: none;">
	<p>是否确定删除？</p>
</div>
<div id="delete_confirm_again" title="消息框" style="display: none;">
	<p>当前节点下拥有子节点，是否一并删除所有子节点？只删除该节点选择否！</p>
</div>
	<center>
	<table class="tb_normal" width=95%>
		<!-- 接口名称 -->
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceName" />
			</td>
			<td width="85%" colspan="3"><xform:text property="fdIfaceName"
				style="width:85%" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.fdNote" /></td>
			<td width="85%" colspan="3">
				<xform:textarea showStatus="edit" property="fdNote" style="width:85%"></xform:textarea>
			</td>
		</tr>
		<!-- 接口标签 -->
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceTags" />
			</td>
			<td colspan="3" width="85%">
				<tib:simpleTags propertyId="fdIfaceTagVos" propertyName="fdIfaceTagNames" ></tib:simpleTags>
			</td>	
		
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceKey" /></td>
			<td width="85%" colspan="3"><xform:text property="fdIfaceKey" onValueChange="dTree2Xml();" 
				style="width:85%" /></td>
		</tr>
		<!-- 调度模式， 前台控制 -->
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.controlPattern" />
			</td>
			<td width="35%"><xform:select property="fdControlPattern" showPleaseSelect="noshow" onValueChange="dTree2Xml();">
				<xform:enumsDataSource enumsType="fd_control_pattern_enums" />
			</xform:select></td>
			<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceControl" />
			</td>
			<td width="35%"><xform:radio property="fdIfaceControl">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio></td>
		</tr>
		<tr>
			<td class="td_normal_title" width="100%" colspan="4" style="text-align: center;">
				<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceXml" />
				<c:if test="${tibSysCoreIfaceForm.fdIfaceType == 1}">
					<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.initIface" />
				</c:if>
			</td>
		</tr>
		<tr>
			<td width="50%" colspan="2" valign="top">
				<!-- 展开、收起  class="dtree" -->
				<div style="padding-left:11px;" class="dTreeNode">
					<a href="javascript: d.openAll();" class=node>
						<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.openAll"/>
					</a> 
					| <a href="javascript: d.closeAll();" class=node>
						<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.closeAll"/>
					</a> 
					| <a href="javascript: xml2DTree();" class=node>生成树</a>
				</div>
				<div id="treeDiv">
					<script type="text/javascript">
						//实例名d不可以改变。
						d = new dTree("d");
						d.add(0,-1,'tib');
						d.add(1,0,'in','in', "", "", "", "", true);
						var xmlStr = "${tibSysCoreIfaceForm.fdIfaceXml}";
						// var xmlStr = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><tib><in><Node1.1 ctype=\"string\" length=\"200\" required=\"1\" multi=\"1\"><Node1.1.1 ctype=\"int\" required=\"0\" multi=\"1\"><Node1.1.1.1 ctype=\"string\" length=\"200\" required=\"0\" multi=\"1\"/></Node1.1.1><Node1.1.2 ctype=\"int\" required=\"0\" multi=\"1\"/></Node1.1><Node1.2 ctype=\"string\" length=\"200\" required=\"1\" multi=\"1\"/></in></tib>";
						if (xmlStr != "") {
							var doc = TIB_SysUtil.createXmlObj(xmlStr);
							var inObjs = $(doc).find("tib in");
							loopNode(d, $(inObjs), 1);
						}
						document.write(d);
					</script>
				</div>
				<div id="emample3">
			        <div class="clr"></div>
			        <div id="blk3" class="blk" style="display:none;">
			            <div class="head"><div class="head-right"></div></div>
			            <div class="main">
			                <h2><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.nodeEdit"/></h2>
			                <!-- 保存、关闭 -->
							<a href="javascript:void(0)" id="saveId" class="saveBtn"><bean:message key="button.save"/></a>
			                <a href="javascript:void(0)" id="close3" class="closeBtn"><bean:message key="button.close"/></a>
			                <ul>
			                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.nodeName"/>
									<input type="text" id="nodeTagName" size="6" style="font-size: 12px;" value=""/>
								</li>
			                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.ctype"/>
									<select id="dataType" style="width: 65px;" onchange="dataTypeChange(this.value);">
										<option value="string">string</option>
										<option value="int">int</option>
										<option value="boolean">boolean</option>
										<option value="double">double</option>
										<option value="date">date</option>
										<option value="object">object</option>
									</select>
								</li>
			                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.length"/><br/>
									<input style="text-align:center; font-size: 12px;" type="text" id="length" size="4" value=""/>
								</li>
			                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.required"/><br/>
									<input type="checkbox" name="required" id="required" />
								</li>
			                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.multi"/><br/>
									<input type="checkbox" name="multi" id="multi"/>
								</li>
			                </ul>
			            </div>
			            <div class="foot"><div class="foot-right"></div></div>
			        </div>
			    </div>
			</td>
			<td width="50%" colspan="2" valign="top">
				<textarea style="display: none;" name="fdIfaceXml" id="fdIfaceXml"></textarea>
				<!-- 通过数据初始化过来的数据限制编辑  --> 
				<textarea name="tibXml" id="tibXml" 
						<c:if test="${tibSysCoreIfaceForm.fdIfaceType == 1}">readonly="readonly"</c:if>
						style='overflow:scroll;overflow-y:hidden;;overflow-x:hidden;width:100%;'
						onfocus="window.activeobj=this;this.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},200);" 
						onblur="clearInterval(this.clock);"></textarea>
			</td>
		</tr>
	</table>
	</center>
	<html:hidden property="fdId" />
	<html:hidden property="fdIfaceType" />
	<html:hidden property="method_GET" />

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>