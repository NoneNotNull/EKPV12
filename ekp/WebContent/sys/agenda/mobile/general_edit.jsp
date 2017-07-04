<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="mainModelForm" value="${requestScope[param.formName]}" scope="request" />
<c:set var="sysAgendaMainForm" value="${mainModelForm.sysAgendaMainForm}" scope="request" />
<div id="agenda_${param.fdPrefix}_${param.fdKey}">
	<%@include file="/sys/notify/mobile/import/edit.jsp"%>
</div>
<script type="text/javascript">
	require(['dojo/ready','dojo/query','dojo/dom-style','dojo/topic'],function(ready,query,domStyle,topic){
		//初始化日程机制
		ready(function(){
			if("${param.syncTimeProperty}"!=""){
				var syncTimeProperty="${param.syncTimeProperty}";
				var noSyncTimeValues="${param.noSyncTimeValues}".split(";");
				for(var i=0;i<noSyncTimeValues.length;i++){
					var noSyncTimeValue=noSyncTimeValues[i];
					if(query("[name='"+syncTimeProperty+"']")[0].value==noSyncTimeValue){
						domStyle.set(query('#agenda_${param.fdPrefix}_${param.fdKey}')[0],'display','none');
						break;
					}
				}
				
				topic.subscribe('/mui/form/valueChanged',function(widget,args){
					if(widget.name==syncTimeProperty){
						var k=0;
						for(k=0;k<noSyncTimeValues.length;k++){
							var noSyncTimeValue=noSyncTimeValues[k];
							if(args.value==noSyncTimeValue){
								domStyle.set(query('#agenda_${param.fdPrefix}_${param.fdKey}')[0],'display','none');
								break;
							}
						}
						if(k>=noSyncTimeValues.length){
							domStyle.set(query('#agenda_${param.fdPrefix}_${param.fdKey}')[0],'display','block');
						}
						
					}
				});
				
			}
		});
	});
	
	
</script>
