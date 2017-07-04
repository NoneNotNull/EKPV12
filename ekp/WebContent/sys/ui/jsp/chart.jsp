<%@ page language="java" pageEncoding="UTF-8"
	contentType="application/json; charset=UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:chart-data
	text="${config.text}"
	subText="${config.subText}"
	textPosition="${config.textPosition}"
	legendOrient="${config.legendOrient}"
	legendPosition="${config.legendPosition}"
	tooltipLabel="${config.tooltipLabel}"
	xAxisData="${config.xAxisData}"
	xAxisLabel="${config.xAxisLabel}"
	xAxisName="${config.xAxisName}"
	xAxisRotate="${config.xAxisRotate}"
	xAxisShowAll="${config.xAxisShowAll}"
	yAxisLabel="${config.yAxisLabel}"
	yAxisName="${config.yAxisName}"
	y2AxisLabel="${config.y2AxisLabel}"
	y2AxisName="${config.y2AxisName}"
	reverseXY="${config.reverseXY}"
	dataZoom="${config.dataZoom}"
	zoomAlign="${config.zoomAlign}"
	zoomCount="${config.zoomCount}"
	gridMargin="${config.gridMargin}">
	<c:forEach items="${config.series}" var="item">
		<ui:chart-series
			name="${item.name}"
			type="${item.type}"
			data="${item.data}"
			forY2="${item.forY2}"
			stack="${item.stack}">
			<c:forEach items="${item.properties}" var="property">
				<ui:chart-property
					name="${property.name}"
					value="${property.value}"
					merge="${property.merge}"
					isScript="${property.isScript}">
					${property.content}
				</ui:chart-property>
			</c:forEach>
		</ui:chart-series>
	</c:forEach>
	<c:forEach items="${config.properties}" var="property">
		<ui:chart-property
			name="${property.name}"
			value="${property.value}"
			merge="${property.merge}"
			isScript="${property.isScript}">
			${property.content}
		</ui:chart-property>
	</c:forEach>
</ui:chart-data>