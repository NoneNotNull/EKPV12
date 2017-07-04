<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%="</head><body>"%>
<script type="text/javascript">
Com_IncludeFile('optbar.js|listview.js');
function List_CheckSelect(){
	var obj = document.getElementsByName("List_Selected");
	for(var i=0; i<obj.length; i++)
		if(obj[i].checked)
			return true;
	alert("<bean:message key="page.noSelect"/>");
	return false;
}
function List_ConfirmDel(){
	return List_CheckSelect() && confirm("<bean:message key="page.comfirmDelete"/>");
}
window.onload=function(){ 
	ListView.Msg = { 
			first: '<bean:message key="page.first"/>',//首页
			prev: '<bean:message key="page.prev"/>',//前页
			next: '<bean:message key="page.next"/>',//后页
			last: '<bean:message key="page.last"/>',//末页
			reload: '<bean:message key="button.refresh"/>',//刷新
			the: '<bean:message key="page.the"/>',//第
			page: '<bean:message key="page.page"/>',//页 
			total:'<bean:message key="page.total"/>',//共
			row: '<bean:message key="page.row"/>',//条
			rowPerPage: '<bean:message key="page.rowPerPage"/>',//每页
			changeTo: '<bean:message key="page.changeTo"/>',//转到
			to: '<bean:message key="page.to"/>',//到
			//rownum: '<bean:message key="page.rownum"/>',//页数
			mustBeInt: '<bean:message key="page.must_be_int"/>',//必须为整数
			imgUrl: "icons/go.gif",
			imgTitle:'<bean:message key="page.to"/>',// 转到
			loadingHint: '<bean:message key="page.loadingHint"/>',//请稍等！数据加载中...
			loadedHint: '<bean:message key="page.loadedHint"/>',//加载完成！
			loadFailure:'<bean:message key="listview.build.msg"/>'//数据加载失败！
		};
} 
</script>