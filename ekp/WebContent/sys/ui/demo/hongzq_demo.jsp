<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>筛选器代码测试</title>


<script src="<%=request.getContextPath() %>/resource/js/sea.js"></script>
<script src="<%=request.getContextPath() %>/resource/js/seaconfig.jsp"></script>

</head>
<body>
	
	<list:criteria id="criteria1" expand="true">
		
		<list:criterion title="分类" muitl="false" expand="true" key="docCatergroy">
			<list:titleBox>
				<span style="color:red">系统分类</span>
			</list:titleBox>
			<list:selectBox>
			<list:select type="lui/criteria/criteria!CriterionHierarchyDatas">
				<ui:source type="Static">
					[
						{text:'分类1', value:'v1'},
						{text:'分类2', value:'v2'}
					]
				</ui:source>
			</list:select>
			</list:selectBox>
		</list:criterion>
		
		<list:criterion title="辅分类" expand="true" key="docProperties">
			<list:selectBox>
			<list:select >
				<ui:source type="Static">
					[
						{text:'分类1', value:'v1'},
						{text:'分类2', value:'v2'}
					]
				</ui:source>
				<script type="lui/event" data-lui-event="draw">
					if (window.console)
						console.info("is me !");
				</script>
				<script type="lui/topic" data-lui-topic="criteria.criterion.changed">
					if (window.console)
						console.info("criteria.criterion.changed !!!");
				</script>
			</list:select>
			</list:selectBox>
		</list:criterion>
		
		<list:criterion title="多选数据" mutil="false" expand="false" key="fdMutils">
			<list:selectBox>
			<list:select >
				<ui:source type="Static">
					[
						{text:'分类1', value:'v1'},
						{text:'分类2', value:'v2'},
						{text:'分类3', value:'v3'},
						{text:'分类4', value:'v4'}
					]
				</ui:source>
			</list:select>
			</list:selectBox>
		</list:criterion>
	</list:criteria>

<script>
seajs.use(['lui/parser','lui/jquery','lui/LUI','theme!common','theme!icon'], function(parser,$,LUI) {
	parser.parse();

	$(document).ready(function() {
		setTimeout(function(){
			var id = "dialog_iframe";
			if(id==""){
				return;
			}
			LUI.fire({
				"type":"event",
				"name":"resize",
				"target":id,
				"data":{
					"width":$(document.body).width(),
					"height":$(document.body).height()
				}
			}, parent);
			}, 100);
		
	});
});
</script>

</body>
</html>