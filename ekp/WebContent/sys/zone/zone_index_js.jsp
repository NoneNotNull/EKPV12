<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript">
	/* 点击标签触发 */
	function tagSearch(name,isSearch){
		seajs.use(['lui/jquery'], function($){
			$("#fdTags").val(name);
			zoneSearch();
		});
	}
	/* 按标签，名字，emal或电话找员工 */
	function zoneSearch(){
		seajs.use(['lui/jquery'], function($){	
			var searchValue = $.trim( $("#searchValue").val());
			if(searchValue=="${lfn:message('sys-zone:sysZonePerson.searchInputHelp') }"){
				$("#searchValue").val("");
			}
			Com_Submit(document.sysZonePersonInfoForm, 'toSearch');
		});
	}
	
	LUI.ready(function(){
		seajs.use(['lui/jquery'], function($){
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
	});
</script>