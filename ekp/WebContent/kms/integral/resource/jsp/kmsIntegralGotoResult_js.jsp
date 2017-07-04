<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
	var _dialog;
	seajs.use(['lui/dialog'], function(dialog) {
		_dialog = dialog;
	});
	function gotoResultView(scoreType,fdTimeUnit,yearStartTime,yearEndTime,monthStartTime,monthEndTime,operatorId,deptId){
		url = '/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=gotoResultView';
		if(null != scoreType){
			url += "&scoreType="+scoreType ;
		}
		if(null != fdTimeUnit){
			url += "&fdTimeUnit="+fdTimeUnit ;
		}
		if(null != yearStartTime){
			url += "&yearStartTime="+yearStartTime ;
		}
		if(null != yearEndTime){
			url += "&yearEndTime="+yearEndTime ;
		}
		if(null != monthStartTime){
			url += "&monthStartTime="+monthStartTime ;
		}
		if(null != monthEndTime){
 			url += "&monthEndTime="+monthEndTime ;
		}
		if(null != operatorId){
			url += "&operatorId="+operatorId ;
		}
		if(null != deptId){
			url += "&deptId="+deptId ;
		}
		seajs.use(
				[ 'lui/dialog' ],
				function(dialog) {
					dialog.iframe(
							url,
							"${lfn:message('kms-integral:kmsIntegralCommon.scoreDetail')}",
							function() {
							}, {
								"width" : 700,
								"height" : 500
							});
		});
	}

 	function checkDelete(url) {
 	 	seajs.use(['lui/dialog'],function(dialog) {
 	 		dialog.confirm("${lfn:message('kms-evaluate:kmsEvaluateCommon.confirmDeleteCount')}", function(flag) {
 	 	 		if(flag) {
 	 	 			Com_OpenWindow(url,'_self');
				}}
			);
	 	});
	}
</script>