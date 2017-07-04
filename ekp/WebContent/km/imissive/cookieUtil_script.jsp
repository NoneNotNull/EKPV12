<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
function getValueFromCookie(key){
	var strCookie=document.cookie; 
	console.log(strCookie);
	var arrCookie=strCookie.split("; ");
	var value; 
	for(var i=0;i<arrCookie.length;i++){ 
	  var arr=arrCookie[i].split("=");
		if(key==arr[0]){
		   value=arr[1];
		   break;
	  } 
   }
 return value;
}
function delCookie(){
    var exp = new Date(); 
    exp.setTime(exp.getTime()-1);
    var strCookie=document.cookie; 
	var arrCookie=strCookie.split(";"); 
    for(var i=0;i<arrCookie.length;i++){ 
  	  var arr=arrCookie[i].split("="); 
  	  var cval=getValueFromCookie(arr[0]); 
      if(cval!=null)
       document.cookie= (arr[0] + "="+cval+";expires="+exp.toGMTString()); 
   }
}  
function delCookieByName(name){
    var exp = new Date(); 
    exp.setTime(exp.getTime()-1);
	var cval=getValueFromCookie(name); 
    if(cval!=null)
       document.cookie= (name + "="+cval+";expires="+exp.toGMTString()); 
}
</script>
