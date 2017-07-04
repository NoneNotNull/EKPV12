<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("popup.js", "${KMSS_Parameter_ContextPath}tib/common/resource/js/jsdialog/", "js", true);

</script>

<body>
<script type="text/javascript">
//contentType: 3
    function confirmbtn() {
        var pop = new txooo.ui.Popup({ contentType: 3, isReloadOnClose: false, width: 340, height: 80 });
        pop.setContent("title", "删除文章");
        pop.setContent("confirmCon", "您确定要彻底删除这篇文章及其所有评论吗？");
        pop.setContent("callBack", okBtn);
        pop.setContent("parameter", { fid: "xxxxxxxxxx", popup: pop });
        pop.build();
        pop.show();
        return false;
    }

    function okBtn(para) {
        alert("para为传递过来的parameter")
		alert(para["fid"]);
		alert(para["popup"]);
    }


//contentType: 2
    function ShowHtmlString(){
		var strHtml = "aaaa<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />bbbbb<br />";
		var pop=new txooo.ui.Popup({ contentType:2,isReloadOnClose:false,width:340,height:300});
		pop.setContent("contentHtml",strHtml);
		pop.setContent("title","html字符串示例");
		pop.build();
		pop.show();
	}

//contentType: 1
	function showURL(url){
	    var pop = new txooo.ui.Popup({contentType: 1, isReloadOnClose: false, width: 440, height: 390 });
	
	    //设置对话框的颜色，包括:
	    //标题字体颜色、
	    pop.color.wColor = "red";
	    
	    //背景颜色包括标题的颜色、
	    pop.color.tColor = "#EEEEEE";
	    
	    //覆盖层颜色。
	    pop.color.cColor = "black";
		
		pop.setContent("title","编辑分类");
		pop.setContent("contentUrl",url);
		pop.build();
		pop.show();
		return false;
	}
//contentType: 4
    function ShowCallBack(opt) {
		alert(opt);
		dialogBoxClose.click();//关闭对话框
    }
    
	function ShowAlert(){
	     var pop=new txooo.ui.Popup({ contentType:4,isReloadOnClose:false,width:340,height:500});
	     pop.setContent("title","alert警告框示例");
	     pop.setContent("alertCon", "alert对话框的内容alert对话框的内容alert对话框的内容alert对话框的内容alert对话框的内容alert对话框的内容alert对话框的内容");
	     pop.setContent("callBack", ShowCallBack);
	     pop.setContent("parameter", { id: "divCall", str: "点击确定后显示的字符串", obj: pop });
	     pop.build();
	     pop.show();
	}
	
//先弹出是否删除，再弹出3个按钮
    function test3(){
        var pop = new txooo.ui.Popup({ contentType: 3, isReloadOnClose: false, width: 340, height: 80 });
        pop.setContent("title", "删除节点");
        pop.setContent("confirmCon", "此节点下存在子节点，是否要删除？");
        pop.setContent("callBack", goBtn);
        //pop.setContent("parameter", { fid: "xxxxxxxxxx", popup: pop });	//传递参数
        pop.build();
        pop.show();
        return false;
	}
    function goBtn(para) {
        //alert("para为传递过来的parameter")
		//alert(para["fid"]);
		//alert(para["popup"]);
		var strHtml = "当前节点下拥有子节点，是否一并删除所有子节点？只删除该节点选择否！";
		var pop=new txooo.ui.Popup({ contentType:2,isReloadOnClose:false,width:340,height:300});
		pop.setContent("contentHtml",strHtml);
		pop.setContent("title","删除节点");
		var buttonsArr=new Array("是:yesFun","否:noFun","取消");	//每个数组元素为一个按钮，每个按钮对应触发的函数用半角冒号隔开，无触发函数默认为关闭对话框
		pop.setContent("buttons",buttonsArr);
		pop.build();
		pop.show();		
    }
    function yesFun(para) {
		alert("yesFun");
    }
    function noFun(para) {
		alert("noFun");
    }


//弹出3个按钮传参数
    function test3cs(para) {
		var strHtml = "当前节点下拥有子节点，是否一并删除所有子节点？只删除该节点选择否！";
		var pop=new txooo.ui.Popup({ contentType:2,isReloadOnClose:false,width:340,height:300});
		pop.setContent("contentHtml",strHtml);
		pop.setContent("title","删除节点");
		var buttonsArr=new Array("是:yesFuncs","否:noFuncs","取消");	//每个数组元素为一个按钮，每个按钮对应触发的函数用半角冒号隔开，无触发函数默认为关闭对话框
		pop.setContent("buttons",buttonsArr);

		//传递参数，注意JS参数为值传递，故具体值中不允许有单双引号、&quot;、&#039;等特殊字符
		var tmpObja = new Object();
		tmpObja.aa1="aaa&#0aaa";	//例如不允许有\"，\'，&quot;等
		tmpObja.sizaa=1;
		pop.setContent("yesFuncs", tmpObja);		//为yesFuncs设置要传递的第1个参数
		pop.setContent("yesFuncs", "11");			//为yesFuncs设置要传递的第2个参数
		pop.setContent("yesFuncs", "22");			//为yesFuncs设置要传递的第3个参数
		pop.setContent("yesFuncs", buttonsArr);		//为yesFuncs设置要传递的第4个参数
		
		pop.build();
		pop.show();
    }
    function yesFuncs(para) {
		alert("yesFun");
        var aa=JSON.parse(para);	//转换为json
        alert(typeof(aa));
        alert(aa.p1.aa1);			//p1: 传递的第1个参数
        alert(aa.p2);				//p2: 传递的第2个参数
        alert(aa.p4);				//p4: 传递的第4个参数
        alert(aa.size);				//size: 参数个数
    }
    function noFuncs(para) {
		alert("noFun");
    }

</script>

<button onclick="confirmbtn()">confirm</button>




<br><br><br><br><br>

<button onclick="ShowHtmlString()">ShowHtmlString</button>
<br><br><br><br><br>

<button onclick="showURL('http://www.baidu.com')">show</button>

<br><br><br><br><br>
<button onclick="ShowAlert()">ShowAlert</button>

<br><br><br><br><br>
<button onclick="test3cs()">弹出3个按钮传参数</button>

<br><br><br><br><br>
<button onclick="test3()">先弹出是否删除，再弹出3个按钮</button>

<br><br><br><br><br>
<select>
<option>测试测试ddddddddd1</option>
</select>
aaaaaaa测试测试测试测试测试
</body>

