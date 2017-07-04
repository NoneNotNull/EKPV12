<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	org.springframework.transaction.*,
	java.util.*,
	com.landray.kmss.util.*,
	com.landray.kmss.sys.lbpm.engine.persistence.*,
	com.landray.kmss.sys.lbpm.engine.persistence.model.*,
	com.landray.kmss.sys.organization.interfaces.*,
	com.landray.kmss.sys.organization.model.*,
	net.sf.json.JSONObject"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>lbpm沟通临时组织架构数据迁移</title>
</head>
<body>
<kmss:authShow roles="SYSROLE_ADMIN">
<%
	// 沟通数据升级
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	TransactionStatus status = TransactionUtils.beginNewTransaction();
	try {
		AccessManager accessManager = (AccessManager)ctx.getBean("accessManager");
		ISysOrgCoreService sysOrgCoreService = (ISysOrgCoreService)ctx.getBean("sysOrgCoreService");
		List processParameters = accessManager.find("from LbpmProcessParameter where fdValue like '%fdCommOrgId%' and fdTaskType='processInstance'");
		int num = 0;
		for(int i = 0; i < processParameters.size(); i++) {
			LbpmProcessParameter processParameter = (LbpmProcessParameter)processParameters.get(i);
			JSONObject obj = JSONObject.fromObject(processParameter.getFdValue());
			SysOrgElement org = sysOrgCoreService.findByPrimaryKey(obj.getString("fdCommOrgId"), null, true);
			if(org == null) {
				// 新数据了
				continue;
			}
			LbpmTempOrg commuicater = new LbpmTempOrg();
			commuicater.setFdOrgType("fdCommOrgId");
			commuicater.setFdOrg(org);
			commuicater.setFdTaskId(obj.getString("fdId"));
			commuicater.setFdTaskType("communicateTask");
			commuicater.setFdFactNodeId(obj.getString("fdFactNodeId"));
			commuicater.setFdProcessId(obj.getString("fdProcessId"));
			accessManager.save(commuicater);
			obj.put("fdCommOrgId", commuicater.getFdId());
			processParameter.setFdValue(obj.toString());
			accessManager.update(processParameter);
			out.println(obj);
			num++;
		}
		out.println("升级成功！共升级记录数："+num);
		TransactionUtils.commit(status);
	} catch(Exception e) {
		TransactionUtils.rollback(status);
		out.println("升级失败！");
		e.printStackTrace();
	}
%>
</kmss:authShow>
</body>
</html>