<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
</script>

<c:set var="attForms" value="${_formBean.attachmentForms[param.fdKey]}" />
<c:set var="msgkey" value="${param.msgkey}"/>
<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
<dd>
	<table>
		<tr>
			<c:if test="${param.useTab==true}">
			</c:if>
			<c:if test="${msgkey!=null}">
			</c:if>
			<div class="div_attGroup" align="center">
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
						<c:when test="${attSuffixLower=='ppt' || attSuffixLower=='pptx'}">
							<c:set var="classVar" value="div_pptAtt"/>
						</c:when>
						<c:when test="${attSuffixLower=='doc' || attSuffixLower=='docx' }">
							<c:set var="classVar" value="div_docAtt"/>
						</c:when>
						<c:when test="${attSuffixLower=='xls' || attSuffixLower=='xlsx' }">
							<c:set var="classVar" value="div_xlsAtt"/>
						</c:when>
						<c:when test="${attSuffixLower=='pdf'}">
							<c:set var="classVar" value="div_pdfAtt"/>
						</c:when>
						<c:when test="${attSuffixLower=='vsd'}">
							<c:set var="classVar" value="div_vsdAtt"/>
						</c:when>
						<c:when test="${attSuffixLower=='txt'}">
							<c:set var="classVar" value="div_txtAtt"/>
						</c:when>
						<c:when test="${attSuffixLower=='png'||attSuffixLower=='jpg'||attSuffixLower=='gif'||attSuffixLower=='bmp'}">
							<c:set var="classVar" value="div_imgAtt"/>
						</c:when>
						<c:otherwise>
							<c:set var="classVar" value="div_otherAtt"/>
						</c:otherwise>
					</c:choose>
					<div>
						<div class="${classVar}">
						</div>
						<c:if test="${_downLoadNoRight==true}">
							<a href='<c:url value="/third/pda/attdownload.jsp?fdId=${sysAttMain.fdId}"/>' target="_blank">
						</c:if>
						<c:if test="${_downLoadNoRight!=true}">
							<a href='<c:url value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"/>' target="_blank">
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
						</c:if></a>
						<b class="list_summary">(<script>document.write(att_formatSize('${sysAttMain.fdSize}'));</script>)</b>
					</div>
				</c:if>
			</c:forEach>
			</div>
			<c:if test="${param.useTab==true}">
			</c:if>
			
		</tr>
	</table>
</dd>
</c:if>