<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.imeeting" bundle="km-imeeting"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	
	<%-- 模块设置--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="kmImeeting.tree.moduleConfig" bundle="km-imeeting" />"
	);
	
	<%-- 会议类别设置--%>
	n3=n2.AppendURLChild(
		"<bean:message key="kmImeeting.tree.categorySetting" bundle="km-imeeting" />",
		"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&mainModelName=com.landray.kmss.km.imeeting.model.KmImeetingMain&categoryName=docCategory&templateName=fdTemplate&authReaderNoteFlag=2" />"
	);
	<%-- 卡片库--%>
	n2.AppendCV2Child(
		"<bean:message key="kmImeeting.tree.templateSetting.card" bundle="km-imeeting" />",
		"com.landray.kmss.km.imeeting.model.KmImeetingTemplate",
		"<c:url value="/km/imeeting/km_imeeting_template/kmImeetingTemplate.do?method=listChildren&parentId=!{value}" />"
	);
	
	<kmss:authShow roles="ROLE_KMIMEETING_SETTING">
	<%-- 会议安排流程模板--%>
	n2.AppendURLChild(
		"<bean:message key="kmImeeting.tree.mainMeetingFlow" bundle="km-imeeting" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&fdKey=ImeetingMain" />"
	);
	
	<%-- 会议纪要流程模板--%>
	n2.AppendURLChild(
		"<bean:message key="kmImeeting.tree.summaryFlow" bundle="km-imeeting" />",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.imeeting.model.KmImeetingTemplate&fdKey=ImeetingSummary" />"
	);		
	
	<%-- 编号机制--%>
	n2.AppendURLChild(
			"<bean:message bundle="sys-number" key="sysNumber.config.tree.numberMain"/>",
			"<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.imeeting.model.KmImeetingMain" />"
		);
		
	<%-- 基础设置--%>	
	n2.AppendURLChild(
		"<bean:message key="kmImeeting.tree.moduleBaseConflict" bundle="km-imeeting" />",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.km.imeeting.model.KmImeetingConfig" />"
	);
	</kmss:authShow>
	
	
	<%-- 会议室管理设置--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="kmImeeting.tree.place" bundle="km-imeeting" />"
	);
	
	<%-- 会议室分类 --%>
	n2.AppendURLChild(
		"<bean:message key="table.kmImeetingResCategory" bundle="km-imeeting" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.imeeting.model.KmImeetingResCategory&actionUrl=/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do&formName=kmImeetingResCategoryForm&mainModelName=com.landray.kmss.km.imeeting.model.KmImeetingRes&docFkName=docCategory" />"
	);
	
	<%-- 会议室信息 --%>
	n3=n2.AppendURLChild(
		"<bean:message key="table.kmImeetingRes" bundle="km-imeeting" />",
		"<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=list&dataWithAdmin=true" />"
	);	
	
	n3.AppendSimpleCategoryData(
    	"com.landray.kmss.km.imeeting.model.KmImeetingResCategory",
    	"<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=list&docCategoryId=!{value}&authReaderNoteFlag=2&dataWithAdmin=true" />"
    );
	
	
	<%-- 辅助设备 --%>
	 n2.AppendURLChild(
		"<bean:message key="table.kmImeetingDevice" bundle="km-imeeting" />",
		"<c:url value="/km/imeeting/km_imeeting_device/kmImeetingDevice.do?method=list" />"
	);
	
	<kmss:authShow roles="ROLE_KMIMEETING_RES_READER">
	<%-- 会议室查询 --%>
	 n2.AppendURLChild(
		"<bean:message key="kmImeeting.tree.listUse" bundle="km-imeeting" />",
		"<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=listUse" />"
	);
	</kmss:authShow>
	
	<%-- 文档维护 --%>
	n6 = n1.AppendURLChild("<bean:message key="tree.sysCategory.maintains" bundle="sys-category" />")
	
	<%-- 会议安排--%>
	n7 = n6.AppendURLChild("<bean:message key="kmImeeting.tree.myHandleMeeting" bundle="km-imeeting" />")
	n7.authType="01";
	<kmss:authShow roles="ROLE_KMIMEETING_OPTALL">
		n7.authRole="optAll";
	</kmss:authShow>
	n7.AppendCategoryDataWithAdmin ("com.landray.kmss.km.imeeting.model.KmImeetingTemplate","<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=manageList&categoryId=!{value}"/>","<c:url value="/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=optAllList&categoryId=!{value}"/>");
	
	<%-- 会议纪要安排--%>
	n8 = n6.AppendURLChild("<bean:message key="kmImeeting.tree.myHandleSummary" bundle="km-imeeting" />")
	n8.authType="01";
	<kmss:authShow roles="ROLE_KMIMEETING_OPTALL">
		n8.authRole="optAll";
	</kmss:authShow>
	n8.AppendCategoryDataWithAdmin ("com.landray.kmss.km.imeeting.model.KmImeetingTemplate","<c:url value="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=manageList&categoryId=!{value}"/>","<c:url value="/km/imeeting/km_imeeting_summary/kmImeetingSummary.do?method=optAllList&categoryId=!{value}"/>");
	
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>