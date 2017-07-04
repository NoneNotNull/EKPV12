<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script type="text/javascript" src="${LUI_ContextPath }/kms/common/pda/script/lib/photoswipe.js"></script>
<link href="${LUI_ContextPath }/kms/common/pda/script/lib/photoswipe.css" type="text/css" rel="stylesheet" />
<%
	String formBeanName = request.getParameter("formBeanName");
	Object formBean = pageContext.findAttribute(formBeanName);
	pageContext.setAttribute("formBean", formBean);
%>

<div id="attachment__${param.fdModelId }" class="lui-attachment-area">
	<c:set var="__attForms" value="${formBean.attachmentForms.attachment.attachments}" />
	<c:set var="attForms" value="${formBean.attachmentForms.spic}" />
	<c:set var="hasPic" value="${false}" />
	<c:forEach var="sysAttMain" items="${attForms.attachments }" varStatus="vsStatus">
		<c:if test="${vsStatus.first }">
			<c:set var="fdAttId" value="${sysAttMain.fdId }" />
			<c:set var="hasPic" value="${true}" />
			<c:set var="cardPicURL" value="${pageContext.request.contextPath }/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
		</c:if>
	</c:forEach>
	<c:if test="${hasPic=='true'}">
		<a href='${cardPicURL }'>
			<img src="${cardPicURL }" width="100%" alt="" data-lui-id="${ fdAttId}"/>
		</a>
	</c:if>
	<c:forEach items="${__attForms }" var="sysAttMain" varStatus="__index">

		<%!
			String getExt(String fileName) {
				if(fileName.lastIndexOf(".") < 0)
					return "";
				return fileName.substring(fileName.lastIndexOf("."));
			}
		%>
		
		<%
			SysAttMain att = (SysAttMain) pageContext
						.getAttribute("sysAttMain");
				String ext = getExt(att.getFdFileName());
				String fdId = att.getFdId();
				String imageType = ".gif;.jpg;.jpeg;.bmp;.png;.tif";
				String videoType = ".flv;.f4v;.mp4;.ogg;.3gp;.avi;.wmv;.rm;.rmvb;.asx;.asf;.mpg;.mov;.wmv9;.wrf";
				String officeType = ".doc;.xls;.mpp;.ppt;.xlc;.docx;.xlsx;.mppx;.pptx;.xlcx;.wps;.et";
				String src = "/resource/style/default/attachment/default.png";
				if (imageType.indexOf(ext) >= 0)
					src = "/sys/attachment/sys_att_main/sysAttMain.do?method=showThumbs&size=s1&fdId="
							+ fdId;
				else if (videoType.indexOf(ext) >= 0)
					src = "/sys/attachment/sys_att_main/sysAttMain.do?method=showThumbs&size=s1&fdId="
							+ fdId;
				else if (officeType.indexOf(ext) >= 0)
					src = "/sys/attachment/sys_att_swf/sysAttSwf.do?method=swf&thumb=true&attid="
							+ fdId;
				pageContext.setAttribute("src", src);
		%>
		<a href='<c:url value="${src }"/>'  <c:if test="${hasPic=='true' || __index.index>0 }"> style="display: none"</c:if>>
			<img <c:if test="${hasPic!='true' &&  __index.index == 0 }"> src="<c:url value="${src }"/>"</c:if> height="100%" width="100%" alt="${sysAttMain.fdFileName }" data-lui-id="${sysAttMain.fdId }"/>
		</a>
	</c:forEach>
	<%
	Boolean hasPic = (Boolean)pageContext.getAttribute("hasPic");
		List attList = (List)pageContext.getAttribute("__attForms");
		Boolean hasGroup = false;
		if(Boolean.TRUE.equals(hasPic)&&attList.size()>=1)
			hasGroup = true;
		else if(attList.size()>1)
			hasGroup = true;
		if(hasGroup){
	%>
		<span class="pic_group">图集</span>
	<%
		}
	%>
</div>

<script>
	$("#attachment__${param.fdModelId } a").photoSwipe();
</script>
