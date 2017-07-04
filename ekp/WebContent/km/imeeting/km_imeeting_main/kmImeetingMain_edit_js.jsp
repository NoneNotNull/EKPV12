<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
	var validation=$KMSSValidation();//校验框架
</script>
<script>
	seajs.use([
	      'km/imeeting/resource/js/dateUtil',
	      'km/imeeting/resource/js/arrayUtil',
	      'lui/jquery',
	      'lui/dialog',
	      'lui/topic'
	        ],function(dateUtil,arrayUtil,$,dialog,topic){

		//var ___placeId=$('[name="fdPlaceId"]').val();//记录最初的会议地点，如果提交时的地点跟此地点一样则不做冲突检测

		//是否显示纪要催办天数
		var fdIsHurrySummary=$('[name="fdIsHurrySummary"]');
		if(fdIsHurrySummary.prop('checked')==true){
			$('#HurryDayDiv').show();
		}
		
		//校验召开时间不能晚于结束时间
		var _compareTime=function(){
			var fdHoldDate=$('[name="fdHoldDate"]');
			var fdFinishedDate=$('[name="fdFinishDate"]');
			var result=true;
			if( fdHoldDate.val() && fdFinishedDate.val() ){
				var start=dateUtil.parseDate(fdHoldDate.val());
				var end=dateUtil.parseDate(fdFinishedDate.val());
				if( start.getTime()>=end.getTime() ){
					result=false;
				}
			}
			return result;
		};
		
		//自定义校验器:校验召开时间不能晚于结束时间
		validation.addValidator('compareTime','${lfn:message("km-imeeting:kmImeetingMain.fdDate.tip")}',function(v, e, o){
			 var fdHoldDate=document.getElementsByName('fdHoldDate')[0];
			 var result=true;
			 if(e.name=="fdFinishDate"){//fdFinishDate的这个校验与fdHoldDate的相同，直接执行fdHoldDate的
				 validation.validateElement(fdHoldDate);
			 }else{
				 result= _compareTime();
			 }
			return result;
		});

		//校验与会人员和外部与会人员不全为空
		var _validatePerson=function(){
			var attendPerson=$('[name="fdAttendPersonIds"]').val();//与会人员
			var otherAttendPerson=$('[name="fdOtherAttendPerson"]').val();//外部与会人员
			if( attendPerson || otherAttendPerson){
				return true;
			}else{
				return false;
			}
		};
		

		//自定义校验器:参加人员和外部参加人员不能全为空
		validation.addValidator('validateattend','${lfn:message("km-imeeting:kmImeetingMain.attend.notNull.tip")}',function(v, e, o){
			var attendPerson=$('[name="fdAttendPersonNames"]')[0];//参加人员
			var otherAttendPerson=$('[name="fdOtherAttendPerson"]')[0];//外部参加人员
			 var result= _validatePerson();
			 if(result==false){
				KMSSValidation_HideWarnHint(attendPerson);
				KMSSValidation_HideWarnHint(otherAttendPerson);
			}
			return result;
		});
		
		
		//校验地点和外部地点不能全为空 
		var _validatePlace=function(){
			var fdPlaceId=$('[name="fdPlaceId"]').val();//地点
			var fdOtherPlace=$('[name="fdOtherPlace"]').val();//外部地点
			if( fdPlaceId || fdOtherPlace){
				return true;
			}else{
				return false;
			}
		};

		//自定义校验器:会议地点不能全为空
		validation.addValidator("validateplace","${lfn:message('km-imeeting:kmImeetingMain.place.notNull.tip')}",function(v, e, o) {
			 var fdPlaceName=document.getElementsByName('fdPlaceName')[0];
			 var result=true;
			 if(e.name=="fdOtherPlace"){//fdOtherPlace的这个校验与fdPlaceName的相同，直接执行fdPlaceName的
				 validation.validateElement(fdPlaceName);
			 }else{
				 result= _validatePlace();
			 }
			return result;
		});


		//自定义校验器:若催办纪要，填写纪要参与人
		validation.addValidator("validateSummaryInputPerson","若催办纪要，请选择纪要录入人",function(v, e, o) {
			var fdIsHurrySummary=$('[name="fdIsHurrySummary"]');
			var fdSummaryInputPersonId=$('[name="fdSummaryInputPersonId"]');
			if( fdIsHurrySummary.prop('checked')==true && !fdSummaryInputPersonId.val() ){
				return false;
			}
			return true;
		});

		//自定义校验器:若催办纪要,既要完成时间不能为空
		validation.addValidator("validateSummaryCompleteTime","纪要完成时间不能为空",function(v, e, o) {
			var fdIsHurrySummary=$('[name="fdIsHurrySummary"]');
			var fdSummaryCompleteTime=$('[name="fdSummaryCompleteTime"]');
			if( fdIsHurrySummary.prop('checked')==true && !fdSummaryCompleteTime.val() ){
				return false;
			}
			return true;
		});
		
		//自定义校验器:若催办纪要,纪要完成时间不能早于会议召开时间
		validation.addValidator("validateWithHoldDate","纪要完成时间不能早于会议召开时间",function(v, e, o) {
			var fdHoldDate=$('[name="fdHoldDate"]');
			if(fdHoldDate.val() && v){
				var holdDate=dateUtil.parseDate(fdHoldDate.val());
				var summaryDate=dateUtil.parseDate(v);
				if( holdDate.getTime()>=summaryDate.getTime() ){
					return false;
				}
			}
			return true;
		});
    	
		//计算会议历时时间,返回数组,依次为:总时差、小时时差、分钟时差、……
		var _caculateDuration=function(start,end){
			if( start && end ){
				start=dateUtil.parseDate(start);
				end=dateUtil.parseDate(end);
				if(start.getTime()<end.getTime()){
					var total=end.getTime()-start.getTime();
					var hour=parseInt((end.getTime()-start.getTime() )/(1000*60*60));
					var minute=parseInt((end.getTime()-start.getTime() )%(1000*60*60)/(1000*60));
					return [total,hour,minute];
				}else{
					return [0.0,0,0];
				}
			}
		};

		//修改时间触发
		var changeDateTime=function(){
			var fdHoldDate=$('[name="fdHoldDate"]').val();//召开时间
			var fdFinishDate=$('[name="fdFinishDate"]').val();//结束时间
			//选择了开始时间后，结束时间默认带出
			if( fdHoldDate && !fdFinishDate ){
				$('[name="fdFinishDate"]').val(fdHoldDate);
				fdFinishDate=fdHoldDate;
			}
			if(fdHoldDate && fdFinishDate){
				 
				//如果结束日期早于召开日期，自动调整结束日期为开始日期
				if(dateUtil.parseDate(fdHoldDate).getTime()>dateUtil.parseDate(fdFinishDate).getTime()){
					$('[name="fdFinishDate"]').val(fdHoldDate);
				}
				
				var duration=_caculateDuration(fdHoldDate,fdFinishDate);
				//设置会议历时
				$('[name="fdHoldDuration"]').val(duration[0]);
				$('[name="fdHoldDurationHour"]').val(duration[1]);
				$('[name="fdHoldDurationMin"]').val(duration[2]);
				//设置临时值
				$('[name="fdHoldDateTmp"]').val(fdHoldDate);
				$('[name="fdFinishDateTmp"]').val(fdFinishDate);
			}
		};

		//修改会议历时时触发
		var changeDuration=function(){
			var fdHoldDurationHour=$('[name="fdHoldDurationHour"]').val();
			var fdHoldDurationMin=	$('[name="fdHoldDurationMin"]').val();
			var totalHour=dateUtil.mergeTime({"hour":fdHoldDurationHour, "minute":fdHoldDurationMin},"ms" );
			$('[name="fdHoldDuration"]').val(totalHour);
		};
		
		//初始化会议历时
		if('${kmImeetingMainForm.fdHoldDuration}'){
			//将小时分解成时分
			var timeObj=dateUtil.splitTime({"ms":"${kmImeetingMainForm.fdHoldDuration}"});
			$('[name="fdHoldDurationHour"]').val(timeObj.hour);
			$('[name="fdHoldDurationMin"]').val(timeObj.minute);
		}

		//AJAX,到后台计算出与会人数
		var caculateAttendNum=function(){
			//debugger;
			var fdHostId=$('[name="fdHostId"]').val() || "";//主持人
			var fdAttendPersonIds=$('[name="fdAttendPersonIds"]').val() || "",
				fdAttendPersonArray=fdAttendPersonIds?fdAttendPersonIds.split(';'):[];//参与人员
			var fdParticipantPersonIds=$('[name="fdParticipantPersonIds"]').val() || "",
				fdParticipantPersonArray=fdParticipantPersonIds?fdParticipantPersonIds.split(';'):[];//列席人员
			var fdSummaryInputPersonId=$('[name="fdSummaryInputPersonId"]').val() || "";//会议纪要人

			var personArray=[];
			personArray=personArray.concat(fdAttendPersonArray);
			personArray=personArray.concat(fdParticipantPersonArray);
			if(fdHostId){
				personArray.push(fdHostId);
			}
			if(fdSummaryInputPersonId){
				personArray.push(fdSummaryInputPersonId);
			}
			
			var personIds=personArray.join(';');
			$.ajax({
				url: "${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=caculateAttendNumber",
				type: 'POST',
				dataType: 'json',
				data: {personIds: personIds},
				success: function(data, textStatus, xhr) {//操作成功
					if(data && !isNaN(data['number'])){
						$('[name="fdAttendNum"]').val(data['number']);//预计与会人数
					}
				}
			});
		};
		
		//初始化
		caculateAttendNum();

		//选择会议室
		var selectHoldPlace=function(){
			var fdHoldDate=$('[name="fdHoldDate"]').val();//召开时间
			var fdFinishDate=$('[name="fdFinishDate"]').val();//结束时间
			var resId=$('[name="fdPlaceId"]').val();//地点ID
			var resName=$('[name="fdPlaceName"]').val();//地点Name
			var url="/km/imeeting/km_imeeting_res/kmImeetingRes_showResDialog.jsp?fdHoldDate="+fdHoldDate+"&fdFinishDate="+fdFinishDate+"&resId="+resId+"&resName="+resName;
			dialog.iframe(url,'会议室选择',function(arg){
				if(arg){
					$('[name="fdPlaceId"]').val(arg.resId);
					$('[name="fdPlaceName"]').val(arg.resName);
					//修改日期，重新计算会议历时
					if(arg.fdFinishDate && arg.fdHoldDate){
						$('[name="fdHoldDate"]').val(arg.fdHoldDate);
						$('[name="fdFinishDate"]').val(arg.fdFinishDate);
						changeDateTime();
					}
				}
				validation.validateElement( $('[name="fdPlaceName"]')[0] );
			},{width:800,height:520});
		};

		//显示、隐藏纪要催办天数
		var showHurryDayDiv=function(){
			var fdIsHurrySummary=$('[name="fdIsHurrySummary"]');
			if(fdIsHurrySummary.prop('checked')==true){
				$('#HurryDayDiv').show();
			}else{
				$('#HurryDayDiv').hide();
			}
		};

		//提交
		window.commitMethod=function(commitType, saveDraft,isChange){
			//暂存不需要校验#9721
			if (saveDraft == "true") {
				_removeRequireValidate();
				$('[name="docStatus"]').val('10');
				var formObj = document.kmImeetingMainForm;
				if ('save' == commitType) {
					Com_Submit(formObj, commitType, 'fdId');
				} else {
					Com_Submit(formObj, commitType);
				}
				return ;
			}
			validation.resetElementsValidate(document.kmImeetingMainForm);
			//校验
			if(validation.validate()==false){
				return;
			}
			//校验时间
			if( !_compareTime() ){
				dialog.alert("${lfn:message('km-imeeting:kmImeetingMain.endDate.than.holdDate.tip')}");
				return;
			}
			//校验参加人员
			if( !_validatePerson() ){
				dialog.alert("${lfn:message('km-imeeting:kmImeetingMain.attend.notNull.tip')}");
				return;
			}
			//校验地点
			if( !_validatePlace() ){
				dialog.alert("${lfn:message('km-imeeting:kmImeetingMain.place.notNull.tip')}");
				return;
			}
			//资源冲突检测
			$.ajax({
				url: "${LUI_ContextPath}/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=checkConflict",
				type: 'POST',
				dataType: 'json',
				data: {meetingId : $('[name="fdId"]').val() , fdPlaceId: $('[name="fdPlaceId"]').val(), "fdHoldDate":$('[name="fdHoldDate"]').val() , "fdFinishDate":$('[name="fdFinishDate"]').val() },
				success: function(data, textStatus, xhr) {//操作成功
					if(data && !data.result ){
						//不冲突
						if (saveDraft == "true") {
							$('[name="docStatus"]').val('10');
						}else{
							$('[name="docStatus"]').val('20');
						}
						var formObj = document.kmImeetingMainForm;
						if('true'==isChange){//会议变更
							Change_Submit(formObj,commitType);
						}else if ('save' == commitType) {
							Com_Submit(formObj, commitType, 'fdId');
						} else {
							Com_Submit(formObj, commitType);
						}
					}else{
						//冲突
						dialog.alert("${lfn:message('km-imeeting:kmImeetingMain.conflict.tip')}".replace('%Place%',$('[name="fdPlaceName"]').val()));
					}
				}
			});
		};
		
		//变更提交
		var Change_Submit=function(formObj, commitType){
			//变更前内容
			var beforeContent=LUI.toJSON($('[name="beforeChangeContent"]').val());
			var beforePersons=[],afterPersons=[],
				totalPersons={};//totalPersons存储id:name
			//变更前的人员
			var beforeIds=convertToArray(beforeContent['fdHostId'],beforeContent['fdAttendPersonIds'],beforeContent['fdParticipantPersonIds']),
				beforeNames=convertToArray(beforeContent['fdHostName'],beforeContent['fdAttendPersonNames'],beforeContent['fdParticipantPersonNames']);
			for(var i=0;i<beforeIds.length;i++){
				beforePersons.push(beforeIds[i]);
				totalPersons[beforeIds[i]]=beforeNames[i];
			}
			
			//变更后的人员
			var afterIds=convertToArray($('[name="fdHostId"]').val(),$('[name="fdAttendPersonIds"]').val(),$('[name="fdParticipantPersonIds"]').val()),
				afterNames=convertToArray($('[name="fdHostName"]').val(),$('[name="fdAttendPersonNames"]').val(),$('[name="fdParticipantPersonNames"]').val());
			for(var i=0;i<afterIds.length;i++){
				afterPersons.push(afterIds[i]);
				totalPersons[afterIds[i]]=afterNames[i];
			}
			var newPersons=arrayUtil.minus(afterPersons,beforePersons);//新增人员
			var  staticPersons=arrayUtil.intersect(beforePersons,afterPersons);
			var  deletePersons=arrayUtil.minus(beforePersons,afterPersons);//剔除人员

			var str="",names="",index=1;
			
			//新增人员收到的待办
			if( newPersons.length>0 ){
				for(var i=0 ;i< newPersons.length;i++){
					names+=totalPersons[newPersons[i]]+";";
				}
				names=names.substring(0,names.length-1);
				str+=index+"、"+names+"将收到如下通知，"+"${lfn:message('km-imeeting:kmImeetingMain.attend.notify.place.subject')}"
						.replace('%km-imeeting:kmImeetingMain.fdName%',$('[name="fdName"]').val())
						.replace('%km-imeeting:kmImeetingMain.fdDate%',$('[name="fdHoldDate"]').val())
						.replace('%km-imeeting:kmImeetingMain.fdPlace%',$('[name="fdPlaceName"]').val())	+"<br/><br/>";
				index++;
				names="";
			}
			
			// 获取变更类型："all":变更了时间和地点 、"date":变更了时间、"place":变更了地点、"none":时间和地点均未变更
			var changeType=getChangeType();
			for(var i=0 ;i< staticPersons.length;i++){
				names+=totalPersons[staticPersons[i]]+";";
			}
			names=names.substring(0,names.length-1);
			//给以下人员发送通知：……………………………………，敬请注意
			if(changeType=="all"){
				str+=index+"、"+names+"将收到如下通知，"+"${lfn:message('km-imeeting:kmImeetingMain.change.holdDateAndFdPlace.notify.subject')}"
				.replace('%km-imeeting:kmImeetingMain.fdName%',$('[name="fdName"]').val())
				.replace('%km-imeeting:kmImeetingMain.fdDate%',$('[name="fdHoldDate"]').val())
				.replace('%km-imeeting:kmImeetingMain.fdPlace%',$('[name="fdPlaceName"]').val())+"<br/><br/>";
				index++;
			}
			
			if(changeType=="date"){
				str+=index+"、"+names+"将收到如下通知，"+"${lfn:message('km-imeeting:kmImeetingMain.change.holdDate.notify.subject')}"
				.replace('%km-imeeting:kmImeetingMain.fdName%',$('[name="fdName"]').val())
				.replace('%km-imeeting:kmImeetingMain.fdDate%',$('[name="fdHoldDate"]').val())+"<br/><br/>";
				index++;
			}
			
			if(changeType=="place"){
				str+=index+"、"+names+"将收到如下通知，"+"${lfn:message('km-imeeting:kmImeetingMain.change.fdPlace.notify.subject')}"
				.replace('%km-imeeting:kmImeetingMain.fdName%',$('[name="fdName"]').val())
				.replace('%km-imeeting:kmImeetingMain.fdPlace%',$('[name="fdPlaceName"]').val()) +"<br/><br/>";
				index++;
			}
			names="";
			
			//给以下人员发送通知：邀请您参加会议：%km-imeeting:kmImeetingMain.fdName%，召开时间：%km-imeeting:kmImeetingMain.fdDate%
			if( (changeType == "none" && staticPersons.length>0)  ){
				for(var i=0 ;i< staticPersons.length;i++){
					names+=totalPersons[staticPersons[i]]+";";
				}
				names=names.substring(0,names.length-1);
				str+=index+"、"+names+"将收到如下通知，"+"${lfn:message('km-imeeting:kmImeetingMain.change.notify.place.subject')}"
						.replace('%km-imeeting:kmImeetingMain.fdName%',$('[name="fdName"]').val())
						.replace('%km-imeeting:kmImeetingMain.fdDate%',$('[name="fdHoldDate"]').val())
						.replace('%km-imeeting:kmImeetingMain.fdPlace%',$('[name="fdPlaceName"]').val())	+"<br/><br/>";
				index++;
				names="";
			}
			
			//剔除人员....给以下人员发送通知：原定于%km-imeeting:kmImeetingMain.fdDate%举行的会议%km-imeeting:kmImeetingMain.fdName%已不需要参加，敬请注意
			if(deletePersons.length>0){
				for(var i=0 ;i< deletePersons.length;i++){
					names+=totalPersons[deletePersons[i]]+";";
				}
				names=names.substring(0,names.length-1);
				str+=index+"、"+names+"将收到如下通知，"+"${lfn:message('km-imeeting:kmImeetingMain.change.delete.notify.place.subject')}"
					.replace('%km-imeeting:kmImeetingMain.fdName%',$('[name="fdName"]').val())
					.replace('%km-imeeting:kmImeetingMain.fdDate%',$('[name="fdHoldDate"]').val())
					.replace('%km-imeeting:kmImeetingMain.fdPlace%',$('[name="fdPlaceName"]').val())+"<br/><br/>";
				index++;
				names="";
			}
			
			if(str){
				dialog.confirm('<p style="text-align:left;">'+str+'</p>',function(value){
					if(value==true){
						Com_Submit(formObj, commitType);
					}
				});
			}else{
				Com_Submit(formObj, commitType);
			}
		};
		
		//移除必填校验
		function _removeRequireValidate(){
			$('.validation-advice,.lui_validate').hide();//隐藏提示信息(后期修改校验框架，在removeElements时增加移除对应提示信息)
			var formObj = document.kmImeetingMainForm;
			validation.removeElements(formObj,'required');//不校验单字段必填
			validation.removeElements(formObj,'validateattend');//不校验参加人员不全为空
			validation.removeElements(formObj,'validateplace');//不校验地点不全为空
			validation.removeElements(formObj,'min(1)');//不校验地点不全为空
			validation.addElements($('[name="fdName"]')[0],'required');//标题还是要必填
		}
		
		//转换成数组
		function convertToArray(){
			var slice=Array.prototype.slice,
				args=slice.call(arguments,0),
				arr=[];
			for(var i=0;i<args.length;i++){
				if(args[i]){
					var ids=args[i].split(';');
					for(var j=0;j<ids.length;j++){
						if(ids[j])
							arr.push(ids[j]);
					}
				}
			}
			return arr;
		}
		
		//时间或者地点改变
		function getChangeType(){
			var type="none";
			var beforeContent=LUI.toJSON($('[name="beforeChangeContent"]').val());
			
			if(beforeContent.fdHoldDate != $('[name="fdHoldDate"]').val() ){
				type="date";
			}
			
			if(beforeContent.fdPlaceId != $('[name="fdPlaceId"]').val()){
				if(type=="date"){
					type="all";
				}else{
					type="place";
				}
			}
			return type;
		}
		
		//检查潜在与会者的忙闲状态
		window.checkFree=function(){
			var attendIds=convertToArray($('[name="fdHostId"]').val(),$('[name="fdAttendPersonIds"]').val(),$('[name="fdParticipantPersonIds"]').val());
			var fdHoldDate=$('[name="fdHoldDate"]').val(),
				fdFinishDate=$('[name="fdFinishDate"]').val();
			if(!fdHoldDate || !fdFinishDate){
				dialog.alert('${lfn:message("km-imeeting:kmImeetingMain.checkFree.tip.dateNotNull")}');
			}
			//检查潜在与会者的忙闲状态
			$.ajax({
				url: "${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=checkFree",
				type: 'POST',
				dataType: 'json',
				data:{
					fdId:$('[name="fdId"]').val(),
					attendIds:attendIds.join(';'),
					fdHoldDate:fdHoldDate,
					fdFinishDate:fdFinishDate
				},
				success: function(data, textStatus, xhr) {
					if(data && data.type){
						//系统检测到参与人数已超出100人，不进行冲突检测
						if(data.type=='01'){
							dialog.alert('${lfn:message("km-imeeting:kmImeetingMain.checkFree.tip.morePerson")}');
						}
						if(data.type=='02'){
							dialog.alert('${lfn:message("km-imeeting:kmImeetingMain.checkFree.tip.noConflict")}');
						}
						if(data.type=='03'){
							var names=data.array.join('、');
							dialog.alert('${lfn:message("km-imeeting:kmImeetingMain.checkFree.tip.conflict")}'.replace('{0}',names));
						}
					}
				}
			});
		};
		

		window.changeDateTime=changeDateTime;//计算会议历时
		window.caculateAttendNum=caculateAttendNum;//计算预计与会人员
		window.selectHoldPlace=selectHoldPlace;//选择会议室
		window.showHurryDayDiv=showHurryDayDiv;//显示、隐藏纪要催办天数
		window.changeDuration=changeDuration;//修改会议历时
		
	});
</script>