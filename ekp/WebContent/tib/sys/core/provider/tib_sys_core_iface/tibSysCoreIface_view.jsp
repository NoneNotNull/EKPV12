<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<%@page import="com.landray.kmss.tib.sys.core.util.TibSysCoreUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<script>
	function confirmDelete(msg){
		var del = confirm("<bean:message key="page.comfirmDelete"/>");
		return del;
	}
</script>
<link href="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/css/dtree.css" rel="StyleSheet" type="text/css" />
<link href="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/css/core.css" type="text/css" rel="stylesheet"/>
<script src="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/dtree.js" type="text/javascript"></script>
<script src="${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/tree/popup_layer.js" type="text/javascript" language="javascript"></script>

<script type="text/javascript">
	Com_IncludeFile("dialog.js|jquery.js");
	Com_IncludeFile("tib_sys_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
	Com_IncludeFile("tib_sys_core_tree.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
</script>
<script type="text/javascript">
	//节点点击事件
	function click(id, locaId, parID,nodeName) {
		// View页面放空
	}

	$(function(){
		//dTree2Xml();
		var fdIfaceXml = "${tibSysCoreIfaceForm.fdIfaceXml}";
		var tibXmlObj = document.getElementById("tibXml");
		$("#tibXml").text(TIB_SysUtil.formatXml(fdIfaceXml, "   "));
		window.activeobj = tibXmlObj;
		tibXmlObj.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},0);
	});

</script>

<div id="optBarDiv">
<input type="button" value="<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.dataSimulation" />"
		onclick="Com_OpenWindow('tibSysCoreIface.do?method=dataExecute&fdId=${param.fdId}');">
<kmss:auth
	requestURL="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('tibSysCoreIface.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> <kmss:auth
	requestURL="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysCoreIface.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>

<p class="txttitle"><bean:message bundle="tib-sys-core-provider"
	key="table.tibSysCoreIface" /></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceName" /></td>
		<td width="85%" colspan="3"><xform:text property="fdIfaceName"
			style="width:85%" /></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-core-provider" key="tibSysCoreIface.fdNote" /></td>
		<td width="85%" colspan="3">
			<xform:textarea  showStatus="view" property="fdNote" style="width:80%"></xform:textarea>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceKey" /></td>
		<td width="85%" colspan="3"><input type="hidden" name="fdIfaceKey" id="fdIfaceKey" value="${tibSysCoreIfaceForm.fdIfaceKey}"/>
			<c:out value="${tibSysCoreIfaceForm.fdIfaceKey}" />
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
			bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceTags" /></td>
		<td width="85%" colspan="3"><c:out
			value="${tibSysCoreIfaceForm.fdIfaceTagNames}" /></td>	
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.controlPattern" />
			</td>
			<td width="35%"><xform:select property="fdControlPattern" showStatus="view">
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
		<td class="td_normal_title" width="100%" colspan="4" align="center">
			<bean:message
				bundle="tib-sys-core-provider" key="tibSysCoreIface.fdIfaceXml" />
		</td>
	</tr>
	<tr>
		<td width="50%" colspan="2" valign="top">
			<div>
				<!-- 展开、收起  class="dtree" -->
				<div style="padding-left:11px;" class="dTreeNode">
					<a href="javascript: d.openAll();" class=node>
						<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.openAll"/>
					</a> 
					| <a href="javascript: d.closeAll();" class=node>
						<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.closeAll"/>
					</a> 
					<!-- | <a href="javascript: dTree2Xml();" class=node>树转xml</a> -->
				</div>
			</div>
			<div id="treeDiv">
				<script type="text/javascript">
					//实例名d不可以改变。
					d = new dTree("d");
					d.add(0,-1,'tib');
					d.add(1,0,'in','in', "", "", "", "", true);
					var xmlStr = "${tibSysCoreIfaceForm.fdIfaceXml}";
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
								<input type="text" id="nodeName" size="6" style="font-size: 12px;" value=""/>
							</li>
		                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.ctype"/>
								<select id="dataType" style="width: 65px;" onchange="dataTypeChange(this.value);">
									<option value="string">string</option>
									<option value="int">int</option>
									<option value="boolean">boolean</option>
									<option value="double">double</option>
									<option value="object">object</option>
								</select>
							</li>
		                    <li><bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.tree.length"/>
								<input align="center" style="text-align:center; font-size: 12px;" type="text" id="length" size="4" value=""/>
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
			<textarea name="tibXml" id="tibXml" readonly="readonly"
					style='border:0px;overflow:scroll;overflow-y:hidden;;overflow-x:hidden;width:100%;font-size:12px;color:black;'></textarea>
		</td>
	</tr>
</table>
</center>
<input type="hidden" id="method_GET" value="${param.method }"/>

<%@ include file="/resource/jsp/view_down.jsp"%>