<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="filter" uri="/WEB-INF/KmssConfig/sys/ui/filter.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="<%=request.getContextPath()%>/resource/js/sea.js"></script>
<script src="<%=request.getContextPath()%>/resource/js/seaconfig.jsp"></script>
<title>标签测试1</title>
</head>
<body>

<filter:filter id="filter2">
	<filter:item id="docProperties2" attrsName="item" title="分类">
		<filter:render attrName="dataRender">
			{$<ul class='filter-item-data-ul'>$}
			for (var i = 0; i < source.length; i ++) {
				var d = source[i];
				{$<li>
					<a href='javascript:void(0);' 
						data-lui-filter-item-data='{%d.value%}' 
						title='{%d.text%}' >{%d.text%}-{%i%}</a>
				</li>$}
			}
			{$</ul>$}
		</filter:render>
		<filter:datasource attrName="dataSource" args="render, config">
			var datas = [];
			for (var i = 0; i < 10; i ++) {
				datas.push({text: "分类" + (i + 1), value: 'category-' + (i + 1)});
			}
			render(datas);
		</filter:datasource>
	</filter:item>
	<filter:item 
		id="docCategory1" 
		type="lui/filter/items!HierarchyItem" 
		attrsName="item" 
		title="选项" 
		paramName="categoryId">
		<filter:datasource attrName="dataSource" url="/sys/ui/jsp/data-category.jsp" />
	</filter:item>
	<filter:simpleCategory 
		id="simpleCategory" 
		title="简单分类"
		modelName="km.review.Main" 
		modelId="12345" />
</filter:filter>

<script>
seajs.use(["lui/parser"], function(parser) {
	parser.parse();
});
</script>

</body>
</html>