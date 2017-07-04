<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="shortcut icon" href="${KMSS_Parameter_ContextPath}favicon.ico"> 
<script type="text/javascript" src="${KMSS_Parameter_ResPath}js/common.js?s_cache=${LUI_Cache}"></script>


	<input type=button class="btnopt"
		value="<bean:message key="button.ok"/>" onclick="ok();">
	&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="button" class="btnopt"
		value="<bean:message key="button.cancel"/>" onClick="window.close();">
		

<script>
	var params=window.opener.Com_Parameter.Dialog.data;
	var callback=window.opener.Com_Parameter.Dialog.AfterShow;
</script>
<script>
function checkOK(){
	return true;
}
function ok(){
	if(!checkOK()){
		return ;
	}
	var forms = document.forms;
	rtn = {};
	for (var i = 0, l = forms.length; i < l; i ++) {
		var elems = forms[i].elements;
		for (var j = 0, m = elems.length; j < m; j ++) {
			if(elems[j].getAttribute("storage")=='true'||elems[j].getAttribute("type")=='hidden'){
				var key=elems[j].name?elems[j].name:elems[j].id;
				if(!key){
					console.error('存在storage字段没有设置id或name');
					continue;
				}
				if(elems[j].type=='checkbox'||elems[j].type=='radio'){
					if(elems[j].checked){
						rtn[key]=elems[j].value;
						continue;
					}
				}
				else{
					rtn[key]=elems[j].value;
				}
			}
			
		}
	}
	callback(rtn);
	window.close();
}
function after_load(params){
}
function load_ini(){
	if(params){
		var forms = document.forms;
		rtn = {};
		for (var i = 0, l = forms.length; i < l; i ++) {
			var elems = forms[i].elements;
			for (var j = 0, m = elems.length; j < m; j ++) {
				if(elems[j].getAttribute("storage")=='true'||elems[j].getAttribute("type")=='hidden'){
					var key=elems[j].name?elems[j].name:elems[j].id;
					if(elems[j].type=='checkbox'){
						if(params[key]){
							elems[j].checked=true;
						}
						else{
							elems[j].checked=false;
						}
					}else if(elems[j].type=='radio'){
						var selects = document.getElementsByName(key);  
						if(params[key]){
						    for (var count=0; count<selects.length; count++){  
						        if (selects[count].value==params[key]) {  
						            selects[count].checked= true;  
						        }else{
						        	selects[count].checked= false; 
						        }  
						    } 
						}
					}else{
						elems[j].value=params[key];
					}
					
				}
			}
		}
		after_load(params);
	}
}
//加载的时初始化
$(function(){
	load_ini();
});
</script>
