<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@page import="com.landray.kmss.sys.attachment.util.AttImageUtils"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%
	String formBeanName = request.getParameter("formBeanName");
	String attKey = request.getParameter("fdKey");
	Object formBean = null;
	if(formBeanName != null && formBeanName.trim().length()!= 0){
		formBean = pageContext.getAttribute(formBeanName);
		if(formBean == null)
			formBean = request.getAttribute(formBeanName);
		if(formBean == null)
			formBean = session.getAttribute(formBeanName);
	}
	pageContext.setAttribute("_downLoadNoRight",new PdaRowsPerPageConfig().getFdAttDownload());
	pageContext.setAttribute("_formBean", formBean);
%>
<%
    String fdModelId = request.getParameter("fdModelId");
    boolean isExist = JgWebOffice.isExistFile(request);
    pageContext.setAttribute("isExist", isExist);
%>

<script type="text/javascript">
	function att_formatSize(filesize){
		var result = "";
		var index;
		if(filesize!=null && filesize!="") {
			if((index=filesize.indexOf("E"))>0) {			
				var size = parseFloat(filesize.substring(0,index))*Math.pow(10,parseInt(filesize.substring(index+1)));
			}else
				var size = parseInt(filesize);
			if(size<1024) 
				result = size + "B";
			else{
				var size = Math.round(size*100/1024)/100;
				if(size<1024)
					result = size + "KB";
				else{
					var size = Math.round(size*100/1024)/100;
					if(size<1024)
						result = size + "M";
					else {
						var size = Math.round(size*100/1024)/100;
						result = size + "G";
					}
				}
			}
		}
		return result;
	}

	// 判断手机微信端，安卓手机,by qiujh
	function isWechatAndriod(){
		var ua = navigator.userAgent.toLowerCase();
		var u = navigator.userAgent, app = navigator.appVersion;
		// 微信端，安卓，（UC浏览器的判断为u.indexOf('Linux') > -1）
		if(ua.match(/MicroMessenger/i)=="micromessenger" && u.indexOf('Android') > -1) {
			return true;
		} else {
			return false;
		}
	}
	
	// 微信下载，by qiujh
	<%request.setAttribute("contextPath",request.getContextPath());%>
	function wechatDownload(fdFileId, fdContentType, fdFileName) {
		var params = "{\"fdFileId\" : \""+ fdFileId +"\", "
					+"\"fdFileName\" : \""+ fdFileName +"\", "
					+"\"fdContentType\" : \""+ fdContentType +"\"}";
		var url = "${contextPath}/third/wechat/wechatLoginHelper.do?method=wechatDownload&params="+ params;
		var xmlhttp = {};
		if (window.XMLHttpRequest){
			// 所有浏览器
			xmlhttp = new XMLHttpRequest();
		}else if (window.ActiveXObject){
			// IE5 和 IE6
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		xmlhttp.open("POST", url, true);
		xmlhttp.onreadystatechange = function(){
			
		};
		xmlhttp.send(null);
		alert("<bean:message bundle="sys-attachment" key="mui.sysAttMain.msg.wechatDownload" />");
	}
</script>

<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />
<c:set var="msgkey" value="${param.msgkey}"/>
<c:set var="netUrl" value="/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdModelId}"/>
<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
	<c:if test="${param.useTab==true}">
		<tr class="tr_extendTitle">
			<td class="td_title">
	</c:if>
	<c:if test="${msgkey!=null}">
		<c:if test="${param.useTab==true}">
			${msgkey}</td><td>&nbsp;</td></tr>
			<tr><td colspan="2" class="td_common">
		</c:if>
		<c:if test="${param.useTab!=true}">
		   ${msgkey}:&nbsp;<img src="${KMSS_Parameter_ContextPath}third/pda/resource/images/attachment.png"> ${fn:length(attForms.attachments)}<bean:message key="sysAttMain.msg.num" bundle="sys-attachment"/>
		</c:if>
	</c:if>
	<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
		<c:if test="${sysAttMain.fdAttType=='pic'}">
			<div align="center">
				<img class="imgClass" src='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>'></img>
			</div>
		</c:if>
		<c:if test="${sysAttMain.fdAttType!='pic'}">
			<c:set var="attSuffixArr" value="${fn:split(sysAttMain.fdFileName,'.')}" />
			<c:set var="attSuffix" value="${attSuffixArr[fn:length(attSuffixArr)-1]}" />
			<c:set var="attSuffixLower" value="${fn:toLowerCase(attSuffix)}" />
			<c:set var="classVar" value="div_otherAtt"/>
			<c:choose>
				<c:when test="${attSuffixLower=='ppt' || attSuffixLower=='pptx'||attSuffixLower=='pps'}">
					<c:set var="classVar" value="div_pptAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='doc' || attSuffixLower=='docx' }">
				    <%
					// 金格启用模式(公文中部署了启用阅读加速模式，可以实现将word正文转换成图片在PC中阅读，请考虑在移动端也可支持看公文图片)
					if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
					%>
				     <c:choose>
				         <c:when test="${param.fdModelId!=null && isExist==true}">
				             <c:set var="classVar" value="div_htmAtt"/>  
						</c:when>
						<c:otherwise>
							<c:set var="classVar" value="div_docAtt"/>
						</c:otherwise>
				      </c:choose>
					<%
					 } else { //金格不启用模式
					%>
					    <c:set var="classVar" value="div_docAtt"/>
					<%
					}
				    %>
				</c:when>
				<c:when test="${attSuffixLower=='xls' || attSuffixLower=='xlsx'|| attSuffixLower=='csv'}">
					<c:set var="classVar" value="div_xlsAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='pdf'}">
					<c:set var="classVar" value="div_pdfAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='rar'||attSuffixLower=='zip'||attSuffixLower=='7z'||attSuffixLower=='cab'||attSuffixLower=='arc'}">
					<c:set var="classVar" value="div_otherAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='txt'}">
					<c:set var="classVar" value="div_txtAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='png'||attSuffixLower=='jpg'||attSuffixLower=='gif'||attSuffixLower=='bmp'||attSuffixLower=='tif'}">
					<c:set var="classVar" value="div_imgAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='vsd'}">
					<c:set var="classVar" value="div_visioAtt"/>
				</c:when>
				<c:when test="${attSuffixLower=='mpp'}">
					<c:set var="classVar" value="div_mppAtt"/>
				</c:when>
				<c:otherwise>
					<c:set var="classVar" value="div_vsdAtt"/>
				</c:otherwise>
			</c:choose>
			<div id="div_attMain">
				<div class="${classVar}">
				</div>
				<div id="div_att">
				
				<%-- 微信安卓版下载 by qiujh --%>
				<div><script>
				  	var wePublicId = "${sessionScope.wePublicId}";
					if (isWechatAndriod() && wePublicId != "") {
						document.write("<input type=\"button\" value=\"<bean:message bundle="sys-attachment" key="sysAttMain.button.download" />\" onclick=\"wechatDownload('${sysAttMain.fdFileId}', '${sysAttMain.fdContentType}', '${sysAttMain.fdFileName}');\"/>");
					}
				</script></div>
				<%-- 微信安卓版下载 (图片类型可以直接查看) --%>
				<c:choose>
			        <c:when test="${fn:contains(sysAttMain.fdContentType, 'image')}">
						<c:set var="attdownloadUrl" value="/third/pda/attdownload.jsp?fdId=${sysAttMain.fdId}&open=1"/>
					</c:when>
					<c:otherwise>
						<c:set var="attdownloadUrl" value="/third/pda/attdownload.jsp?fdId=${sysAttMain.fdId}"/>
					</c:otherwise>
			    </c:choose>
				
				<c:if test="${_downLoadNoRight==true}">
				    <%
					// 金格启用模式(公文中部署了启用阅读加速模式，可以实现将word正文转换成图片在PC中阅读，请考虑在移动端也可支持看公文图片)
					if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
					%>
					      <c:choose>
					         <c:when test="${param.fdModelId!=null}">
					             <c:if test="${isExist==true}">
					            	  <a href='<c:url value="${netUrl}"/>' target="_blank">
					            	  <c:set var="attSuffix" value="htm"/>
					              </c:if>
					              <%-- 金格控件启用后，兼容历史数据--%>
					              <c:if test="${isExist!=true}">
					            	  <a href='<c:url value="${attdownloadUrl }"/>' target="_blank">
					              </c:if>
							</c:when>
							<c:otherwise>
							    <a href='<c:url value="${attdownloadUrl }"/>' target="_blank">
							</c:otherwise>
					      </c:choose>
					<%
					 } else { //金格不启用模式
					%>
					      <a href='<c:url value="${attdownloadUrl }"/>' target="_blank">
					<%
					}
				    %>
				</c:if>
				<c:if test="${_downLoadNoRight!=true}">
				    <%
					// 金格启用模式(公文中部署了启用阅读加速模式，可以实现将word正文转换成图片在PC中阅读，请考虑在移动端也可支持看公文图片)
					if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
					%>
					       <c:choose>
					         <c:when test="${param.fdModelId!=null}">
					             <c:if test="${isExist==true}">
					            	  <a href='<c:url value="${netUrl}"/>' target="_blank">
					            	  <c:set var="attSuffix" value="htm"/>
					              </c:if>
					              <%-- 金格控件启用后，兼容历史数据--%>
					              <c:if test="${isExist!=true}">
					            	  <a href='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>' target="_blank">
					              </c:if>
							</c:when>
							<c:otherwise>
								<a href='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>' target="_blank">
							</c:otherwise>
					      </c:choose>
					<%
					 } else { //金格不启用模式
					%>
					      <a href='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>' target="_blank">
					<%
					}
				    %>
				</c:if>
				<c:if test="${sysAttMain.fdAttType=='office'}">
					<c:if test="${_formBean.docSubject==null}">
						${_formBean.fdName}.${attSuffix}
					</c:if>
					<c:if test="${_formBean.docSubject!=null}">
						${_formBean.docSubject}.${attSuffix}
					</c:if>
				</c:if>
				<c:if test="${sysAttMain.fdAttType!='office'}">
					${sysAttMain.fdFileName}
				</c:if>
				<span class="list_summary">(<script>document.write(att_formatSize('${sysAttMain.fdSize}'));</script>)</span>
				</a>
				</div>
			</div>
		</c:if>
	</c:forEach>
	
	<c:if test="${param.useTab==true}">
		</td>
			</tr>
	</c:if>
</c:if>