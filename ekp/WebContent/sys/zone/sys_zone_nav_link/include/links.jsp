<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="navForm" value="${requestScope[param.formName] }" scope="page" />
<c:set var="readOnly" value="${param.readOnly eq 'true' }" scope="page" />
				<tr>
					<td colspan="4">
						<table id="linksTable" class="tb_normal" width="100%">
							<col width="10px" align="center">
							<col width="260px" align="center">
							<col width="" align="center">
							<col width="150px" align="center">
							<col width="160px" align="center">
							<c:if test="${!readOnly }">
							<col width="130px" align="center">
							</c:if>
							<tr class="tr_normal_title">
								<td>
									<span style="white-space:nowrap;"><bean:message key="page.serial"/></span>
								</td>
								<td><bean:message bundle="sys-zone" key="sysZoneNavLink.fdName"/></td>
								<td><bean:message bundle="sys-zone" key="sysZoneNavLink.fdUrl"/></td>
								<td><bean:message bundle="sys-zone" key="sysZoneNavLink.server"/></td>
								<td><bean:message bundle="sys-zone" key="sysZoneNavLink.target"/></td>
								<c:if test="${!readOnly }">
								<td>
									<a href="javascript:;" class="com_btn_link" onclick="SysLinksDialog();"><bean:message bundle="sys-zone" key="sysZoneNavigation.fromSys"/></a>
									<a href="javascript:;" class="com_btn_link" onclick="DocList_AddRow('linksTable');"><bean:message bundle="sys-zone" key="sysZoneNavigation.fromInput"/></a>
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
									
									<input type="hidden" name="fdLinks[!{index}].fdServerKey" value="">
									<xform:text property="fdLinks[!{index}].fdName" style="width:95%" subject="${lfn:message('sys-zone:sysZoneNavLink.fdName') }" required="true" />
								</td>
								<td>
									<xform:text property="fdLinks[!{index}].fdUrl" style="width:95%" subject="${lfn:message('sys-zone:sysZoneNavLink.fdUrl') }" required="true" />
								</td>
								<td>
									<input type="hidden" name="fdLinks[!{index}].fdServerName" value="">
									
								</td>
								<td>
									<xform:radio property="fdLinks[!{index}].fdTarget" value="">
										<xform:enumsDataSource enumsType="sysZone_fdTarget">
										</xform:enumsDataSource>
									</xform:radio>
								</td>
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
									
									<xform:text property="fdLinks[${vstatus.index}].fdName" required="true" style="width:95%" value="${link.fdName }" showStatus="${readOnly ? 'view' : 'edit' }"  subject="${lfn:message('sys-zone:sysZoneNavLink.fdName') }"/>
								</td>
								<td>
									<xform:text property="fdLinks[${vstatus.index}].fdUrl" required="true" style="width:95%" value="${link.fdUrl }" showStatus="${readOnly ? 'view' : 'edit' }"  subject="${lfn:message('sys-zone:sysZoneNavLink.fdUrl') }"/>
								</td>
								<td>
									${link.serverName}
									<input type="hidden" name="fdLinks[${vstatus.index}].fdServerKey" value="${link.fdServerKey }">
								</td>
								<td>
									<xform:radio property="fdLinks[${vstatus.index}].fdTarget" value="${link.fdTarget}">
										<xform:enumsDataSource enumsType="sysZone_fdTarget">
										</xform:enumsDataSource>
									</xform:radio>
								</td>
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
										
										'fdLinks[!{index}].fdServerKey' : row.server
								};
								var newRow = DocList_AddRow('linksTable', null, rowData);
								$(newRow).find('[name$=".fdServerName"]').closest('td').html(row.serverName);
							}
						}
						
						function showTypeChange(value, obj){
							seajs.use(['lui/dialog','lui/jquery'], function(dialog, $){
								var _$tr = $("#linksTable").find("tr");
								if(_$tr.length > 1){
									dialog.alert("${lfn:escapeJs(lfn:message('sys-zone:sysZoneNavigation.confirmShowType'))}", function(value){
										_$tr.each(function(index){
											if(index > 0){
												DocList_DeleteRow(this);
											}
										});
									});
								}
							});
						}
						function dd(obj){
							alert(obj.value);
						}
						
						function SysLinksDialog() {
							seajs.use(['lui/dialog','lui/jquery'], function(dialog, $){
								dialog.build({
									config : {
											width : 600,
											height : 600,  
											title : "${lfn:escapeJs(lfn:message('sys-zone:sysZoneNavLink.selectSysLink'))}",
											content : {
												type : "iframe",
												url : "/sys/zone/sys_zone_nav_link/sysZoneNavLink.do?method=dialog&showType=" + $("[name='fdShowType']").val()
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
						</script>
					</td>
				</tr>