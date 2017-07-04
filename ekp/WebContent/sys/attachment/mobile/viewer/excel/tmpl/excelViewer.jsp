<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div style="width: 100%; height: 100%" class="muiAttViewerContent">
	<div class="muiAttViewerContent muiAttViewerExcelContent"
		data-dojo-attach-point="pageContent">
		<iframe src="about:blank" data-dojo-attach-point="pageNode">
		</iframe>
	</div>
	<div class="muiAttViewerSlider" data-dojo-attach-point="pageSlider">
		<div>
			<div data-dojo-attach-point="pageBackScale" class="mui mui-back"
				style="font-size: 2.5rem"></div>
		</div>
	</div>
</div>

