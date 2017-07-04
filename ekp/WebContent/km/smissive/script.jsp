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
function checkBookMarks(){
			var fdFileNo = document.getElementsByName('fdFileNo')[0].value;
			if(fdFileNo.length ==0 || fdFileNo==null){
				var message = "<"+"<bean:message bundle="km-smissive" key="kmSmissiveMain.bookMarks"/>"+"("+"<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>"+")>";
				Attachment_ObjectInfo['mainOnline'].setBookmark('fdFileNo',message);
			}
	  }
	  
function switchLabelEvent(tableName, index){
	if(index == 2){
		setTimeout("addBookMarks();", 500); 
	}
}
//作用：还原特殊符号
function returnStr(str){
	// 回车、双引号、单引号
	var regEnter=new RegExp("<br>","g"), regRegQm=new RegExp("&quot","g"),RegSqm=new RegExp("&acute","g");
	return str.replace(regEnter,"\r\n").replace(regRegQm,'"').replace(RegSqm,"'"); 
}

//获得下拉列表的值
function getSelectedText(name){
	var select=document.getElementsByName(name)[0];
	return select[select.selectedIndex].innerText||select[select.selectedIndex].textContent;
}

function addBookMarks(){
	var docSubject = document.getElementsByName('docSubject')[0].value;
	if(docSubject!=null && docSubject.length !=0&& docSubject !='${kmMissiveSendMainForm.docSubject}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('docsubject',docSubject);
	}
	var docAuthorName = document.getElementsByName('docAuthorName')[0].value;
	if(docAuthorName!=null && docAuthorName.length !=0&& docAuthorName !='${kmMissiveSendMainForm.docAuthorName}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('docAuthorName',docAuthorName);
	}
	var fdUrgency = getSelectedText('fdUrgency');
	if(fdUrgency!=null && fdUrgency.length !=0&& fdUrgency !='${kmMissiveSendMainForm.fdUrgency}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdUrgency',fdUrgency);
	}
	var fdTemplateName = '${kmSmissiveMainForm.fdTemplateName }';
	if(fdTemplateName!=null && fdTemplateName.length !=0&& fdTemplateName !='${kmMissiveSendMainForm.fdTemplateName}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdTemplateName',fdTemplateName);
	}
	var docCreateTime = '${kmSmissiveMainForm.docCreateTime }';
	var docCreateTimeCn = transferDate('${kmSmissiveMainForm.docCreateTime }');
	if(docCreateTime!=null && docCreateTime.length !=0&& docCreateTime !='${kmMissiveSendMainForm.docCreateTime}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('docCreateTime',docCreateTime);
		Attachment_ObjectInfo['mainOnline'].setBookmark('docCreateTimeCn',docCreateTimeCn);
	}
	var fdSecret = getSelectedText('fdSecret');
	if(fdSecret!=null && fdSecret.length !=0&& fdSecret !='${kmMissiveSendMainForm.fdSecret}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdSecret',fdSecret);
	}
	var fdFileNo = document.getElementsByName('fdFileNo')[0].value;
	if(fdFileNo!=null && fdFileNo.length !=0&& fdFileNo !='${kmMissiveSendMainForm.fdFileNo}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdFileNo',fdFileNo);
	}
	var fdMainDeptName = document.getElementsByName('fdMainDeptName')[0].value;
	if(fdMainDeptName!=null && fdMainDeptName.length !=0&& fdMainDeptName !='${kmMissiveSendMainForm.fdMainDeptName}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdMainDeptName',fdMainDeptName);
	}
	var fdSendDeptNames = document.getElementsByName('fdSendDeptNames')[0].value;
	if(fdSendDeptNames!=null && fdSendDeptNames.length !=0&& fdSendDeptNames !='${kmMissiveSendMainForm.fdSendDeptNames}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdSendDeptNames',fdSendDeptNames);
	}
	var docPublishTime = document.getElementsByName('docPublishTime')[0].value;
	var docPublishTimeCn = transferDate(document.getElementsByName('docPublishTime')[0].value);
	if(docPublishTime!=null && docPublishTime.length !=0&& docPublishTime !='${kmMissiveSendMainForm.docPublishTime}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('docPublishTimeCn',docPublishTimeCn);
		Attachment_ObjectInfo['mainOnline'].setBookmark('docPublishTime',docPublishTime);
	}
	
	var fdCopyDeptNames = document.getElementsByName('fdCopyDeptNames')[0].value;
	if(fdCopyDeptNames!=null && fdCopyDeptNames.length !=0&& fdCopyDeptNames !='${kmMissiveSendMainForm.fdCopyDeptNames}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdCopyDeptNames',fdCopyDeptNames);
	}
	var fdIssuerName = document.getElementsByName('fdIssuerName')[0].value;
	if(fdIssuerName!=null && fdIssuerName.length !=0&& fdIssuerName !='${kmMissiveSendMainForm.fdIssuerName}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('fdIssuerName',fdIssuerName);
	}
	var docCreatorName = '${kmSmissiveMainForm.docCreatorName }';
	if(docCreatorName!=null && docCreatorName.length !=0&& docCreatorName !='${kmMissiveSendMainForm.docCreatorName}'){
		Attachment_ObjectInfo['mainOnline'].setBookmark('docCreatorName',docCreatorName);
	}
	 	 
	return true;
}
</script>