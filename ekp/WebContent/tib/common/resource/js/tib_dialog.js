
Com_IncludeFile("popup.js", Com_Parameter.ContextPath +"tib/common/resource/js/jsdialog/", "js", true);

/**
 * 确认弹出框
 * @param title			弹出框标题
 * @param content		弹出框内容
 * @param action		点确认时的回调函数，可返回true or false，
 * 							在第四个参数不为空的情况下，true为不再弹出自定义框，false为弹出自定义框
 * @param boxParam		再次弹出框参数，不填则不弹出。格式如下举例：
	var boxParam = {
		title : title,				// 可选，默认第一次弹出框title
		width : 340,				// 可选，默认340
		height : 100,				// 可选，默认100
		content : "再次弹出框内容",	// 可选，默认为空
		// 每个数组元素为一个按钮，每个按钮对应触发的函数用半角冒号隔开，无触发函数默认为关闭对话框
		buttons : new Array("是:yesFun","否:noFun","取消")  // 可选，默认为没有按钮。
	};
 */
function Tib_Confirm(title, content, action, boxParam) {
	if (boxParam != null) {
		if (boxParam.title == null) {
			boxParam.title = title;
		}
		boxParam.confirmFunc = action;
		// 确认后，再根据返回值是否自定义弹出框
		new txooo.ui.conform(title, content, Tib_CustomBox, boxParam);
	} else {
		// 简单的弹出框
		new txooo.ui.conform(title, content, Tib_Call_Action, action);
	}
}

/**
 * 简单弹出框回调函数
 * @param rtnParam
 * @return
 */
function Tib_Call_Action(rtnParam) {
	if (rtnParam.param != null) {
		// 调用确认执行的方法
		rtnParam.param();
	}
	// 关闭对话框
	dialogBoxClose.click();
}

/**
 * 自定义创建弹出框
 * @param par    参数格式如 Tib_Confirm(); 方法所示
 * @return
 */
function Tib_CustomBox(par) {
	if (par.param.confirmFunc != null && par.param.confirmFunc()) {
		Tib_CloseBox();
		return;
	}
	var pop = pop = new txooo.ui.Popup({ 
		contentType : 2,
		isReloadOnClose : false,
		width : par.param.width != null ? par.param.width : 340,
		height : par.param.height != null ? par.param.height : 100
	});
	pop.setContent("title", par.param.title != null ? par.param.title : "");
	pop.setContent("contentHtml" , par.param.content != null ? par.param.content : "");
	//传递参数
	//alert("par.param.parameter="+par.param.parameter);
	pop.setContent("parameter", par.param.parameter);	
	// 每个数组元素为一个按钮，每个按钮对应触发的函数用半角冒号隔开，无触发函数默认为关闭对话框
	pop.setContent("buttons", par.param.buttons);
	pop.build();
	pop.show();
}

/**
 * 关闭弹出框
 * @return
 */
function Tib_CloseBox() {
	dialogBoxClose.click();
}