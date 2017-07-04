/****************************************************************************************
功能：界面上弹出一个遮罩的对话框，一般用于提示信息，接受用户输入内容，或是按保存后提示用户正在上传保存数据等场景. 
相关文件：
	不依赖其它文件可独立使用
使用方法：
	var popup = new PopDialog([options]);
Options参数说明：
	width			弹出框的宽度
	top				弹出框距离页面顶部距离
	content			弹出框显示的内容
	shoProgress		是否显示进度条
	openOnCreate	是否在创建时就显示
	destroyOnClose	关闭时是否销毁对象
	escHandler		Esc建的回调函数
	buttons			界面上按钮
对象方法：
	open			打开显示
	close			关闭显示
	setTitle		设置标题
	setContent		设置显示内容
	setProgressVal	设置进度条值，只有shoProgress为True时才有效
	...待扩充
	下划线开头的是私有方法
使用示例：
	var popup1 = new PopDialog({content:'数据正在处理....'});
	
	var popup2 = new PopDialog({openOnCreate:false});
	popup2.setContent('数据处理中....');
	popup2.open();
	
	var popup3 = new PopDialog({openOnCreate:false,showProgress:true});
	popup3.setProgressVal('20%');
	popup3.setContent('数据处理中....');
	popup3.setProgressVal('60%');
	popup3.open();
作者：liyong
创建时间：2010-09-28
****************************************************************************************/
Com_RegisterFile("popdialog.js");
// 定义PopUp对象
function PopDialog(options) {
	this.options = {
		width: 400,
		top: 120,
		content: "",
		showProgress: false,
		openOnCreate: true,
		destroyOnClose: true,
		escHandler: this.close,
		buttons: {'OK': this.close}
	}; 
	for (var option in options) {
		this.options[option] = options[option];
	} 
	this._makeNodes();
	if (this.options.openOnCreate) {
		this.open();
	}
}
// 实现PopUp对象的方法
PopDialog.prototype = { 
	container: null,
	header: null,
	body: null,
	content: null,
	actions: null,
	_progress: null,
	_overlay: null,
	_wrapper: null,
	_zIndex: 0,
	_escHandler: null,
 
	//弹出框显示
	open: function() {
		this._makeTop();
		var ws = this._wrapper.style;
		ws.left = (document.body.clientWidth - this.options.width) / 2 + 'px';
		ws.top = (document.body.scrollTop || document.documentElement.scrollTop) + this.options.top + 'px';
		this._overlay.style.display = 'block';
		ws.display = 'block';
		this._wrapper.focus();

		if (this.options.focus) {
			var input = document.getElementById(this.options.focus);
			if (input) {
				input.focus();
			}
		}
	},
	//弹出窗口关闭
	close: function() {
		if (this.options.destroyOnClose) {
			this._destroy();
		} else {
			this._overlay.style.display = 'none';
			this._wrapper.style.display = 'none';
		}
	},
	//设置弹出窗的标题
	setTitle: function(title){
		if (!this.header) {
			var header = document.createElement('div');
			header.className = 'dialog-header';
			header.style.border="1px solid #186CBB";
			header.style.color="#FFFFFF";
			header.style.background="#2371BA none no-repeat right center";
			header.style.padding="5px 10px";
			header.style.fontSize="14px";
			header.style.fontWeight="bold";
			this.container.insertBefore(header, this.body);
			this.header = header;
		}
		this.header.innerHTML = title;
	},
	//设置弹出窗口的内容
	setContent: function(content) { 
		this.content.innerHTML = content;
	},
	//设置进度条的值，只有进图条显示的时候也就是showProgress为True时才有用
	setProgressVal:function(val){
		this._progress.style.width = val;
	},
	//隐藏按钮工具条
	hiddenActions:function(val){
		if(this.actions) {
			if(val == null) {
				val = true;
			}
			if(val) {
				this.actions.style.display = 'none'
			} else {
				this.actions.style.display = ''
			}
		}
	},
	//创建Dom主体部分代码
	_makeNodes: function() {
		if (this._overlay || this._wrapper) {
			return; 
		} 
		this._overlay = document.createElement('div');
		this._overlay.className = 'dialog-overlay';
		//this._overlay.innerHTML = "s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>s<br>";
		this._overlay.style.backgroundColor = "#F0F0F0";
		this._overlay.style.opacity = "0.5";
		this._overlay.style.filter = "alpha(opacity=70)";
		this._overlay.style.position = "absolute";
		this._overlay.style.height = "100%";
		this._overlay.style.width = "100%";
		this._overlay.style.left = "0";
		this._overlay.style.top = "0";
		this._overlay.style.display = "";
		 
		document.body.appendChild(this._overlay);

		if (typeof this.options.title == 'string' && this.options.title != '') {
			var header = document.createElement('div');
			header.className = 'dialog-header';
			header.style.border="1px solid #186CBB";
			header.style.color="#FFFFFF";
			header.style.background="#2371BA none no-repeat right center";
			header.style.padding="5px 10px";
			header.style.fontSize="14px";
			header.style.fontWeight="bold";
			header.innerHTML = this.options.title;
			this.header = header;
		}
		 
		var content = document.createElement('div');
		content.className = 'dialog-content';
		content.style.padding="10px";
		content.style.backgroundColor="#FFFFFF";
		content.innerHTML = this.options.content;
		this.content = content;
 
		var actions = document.createElement('div');
		actions.className = 'dialog-actions';
		actions.style.backgroundColor = "#F2F2F2";
		actions.style.borderTop = "1px solid #CCCCCC";
		actions.style.padding = "3px 10px";
		actions.style.textAlign = "right";
		var buttons = this._makeButtons(this.options.buttons);
		if (buttons.length > 0) {
			for (var i = 0; i < buttons.length; i++) {
				actions.appendChild(buttons[i]);
			}
		}else{
			actions.style.display = 'none';	
		}
		this.actions = actions; 

		var body = document.createElement('div');
		body.style.backgroundColor="#ffffff";
		body.className = 'dialog-body';
		body.style.border = "1px solid #898989";
		if(this.options.showProgress){
			var progress = document.createElement('div');
			progress.className = "dialog-content";
			progress.style.backgroundColor="#ffffff";
			progress.style.margin="10px";
			progress.style.border = "1px solid #CCCCCC";
			var progressval = document.createElement('div');
			progressval.style.backgroundColor="#CCCCCC";
			progressval.style.width ="0px";
			progress.appendChild(progressval);
			this._progress = progressval;
			body.appendChild(progress);
		}
		body.appendChild(content);
		body.appendChild(actions);
		this.body = body; 

		var container = document.createElement('div');
		container.className = 'dialog';
		container.style.border = "3px solid #A1A1A1";
		if (this.header) {
			container.appendChild(header);
		}
		container.appendChild(body);
		this.container = container;

		var wrapper = document.createElement('div');
		wrapper.className = 'dialog-wrapper';
		wrapper.style.overflow = "hidden";
		var ws = wrapper.style;
		ws.position = 'absolute';
		ws.width = this.options.width + 'px';
		ws.display = 'none';
		ws.outline = 'none';
		wrapper.appendChild(container);
		// register keydown event
		if (this.options.escHandler) {
			wrapper.tabIndex = -1;
			this._onKeydown = this._makeHandler(function(e) {
				if (!e) {
					e = window.event;
				}
				if (e.keyCode && e.keyCode == 27) {
					this.options.escHandler.apply(this);
				}
			}, this);
			this._bindEventHandler(wrapper, 'keydown', this._onKeydown);
		}
		this._wrapper = document.body.appendChild(wrapper);
 
		this._fixIE();
		 
	},
	//创建Button的代码
	_makeButtons: function(buttons) {
		var buttonArray = new Array();
		for (var buttonText in buttons) {
			var button = document.createElement('button');
			button.className = 'dialog-button';
			button.style.fontSize = "12px";
			button.style.backgroundColor = "#4383CE";
			button.style.border = "1px solid #DDDDDD";
			button.style.color = "#FFFFFF";
			button.style.marginLeft = "8px";
			button.style.padding = "1px 10px";
			button.style.cursor = "pointer";
			button.innerHTML = buttonText;
			
			this._bindEventHandler(button, 'click', this._makeHandler(buttons[buttonText], this));

			buttonArray.push(button);
		}
		return buttonArray;
	},
	//处理回调
	_makeHandler: function(method, obj) {
		return function(e) {
			method.call(obj, e);
		}
	}, 
	//管理遮罩zIndex
	_makeTop: function() {
		if (this._zIndex < this._Manager.currentZIndex) {
			this._overlay.style.zIndex = this._Manager.newZIndex();
			this._zIndex = this._wrapper.style.zIndex = this._Manager.newZIndex();
		}
	},
	//管理遮罩iframe,IE里面有些内容Div遮罩不了，需要使用iframe
	_fixIE: function() {
		var pageSize =this._pageSize();
		var width = pageSize.pageWidth;
		var height = pageSize.pageHeight;
		var os = this._overlay.style;
		os.position = 'absolute';
		os.width = width;
		os.height = height; 

		var iframe = document.createElement('iframe');
		iframe.className = 'iefix';
		iframe.style.display = ""; 
		iframe.style.position = "absolute";
		iframe.style.top = "0";
		iframe.style.left = "0"; 
		iframe.style.width = width;
		iframe.style.height = height;
		this._overlay.appendChild(iframe);
	},
	//为元素绑定事件
	_bindEventHandler: function(element, eventName, handler) {
		if (element.addEventListener) { 
			element.addEventListener(eventName, handler, false);
		} else if (element.attachEvent) { 
			element.attachEvent('on' + eventName, handler);
		}
	}, 
	//对象销毁
	_destroy: function() {
		document.body.removeChild(this._wrapper);
		document.body.removeChild(this._overlay);
		this.container = null;
		this.header = null;
		this.body = null;
		this.content = null;
		this.actions = null;
		this._overlay = null;
		this._wrapper = null;
	}, 
	//获取页面大小
    _pageSize : function(){
		 var xScroll, yScroll;  
		 if (window.innerHeight && window.scrollMaxY) {  
		    xScroll = document.body.scrollWidth;
		    yScroll = window.innerHeight + window.scrollMaxY;
		 } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
		    xScroll = document.body.scrollWidth;
		    yScroll = document.body.scrollHeight;
		 } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
		    xScroll = document.body.offsetWidth;
		    yScroll = document.body.offsetHeight;
		 }
		
		 var windowWidth, windowHeight;
		 if (self.innerHeight) {  // all except Explorer
		    windowWidth = self.innerWidth;
		    windowHeight = self.innerHeight;
		 } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
		    windowWidth = document.documentElement.clientWidth;
		 	windowHeight = document.documentElement.clientHeight;
		 } else if (document.body) { // other Explorers
		    windowWidth = document.body.clientWidth;
		    windowHeight = document.body.clientHeight;
		 }  
		  
		  // for small pages with total height less then height of the viewport
		 if(yScroll < windowHeight){
		    pageHeight = windowHeight;
		 } else { 
		    pageHeight = yScroll;
		 }
		
		 if(xScroll < windowWidth){  
		    pageWidth = windowWidth;
		 } else {
		    pageWidth = xScroll;
		 }

		 return {"pageWidth":pageWidth,"pageHeight":pageHeight};
	},
	//管理zIndex
	_Manager : {
		currentZIndex: 3000,
		newZIndex: function() {
			return ++this.currentZIndex;
		}
	}
};
 
  
