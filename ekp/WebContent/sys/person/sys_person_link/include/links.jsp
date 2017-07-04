<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="com.landray.kmss.sys.person.forms.SysPersonCfgLinkForm"%>
<%@page import="com.landray.kmss.sys.person.interfaces.LinkInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="navForm" value="${requestScope[param.formName] }" scope="page" />
<c:set var="icon" value="${param.linkType eq 'shortcut' }" scope="page" />
<c:set var="readOnly" value="${param.readOnly eq 'true' }" scope="page" />
<c:set var="showMode" value="${readOnly ? 'view' : 'edit' }" scope="page" />
				<tr>
					<td colspan="4">
						<table id="linksTable" class="tb_normal" width="100%">
							<col width="10px" align="center">
							<col width="260px" align="center">
							<col width="" align="center">
							<c:if test="${icon }">
							<col width="60px" align="center">
							</c:if>
							<c:if test="${param.linkType eq 'home' or param.linkType eq 'zone' }">
							<col width="150px" align="center">
							</c:if>
							<c:if test="${!readOnly }">
							<col width="130px" align="center">
							</c:if>
							<tr class="tr_normal_title">
								<td>
									<span style="white-space:nowrap;"><bean:message key="page.serial"/></span>
								</td>
								<td><bean:message bundle="sys-person" key="sysPersonSysNavLink.fdName"/></td>
								<td><bean:message bundle="sys-person" key="sysPersonSysNavLink.fdUrl"/></td>
								<c:if test="${icon }">
								<td><bean:message bundle="sys-person" key="sysPersonSysNavLink.fdIcon"/></td>
								</c:if>
								<c:if test="${param.linkType eq 'home' }">
								<td><bean:message bundle="sys-person" key="sysPersonSysNavLink.fdTarget"/></td>
								</c:if>
								<c:if test="${!readOnly }">
								<td>
									<a href="javascript:;" class="com_btn_link" onclick="SysLinksDialog();"><bean:message bundle="sys-person" key="sysPersonSysNavLink.fromSys"/></a>
									<a href="javascript:;" class="com_btn_link" onclick="DocList_AddRow('linksTable');"><bean:message bundle="sys-person" key="sysPersonSysNavLink.fromInput"/></a>
								</td>
								</c:if>
							</tr>
							<c:if test="${!readOnly }">
							<%-- 模版行 --%>
							<tr style="display:none;" KMSS_IsReferRow="1">
								<td KMSS_IsRowIndex="1">
									!{index}
								</td>
								<td>
									<input type="hidden" name="fdLinks[!{index}].fdId" value=""> 
									<input type="hidden" name="fdLinks[!{index}].fdSysLink" value="" > 
									<xform:text property="fdLinks[!{index}].fdName" style="width:95%" subject="${lfn:message('sys-person:sysPersonSysNavLink.fdName') }" required="true" />
								</td>
								<td>
									<xform:text htmlElementProperties="flag='fdUrl'" property="fdLinks[!{index}].fdUrl" style="width:95%" subject="${lfn:message('sys-person:sysPersonSysNavLink.fdUrl') }" required="true" />
								</td>
								<c:if test="${icon }">
								<td>
									<div class="lui_icon_l" style="cursor: pointer;" title="${lfn:message('sys-person:sysPersonSysNavLink.selectIconTitle') }">
									<div class="lui_icon_l lui_icon_l_icon_1" style="background-color: #C78700;" onclick="SysIconDialog(this);"></div>
									</div>
									<input type="hidden" name="fdLinks[!{index}].fdIcon" value="lui_icon_l_icon_1">
								</td>
								</c:if>
								<c:if test="${param.linkType eq 'home' }">
								<td align="center">
									<xform:select showPleaseSelect="false" property="fdLinks[!{index}].fdTarget" required="true">
										<xform:enumsDataSource enumsType="sysPerson_urlTarget" />
									</xform:select>
								</td>
								</c:if>
								<td>
									<div style="text-align:center">
									<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow(this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
									<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
									<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">
									</div>
								</td>
							</tr>
							</c:if>
							<%-- 内容行 --%>
							<c:forEach items="${navForm.fdLinks}" var="link" varStatus="vstatus">
							<tr KMSS_IsContentRow="1">
								<td>
									${vstatus.index + 1}
								</td>
								<td>
									<input type="hidden" name="fdLinks[${vstatus.index}].fdId" value="${link.fdId }" > 
									<input type="hidden" name="fdLinks[${vstatus.index}].fdSysLink" value="${link.fdSysLink }" > 
									<xform:text property="fdLinks[${vstatus.index}].fdName" required="true" style="width:95%" value="${link.fdName }" showStatus="${readOnly ? 'view' : 'edit' }"  subject="${lfn:message('sys-person:sysPersonSysNavLink.fdName') }"/>
								</td>
								<td>
									<c:if test="${empty link.fdSysLink }">
										<xform:text htmlElementProperties="flag='fdUrl'"  property="fdLinks[${vstatus.index}].fdUrl" required="true" style="width:95%" value="${link.fdUrl }" showStatus="${readOnly ? 'view' : 'edit' }"  subject="${lfn:message('sys-person:sysPersonSysNavLink.fdUrl') }"/>
									</c:if>
									<c:if test="${not empty link.fdSysLink }">
										<% 
										pageContext.setAttribute("fdUrlWidth","width:95%");
										if(LinkInfo.isMultiServer()){
											Object xinfo = pageContext.getAttribute("link");
											String xid =  (String)PropertyUtils.getProperty(xinfo, "fdSysLink");
											if(xid.indexOf(SysUiConstant.SEPARATOR)>0){
						
												String server = xid.substring(0,xid.indexOf(SysUiConstant.SEPARATOR));
												out.print("(");
												out.print(LinkInfo.getServerNameByKey(server));
												out.print(")");

												pageContext.setAttribute("fdUrlWidth","width:50%");
											}
										}
										%>
										<xform:text htmlElementProperties="flag='fdUrl'"  property="fdLinks[${vstatus.index}].fdUrl" required="true" style="${ fdUrlWidth }" value="${link.fdUrl }" showStatus="readOnly"  subject="${lfn:message('sys-person:sysPersonSysNavLink.fdUrl') }"/>
									</c:if>
								</td>
								<c:if test="${icon }">
								<td>
									<div class="lui_icon_l" style="cursor: pointer;" title="${lfn:message('sys-person:sysPersonSysNavLink.selectIconTitle') }">
										<div class="lui_icon_l ${link.fdIcon }" style="background-color: #C78700;" onclick="SysIconDialog(this);"></div>
										</div>
									</div>
									<c:if test="${!readOnly }">
									<input type="hidden" name="fdLinks[${vstatus.index}].fdIcon" value="${link.fdIcon }">
									</c:if>
								</td>
								</c:if>
								<c:if test="${param.linkType eq 'home' }">
								<td align="center">
									<xform:select showPleaseSelect="false" property="fdLinks[${vstatus.index}].fdTarget" value="${link.fdTarget }" required="true" showStatus="${readOnly ? 'view' : 'edit' }">
										<xform:enumsDataSource enumsType="sysPerson_urlTarget" />
									</xform:select>
								</td>
								</c:if>
								<c:if test="${param.isRedirect eq 'true' }">
								<td align="center">
									<input type="checkbox" name="fdLinks[${vstatus.index}].fdIsRedirect" value="true"
										<c:if test="${link.fdIsRedirect eq 'true' }">checked</c:if>
										<c:if test="${readOnly }">disabled</c:if> />
								</td>
								</c:if>
								<c:if test="${!readOnly }">
								<td>
									<div style="text-align:center">
									<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="DocList_DeleteRow(this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
									<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="DocList_MoveRow(-1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">&nbsp;&nbsp;
									<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="DocList_MoveRow(1, this.parentNode.parentNode.parentNode);" style="cursor:pointer">
									</div>
								</td>
								</c:if>
							</tr>
							</c:forEach>
						</table>
						<input type="hidden" name="sysLinkId">
						<input type="hidden" name="sysLinkName">
						<input type="hidden" name="sysLinkText">
						<script>Com_IncludeFile("doclist.js");</script>
						<script>DocList_Info.push('linksTable');</script>
						<script>
						function AddSelectedNavLink(data) {
							for (var i = 0; i < data.length; i ++) {
								var row = data[i];
								var rowData = {
										'fdLinks[!{index}].fdName': row.name,
										'fdLinks[!{index}].fdUrl': row.url,
										'fdLinks[!{index}].fdIcon': row.icon,
										'fdLinks[!{index}].fdSysLink': row.id
								};
								<%--/* if (row.issys == 'true') {
									rowData['fdLinks[!{index}].fdSysLink'] = row.id;
								} */--%>
								var isMultiServer = <%=LinkInfo.isMultiServer()%>;
								var xtr = DocList_AddRow('linksTable', null, rowData);
								var xinput = $(xtr).find("[flag='fdUrl']");
								if(isMultiServer && $.trim(row.server)!=""){
									xinput.css({"width":"50%"}).attr("readonly","true").parent().prepend("("+row.server+")");
								}else{
									xinput.attr("readonly","true");
								}
							}
							FixRowsIconSelectd();
							// SysRegisterLinkReadonly();
						}
						function FixRowsIconSelectd() {
							$("#linksTable [name$='fdIcon']").each(function() {
								this.value = this.value || "lui_icon_l_icon_1";
								$(this).closest("td").find('.lui_icon_l [onclick]').removeClass().addClass("lui_icon_l").addClass(this.value);
							});
						}
						<%--/* function SysRegisterLinkReadonly() {
							$('[name$="fdSysLink"]').each(function() {
								if (this.name.indexOf('!{index}') > -1 || this.value == '') {
									return;
								}
								$(this).closest("tr").find('[name$="fdName"], [name$="fdUrl"]').each(function() {
									$(this).attr('readonly', true).css('border', 'none');
								});
							});
							$('[name$="fdIcon"]').each(function() {
								if (this.name.indexOf('!{index}') > -1 || this.value == '') {
									return;
								}
								var icon = this.value;
								$(this).parent().children(".lui_icon_l").each(function() {
									var self = $(this);
									if (!self.hasClass(icon)) {
										self.removeClass().addClass("lui_icon_l").addClass(icon);
									}
								});
							});
						} */--%>
						function SysLinksDialog() {
							seajs.use(['lui/dialog','lui/jquery'], function(dialog, $){
								dialog.build({
									config : {
											width : 600,
											height : 600,  
											title : "${lfn:escapeJs(lfn:message('sys-person:sysPersonSysNavLink.selectSysLink'))}",
											content : {
												type : "iframe",
												<c:if test="${empty param.linkDialog}">
												url : "/sys/person/sys_person_link/sysPersonLink.do?method=dialog&type=${param.linkType}"
												</c:if>
												<c:if test="${not empty param.linkDialog}">
												url : "${param.linkDialog}"
												</c:if>
											}
									},
									callback : function(data) {
										if(data==null) {
											return;
										}
										AddSelectedNavLink(data);
									}
								}).show(); 
							});
						}
						seajs.use(['lui/jquery'], function($) {
							$('#linksTable').delegate('[name="List_Tongle"]', 'click', function(event) {
								var checked = this.checked;
								$(this).closest('table').find('[name="List_Selected"]').each(function() {
									this.checked = checked;
								});
							});
							// 单选
							$('#linksTable').delegate('[name="List_Selected"]', 'click', function(event) {
								var allSelected = true;
								var table = $(this).closest('table');
								table.find('[name="List_Selected"]').each(function() {
									if (!this.checked) {
										allSelected = false;
										return false;
									}
								});
								table.find('[name="List_Tongle"]').each(function() {
									this.checked = allSelected;
								});
							});
						});
						<%--/*seajs.use(['lui/jquery'], function($) {
							$(document).ready(function() {
								SysRegisterLinkReadonly();
							});
						});*/--%>
						</script>
						
						<c:if test="${icon }">
						<script>
						function SysIconDialog(dom) {
							seajs.use(['lui/dialog','lui/jquery'], function(dialog, $){
								dialog.build({
									config : {
											width : 500,
											height : 400,  
											title : "${lfn:escapeJs(lfn:message('sys-person:sysPersonSysNavLink.selectIconTitle')) }",
											content : {  
												type : "iframe",
												url : "/sys/ui/jsp/icon.jsp?type=l&status=false"
											}
									},
									callback : function(value, dia) {
										if(value==null){
											return ;
										}
										$(dom).removeClass().addClass("lui_icon_l").addClass(value).
														closest("td").find('[name$="fdIcon"]').val(value);
									}
								}).show(); 
							});
						}
						</script>
						</c:if>
					</td>
				</tr>
