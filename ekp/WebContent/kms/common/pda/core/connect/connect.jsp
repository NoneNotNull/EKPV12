<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script>
	function person_opt(optType,val,telType){
	    if(checkOptTypeAndVal(val)){
	      var url = optType;
	      url += val;
		  window.open(url,"_self");
	    }
	}

	function checkOptTypeAndVal(val){
		var flag = false;
		if(val!=null && val!='' && typeof(val)!='undefined')
		    flag = true;   
		return flag;
	}
</script>

