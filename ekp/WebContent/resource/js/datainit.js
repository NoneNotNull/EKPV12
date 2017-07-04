/*压缩类型：标准*/

Com_IncludeFile("sysDatainit_MessageInfo.jsp?locale="+ Com_Parameter.__dataInitlocale__,Com_Parameter.ContextPath + "sys/datainit/sys_datainit_main/", 'js',true);
if (typeof Datainit_MessageInfo == "undefined") {
	Datainit_MessageInfo = new Array();
}

function OptBar_RefreshButtonList(){
	OptBar_ButtonList = new Array();
	if(
			document.forms.length>0 &&
			document.forms[0].action!=null &&
			document.forms[0].action.indexOf("/sys/datainit/sys_datainit_main/sysDatainitMain.do")==-1 &&
			window.List_CheckSelect
	){
		var element = new Object();
		element.click = Datainit_Submit;
		element.value = Datainit_MessageInfo["sysDatainitMain.export"];
		element.title = element.value;
		OptBar_ButtonList[OptBar_ButtonList.length] = element;
	}
	var btnObj;
	for(var w=0; w<OptBar_WindowList.length; w++){
		for(var i=0; i<OptBar_WindowList[w].OptBar_BarList.length; i++){
			btnObj = OptBar_WindowList[w].document.getElementById(OptBar_BarList[i]);
			if(btnObj==null)
				continue;
			btnObj.style.display = "none";
			btnObj = btnObj.getElementsByTagName("INPUT");
			for(var j=0; j<btnObj.length; j++){
				if(btnObj[j].style.display=="none")
					continue;
				switch(btnObj[j].type){
				case "button":
				case "submit":
				case "reset":
					break;
				default:
					continue;
				}
				OptBar_ButtonList[OptBar_ButtonList.length] = btnObj[j];
			}
		}
	}
}

function Datainit_Submit(){
	if(window.List_CheckSelect!=null && !List_CheckSelect())
		return;
	var form = document.forms[0];
	var url = Com_Parameter.ContextPath + "sys/datainit/sys_datainit_main/sysDatainitMain.do?method=export&formName="+form.name;
	form.action = url;
	form.submit();
}