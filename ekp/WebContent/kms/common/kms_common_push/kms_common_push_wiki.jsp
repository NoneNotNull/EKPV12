<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/dialog_htmlhead.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
</head>
<frameset cols="25%,1%,74%" framespacing=3 frameborder=0>
  <frame src="../../common/kms_common_push/kms_common_category.jsp?kmsCommonPushAction=${param.kmsCommonPushAction}&fdModelId=${param.fdModelId}" frameborder=0 name="bb" id="bb"/>
  <frame src="../../common/kms_common_push/kms_common_vertical_line.jsp" scrolling=no frameborder=0/>
  <frame src="../../common/kms_common_push/kms_common_push_wiki_content.jsp?fdModelId=${param.fdModelId}&kmsCommonPushAction=${param.kmsCommonPushAction}" name="rightFrameset"  scrolling=no id="viewFrameObj" /> 
</frameset> 
</html>