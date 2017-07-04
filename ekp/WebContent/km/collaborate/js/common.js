// JavaScript Document


/** 选项卡切换 ***********************************************************************************************/
function setTab(name, cursel, n) {
    for (i = 1; i <= n; i++) {
        var menu = document.getElementById(name + i);
        var con = document.getElementById("con_" + name + "_" + i);
        menu.className = i == cursel ? "current" : "";
    }
	var iframe = document.getElementById("relatedSummary").getElementsByTagName("win")[0];
    if(cursel=="1"){
	 iframe.src = "${KMSS_Parameter_ContextPath}km_collaborate_main_reply_ui/kmCollaborateMainReply_reply.jsp?mainId=${param.fdId}&pageno=1&rowsize=10&sortType=asc";
    }else{
    	alert(2);
    }
};

