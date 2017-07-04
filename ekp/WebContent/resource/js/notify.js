/*压缩类型：标准*/

Com_RegisterFile("notify.js");
Com_IncludeFile("dialog.js");

Notify_CurrentObject = new Array();
Notify_KeyList = new Array();
Notify_SubjectRequired = new Object();
Notify_NewsCateRequired = new Object();

function Notify_InsertReplaceText(obj, key){
	Com_EventPreventDefault();
	if(Notify_CurrentObject[key]!=null){
		try{
			Notify_CurrentObject[key].focus();
			Notify_CurrentObject[key].document.selection.createRange().text = obj.innerHTML;
		}catch(e){alert(e);}
	}
}

function Notify_CheckInput(){
	for(var i=0; i<Notify_KeyList.length; i++){
		var notifyType = document.getElementsByName("notifySettingForms."+Notify_KeyList[i]+".fdNotifyType")[0].value;
		if(notifyType=="")
			continue;
		var fieldValue = document.getElementsByName("notifySettingForms."+Notify_KeyList[i]+".fdSubject")[0].value;
		if(fieldValue==""){
			alert(Notify_SubjectRequired[Notify_KeyList[i]]);
			return false;
		}
		if(Com_ArrayGetIndex(notifyType.split(";"), "news")>-1){
			fieldValue = document.getElementsByName("notifySettingForms."+Notify_KeyList[i]+".fdNewsCateId")[0].value;
			if(fieldValue==""){
				alert(Notify_NewsCateRequired[Notify_KeyList[i]]);
				return false;
			}
		}
	}
	return true;
}

Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = Notify_CheckInput;