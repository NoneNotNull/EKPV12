/**********************************************************
功能：撤销/重做
支持的撤销：
	1.属性面板修改后的撤销
	2.绘制区拖拽，拉伸控件后的撤销
	3.工具栏大部分操作后的撤销
暂不支持的撤销：
其他/后续：
	撤销功能可能对工程自定义的一些控件支持不是很好
	(暂时的做法是暴露了DesignerUndoSupport接口，使用方法可以参考JSP片段、权限区段中的调用)
创建时间：2014年5月30号
**********************************************************/
(function(window, undefined){
	
	/*操作历史对象*/
	var Historys=function(){
		this.settings={
			limit:30
		};
		this.redos=[];//重做区
		this.undos=[];//撤销区
	};

	//增加历史操作
	Historys.prototype.add=function(operation){
		this.redos=[];//清空重做区
		if(!operation instanceof Historys.operation){
			return ;
		}
		var _prevOpt;
		if(!operation.prev && this.undos.length>0){
			_prevOpt=this.undos[0];
			operation.prev=_prevOpt.next;
		}

		this.undos.unshift(operation);
		if(this.settings.limit){
			this.undos.splice(this.settings.limit);
		}
		return this;
	};

	//撤销
	Historys.prototype.undo=function(){
		var operation;
		if(operation=this.undos.shift() ){
			if(operation.prev){
				this.redos.unshift(operation);
				operation.prev();
				DesignerUndoSupport.fire("undo",operation.control?operation.control:null);
			}else{
				this.undos.unshift(operation);
			}
		}
		return this;
	};

	//重做
	Historys.prototype.redo=function(){
		var operation;
		if(operation=this.redos.shift()){
			if(operation.next){
				this.undos.unshift(operation);
				operation.next();
				DesignerUndoSupport.fire("redo",operation.control?operation.control:null);
			}
		}
		return this;
	};

	//操作对象
	Historys.operation=function(args){
		this.prev=args.prev || null; //即将要执行的方法
		this.next=args.next || null; //上一个执行方法
	};


	/*JS AOP*/
	function AopImp() {
		this.doAspect;
	}

	AopImp.doAspect = function(object) {
		object.yield = null;
		object.rtnValue = {};//原返回值
		object.before = function(method, f) {
			var original = eval("this." + method);
			this[method] = function() {
				f.apply(this, arguments);
				return original.apply(this, arguments);
			};
		};
		object.after = function(method, f) {
			var original = eval("this." + method);
			this[method] = function() {
				this.rtnValue[method] = original.apply(this, arguments);
				return f.apply(this, arguments);
			};
		};
		object.around = function(method, f) {
			var original = eval("this." + method);
			this[method] = function() {
				this.yield = original;
				return f.apply(this, arguments);
			};
		};
	};
	
	
	var hasChanged=false;
	var isMoving=false;
	var currentActionType="default";
	//绘制区事件切入
	function UndoAdapter_fn_aspectBuilder (designer) {
		var builder=designer.builder;
		if(!builder.before)
			AopImp.doAspect(builder);

		//鼠标移动事件开始时执行
		builder.before("_mouseMove", function(){
			switch (this._actionType) {
				case 'drag':
				case 'resize':
					isMoving = true;
					break;
			}
		});

		//鼠标弹出事件开始时执行
		builder.before('_mouseUp',function(e){
			if (Designer.eventButton(e) != 1)
				return;
			currentActionType=this._actionType;
			switch(this._actionType){
				case "resize":
				case "createControl":
				case "drag":
					hasChanged=true;
					break;
			}
			//如果存在选中控件，添加控件事件切入
			var designer=Designer.instance;
			if(designer.control){
				UndoAdapter_fn_aspectControl(designer,designer.control);
			}
		});

		//鼠标弹出事件结束时执行
		builder.after("_mouseUp", function(e){
			if (Designer.eventButton(e) != 1)
				return;
			switch(currentActionType){
				case "resize":
					hasChanged=true;
					isMoving=false;
					UndoAdapter_fn_addOperation();
					break;
				case "drag":
					hasChanged=true;
					isMoving=false;
					var designer = Designer.instance;
					if(designer.control == null)
						return ;
					var position = "";
					var domElement = null;
					if (designer.control.type == "standardTable") {
						position = designer.control._chooseElement.mousePosition;
						domElement = designer.control._chooseElement.domElement;
					}
					if (position == "" && domElement == null) {
						var distance_x = Math.abs(parseInt(designer.builder.dragDashBox.box.style.left)
							- designer.builder._dragDomElement._prev_x);
						var distance_y = Math.abs(parseInt(designer.builder.dragDashBox.box.style.top)
							- designer.builder._dragDomElement._prev_y);
						if (distance_x >= 10 || distance_y >= 10) {
							UndoAdapter_fn_addOperation();
						}
					} else {
						UndoAdapter_fn_addOperation();
					}
					break;
			}
		});

		//创建控件事件结束时执行
		builder.after("createControl", function(){
			hasChanged=true;
			UndoAdapter_fn_addOperation();
			//控件事件切入
			UndoAdapter_fn_aspectControl(Designer.instance,Designer.instance.control);
		});
	}

	//控件事件切入
	var undoDestoryTimer=null;//销毁定时器
	function UndoAdapter_fn_aspectControl(designer,control){
		function _callback(){
			hasChanged=true;
			isMoving=false;
			UndoAdapter_fn_addOperation();
		}
		
		function _destoryCallback(){
			var _designer=Designer.instance;
			if(undoDestoryTimer==null){
				undoDestoryTimer=setInterval(function(){
					var _controls=_designer.controls;
					//执行插入操作历史的条件：  1、_controls.length==0 :多个非容器类控件都已删除     2、_controls.length==1 &&……：容器类控件已被删除
					if(_controls.length==0 || (_controls.length==1 && _controls[0].container && _designer.control==null)){
						_callback();
						clearInterval(undoDestoryTimer);
						undoDestoryTimer=null;
					}
				},100);
			}
		}

		if(!control.after){
			AopImp.doAspect(control);
			//销毁控件
			control.after('destroy',_destoryCallback);
			//表格特有事件
			if(control.inherit == "table"){
				
				control.after("insertRow", _callback);
				control.after("appendRow", _callback);
				control.after("insertColumn", _callback);
				control.after("appendColumn", _callback);
				control.after("deleteRow", _callback);
				control.after("deleteColumn", _callback);
				control.after("merge", _callback);
				control.after("split", _callback);
			}
			
			//文本特有事件
			if(control.type == 'textLabel'){
				//control.after("setBold", _callback);
				//control.after("setItalic", _callback);
				//control.after("setColor", _callback);
				//control.after("setUnderline", _callback);
				//control.after("setFontStyle", _callback);
				//control.after("setFontSize", _callback);
			}
		}
	}


	//工具栏按钮对象切入(主要针对font类操作)
	function UndoAdapter_fn_aspectToolbar(designer){
		var currentButtons=designer.toolBar.buttons;//当前表单所拥有的按钮
		var buttons=[].concat(Designer_Config.buttons.font);
		//buttons.push("deleteElem");
		for(var i=0;i<currentButtons.length;i++){
			if(!currentButtons[i].config || !contains(currentButtons[i].name,buttons)){
				continue;
			}
			var config=currentButtons[i].config;
			if(!config.before){
				AopImp.doAspect(config);
				if(config.run){
					
					//执行按钮操作开始时执行
					config.before('run',function(designer,button){
						isMoving=false;
					});

					//执行按钮操作结束时执行
					config.after('run',function(designer,button){
						if (designer.control) {
							hasChanged = true;
							UndoAdapter_fn_addOperation();
						}
					});
				}
			}
		}
	}

	//属性面板切入
	function UndoAdapter_fn_aspectArrPanel(designer){
		var panel=designer.attrPanel.panel;
		if(!panel.before){
			AopImp.doAspect(panel);
		}

		panel.after("onLeave",function(){
			return this.rtnValue;//原返回值
		});

		panel.before('resetValues',function(){
			var designer = Designer.instance;
			hasChanged = designer.attrPanel.panel._changed;
			isMoving=false;
		});

		panel.after ('resetValues',function(){
			var designer = Designer.instance;
			var rv = designer.attrPanel.panel.rtnValue.resetValues;
			if(rv && hasChanged){
				UndoAdapter_fn_addOperation();
			}
			return rv;
		});
	}

	//快捷键切入
	function UndoAdapter_fn_aspectShortCut(designer){
		var shortCut=designer.shortcuts;
		var deleteElem=shortCut.shortCuts['delete'];//删除快捷键
		if(!deleteElem.before){
			AopImp.doAspect(deleteElem);
			var beforeSelect=0;//点击按钮前选中的控件个数（针对删除元素特殊处理）
			//删除操作开始时切入
			deleteElem.before("callback",function(){
				isMoving=false;
				beforeSelect=designer.controls.length;
			});
			//删除操作结束时切入
			deleteElem.after("callback",function(){
				if(designer.controls.length ==0 && beforeSelect > 0){
					hasChanged = true;
					UndoAdapter_fn_addOperation();
					beforeSelect=0;
				}
			});
		}
	}

	//增加历史记录
	function UndoAdapter_fn_addOperation () {
		var designer=Designer.instance;
		if(!hasChanged || isMoving){
			return ;
		}
		var html=getCurrentHTML();
		//var html=designer.getHTML();
		var operation=new Historys.operation({
			next:function(){
				if (!designer.attrPanel.isClosed){
					designer.attrPanel.close();
				}
				//designer.builder.resizeDashBox.hide();
				//designer.setHTML(html);
				setNewHTML(html);
			}
		});
		//保存当前控件
		if(designer.control){
			operation.control=designer.control;
		}
		historys.add(operation);
		hasChanged=false;
		isMoving=false;
	}

	/*初始化*/	
	var historys;
	function init () {
		var designer=Designer.instance;
		AopImp.doAspect(designer);
		if(!designer.hasInitialized){
			setTimeout(init,500);
		}else{
			historys=new Historys();
			var html=getCurrentHTML();
			//var html=designer.getHTML();
			var operation=new Historys.operation({
				next:function(){
					if (!designer.attrPanel.isClosed){
						designer.attrPanel.close();
					}
					//designer.builder.resizeDashBox.hide();
					//designer.setHTML(html);
					setNewHTML(html);
				}
			});
			historys.add(operation);
			UndoAdapter_fn_aspectBuilder(designer);//绘制区切入
			UndoAdapter_fn_aspectToolbar(designer);//按钮栏切入
			UndoAdapter_fn_aspectArrPanel(designer);//属性面板切入
			UndoAdapter_fn_aspectShortCut(designer);//快捷键切入
			if(designer.control){
				UndoAdapter_fn_aspectControl(designer,designer.control);
			}
			//增加监听器
			designer.addListener('undoSaveHTML',function(){
				var designer=Designer.instance;
				var html=getCurrentHTML();
				var operation=new Historys.operation({
					next:function(){
						if (!designer.attrPanel.isClosed){
							designer.attrPanel.close();
						}
						//designer.setHTML(html);
						setNewHTML(html);
					}
				});
				historys.add(operation);
			});
		}
	}
	Com_AddEventListener(window,'load',init);


	/*EKP 控件部署*/	

	//定义按钮属性
	Designer_Config.operations['undo'] = {
		imgIndex : 48, // 按钮图片, 直接通过css背景图定位方式来实现，图片是icon.gif
		title : Designer_Lang.controlOperation_undo,
		run : UndoAdapter_fn_undo,
		type : 'cmd',
		hotkey : 'ctrl+z',
		hotkeyName : 'Ctrl + Z',
		select : true
	};
	Designer_Config.operations['redo'] = {
		imgIndex : 49, // 按钮图片, 直接通过css背景图定位方式来实现，图片是icon.gif
		title : Designer_Lang.controlOperation_redo,
		run : UndoAdapter_fn_redo,
		type : 'cmd',
		hotkey : 'ctrl+y',
		hotkeyName : 'Ctrl + Y',
		select : true
	};

	//添加按钮到工具栏
	Designer_Config.buttons.common.push("undo");
	Designer_Config.buttons.common.push("redo");

	//添加按钮到右键菜单
	Designer_Menus.undo = Designer_Config.operations['undo'];
	Designer_Menus.redo = Designer_Config.operations['redo'];
		
	function UndoAdapter_fn_undo () {
		historys.undo();
	}

	function UndoAdapter_fn_redo () {
		historys.redo();
	}


	/*其他*/

	//指定item是否存在list中
	function contains (item,list) {
		if(!list || list.length==0){
			return false;
		}
		for ( var i = 0; i < list.length; i++) {
		if (item == list[i])
			return true;
		}
		return false;
	}

	//获取当前页面的HTML
	function getCurrentHTML(){
		var designer=Designer.instance,builder=designer.builder;
		//序列化相关信息
		//builder.onSerialize();
		builder.serialize();
		//虚线框移到临时存储区
		var dashs=[builder.resizeDashBox,builder.chooseDashBox,builder.vDashLine,builder.hDashLine,builder.dragDashBox];
		
		for(var i=0;i<dashs.length;i++){
			dashs[i].moveDomElement(designer.hiddenDomElement);
		}
		//记录输出的HTML
		var rtnHTML = designer.builderDomElement.innerHTML;
		//虚线框移回到绘制区

		for(var i=0;i<dashs.length;i++){
			dashs[i].moveDomElement(designer.builderDomElement);
		}
		//builder.onSerialized();
		//var rtnHTML=designer.builderDomElement.innerHTML;
		//rtnHTML=rtnHTML.substring(0,rtnHTML.lastIndexOf("</TABLE>")+8);
		//rtnHTML.replace('class="table_selected"','');
		return rtnHTML;
	}
	
	//设置页面HTML
	function setNewHTML(html){
		var designer=Designer.instance;
		var builder = designer.builder;
		// 清除控件
		builder.controls = [];
		//虚线框移到临时存储区
		builder.moveDashBox(designer.hiddenDomElement);
		//载入HTML
		designer.builderDomElement.innerHTML = html;
		//虚线框移回到绘制区
		builder.moveDashBox(designer.builderDomElement);
		//初始化对象集
		builder.parse(null, designer.builderDomElement);
	}

	var evtList={};
	/*对外接口*/
	window.DesignerUndoSupport={
			
		//事件接口	
		on:function(type,fn){
			var evt = evtList[type];
			if (evt == null) {
				evt = [];
				evtList[type] = evt;
			}
			evt.push({fn: fn});
		},
		off:function(type,fn){
			if (arguments.length == 0) {
				evtList = {};
				return;
			}
			if (arguments.length == 1) {
				evtList[type] = [];
				return;
			}
			var evt =evtList[type] ;
			if(evt==null)
				return;
			for (var i = 0; i < evt.length; i ++) {
				if (evt[i].fn == fn) {
					evt.splice(i, 1);
					return this;
				}
			}
		},
		fire:function(type){
			var evt = evtList[type];
			if (evt) {
				var args = [];
				for (i = 1, len = arguments.length; i < len; i++) {
					args[i - 1] = arguments[i];
				}
				for (var i = 0; i < evt.length; i ++) {
					try {
						var _evt = evt[i];
						_evt.fn.apply(this, args);
					} catch (e) {
						
					}
				}
			}
		}
	};
	DesignerUndoSupport.saveOperation=function(prev,next){
		var designer=Designer.instance;
		var arg={};//new Historys.opertion的参数
		if(prev!=null){
			arg['prev']=prev;
		}
		if(next!=null){
			arg['next']=next;
		}else{
			var html=getCurrentHTML();
			arg['next']=function(){
				setNewHTML(html);
			};
		}
		var operation=new Historys.operation(arg);
		historys.add(operation);
	};
	DesignerUndoSupport.getHTML=getCurrentHTML;
	DesignerUndoSupport.setHTML=setNewHTML;
	
	
	


})(window);