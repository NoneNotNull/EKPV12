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
<style>
	.clr {
		clear: both;
	}
</style>
</head>
<body>
	<script src="<%=request.getContextPath() %>/resource/js/common.js"></script>
	<script src="<%=request.getContextPath() %>/resource/js/calendar.js"></script>
	
	<list:criteria id="criteria1" expand="true" channel="criteria1">
	
		<list:criterion title="标题" mutil="false" expand="true" key="docSubject">
			<list:selectBox>
				<list:select type="lui/criteria/criterion_input!TextInput">
				</list:select>
			</list:selectBox>
		</list:criterion>
		
		<list:criterion title="数字" mutil="false" expand="true" key="fdNumber">
			<list:selectBox>
				<list:select type="lui/criteria/criterion_input!NumberInput">
					<ui:source type="Static">
						[
							{min: 0, max: 500},
							{min: 500, max: 1000},
							{min: 1000, max: 'MAX'},
							{min: 'MIN', max: 'MAX'}
						]
					</ui:source>
				</list:select>
			</list:selectBox>
		</list:criterion>
	
		<list:autoCriteria modelName="com.landray.kmss.sys.news.model.SysNewsMain" property="docCreateTime" />
		<list:autoCriteria modelName="com.landray.kmss.km.review.model.KmReviewMain" property="docProperties" />
		<list:autoCriteria modelName="com.landray.kmss.km.review.model.KmReviewMain" property="fdDepartment" />
		
		<list:criterion title="分类" muitl="false" expand="true" key="docCatergroy">
			<list:titleBox>
				<div style="width:80%;color:red;position: relative;float: left;" class="catergory-title">分类</div>
				<ui:popup positionObject=".catergory-title" style="background-color:#fff"> 
						 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa<br>
						 我是弹出层内容aaaaaa<br>
						 我是弹出层内容aaaaaa<br>
				</ui:popup>
			</list:titleBox>
			<list:selectBox>
			<list:select type="lui/criteria/criteria!CriterionHierarchyDatas" config-paramName="parentId:value">
				<ui:source type="AjaxJson">
					{url: "${LUI_ContextPath}/sys/ui/demo/criteria-hierarchy-data.jsp?parentId=!{parentId}"}
				</ui:source>
			</list:select>
			</list:selectBox>
		</list:criterion>
		
		<list:criterion title="辅分类" expand="true" key="docProperties2">
			<list:selectBox>
			<list:select >
				<ui:source type="Static">
					[
						{text:'辅分类1', value:'v1'},
						{text:'辅分类2', value:'v2'}
					]
				</ui:source>
				<%--
				<script type="lui/event" data-lui-event="draw">
					if (window.console)
						console.info("is me !");
				</script>
				<script type="lui/topic" data-lui-topic="criteria.changed">
					if (window.console)
						console.info("criteria.criterion.changed !!!");
				</script>
				 --%>
				<ui:event event="draw">
					if (window.console)
						console.info("is me !");
				</ui:event>
				<ui:event topic="criteria.criterion.changed">
					if (window.console)
						console.info("criteria.criterion.changed !!!");
				</ui:event>
			</list:select>
			</list:selectBox>
		</list:criterion>
		
		<list:autoCriteria modelName="com.landray.kmss.km.review.model.KmReviewMain" property="docCreator" />
		
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
		
		<list:criterion title="日期区间" mutil="false" expand="false" key="fdCreateDate">
			<list:selectBox>
				<list:select type="lui/criteria/criterion_calendar!CriterionTimeDatas">
				</list:select>
			</list:selectBox>
		</list:criterion>
		
		<list:criterionPopup>
			<list:popupBox title="多选项目" key="fdMMKey">
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
			</list:popupBox>
			<list:autoPopupBox modelName="com.landray.kmss.sys.news.model.SysNewsMain" property="docStatus" />
		</list:criterionPopup>
	</list:criteria>

<script>
seajs.use(['lui/parser'], function(parser) {
	parser.parse();
});
</script>
</body>
</html>