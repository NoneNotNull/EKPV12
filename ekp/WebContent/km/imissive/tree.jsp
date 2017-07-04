<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.imissive" bundle="km-imissive" />",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
<kmss:authShow roles="ROLE_KMIMISSIVE_CONFIG_SETTING">	
	//参数设置
	n2 = n1.AppendURLChild(
		"<bean:message key="kmImissive.tree.paramSet" bundle="km-imissive" />");	
	//发文转收文题头设置
	n3=n2.AppendURLChild(
		"阅读加速设置",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.km.imissive.model.KmImissiveConfig" />"
	);	
	//文种设置
	n3=n2.AppendURLChild(
		"<bean:message key="table.kmImissiveType" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_type/kmImissiveType.do?method=list" />"
	);
	//密级程度设置
	n3=n2.AppendURLChild(
		"<bean:message key="table.kmImissiveSecretGrade" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_secret_grade/kmImissiveSecretGrade.do?method=list" />"
	);
	//缓急程度设置
	n3=n2.AppendURLChild(
		"<bean:message key="table.kmImissiveEmergencyGrade" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_emergency_grade/kmImissiveEmergencyGrade.do?method=list" />"
	);
	//单位分类设置
	n3=n2.AppendURLChild(
		"<bean:message key="table.kmImissiveUnitCategory" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_unit_category/kmImissiveUnitCategory.do?method=list" />"
	);	
	//单位设置
	n3=n2.AppendURLChild(
		"<bean:message key="table.kmImissiveUnit" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_unit/kmImissiveUnit.do?method=list" />"
	);
	n3.AppendBeanData("kmImissiveUnitTreeService&parentId=!{value}&type=receive&isFiling=true");
	//公文交换配置
	n3=n2.AppendURLChild(
		"公文交换设置",
		"<c:url value="/km/imissive/km_imissive_template_cfg/kmImissiveTemplateCfg.do?method=list" />"
	);	
		
	//发文转收文题头设置
	//n3=n2.AppendURLChild(
	//	"公文交换配置",
	//	"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.km.imissive.model.KmImissiveConfig" />"
	//);
	//=========模块设置========
	n4 = n1.AppendURLChild("发文设置");
	n4.AppendURLChild(
		"发文分类设置",
		"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.imissive.model.KmImissiveSendTemplate&mainModelName=com.landray.kmss.km.imissive.model.KmImissiveSendMain&templateName=fdTemplate&categoryName=docCategory&authReaderNoteFlag=2" />"
	);
	n4.AppendCV2Child("发文模板设置",
		"com.landray.kmss.km.imissive.model.KmImissiveSendTemplate",
		"<c:url value="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do?method=listChildren&parentId=!{value}&ower=1" />");
	//套红模板设置
	n4.AppendURLChild(
		"<bean:message key="kmImissiveSend.tree.redhead.template" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_redhead_template/kmImissiveRedHeadTemplate_tree.jsp?modelName=com.landray.kmss.km.imissive.model.KmImissiveRedHeadTemplate&actionUrl=/km/imissive/km_imissive_redhead_template/kmImissiveRedHeadTemplate.do&formName=kmImissiveRedHeadTemplateForm&authReaderNoteFlag=2" />"
	  );
	n4.AppendURLChild(
		"发文通用编号规则",
		"<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.imissive.model.KmImissiveSendMain" />"
	);
	
	//流程模板设置
	n4.AppendURLChild(
		"发文通用流程模板设置",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.imissive.model.KmImissiveSendTemplate&fdKey=sendMainDoc" />"
	); 
	//表单模板设置
	n4.AppendURLChild(
		"发文通用表单模板",
		"<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
			<c:param name="method" value="list" />
			<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate" />
			<c:param name="fdKey" value="sendMainDoc" />
			<c:param name="fdMainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
		</c:url>"
	);

	// 表单存储设置
	n4.AppendURLChild(
		"发文表单数据映射设置",
		"<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="list"/>
			<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain"/>
			<c:param name="fdTemplateModel" value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate"/>
			<c:param name="fdKey" value="sendMainDoc"/>
		</c:url>"
	);
	n5 = n1.AppendURLChild("收文设置");
	n5.AppendURLChild(
		"收文分类设置",
		"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate&mainModelName=com.landray.kmss.km.imissive.model.KmImissiveReceiveMain&templateName=fdTemplate&categoryName=docCategory&authReaderNoteFlag=2" />"
	);	
	n5.AppendCV2Child("收文模板设置",
		"com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate",
		"<c:url value="/km/imissive/km_imissive_receive_template/kmImissiveReceiveTemplate.do?method=listChildren&parentId=!{value}&ower=1" />");
		
	n5.AppendURLChild(
		"收文通用编号规则",
		"<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />"
	);
	//流程模板设置
	n5.AppendURLChild(
		"收文通用流程模板设置",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate&fdKey=receiveMainDoc" />"
	);
	//表单模板设置
	n5.AppendURLChild(
		"收文通用表单模板",
		"<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
			<c:param name="method" value="list" />
			<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate" />
			<c:param name="fdKey" value="receiveMainDoc" />
			<c:param name="fdMainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
		</c:url>"
	);

	// 表单存储设置
	n5.AppendURLChild(
		"收文表单数据映射设置",
		"<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="list"/>
			<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain"/>
			<c:param name="fdTemplateModel" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate"/>
			<c:param name="fdKey" value="receiveMainDoc"/>
		</c:url>"
	);
	
	n6 = n1.AppendURLChild("签报设置");
	n6.AppendURLChild(
		"签报分类设置",
		"<c:url value="/sys/category/sys_category_main/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.imissive.model.KmImissiveSignTemplate&mainModelName=com.landray.kmss.km.imissive.model.KmImissiveSignMain&templateName=fdTemplate&categoryName=docCategory&authReaderNoteFlag=2" />"
	);
	n6.AppendCV2Child("签报模板设置",
		"com.landray.kmss.km.imissive.model.KmImissiveSignTemplate",
		"<c:url value="/km/imissive/km_imissive_sign_template/kmImissiveSignTemplate.do?method=listChildren&parentId=!{value}&ower=1" />");
	//套红模板设置
	n6.AppendURLChild(
		"<bean:message key="kmImissiveSign.tree.redhead.template" bundle="km-imissive" />",
		"<c:url value="/km/imissive/km_imissive_sign_redhead_template/kmImissiveSignRedHeadTemplate_tree.jsp?modelName=com.landray.kmss.km.imissive.model.KmImissiveSignRedHeadTemplate&actionUrl=/km/imissive/km_imissive_sign_redhead_template/kmImissiveSignRedHeadTemplate.do&formName=kmImissiveSignRedHeadTemplateForm&authReaderNoteFlag=2" />"
	  );
	n6.AppendURLChild(
		"签报通用编号规则",
		"<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.imissive.model.KmImissiveSignMain" />"
	);
	
	//流程模板设置
	n6.AppendURLChild(
		"签报通用流程模板设置",
		"<c:url value="/sys/workflow/sys_wf_common_template/sysWfCommonTemplate.do?method=list&fdModelName=com.landray.kmss.km.imissive.model.KmImissiveSignTemplate&fdKey=signMainDoc" />"
	); 
	//表单模板设置
	n6.AppendURLChild(
		"签报通用表单模板",
		"<c:url value="/sys/xform/sys_form_common_template/sysFormCommonTemplate.do">
			<c:param name="method" value="list" />
			<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignTemplate" />
			<c:param name="fdKey" value="signMainDoc" />
			<c:param name="fdMainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
		</c:url>"
	);

	// 表单存储设置
	n6.AppendURLChild(
		"签报表单数据映射设置",
		"<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
			<c:param name="method" value="list"/>
			<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain"/>
			<c:param name="fdTemplateModel" value="com.landray.kmss.km.imissive.model.KmImissiveSignTemplate"/>
			<c:param name="fdKey" value="signMainDoc"/>
		</c:url>"
	);
	<kmss:ifModuleExist path="/km/signature/">
		n7 = n1.AppendURLChild("印章设置");
		//印章库
		n8 = n7.AppendURLChild(
			"印章库",
			"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list" />"
		);
		<kmss:authShow roles="ROLE_SIGNATURE_ADD">
		n9 = n8.AppendURLChild(
			"个人签名",
			"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&docType=1" />"	
		);
		</kmss:authShow>
		<kmss:authShow roles="ROLE_SIGNATURE_COMPANY">
		n9 = n8.AppendURLChild(
			"单位印章",
			"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&docType=2" />"
		);
		</kmss:authShow>
		<kmss:authShow roles="ROLE_SIGNATURE_CATEGORY_MAINTAINER;ROLE_SIGNATURE_ADMIN">
		//印章分类设置
		n8 = n7.AppendURLChild(
				"印章分类设置",
				"<c:url value="/km/signature/km_signature_category/kmSignatureCategory_tree.jsp?modelName=com.landray.kmss.km.signature.model.KmSignatureCategory&actionUrl=/km/signature/km_signature_category/kmSignatureCategory.do&formName=kmSignatureCategoryForm" />"
			);
		</kmss:authShow>
	</kmss:ifModuleExist>
	</kmss:authShow>
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>