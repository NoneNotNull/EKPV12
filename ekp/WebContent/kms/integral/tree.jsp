<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.kms.integral" bundle="kms-integral"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 服务器设置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message bundle='kms-integral' key='kms.integral.nav.integralServerSet'/>"
	);
	
	
	n4=n2.AppendURLChild("<bean:message bundle='kms-integral' key='kms.integral.nav.integralServerSet'/>"
			,"<c:url value="/kms/integral/kms_integral_server/kmsIntegralServer.do?method=list"/>");
	n4=n2.AppendURLChild("<bean:message bundle='kms-integral' key='kms.integral.nav.integralSet'/>" 
			,"<c:url value="/kms/integral/kms_integral_server/kmsIntegralServer.do?method=getList&type=1"/>");
	
	<%-- 基础设置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message bundle='kms-integral' key='kms.integral.base.set'/>"
	);
	
	<%-- 积分规则表 --%>
	n4 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralRule" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_rule/kmsIntegralRule.do?method=edit" />"
	);
	<%-- 积分规则系数 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralRuleParam" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_rule/kmsIntegralConifg.do?method=edit" />"
	);
	<kmss:authShow roles="SYSROLE_ADMIN">
	n3 = n2.AppendURLChild(
		"<bean:message key="kmsIntegral.tree.reset" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_rule/kmsIntegralRule_reset.jsp" />"
	);
	</kmss:authShow>
	
	<%-- 团队 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralTeam" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_team/kmsIntegralTeam.do?method=list" />"
	);
	<%-- 人员角色 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralPersonRole" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_person_role/kmsIntegralPersonRole.do?method=list" />"
	);
	<%-- 积分类型 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralType" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_type/kmsIntegralType.do?method=edit" />"
	);
	<%-- 积分修改 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralAlter" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_alter/kmsIntegralAlter.do?method=list" />"
	);
	
	<%-- 积分头衔设置  --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="kmsIntegralGradeConfig.score.grade.set" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_config/kmsIntegralGradeConfig.do?method=edit" />"
	);

	<%-- 团队积分排行 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsIntegralTeamRank" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_team_rank/kmsIntegralTeamRank.do?method=list" />"
	);
	<%-- 个人综合积分 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsIntegralPersonTotal" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=list" />"
	);
	
	
	<%-- 用户模块累计积分 
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsIntegralModuleTotal" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_module_total/kmsIntegralModuleTotal.do?method=list" />"
	);--%>
	<%-- 其它积分累计 
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsIntegralOtherTotal" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_other_total/kmsIntegralOtherTotal.do?method=list" />"
	);--%>

	
	<%-- 基础设置
	n2 = n1.AppendURLChild(
		"积分统计"
	); --%>
	
	<%-- 个人综合积分
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralPersonFilter" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_person_filter/kmsIntegralPersonFilter.do?method=list" />"
	); --%>
	
	<%-- 部门积分月统计条件
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmsIntegralDeptFilter" bundle="kms-integral" />",
		"<c:url value="/kms/integral/kms_integral_dept_filter/kmsIntegralDeptFilter.do?method=list" />"
	); --%>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>