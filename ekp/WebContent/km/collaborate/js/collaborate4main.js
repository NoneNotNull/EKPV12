
	function displayNode(id){
	    document.getElementById(id).style.display="none";
	}


		 
	/***********************************************************/
    /*
     *  设置 制定ID 的 input 输入 的value值
     * */
	function setInputValue4ID(id,value){
		document.getElementById(id).value=value;
		
	}	
	/* 关闭当前窗口*/
	function closeWindow(){
		window.close();
	}
	/* 回到 顶部*/
	function goTop(){
		$('body,html').animate({scrollTop:0},100);
	}
	/* 获得 event 的事件源 对象*/
	function getTarget(event){
		var event= event || window.event;
		var source=event.target|| event.srcElement;
		return source;
	}
	/* 获得 事件对象*/
	
	function getEvent(event){
		return event || window.event;
	}
	/*
	 *  阻止默认事件
	 * */
	function preventDefault(event){
		if(event.preventDefault){
			event.preventDefault();
	    }else{
			event.returnValue=false; 
	    }
	}
	
	/*
	 *  返回 fckEdit 的body 对象 
	 * */
	function FCKBody(){		
		var cframe = document.getElementsByName('fdContent___Frame')[0];
		return cframe.contentWindow.document.frames[0].document.body;
	}
	

	
	function SetWinHeight(obj) {
		var win=obj;
		if (document.getElementById){
			if (win && !window.opera) { 
				if (win.contentDocument && win.contentDocument.body.offsetHeight)    
					win.height = win.contentDocument.body.offsetHeight;     
				else if(win.Document && win.Document.body.scrollHeight)   
					win.height = win.Document.body.scrollHeight;
			}
		}
	}
	
	