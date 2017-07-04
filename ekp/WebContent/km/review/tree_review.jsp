<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="kmReview.tree.title" bundle="km-review"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	//========== 我的文档 ==========
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.tree.myDoc" bundle="km-review" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=all" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message  bundle="km-review" key="status.discard" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=00" />"
	);	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.draft" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=10" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.refuse" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=11" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.append" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=20" />"
	);	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.publish" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=30" />"
	);	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.feedback" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=true&status=31" />"
	);	

	//========== 我审批的文档 ==========

	//待审批的文档
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.doc.owner.append" bundle="km-review" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&myflow=0&status=all" />"
	);	
	//已审批的文档
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.doc.owner.disposed" bundle="km-review" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&myflow=1&status=all" />"
	);	
		
	//=========按类别=======
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.tree.category" bundle="km-review" />"
	);
	n2.AppendBeanData(
		"kmReviewCategoryTreeService",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&type=category&categoryId=!{value}" />",
		null,
		false
	);
	//=========按部门========
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.tree.department" bundle="km-review" />"
	);
	
	n2.AppendOrgData(
			"organizationTree&fdId=!{value}",
			"../review/km_review_main/kmReviewMain.do?method=list&type=department&departmentId=!{value}"
		);
	
	
	//=========按状态========
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.tree.status" bundle="km-review" />"
	);
	
	n3 = n2.AppendURLChild(
		"<bean:message  bundle="km-review" key="status.discard" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=false&status=00" />"
	);	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.draft" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=false&status=10" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.refuse" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=false&status=11" />"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.append" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=false&status=20" />"
	);	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.publish" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=false&status=30" />"
	);	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-review" key="status.feedback" />",
		"<c:url value="/km/review/km_review_main/kmReviewMain.do?method=list&mydoc=false&status=31" />"
	);	
	//=========模块设置========
	n2 = n1.AppendURLChild(
		"<bean:message key="kmReview.tree.modelSet" bundle="km-review" />"
	);
	
	//类别设置
	n2.AppendURLChild(
		"<bean:message key="kmReview.tree.categorySet" bundle="km-review" />"
	);

	//模板设置
	n3=n2.AppendURLChild(
		"<bean:message key="kmReview.tree.templateSet" bundle="km-review" />"
	);
	
	//我的模板
	n3.AppendURLChild(
		"<bean:message key="template.owner" bundle="km-review" />",
		"<c:url value="/km/review/km_review_template/kmReviewTemplate.do?method=list&ower=1" />"
	);
	//所有模板
	n3.AppendURLChild(
		"<bean:message key="template.all" bundle="km-review" />",
		"<c:url value="/km/review/km_review_template/kmReviewTemplate.do?method=list&ower=0" />"
	);
	//流程模板设置
	n2.AppendURLChild(
		"<bean:message key="tree.workflowTemplate" bundle="km-review" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.review.model.KmReviewTemplate&fdKey=reviewMainDoc" />"
	);
	<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
		n2.AppendURLChild(
			"<bean:message bundle="sys-number" key="sysNumber.config.tree.numberMain"/>",
			"<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.review.model.KmReviewMain" />"
		);
		<%} %>
	//表单模板设置
	n2.AppendURLChild(
		"<bean:message key="tree.xform.def" bundle="sys-xform" />",
		"<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
			<c:param name="method" value="list" />
			<c:param name="fdModelName" value="com.landray.kmss.km.review.model.KmReviewTemplate" />
			<c:param name="fdKey" value="reviewMainDoc" />
			<c:param name="fdMainModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
		</c:url>"
	);

	
	//LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
