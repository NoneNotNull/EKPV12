<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript">
/* 点击标签触发 */
function tagSearch(tagName,isSearch){
	var tags=$("#fdTags").val();
	var tagIsSelect=false;
	if(tags){
		var tagsArray= tags.split(" "); 
		 for(var i=0;i<tagsArray.length;i++){
			var getTagName=tagsArray[i];
			if(tagName==getTagName){
				tagIsSelect=true;
				return;
			}
		 }
	}
	if(!tagIsSelect){
		$("#staffYpage_searchConditon").attr("style","");
		var html="<li  name='searchTag'>";
		html+="<input type='hidden' value="+tagName+" id='tagName' />";
		html+=tagName+"<i class='btn_close' onclick='deleteSelectTag(this)'></i>";
		html+="</li>";
		$("#searchTagsDiv").append(html); 
		getTagsNames();
		if(isSearch){
			zoneSearch();
		}
	}
}

/* 删除已选标签 */
function deleteSelectTag(e){
	$(e).parent().remove();
	getTagsNames();
		zoneSearch();
}

/* 按标签，名字，emal或电话找员工 */
function zoneSearch(){
	var searchValue =$.trim( $("#searchValue").val());
	if(searchValue=="${lfn:message('sys-zone:sysZonePerson.searchInputHelp') }"){
		$("#searchValue").val("");
	}
		Com_Submit(document.sysZonePersonInfoForm, 'toSearch');
}
/* 把选择的标签Name拼成Names */
function getTagsNames(){
	var tags="";
	$("li[name='searchTag']").each(function(){
		var name=$(this).children("#tagName").val();
		tags+=name+" ";
	});
	tags=$.trim(tags);
	$("#fdTags").val(tags);
}

LUI.ready(function(){
	if('${fdTags}'){
		var fdTags = "${fdTags}".split(" "); 
		 for(var i=0;i<fdTags.length;i++){
			tagSearch(fdTags[i],false);
		 }
	}
	if("${searchValue}"){
		$("#searchValue").val("${searchValue}");
	}else{
		$("#searchValue").val("${lfn:message('sys-zone:sysZonePerson.searchInputHelp') }");
	}
	$("#searchValue").blur(function(){
		var searchValue = $("#searchValue").val();
		searchValue=$.trim(searchValue);
		if(searchValue==""){
			searchValue="${lfn:message('sys-zone:sysZonePerson.searchInputHelp') }";
			 $("#searchValue").val(searchValue);
		}
	});
	$("#searchValue").focus(function(){
		var searchValue = $("#searchValue").val();
		searchValue=$.trim(searchValue);
		if(searchValue=="${lfn:message('sys-zone:sysZonePerson.searchInputHelp') }"){
			searchValue="";
			 $("#searchValue").val(searchValue);
		}
	});
	$('#searchValue').bind('keypress',function(event){
        if(event.keyCode == 13)    
        {
 	    	   zoneSearch();  
        }
    });	
});

// 加载关注、取消关注的js
seajs.use(['lui/jquery', 'sys/zone/resource/zone_follow'], function($, follow) {
	$(document).ready(follow.ready);
});
function __followAfter(data, fdToElementId, caredType, element){
	seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog){
		if(data !=null && data.success==true){
			if(data.message == ""){
				if(caredType == "cancelCared"){
					dialog.success("${lfn:message('sys-zone:sysZonePerson.cancelCaredSuccess')}");
					$(element).attr("onclick", "zoneCared('"+fdToElementId+"','cared',this, '__followAfter')");
					$(element).attr("title", "${lfn:message('sys-zone:sysZonePerson.cared') }");
					$(element).attr("class","");
					$(element).html("  <span > <span class='lui_zone_btn_focus2'>+ ${lfn:message('sys-zone:sysZonePerson.cared') }</span></span>");
				}else{
					dialog.success("${lfn:message('sys-zone:sysZonePerson.caredSuccess') }");
					$(element).attr("onclick","zoneCared('"+fdToElementId+"','cancelCared',this, '__followAfter')");
					$(element).attr("title", "${lfn:message('sys-zone:sysZonePerson.cancelCared') }");
					$(element).attr("class","");
					$(element).html("  <span > <span class='lui_zone_btn_focused2'>- ${lfn:message('sys-zone:sysZonePerson.cancelCared') }</span></span>");
				}
			}else{
				dialog.confirm(data.message, function (value){
					if(value == true){
						window.location.reload();
					} 
				}, null, null); 
			}
			
		}else{
			if(caredType == "cancelCared"){
				dialog.failure("${lfn:message('sys-zone:sysZonePerson.cancelCaredFailure') }");
			}else{
				dialog.failure("${lfn:message('sys-zone:sysZonePerson.caredFailure') }");
			}
		}
	});
}
</script>