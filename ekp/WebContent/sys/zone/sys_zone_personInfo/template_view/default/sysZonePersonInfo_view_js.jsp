<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.zone.util.SysZoneConfigUtil"%>
<script>
/* 导航信息的链接 */
function __navLinkUrl(fdUrl, serverPath, key){
	if(fdUrl.indexOf("http://") == 0 || fdUrl.indexOf("https://") == 0){
		return fdUrl;
	}
	var currentKey  = "<%=SysZoneConfigUtil.getCurrentServerGroupKey()%>";
	if(currentKey == key || !serverPath ){
		serverPath = "${ LUI_ContextPath }";
	}
	fdUrl = serverPath + fdUrl;
	var param = "LUIID=iframe_body&userId=${sysOrgPerson.fdId}&userSex=${sysOrgPerson.fdSex}&isSelf=${isSelfNoPower}&zone_TA=${zone_TA}";
	var index = fdUrl.indexOf("?");
	if(index >= 0){
		if(index == fdUrl.length - 1){
			fdUrl += param; 
		}else{
			fdUrl += "&" + param;
		}
	}else if(index < 0){
		fdUrl += "?" + param; 
	}
	
	return fdUrl;
}



seajs.use(['lui/jquery'], function($){
	$(function(){
		$("#lui_zone_follow_box, #lui_zone_fans_box").click(function(event){
			$("a[data-info]").removeClass("selected");
			var type = "follower";
			if(this.id == 'lui_zone_follow_box'){
				type = "following";
			}
			$("#iframe_body").attr("src", "${LUI_ContextPath}/sys/zone/sys_zone_personInfo/sysZonePersonInfo_follow.jsp?LUIID=iframe_body&fdId=${sysZonePersonInfoForm.fdId}&zone_TA=${zone_TA}&type=" + type);
		});
	});	
});
</script>