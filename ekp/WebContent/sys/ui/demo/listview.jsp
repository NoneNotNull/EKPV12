<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui" %>
<%
	String KMSS_Parameter_ContextPath = request.getContextPath()+"/";
	request.setAttribute("KMSS_Parameter_ContextPath", KMSS_Parameter_ContextPath);
	String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath+"resource/";
	request.setAttribute("KMSS_Parameter_ResPath", KMSS_Parameter_ResPath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>筛选器代码测试</title>


<script src="<%=request.getContextPath() %>/resource/js/sea.js"></script>
<script src="<%=request.getContextPath() %>/resource/js/seaconfig.jsp"></script>
	<script>
	var Com_Parameter = {
			ContextPath:"${KMSS_Parameter_ContextPath}",
			JsFileList:new Array,
			ResPath:"${KMSS_Parameter_ResPath}"
		};
	</script>
</head>
<body>
	<script src="<%=request.getContextPath() %>/resource/js/common.js"></script>
	<script src="<%=request.getContextPath() %>/resource/js/calendar.js"></script>
	
	<list:criteria id="criteria1" expand="true" channel="ch1">
		<list:criterion title="多选数据" mutil="false" expand="false" key="fdMutils">
			<list:selectBox>
			<list:select >
				<ui:source type="Static">
					[
						{text:'数据项1', value:'v1'},
						{text:'数据项2', value:'v2'},
						{text:'数据项3', value:'v3'},
						{text:'数据项4', value:'v4'}
					]
				</ui:source>
			</list:select>
			</list:selectBox>
		</list:criterion>
	</list:criteria>
	
	<list:listview id="lv1" channel="ch1">
		<ui:source type="Static">
			{
				columns: [
					{title:'文档', property:'property1', width: '10%'}, 
					{title:'信息', property:'property2', width: '50%'}
				],
				datas: [
					[{col:'property1',value: 'v1'}, {col:'property2', value: 'v2'}],
					[{col:'property1', value:'v3'}, {col:'property2', value: 'v4'}]
				] 
			}
		</ui:source>
		<list:columnTable></list:columnTable>
	</list:listview>

<script>
seajs.use(['lui/parser'], function(parser) {
	parser.parse();
});
</script>
</body>
</html>