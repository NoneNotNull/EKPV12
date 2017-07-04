<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
	<%--
	/*******************************************************************************
	 * 功能：空操作JS
	  使用：
	  作者：罗荣飞
	 创建时间：2012-06-06
	 ******************************************************************************/
	--%>
	( function(operations) {
		operations['empty_operation'] = {
			click:function() {},
			check:function() {return false;},
			setOperationParam:function() {}
		};

	})(lbpm.operations);
</script>
