<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div style="width: 100%; height: 100%" class="muiAttViewerContent">
	<div class="muiAttViewerContent" data-dojo-attach-point="pageContent">
		<iframe src="about:blank" data-dojo-attach-point="pageNode"
			style="border: none"> </iframe>
	</div>
	<div class="muiAttViewerSlider"
		data-dojo-attach-point="pageSliderScale">
		<div>
			<div data-dojo-attach-point="pageBackScale" class="mui mui-back"></div>
			<input type="range"
				data-dojo-type="sys/attachment/mobile/viewer/doc/PageSlider">
		</div>
	</div>
</div>

