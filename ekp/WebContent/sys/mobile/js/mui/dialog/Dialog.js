define([ "dojo/_base/declare", "mui/dialog/_DialogBase", "dojo/dom-construct",
		"dojo/dom-style", "dojo/dom-class", "dojo/_base/array",
		"dojo/_base/lang", 'dojo/parser', "mui/iconUtils" ], function(declare,
		_DialogBase, domConstruct, domStyle, domClass, array, lang, parser,
		iconUtils) {

	var claz = declare('mui.dialog.Dialog', [ _DialogBase ], {

		element : null,

		title : '',

		buttons : [],

		callback : null,
		
		onDrawed : null,

		showClass : 'muiDialogElementShow',

		closeClass : 'mui-close mui',

		//是否需要关闭
		canClose : true,

		//是否需要滚动，需要滚动时必须解析
		scrollable : true,
		
		//是否需要解析
		parseable : false,

		// 弹出框内容加载完毕后调整位置
		loaded : function() {
			domStyle.set(this.containerNode, {
				'margin-top' : -(this.containerNode.offsetHeight/2) + 'px',
				'margin-left' : -(this.containerNode.offsetWidth/2) + 'px'
			});
		},

		buildRendering : function() {
			this.inherited(arguments);
			this.domNode = domConstruct.create('div', {
				className : 'muiDialogElement' + (this.showClass!=null?(" " +this.showClass):'' )
			}, document.body, 'last');

			this.containerNode = domConstruct.create('div', {
				className : 'muiDialogElementContainer'
			}, this.domNode);
			// 头部容器
			this.divNode = domConstruct.create('div', {
				className : 'muiDialogElementDiv'
			}, this.containerNode);

			// 标题节点
			this.titleNode = domConstruct.create('div', {
				className : 'muiDialogElementTitle',
				innerHTML : this.title
			}, this.divNode);

			
			if (this.canClose) {
				this.closeNode = iconUtils.setIcon(this.closeClass
						+ ' muiDialogElementClose', null, null, null,
						this.divNode);
				this.connect(this.closeNode, 'click', '_onClose');
			}
			
			// 内容节点
			this.contentNode = domConstruct.create('div', {
				className : 'muiDialogElementContent'
			}, this.containerNode);

			// 创建按钮节点
			if (this.buttons.length > 0) {
				this.buttonsNode = domConstruct.create('div', {
					className : 'muiDialogElementButtons'
				}, this.containerNode);

				this.buttonsDom = [];
				array.forEach(this.buttons, lang.hitch(this, function(item) {
					var btn = domConstruct.create('div', {
						className : 'muiDialogElementButton',
						innerHTML : item.title
					}, this.buttonsNode);
					this.buttonsDom.push(btn);
				}));
				this.connect(this.buttonsNode, 'click', '_onClick');
			}
			
			var _container = this.contentNode;
			var isParse = this.parseable;
			if (this.scrollable) {
				_container = domConstruct.create('div', {
					'data-dojo-type' : 'dojox/mobile/ScrollableView',
					'data-dojo-props' : 'scrollBar:true,height:\'100%\''
				}, this.contentNode);
				isParse = true;
			}
			domConstruct.place(this.element, _container);
			if(isParse){
				var self = this;
				parser.parse(this.contentNode).then(function(widgetList) {
					self.htmlWdgts = widgetList;
					self.loaded();
					if(self.onDrawed){
						self.onDrawed(self);
					}
				});
			}else{
				this.loaded();
				if(this.onDrawed){
					this.onDrawed(this);
				}
			}
			
		},

		_onClick : function(evt) {
			var target = evt.target;
			for (var i = 0; i < this.buttonsDom.length; i++) {
				if (target === this.buttonsDom[i]) {
					this.buttons[i].fn.call(window, this);
					if (this.callback)
						this.callback(window, this);
					break;
				}
			}
		},

		_onClose : function(evt) {
			if (this.callback)
				this.callback(window, this);
			this.hide();
		},

		show : function() {
			return this.inherited(arguments);
		},

		hide : function() {
			this.inherited(arguments);
			array.forEach(this.htmlWdgts,function(wdt){
				if(wdt && wdt.destroy){
					wdt.destroy();
				}
			});
			domConstruct.destroy(this.domNode);
			this.domNode = null;
			this.destroy();
		}
	});

	return {
		element : function(options) {
			var obj = new claz(options);
			return obj.show();
		}
	};

})