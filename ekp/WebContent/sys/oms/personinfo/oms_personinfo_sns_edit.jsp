<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page
	import="com.landray.kmss.util.*,com.landray.kmss.sys.organization.service.ISysOrgPersonService,java.net.URLDecoder,java.util.List,com.landray.kmss.sys.organization.model.SysOrgPerson"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<%ISysOrgPersonService personService = (ISysOrgPersonService) SpringBeanUtil
					.getBean("sysOrgPersonService");
			String fdLoginName = null;
			if (request.getParameterMap().containsKey("username")) {
				fdLoginName = URLDecoder.decode(request
						.getParameter("username"), "utf-8");
			}
			String fdMobileNo = URLDecoder.decode(request
					.getParameter("mobile"), "utf-8");
			String fdEmail = URLDecoder.decode(request.getParameter("email"),
					"utf-8");
			String fdWorkPhone = URLDecoder.decode(request
					.getParameter("workphone"), "utf-8");
			String errorMessage = null;
			List persons = null;
			try {
				SysOrgPerson currentPerson = UserUtil.getUser(request);
				SysOrgPerson editPerson = null;
				if (currentPerson.getFdLoginName().equals("admin")) {
					editPerson = (SysOrgPerson) personService.findList(
							"fdLoginName='" + fdLoginName + "'", "").get(0);
				} else {
					editPerson = currentPerson;
				}
				if (StringUtil.isNotNull(fdEmail)) {
					editPerson.setFdEmail(fdEmail);
				}
				if (StringUtil.isNotNull(fdWorkPhone)) {
					editPerson.setFdWorkPhone(fdWorkPhone);
				}
				if (StringUtil.isNotNull(fdMobileNo)) {
					editPerson.setFdMobileNo(fdMobileNo);
				}
				personService.update(editPerson);

			} catch (Exception ex) {
				errorMessage = ex.getMessage();
			}
			if (errorMessage != null) {
				request.setAttribute("ErrorMessage", errorMessage);
			}%>

	var toUN = {
		on: function(str) {
			var a = [],
			i = 0;
			for (; i < str.length;) a[i] = ("00" + str.charCodeAt(i++).toString(16)).slice( - 4);
			return "\\u" + a.join("\\u")
		},
		un: function(str) {
			return unescape(str.replace(/\\/g, "%"))
		}
	};
	
	function returnResult(){
		var errorMessage="${ErrorMessage}";
		var result=null;
		if(errorMessage=="")
		{
			result=new String("{\"ret\":0,\"msg\":\""+toUN.on("成功")+"\"}");
		}
		else{
			result=new String("{\"ret\":1,\"msg\":\""+toUN.on(errorMessage)+"\"}");
		}
		document.write(result);
	}
</script>
</head>
<body onload="returnResult();">
</body>
</html>