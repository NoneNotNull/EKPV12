<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	seajs.use(['lui/jquery'], function($){
		$(function(){
			var $location = null;
			var attLocal = "${param.attentLocalId}";
			var fansLocal = "${param.fansLocalId}";
			if(attLocal != null && attLocal != ""){
				if(fansLocal != null && fansLocal != ""){
					$location = $("#${param.attentLocalId}, #${param.fansLocalId}");
				}else{
					$location = $("#${param.attentLocalId}");
				}
			}else{
				if(fansLocal != null && fansLocal != ""){
					$location = $("#${param.fansLocalId}")
				}
			}
			
			if($location != null){
				$location.click(function(event){
					$("a[data-info]").removeClass("selected");
					var type = "attention";
					if(this.id == 'sys_fans_fans_num'){
						type = "fans";
					}
					var fans_TA = $("input[name='fans_TA']").val();
					var showTabPanel = $("input[name='showTabPanel']").val();
					var attentModelName = $("input[name='attentModelName']").val();
					var fansModelName = $("input[name='fansModelName']").val();
					$("#${param.showFollowList}").attr("src", "${LUI_ContextPath}/sys/fans/sys_fans_main/sysFansMain_follow_list.jsp?"+
							"LUIID=iframe_body&fdId=${param.userId}&attentModelName="+attentModelName+"&fansModelName=" + 
							fansModelName+"&fans_TA="+fans_TA+"&type=" + type + "&showTabPanel=" + showTabPanel);
				});
			}
		});	
	});

</script>