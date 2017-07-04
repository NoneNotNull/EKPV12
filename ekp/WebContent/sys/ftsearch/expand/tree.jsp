<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ftsearch.util.MultSystemlicense" %>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
<%
	boolean multSystemFlag=MultSystemlicense.getLicene();
	String searchEngineType= ResourceUtil.getKmssConfigString("sys.ftsearch.config.engineType");
%>
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.sys.ftsearch.expand" bundle="sys-ftsearch-expand"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 搜索主页 
	n2 = n1.AppendURLChild(
		"<bean:message key="sysFtsearch.ftsearch.homePage" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/searchHomePage.do?method=homePage" />"
	);--%>
	<%-- 默认搜索模块配置--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchConfig" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/sys_ftsearch_config/sysFtsearchConfig.do?method=edit" />"
	);
	
	<%-- 字段权值配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.fieldBoostingConfig" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/fieldBoostingConfig.do?method=getSearchField" />"
	);
	<%-- 搜索优先展示区域配置 --%>
	if(<%="elasticsearch".equals(searchEngineType)%>){
		n2 = n1.AppendURLChild(
			"<bean:message key="reaultDisplayArea.customDisplayAreaConfig" bundle="sys-ftsearch-expand" />",
			"<c:url value="/sys/ftsearch/expand/customDisplayAreaConfig.do?method=load" />"
		);
	}
	<%-- 阅读文档 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchReadLog" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_read_log/sysFtsearchReadLog.do?method=list" />"
	);
	
	<%-- 搜索热词 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchHotword" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_hotword/sysFtsearchHotword.do?method=list&orderby=sysFtsearchHotword.fdWordOrder desc,sysFtsearchHotword.fdSearchFrequency&ordertype=down" />"
	);
	<%-- 用户搜索日志表 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchWord" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_word/sysFtsearchWord.do?method=list" />"
	);
	if(<%=multSystemFlag%>){
		<%-- 多系统支持配置 --%>
		n2 = n1.AppendURLChild(
			"<bean:message key="table.sysFtsearchMultisystem" bundle="sys-ftsearch-expand" />"
		);
		<%-- 多系统支持 --%>
		n3 = n2.AppendURLChild(
			"<bean:message key="table.sysFtsearchMultisystem" bundle="sys-ftsearch-expand" />",
			"<c:url value="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do?method=list" />"
		);
		
		<%-- 多系统模块类别分类 --%>
		n3 = n2.AppendURLChild(
			"<bean:message key="table.sysFtsearchModelgroup" bundle="sys-ftsearch-expand" />",
			"<c:url value="/sys/ftsearch/expand/sys_ftsearch_modelgroup/sysFtsearchModelgroup.do?method=list" />"
		);
		<%-- 权限对应表 --%>
		n3 = n2.AppendURLChild(
			"<bean:message key="table.tattEkpSys" bundle="sys-ftsearch-expand" />",
			"<c:url value="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do?method=list" />"
		);
	}
	<%-- 汉字联想词表 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchChineseLegend" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=list&orderby=sysFtsearchChineseLegend.fdSearchFrequency&ordertype=down" />"
	);
	<%-- 分面搜索配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchFacet" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_facet/sysFtsearchFacet.do?method=list" />"
	);
	<%-- 同义词结果表 	--%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchSynonymsSet" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=list" />"
	);

	
	<%-- 同义词表 
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchSynonym" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=list" />"
	);--%>
	<%-- 
		//n3 = n2.AppendURLChild(
				//"同步到结果表",
				//"同步到结果表",
				//"<c:url value="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=list"/>"
				//)
		
			n3 = n2.AppendURLChild(
				"未同步",
				"<c:url value="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=list&fdSynchState=0" />"
				)
			n3 = n2.AppendURLChild(
				"已同步",
				"<c:url value="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=list&fdSynchState=1" />"
				)	
	--%>
	
	
	
	<%-- 分词管理表 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchParticiple" bundle="sys-ftsearch-expand" />"
	);
	<%--自定义分词管理 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.sysFtsearchUserParticiple" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_user_participle/sysFtsearchUserParticiple.do?method=list" />"
	)
	<%--歧义词分词管理 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.sysFtsearchAmbParticiple" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_amb_participle/sysFtsearchAmbParticiple.do?method=list" />"
	)
	<%--
		n3 = n2.AppendURLChild(
				//"导出分词",
				"导出分词",
				"<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=list" />"
				)
		
			n4 = n3.AppendURLChild(
				//"未导出分词",
				"未导出分词",
				"<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=list&fdExportState=0"/>"
				)
			n4 = n3.AppendURLChild(
				//"已导出分词",
				"已导出分词",
				"<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=list&fdExportState=1"/>"
				)
	 --%>
		<%-- 分词类别 
		n3 = n2.AppendURLChild(
			"<bean:message key="table.sysFtsearchParticipleCategory" bundle="sys-ftsearch-expand" />",
			"<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle_category/sysFtsearchParticipleCategory_tree.jsp" />"
		);--%>
		
		
		
		
	<%--
	//按类别
	//n3 = n2.AppendURLChild(
		//"按类别"
	//);
	
	//n3.AppendSimpleCategoryData(
		//"com.landray.kmss.sys.ftsearch.expand.model.SysFtsearchParticipleCategory",
		//"<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=listChildren&categoryId=!{value}&orderby=docCreateTime&ordertype=down" />"
	//);
	//n3.isExpanded = true;
	
		//导出功能
		//<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=list&fdModelName=com.landray.kmss.sys.ftsearch.expand.model.SysFtsearchParticiple">
			
			//n3 = n2.AppendURLChild(
			//"导出",
			//"<c:url value="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=list&fdModelName=com.landray.kmss.sys.ftsearch.expand.model.SysFtsearchParticiple"/>"	
			//);
		</kmss:auth>
	--%>	
		
	<%-- 用户搜索分析表
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchAnalysis" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do?method=list" />"
	); 	--%>
	
		<%-- 索引初始化
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysFtsearchAnalysis" bundle="sys-ftsearch-expand" />",
		"<c:url value="/sys/ftsearch/expand/sys_ftsearch_analysis/sysFtsearchAnalysis.do?method=list" />"
	); --%>
	
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>