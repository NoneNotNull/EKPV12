<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>

<!-- 筛选器 -->
<list:criteria id="" layout="sys.ui.criteria.default" style=""
	channel="">
	<ui:layout />

	<!-- 自动筛选项 -->
	<list:autoCriteria modelName="*" properties="*" expand="true"
		multi="true" />

	<!-- 引用筛选项，可覆盖部分子标签 -->
	<list:refCriterion id="" ref="*" title="*" property="*" expand="true"
		multi="true">
		<list:titleBox />
		<list:selectBox />
	</list:refCriterion>

	<!-- 自定义筛选项 -->
	<list:criterion id="" title="" expand="">
		<!-- 标题区域 -->
		<list:titleBox id="">
			HTML
		</list:titleBox>
		<!-- 选择区域 -->
		<list:selectBox id="">
			HTML
			<!-- 选择项 -->
			<list:select id="" source="" render="" title="*" property="*"
				multi="true" style="">
				<ui:source />
				<ui:render />
			</list:select>
		</list:selectBox>
	</list:criterion>
	
	<list:criterionPopup>
		<list:titleBox id="">
			HTML
		</list:titleBox>
		
		<list:popupBox>
			<list:select id="" source="" render="" title="*" property="*"
					multi="true" style="">
					<ui:source />
					<ui:render />
			</list:select>
		</list:popupBox>
		
		<list:popupBox>
			<list:select id="" source="" render="" title="*" property="*"
					multi="true" style="">
					<ui:source />
					<ui:render />
			</list:select>
		</list:popupBox>
	</list:criterionPopup>
</list:criteria>

<!-- 排序按钮 -->
<list:sort id="" text="*" property="*" param="orderby" channel="" />

<!-- 分页展示 -->
<list:paging id="" layout="sys.ui.paging.default" currentPage=""
	pageSize="" totalSize="" channel="" displayMargin="4"/>

<!-- 多列表视图切换 -->
<list:listview id="" style="" channel="">
	<!-- ?? -->
	<list:source url="" />
	<list:columnTable />
	<list:rowTable />
	<list:gridTable />
</list:listview>

<!-- 列模式列表界面，rowHref可以带变量：!{fdId} -->
<list:columnTable id="" name="" isDefault="false" rowHref=""
	target="_blank" onRowClick="" layout="sys.ui.columntable.default"
	style="" channel="">
	<list:source />
	<!-- checkbox列 -->
	<list:checkboxColumn id="" name="List_Selected" style="" cellStyle="" />

	<!-- 序号列 -->
	<list:serialColumn id="" title="{page.serial}" style="" cellStyle=""  />

	<!-- 调整顺序，覆盖模版 -->
	<list:column id="" title="" property="*" style="" display="true"
		onHeaderClick="" cellStyle="" />

	<!-- properties为空则所有其它列 -->
	<list:columns props="" />

	<list:htmlColumn id="" title="" style="" onHeaderClick="" cellStyle="">
		<!-- 以模板的方式定义，传递：row/env/$ -->
		row["fdId"]
	</list:htmlColumn>
</list:columnTable>

<!-- 行模式列表视图 -->
<list:rowTable id="" name="" isDefault="false" rowHref=""
	target="_blank" onRowClick="" layout="sys.ui.rowtable.default"
	style="" channel="">
	<list:source />
	<!-- 模板ref不为空，则定义属性关系 -->
	<!-- 模板ref为空，展现模板，传递row/env/$ -->
	<list:template id="" ref="">
	{
		"subject":"docSubject",
		"other":"*"
	}
	</list:template>
</list:rowTable>

<!-- 格子模式列表视图，columnNum列数，aline横向对齐 -->
<list:gridTable id="" columnNum="5" aline="true" name="" default="false"
	gridHref="" target="_blank" onGridClick=""
	layout="sys.ui.gridtable.default" style="" channel="">
	<list:source />
	<list:template />
</list:gridTable>

<!-- 数据组装 -->
<list:data>
	<list:pagingData currentPage="" pageSize="" totalSize="" />
	<list:columnDatas list="*" var="*">
		<list:columnData property="*" for="" style="" title="" escape="true"/>
			HTML
		</list:columnData>
	</list:columnDatas>
</list:data>

<!-- 最终输出为JSON或JSONP -->
{
	columns: [
		{title:'', property:'property1', width: '10%'}, 
		{title:'', property:'property2', width: '50%'}
	],
	datas: [
		[{col:'property1',value: ''}, {col:'property2', value: ''}],
		[{col:'property1', value:''}, {col:'property2', value: ''}]
	] 
}
