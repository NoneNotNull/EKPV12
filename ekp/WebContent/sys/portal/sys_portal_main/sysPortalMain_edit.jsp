<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalFooter"%>
<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalHeader"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.edit" width="95%" sidebar="no">
	<template:replace name="title">
	${ lfn:message("sys-portal:table.sysPortalMain") }
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<c:choose>
					<c:when test="${ sysPortalMainForm.method_GET == 'add' }">
						<ui:button text="${lfn:message('button.save') }" order="2" onclick=" Com_Submit(document.sysPortalMainForm, 'save');">
						</ui:button>
					</c:when>
					<c:when test="${ sysPortalMainForm.method_GET == 'edit' }">					
						<ui:button text="${lfn:message('button.update') }" order="2" onclick=" Com_Submit(document.sysPortalMainForm, 'update');">
						</ui:button>							
					</c:when>
				</c:choose> 
				<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
				</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="#" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:module.sys.portal') }" href="#" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-portal:table.sysPortalMain') }" href="#" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	<template:replace name="content"> 
		<html:form action="/sys/portal/sys_portal_main/sysPortalMain.do">
		<p class="txttitle">${ lfn:message('sys-portal:table.sysPortalMain') }</p>
		
		<script src="${LUI_ContextPath}/sys/ui/js/var.js"></script>
		<script>
		Com_IncludeFile("doclist.js");
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
		</script>
		<script>
			String.prototype.startWith=function(str){     
				  var reg=new RegExp("^"+str);     
				  return reg.test(this);        
			}  
	
			String.prototype.endWith=function(str){     
			  var reg=new RegExp(str+"$");     
			  return reg.test(this);        
			}

			LUI.ready(function(){
				seajs.use(['lui/jquery'],function($){
					window.$ = $;
				});
			});
			var portalType = {};			
			portalType.page = "${lfn:message('sys-portal:sys_portal_page_type_page')}";
			portalType.portal = "${lfn:message('sys-portal:sys_portal_page_type_portal')}";
			portalType.url = "${lfn:message('sys-portal:sys_portal_page_type_url')}";
			var targetType = {};
			targetType.blank = "${ lfn:message('sys-portal:sysPortalLinkDetail.target.type1') }";
			targetType.top = "${ lfn:message('sys-portal:sysPortalLinkDetail.target.type2') }";
			function selectPage(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.iframe('/sys/portal/sys_portal_page/sysPortalPage_select.jsp',"${lfn:message('sys-portal:sysPortalPage.msg.selectpage')}",function(val){
						//debugger;
						if(val != null && val != false && val.length && val.length > 0){
							for(var i=0;i<val.length;i++){
								pages_addRow(val[i]);
							}
						}
					},{"width":650,"height":550}); 
				});
			}
			function modifyPage(obj){
				var xtr = $(obj).closest("tr");
				seajs.use(['lui/dialog'],function(dialog){
					dialog.iframe('/sys/portal/sys_portal_page/sysPortalPage_select.jsp',"${lfn:message('sys-portal:sysPortalPage.msg.selectpage')}",function(val){
						//debugger;
						if(val != null && val != false){
							xtr.find(".pageId").val(val.fdId);
							xtr.find(".pageName").val(val.fdName);
							if(val.fdType == "1"){
								xtr.find(".pageTypeName").text(portalType.page);
								xtr.find(".pageType").val('page');
							}
							if(val.fdType == "2"){
								xtr.find(".pageTypeName").text(portalType.url);
								xtr.find(".pageType").val('url');
							}
							xtr.find(".pageIconDiv").attr("class","pageIconDiv lui_icon_l "+val.fdIcon);
							xtr.find(".pageIcon").val(val.fdIcon);
						}
					},{"width":650,"height":550}); 
				});
			}
			function pages_addRow(data){
				var portalId = "${ sysPortalMainForm.fdId }";
				var tab = $("#pagesContent");
				var index = tab.find("tr").length;
				var row = $("<tr></tr>");
				
				var xtd1 = $("<td></td>");
				if(data.fdType == "1"){
					xtd1.append("<div class=\"pageTypeName\">"+portalType.page+"</div>");
					xtd1.append('<input class="pageType" type="hidden" name="pages['+index+'].fdType" value="page">');
				}
				if(data.fdType == "2"){
					xtd1.append("<div class=\"pageTypeName\">"+portalType.url+"</div>");
					xtd1.append('<input class="pageType" type="hidden" name="pages['+index+'].fdType" value="url">');
				}
				xtd1.append('<input class="pageOrder" type="hidden" name="pages['+index+'].fdOrder" value="'+index+'">');
				xtd1.append('<input class="pagePortal" type="hidden" name="pages['+index+'].sysPortalMainId" value="'+portalId+'" />');
				row.append(xtd1);				
				
				var xtd2 = $("<td></td>");				
				xtd2.append('<input class="pageId" type="hidden" name="pages['+index+'].sysPortalPageId" value="'+data.id+'" />');
				xtd2.append('<input class="pageName inputsgl" style="width: 65%;" validate="required"  name="pages['+index+'].fdName" value="'+data.name+'"><span class="txtstrong">*</span>');
				//xtd2.append('<a href="javascript:void(0)" onclick="modifyPage(this)">选择</a>');
				xtd2.append('['+data.name+']');
				row.append(xtd2);
				
				var xtdT = $("<td></td>");				 
				xtdT.append('<select style="width:90%" name="pages['+index+'].fdTarget" class="pageTarget"><option value="_blank">'+targetType.blank+'</option><option value="_top" selected="selected">'+targetType.top+'</option></select>');
				row.append(xtdT);
			 
				
				var xtd3 = $("<td align='center' style='display:none'></td>");
				xtd3.append('<input class="pageEnabled" name="pages['+index+'].fdEnabled" value="true" type="checkbox" checked="true">');
				row.append(xtd3);
				
				var xtd4 = $("<td style='display:none'></td>");
				xtd4.append('<div class="lui_icon_l lui_icon_on"><div class="pageIconDiv lui_icon_l '+data.fdIcon+'"></div></div>');
				xtd4.append('<a href="javascript:void(0)" onclick="selectIcon(this)">'+"${ lfn:message('sys-portal:sysPortalLinkDetail.msg.select') }"+"</a>");
				xtd4.append('<input class="pageIcon" type="hidden" style="width:90%" class="inputsgl" name="pages['+index+'].fdIcon" value="'+data.fdIcon+'">');
				row.append(xtd4);
				
				var xtd5 = $("<td width='20%' align='center'></td>");
				xtd5.append('<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="pages_delRow(this);" style="cursor:pointer">&nbsp;&nbsp;');
				xtd5.append('<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="pages_moveUp(this);" style="cursor:pointer">&nbsp;&nbsp;');
				xtd5.append('<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="pages_moveDown(this);" style="cursor:pointer">');
				row.append(xtd5);
			
				tab.append(row);
			}
			function pages_moveUp(obj){
				var xtr = $(obj).closest("tr").get(0);
				var tab = $("#pagesContent");
				var index = 0;
				tab.find("tr").each(function(i,tr){
					if(tr == xtr){
						index = i;
					}
				});
				if(index > 0){
					index--;
					$(xtr).insertBefore($(tab.find("tr").get(index)));
					resetOrder();
				}
			}
			function pages_moveDown(obj){
				var xtr = $(obj).closest("tr").get(0);
				var tab = $("#pagesContent");
				var index = 0;
				tab.find("tr").each(function(i,tr){
					if(tr == xtr){
						index = i;
					}
				});
				if(index < tab.find("tr").length-1){
					index++;
					$(xtr).insertAfter($(tab.find("tr").get(index)));
					resetOrder();
				}
			}
			function pages_delRow(obj){
				var xtr = $(obj).closest("tr");
				xtr.remove();
				resetOrder();
			}
			function resetOrder(){
				var tab = $("#pagesContent");
				tab.find("tr").each(function(i,tr){
					var index  = i;
					$(tr).find(".pageOrder").val(index);					
					var trHtml = $(tr).html(); 
					var pageName = ($(tr).find(".pageName").val());
					var pageTarget = ($(tr).find(".pageTarget").val());
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdId/g,"pages["+index+"].fdId");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdTarget/g,"pages["+index+"].fdTarget");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdType/g,"pages["+index+"].fdType");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdOrder/g,"pages["+index+"].fdOrder");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.sysPortalMainId/g,"pages["+index+"].sysPortalMainId");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.sysPortalPageId/g,"pages["+index+"].sysPortalPageId");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdName/g,"pages["+index+"].fdName");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdEnabled/g,"pages["+index+"].fdEnabled");
					trHtml = trHtml.replace(/pages\[([\d]*)\]\.fdIcon/g,"pages["+index+"].fdIcon"); 
					$(tr).html(trHtml);
					$(tr).find(".pageName").val(pageName);
					$(tr).find(".pageTarget").val(pageTarget); 
				});
			}
			function selectIcon(obj){
				var xtr = $(obj).closest("tr");
				seajs.use(['lui/dialog'],function(dialog){
					dialog.build({
						config : {
								width : 500,
								height : 400,  
								title : "${ lfn:message('sys-portal:sysPortalLinkDetail.msg.select') }",
								content : {  
									type : "iframe",
									url : "/sys/ui/jsp/icon.jsp?type=l&status=true"
								}
						},
						callback : function(value, dia) {
							if(value==null){
								return ;
							}
							xtr.find(".pageIconDiv").attr("class","pageIconDiv lui_icon_l "+value);
							xtr.find(".pageIcon").val(value);
						}
					}).show(); 
				});
			}
			function modifyIcon(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.iframe('/sys/ui/jsp/icon.jsp?type=l&status=false',"${ lfn:message('sys-portal:sysPortalLinkDetail.msg.select') }",function(value){
						if(value != null && value != false){
							$("#iconPreview").attr("class","lui_icon_l "+value);
							$("input[name='fdIcon']").val(value);
						}
					},{"width":500,"height":400}); 
				});
			}
		</script>
		<center>
		<table class="tb_normal" width=95%>
			<tr>
				<td class="td_normal_title" width=15%>
					${ lfn:message("sys-portal:sysPortalMain.fdName") }
				</td>
				<td width="35%">
					<xform:text required="true" subject="${ lfn:message('sys-portal:sysPortalMain.fdName') }" property="fdName" style="width:85%" />
				</td>
				<td class="td_normal_title" width=15% rowspan="2">							
					<bean:message bundle="sys-portal" key="sysPortalMain.fdIcon"/>
				</td>
				<td width="35%" rowspan="2">
					<div class="lui_icon_l lui_icon_on ">
						<div id='iconPreview' class="lui_icon_l ${ sysPortalMainForm.fdIcon }">
						</div>
					</div>
					<a href="javascript:void(0)" onclick="modifyIcon()">${ lfn:message('sys-portal:sysPortalPage.msg.select') }</a>
					<html:hidden property="fdIcon" style="width:90%" />
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalMain.fdParent"/>
				</td>
				<td width="35%">
					<xform:dialog propertyId="fdParentId" propertyName="fdParentName" style="width:90%">
					Dialog_Tree(false,'fdParentId','fdParentName',';','sysPortalMainTreeService','${ lfn:message('sys-portal:sysPortalPage.msg.selectParent') }',null,null,'${ sysPortalMainForm.fdId }');
					</xform:dialog>
				</td>
			</tr>
			<tr>				
				<td class="td_normal_title" width=15%>							
					<bean:message bundle="sys-portal" key="sysPortalMain.fdEnabled"/>
				</td>
				<td width="35%">
					<xform:radio property="fdEnabled">
						<xform:enumsDataSource enumsType="common_yesno"></xform:enumsDataSource>		
					</xform:radio>
				</td>
				<td class="td_normal_title" width=15%>							
					${ lfn:message('sys-portal:sysPortalLinkDetail.fdTarget') }
				</td>
				<td width="35%">
					<xform:radio property="fdTarget" className="pageTarget">
						<xform:simpleDataSource value="_blank">${ lfn:message('sys-portal:sysPortalLinkDetail.target.type1') }</xform:simpleDataSource>
						<xform:simpleDataSource value="_top">${ lfn:message('sys-portal:sysPortalLinkDetail.target.type2') }</xform:simpleDataSource>  
					</xform:radio>
				</td>
			</tr>
			<c:if test="${ empty sysPortalMainForm.fdParentId }">
			<tr>
				<td class="td_normal_title" width=15%>${ lfn:message('sys-portal:sysPortalLinkDetail.fdOrder') }</td>
				<td width="35%">
					<xform:text property="fdOrder" style="width:85%" />
				</td>
				<td class="td_normal_title" width=15%>		</td>
				<td width="35%"></td>
			</tr>
			</c:if>
			<tr>
				<td class="td_normal_title" width=15%>${ lfn:message('sys-portal:sysPortalMain.msg.page') }</td>
				<td width="85%" colspan="3">			
					<table id="TABLE_DocList" class="tb_normal" width=100%>
						<tr> 
							<td align="center" class="td_normal_title">${ lfn:message('sys-portal:sysPortalPage.fdType') }</td> 
							<td align="center" class="td_normal_title">${ lfn:message('sys-portal:sysPortalPage.fdName') }</td> 
							<td align="center" class="td_normal_title">${ lfn:message('sys-portal:sysPortalLinkDetail.fdTarget') }</td> 
							<td align="center" class="td_normal_title" style='display:none'>${ lfn:message('sys-portal:sysPortalLinkDetail.msg.enabled') }</td> 
							<td align="center" class="td_normal_title" style='display:none'>${ lfn:message('sys-portal:sysPortalLinkDetail.fdIcon') }</td> 
							<td width="15%" align="center" class="td_normal_title">
								<img src="../../../resource/style/default/icons/add.gif" alt="add" onclick="selectPage();" style="cursor:pointer">
							</td>
						</tr>
						<tbody id="pagesContent">
							<!--内容行-->
							<c:forEach items="${sysPortalMainForm.pages}" var="page" varStatus="vstatus">
								<tr>
									<td width="10%">
										<div class="pageTypeName">${lfn:message(lfn:concat('sys-portal:sys_portal_page_type_',page.fdType))}</div>
										<input class="pageId" type="hidden" name="pages[${vstatus.index}].fdId" value="${page.fdId}">
										<input class="pageType" type="hidden" name="pages[${vstatus.index}].fdType" value="${page.fdType}">
										<input class="pageOrder" type="hidden" name="pages[${vstatus.index}].fdOrder" value="${vstatus.index}">
										<input class="pagePortal" type="hidden" name="pages[${vstatus.index}].sysPortalMainId" value="${ page.sysPortalMainId }" />
									</td>
									<td width="45%">
										<c:choose>
											<c:when test="${ page.fdType == 'page' || page.fdType == 'url' }">
												<input class="pageId" type="hidden" name="pages[${vstatus.index}].sysPortalPageId" value="${ page.sysPortalPageId }" />
												<input style="width: 65%;" class="pageName inputsgl" validate="required"  name="pages[${vstatus.index}].fdName" value="${ page.fdName }"><span class="txtstrong">*</span>
												[${page.sysPortalPageName}]
											</c:when>
											<c:when test="${ page.fdType == 'portal' }">	
												<input style="width: 65%;" class="pageName inputsgl" readonly="readonly" name="pages[${vstatus.index}].fdName" value="${ page.fdName }">					
											</c:when>
										</c:choose>										
									</td>
									<td width="10%">
										<select style="width:90%" name="pages[${vstatus.index}].fdTarget" class="pageTarget">
											<option value="_blank" ${ page.fdTarget == "_blank" ? "selected" : ""}>${ lfn:message('sys-portal:sysPortalLinkDetail.target.type1') }</option>
											<option value="_top" ${ page.fdTarget == "_top" ? "selected" : ""}>${ lfn:message('sys-portal:sysPortalLinkDetail.target.type2') }</option>
										</select>
									</td>
									<td width="10%" align="center" style='display:none'> 
										<input name="pages[${vstatus.index}].fdEnabled" value="true" class='pageEnabled' type="checkbox" ${not empty page.fdEnabled && page.fdEnabled == 'true' ? "checked='checked'" : ""}>
									</td>
									<td width="15%" style='display:none'> 
										<div class="lui_icon_l lui_icon_on">
											<div class="pageIconDiv lui_icon_l ${ page.fdIcon }">
											</div>
										</div>
										<a href="javascript:void(0)" onclick="selectIcon(this)">${ lfn:message('sys-portal:sysPortalLinkDetail.msg.select') }</a>
										<input class='pageIcon' type="hidden" style="width:90%" class="inputsgl" name="pages[${vstatus.index}].fdIcon" value="${ page.fdIcon }">
									</td>
									<td width="10%" align="center">
										<c:choose>
											<c:when test="${ page.fdType == 'page' || page.fdType == 'url'}">
												<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="pages_delRow(this);" style="cursor:pointer">&nbsp;&nbsp;
											</c:when>
											<c:when test="${ page.fdType == 'portal' }">
												<span>&nbsp;&nbsp;&nbsp;&nbsp;</span>
											</c:when>
										</c:choose>
										<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="pages_moveUp(this);" style="cursor:pointer">&nbsp;&nbsp;
										<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="pages_moveDown(this);" style="cursor:pointer">
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="sys-portal" key="sysPortalMain.fdTheme"/>
				</td>
				<td width="35%" colspan="3">
					<script type="text/javascript">
					function selectTheme(){
						seajs.use(['lui/dialog'],function(dialog){
							dialog.iframe("/sys/portal/designer/jsp/selecttheme.jsp","${ lfn:message('sys-portal:sysPortalPage.msg.selectTheme') }",function(value, dia){
								if(value==null){
									return ;
								}
								$("[name='fdTheme']").val(value.ref);
								$("[name='fdThemeName']").val(value.name);
							},{"width":700,"height":500});
						});
					}
					</script>						 
				 	<xform:dialog subject="${ lfn:message('sys-portal:sysPortalPage.fdTheme') }"  style="width:90%" propertyId="fdTheme" propertyName="fdThemeName">
					selectTheme()
					</xform:dialog>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					LOGO
				</td>
				<td width="35%" colspan="3">
					<script> 
					function selectLogo(){
						seajs.use(['lui/dialog'],function(dialog){
							dialog.iframe("/sys/ui/jsp/logo.jsp","${ lfn:message('sys-portal:sysPortalPage.msg.select') }Logo",function(value, dia){
								if(value==null){
									return ;
								}
								$("[name='fdLogo']").val(value);
								$("#fdLogoImg").attr("src","${LUI_ContextPath}"+value); 
							},{"width":500,"height":400});
						});
					}
					</script>
					<html:hidden property="fdLogo" />
					<div style="background: rosybrown;display: inline-block;">
						<img id="fdLogoImg" src="${LUI_ContextPath}${sysPortalMainForm.fdLogo}" />
					</div>
					<a href="javascript:void(0)" onclick="selectLogo()">${ lfn:message('sys-portal:sysPortalPage.msg.select') }</a>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title"  width="15%">${ lfn:message('sys-portal:sysPortalMain.msg.header') }</td>
				<td colspan="3">
				<script type="text/javascript">
				lodingImg = "<img src='${LUI_ContextPath}/sys/ui/js/ajax.gif'/>";
				function fdHeaderSelectChange(val){
					var sindex = document.getElementById("portal_page_header_select").selectedIndex;
					if( sindex > 0){
						var opt = document.getElementById("portal_page_header_select").options[sindex];
						var headerId = opt.value;
						LUI.$("#fdHeaderId").val(headerId);
						LUI.$("#portal_page_header_img").attr("src","${LUI_ContextPath}"+opt.getAttribute("img")).show();
						LUI.$("#portal_page_header_opts").html(lodingImg).show().attr("jsname","portal_page_header_opts_var").load("${LUI_ContextPath}/sys/portal/designer/jsp/vars/header.jsp?x="+(new Date().getTime()),{"fdId":headerId,"jsname":"portal_page_header_opts_var"},function(){
							 if(val != null){
								 window['portal_page_header_opts_var'].setValue(val);
							 }
						});
					}else{
						LUI.$("#fdHeaderId").val("");
						LUI.$("#portal_page_header_opts").empty().hide();
						window['portal_page_header_opts_var']=null;
						LUI.$("#portal_page_header_img").hide();
					}
				}
				Com_Parameter.event["confirm"].unshift(function() {
					if(window['portal_page_header_opts_var']!=null){
						LUI.$("#fdHeaderVars").val(LUI.stringify(window['portal_page_header_opts_var'].getValue()));
					}else{
						LUI.$("#fdHeaderVars").val("");
					}
					return true;
				});
				</script>
				<html:hidden property="fdHeaderId" styleId="fdHeaderId" />
				<html:hidden property="fdHeaderVars" styleId="fdHeaderVars" />
				<select id="portal_page_header_select" onchange="fdHeaderSelectChange()">
				<option value="">${ lfn:message("sys-portal:portlet.header.noheader") }</option>
				<% 
				List hs = PortalUtil.getPortalHeaders(request);
				for(int i=0;i < hs.size(); i++){
					SysPortalHeader h = (SysPortalHeader)hs.get(i);
					out.println("<option value='"+h.getFdId()+"' img='"+h.getFdThumb()+"'>" +h.getFdName()+"</option>");
				}
				%>								
				</select>
				<div style="height: 5px;"></div>
				<table style="width: 100%;padding: 0px;border: 0px;margin: 0 auto;">
					<tr>
						<td>
							<img style="max-width:750px;" id="portal_page_header_img" src="">
						</td>
					</tr>
					<tr>
						<td><div id="portal_page_header_opts"></div></td>
					</tr>
				</table> 
				</td>
			</tr>
			<tr>
				<td class="td_normal_title"  width="15%">${ lfn:message('sys-portal:sysPortalMain.msg.footer') }</td>
				<td colspan="3">
					<script type="text/javascript">
					function fdFooterSelectChange(val){
						var sindex = document.getElementById("portal_page_footer_select").selectedIndex;
						if( sindex > 0){
							var opt = document.getElementById("portal_page_footer_select").options[sindex];
							var footerId = opt.value;
							LUI.$("#fdFooterId").val(footerId);
							LUI.$("#portal_page_footer_img").attr("src","${LUI_ContextPath}"+opt.getAttribute("img")).show();
							LUI.$("#portal_page_footer_opts").html(lodingImg).show().attr("jsname","portal_page_footer_opts_var").load("${LUI_ContextPath}/sys/portal/designer/jsp/vars/footer.jsp?x="+(new Date().getTime()),{"fdId":footerId,"jsname":"portal_page_footer_opts_var"},function(){
								 if(val != null){
									 window['portal_page_footer_opts_var'].setValue(val);
								 }
							});
						}else{
							LUI.$("#fdFooterId").val("");
							LUI.$("#portal_page_footer_opts").empty().hide();
							window['portal_page_header_opts_var']=null;
							LUI.$("#portal_page_footer_img").hide();
						}
					}
					Com_Parameter.event["confirm"].unshift(function() {
						if(window['portal_page_footer_opts_var']!=null){
							LUI.$("#fdFooterVars").val(LUI.stringify(window['portal_page_footer_opts_var'].getValue()));
						}else{
							LUI.$("#fdFooterVars").val("");
						}
						return true;
					});
					function getPageReader(){
						seajs.use(['lui/dialog'],function(dialog){
							var dd = dialog.loading("正在获取");
							var portalId = "${ sysPortalMainForm.fdId }";
							LUI.$.get("${LUI_ContextPath}/sys/portal/sys_portal_main/sysPortalMain.do?method=getPageDefReader",{"portalId":portalId},function(json){
								var ids = LUI.$("[name='defReaderIds']").val();
								var names = LUI.$("[name='defReaderNames']").val();
								//debugger;
								for(var i=0;i<json.length;i++){
									if(ids.indexOf(json[i].fdId)>=0){
										
									}else{
										ids = ids + (ids.length>0?";":"") + json[i].fdId;
										names = names + (names.length>0?";":"") + json[i].fdName;
									}
								}
								LUI.$("[name='defReaderIds']").val(ids);
								LUI.$("[name='defReaderNames']").val(names);
								dialog.success("获取成功");
								dd.hide();
							});							
						});
					}
					</script>
					<html:hidden property="fdFooterId" styleId="fdFooterId" />
					<html:hidden property="fdFooterVars" styleId="fdFooterVars" />
					<select id="portal_page_footer_select" onchange="fdFooterSelectChange()">
					<option value="">${ lfn:message("sys-portal:portlet.header.nofooter") }</option>							
					<% 
					List fs = PortalUtil.getPortalFooters(request);
					for(int i=0;i<fs.size();i++){
						SysPortalFooter f = (SysPortalFooter)fs.get(i);
						out.println("<option value='"+f.getFdId()+"' img='"+f.getFdThumb()+"'>" +f.getFdName()+"</option>");
					}
					%>	
					</select>		
					<div style="height: 5px;"></div>
					<table style="width:100%;padding: 0px;border: 0px;margin: 0 auto;">
						<tr>
							<td><img style="max-width:750px;" id="portal_page_footer_img" src="" ></td>
						</tr>
						<tr>
							<td><div id="portal_page_footer_opts"></div></td>
						</tr>
					</table>
				</td>
			</tr>
		  	<tr>
				<td class="td_normal_title"  width="15%">${ lfn:message('sys-portal:sysPortalMain.defReader')}</td>
				<td colspan="3">
					<xform:address textarea="true" mulSelect="true" propertyId="defReaderIds" propertyName="defReaderNames" style="width:96%;height:90px;" ></xform:address>
					<br>
					<a href="javascript:getPageReader();" class="com_btn_link">${ lfn:message('sys-portal:sysPortalMain.msg.getdreader') }</a>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width="15%">${ lfn:message('sys-portal:sysPortalPage.fdEditor')}</td>
				<td colspan="3">
					<xform:address textarea="true" mulSelect="true" propertyId="authEditorIds" propertyName="authEditorNames" style="width:96%;height:90px;" ></xform:address>
					<br><span class="com_help">${ lfn:message('sys-portal:sysPortalMain.msg.nadmin') }</span>
				</td>
			</tr> 
		</table>
		</center>
		<html:hidden property="fdId" />
		<html:hidden property="method_GET" />		
		<script type="text/javascript">	
		Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js", null, "js");
		</script>		
		<script>
			$KMSSValidation();
		</script>
		<script>
		LUI.ready(function(){
			var headerId = LUI.$("#fdHeaderId").val();
			if($.trim(headerId) != ""){
				LUI.$("#portal_page_header_select").val(headerId);
			}else{
				$("#portal_page_header_select option").each(function(){
					if($(this).val().endWith(".default")){
						$(this).attr("selected","true");
					}
				});
			}
			var headerVars = LUI.$("#fdHeaderVars").val();
			if($.trim(headerVars) != ""){
				var val = LUI.toJSON(headerVars);
				fdHeaderSelectChange(val);
			}else{
				fdHeaderSelectChange();
			}
			
			var footerId = LUI.$("#fdFooterId").val();
			if($.trim(footerId) != ""){
				LUI.$("#portal_page_footer_select").val(footerId);
			}else{
				$("#portal_page_footer_select option").each(function(){
					if($(this).val().endWith(".default")){
						$(this).attr("selected","true");
					}
				});
			}
			var footerVars = LUI.$("#fdFooterVars").val();
			if($.trim(footerVars) != ""){
				var val = LUI.toJSON(footerVars);
				fdFooterSelectChange(val);
			}else{
				fdFooterSelectChange();
			}
			
		});
		</script>
		</html:form>
		<br><br>
	</template:replace>
</template:include>