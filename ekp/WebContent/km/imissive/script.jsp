<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
//将阿拉伯数字翻译成中文的大写数字
function Chinese(num){   
	if(!/^\d*(\.\d*)?$/.test(num)){alert("Number   is   wrong!");   return   false;}   
	var   AA   =   new   Array("零","一","二","三","四","五","六","七","八","九");   
	var   BB   =   new   Array("","十","百","千","万","亿","点","");   
	var   a   =   (""+   num).replace(/(^0*)/g,   "").split("."),   k   =   0,   re   =   "";   
	for(var   i=a[0].length-1;   i>=0;   i--){   
	    switch(k){   
	            case   0   :   re   =   BB[7]   +   re;   break;   
	            case   4   :   if(!new   RegExp("0{4}\\d{"+   (a[0].length-i-1)   +"}$").test(a[0]))   
	                              re   =   BB[4]   +   re;   break;   
	            case   8   :   re   =   BB[5]   +   re;   BB[7]   =   BB[5];   k   =   0;   break;   
	    }   
	    //if(k%4   ==   2   &&   a[0].charAt(i)=="0"   &&   a[0].charAt(i+2)   !=   "0")   re   =   AA[0]   +   re;   
	    if(a[0].charAt(i)   !=   0)   re   =   AA[a[0].charAt(i)]   +   BB[k%4]   +   re;   k++;   
	}   
	if(a.length>1){   
	        re   +=   BB[6];   
	        for(var   i=0;   i<a[1].length;   i++)   re   +=   AA[a[1].charAt(i)];   
	}   
	return   re;   
}     
function transferYearToChinese(num){
	var numArray = num.split("");
	var newnum = "";
	var AA = new Array("〇","一","二","三","四","五","六","七","八","九");  
	for(var i=0; i<=numArray.length-1;i++){
		switch(numArray[i]){
			case '0' : newnum = newnum+AA[0]; break;
			case '1' : newnum = newnum+AA[1]; break;
			case '2' : newnum = newnum+AA[2]; break;
			case '3' : newnum = newnum+AA[3]; break;
			case '4' : newnum = newnum+AA[4]; break;
			case '5' : newnum = newnum+AA[5]; break;
			case '6' : newnum = newnum+AA[6]; break;
			case '7' : newnum = newnum+AA[7]; break;
			case '8' : newnum = newnum+AA[8]; break;
			case '9' : newnum = newnum+AA[9]; break;
		}
	}
	return newnum;
}
function transferNumToChinese(num){
	var newnum = "";
	var AA = new Array("〇","一","二","三","四","五","六","七","八","九");  
	switch(num){
		case '0' : break;
		case '1' : newnum = newnum+AA[1]; break;
		case '2' : newnum = newnum+AA[2]; break;
		case '3' : newnum = newnum+AA[3]; break;
		case '4' : newnum = newnum+AA[4]; break;
		case '5' : newnum = newnum+AA[5]; break;
		case '6' : newnum = newnum+AA[6]; break;
		case '7' : newnum = newnum+AA[7]; break;
		case '8' : newnum = newnum+AA[8]; break;
		case '9' : newnum = newnum+AA[9]; break;
	}
	return newnum;
}
function transferDate(date){
	if(date!=null && date!=''){
		var dateArray = date.split("");  
		var first = 0;
		var newdate = "";
		for(var i=0; i<=dateArray.length-1;i++){
			if(dateArray[i]=="-"){
				first = first+1;
				if(first==1){
					newdate = newdate+"年";
				}
				if(first==2){
					newdate = newdate+"月";
				}
			}else if(i<4){
				newdate = newdate+transferYearToChinese(dateArray[i]);
			}else if(i==5 && dateArray[5] == "1"){
				newdate = newdate + "十";
			}else if(i==6){ 
				newdate = newdate+transferNumToChinese(dateArray[6]);
			}else if(i==8){
				if(dateArray[8] == "1"){
					newdate = newdate + "十";
				}
				if(dateArray[8] == "2"){
					newdate = newdate + "二十";
				}
				if(dateArray[8] == "3"){
					newdate = newdate + "三十";
				}
			}else if (i==dateArray.length-1){
				newdate = newdate+transferNumToChinese(dateArray[9])+"日";
			}
		}
		return newdate;
	}
	return '';
}
function transferDateToChinese(date){
	if(date!=null && date!=''){
		var dateArray = date.split("");  
		var first = 0;
		var newdate = "";
		for(var i=0; i<=dateArray.length-1;i++){
			if(dateArray[i]=="-"){
				first = first+1;
				if(first==1){
					newdate = newdate+"年";
				}
				if(first==2){
					newdate = newdate+"月";
				}
			}else if(i<dateArray.length){
				if(dateArray[i]!="0" && i==5){
					newdate = newdate+dateArray[i];
				}else if(dateArray[i]!="0" && i==8){
					newdate = newdate+dateArray[i];
				}else if(i!=5 && i!=8){
					newdate = newdate+dateArray[i];
				}
			}
		}
		newdate = newdate+"日";
		return newdate;
	}
	return '';
}
</script>