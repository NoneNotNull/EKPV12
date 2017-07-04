define([
    "dojo/_base/declare",
    "dojo/_base/lang",
    "dojox/mobile/Container",
    "dojox/mobile/SwapView",
    "dojox/mobile/PageIndicator",
    "dojox/mobile/_ItemBase",
    "dojo/query",
    "dojo/_base/array",
	"dojo/dom-class",
	"dojo/dom-construct",
	"dojo/dom-style",
	"dojox/mobile/iconUtils",
	"dojox/mobile/viewRegistry",
	"dojox/mobile/common",
	"dijit/registry"
	], function(declare, lang, Container, SwapView, PageIndicator, _ItemBase, 
			query, array, domClass, domConstruct, domStyle, iconUtils, viewRegistry, com, registry) {
	
	var destroyOperations = function() {
		// 销毁即将流向中的对象
		query("#operationsTDContent, #nextNodeTD").forEach(function(node) {
			array.forEach(registry.findWidgets(node), function(widget) {
				widget.destroy && !widget._destroyed && widget.destroy();
			});
		});
	};
	
	var IconItem = declare([_ItemBase], {
		tag: "li",
		baseClass: "mblIconItem",
		_selStartMethod: "touch",
		_selEndMethod: "none",
		//toggle: true,
		value: null,
		oneHide: false,
		
		buildRendering: function(){
			this.domNode = this.srcNodeRef || domConstruct.create(this.tag);

			if(this.srcNodeRef){
				this._tmpNode = domConstruct.create("div");
				for(var i = 0, len = this.srcNodeRef.childNodes.length; i < len; i++){
					this._tmpNode.appendChild(this.srcNodeRef.firstChild);
				}
			}
			var valueCode = this.value.split(":")[0];
			
			this.set("icon", "mui mui-" + valueCode);
			
			this.iconDivNode = domConstruct.create("div", {className:"mblIconArea " + valueCode}, this.domNode);
			this.iconParentNode = this.iconParentNode = domConstruct.create("div", {className:"mblIconAreaInner"}, this.iconDivNode);
			this.labelNode = domConstruct.create("span", {className:"mblIconAreaTitle"}, this.iconDivNode);

			this.inherited(arguments);
		},
		
		_setIconAttr: function(icon){
			this._set("icon", icon);
			this.iconNode = iconUtils.setIcon(icon, this.iconPos, this.iconNode, this.alt, this.iconParentNode, this.refNode, this.position);
		},
		
		_onClick: function(e) {
			//this.defaultClickAction(e);
			if (this.selected) {
				destroyOperations();
				query("#operationMethodsGroup")[0].value = this.value;
				lbpm.globals.clickOperation(this.value);
				var p = this.getParent().getParent();
				p.setSelectedItem(this.value);
			}
		},
		
		_setSelectedAttr: function(/*Boolean*/selected){
			this.inherited(arguments);
			//domStyle.set(this.iconNode, "opacity", selected ? 0.3 : 1);
			domClass.toggle(this.iconDivNode, "selected", selected);
			if (selected)
				query("#operationsRow").forEach(function(item) {
					item.className = this.value.split(':')[0];
				}, this);
		}
	});
	
	return declare("sys.lbpmservice.mobile.OptionsPane", [Container], {
		
		items: [],
		
		_height: 75,
		
		createItem: function(name, value) {
			var item = new IconItem({label: name, value: value});
			this.items.push(item);
			return item;
		},
		
		createSwapView: function() {
			var view = new SwapView({height:'auto'});
			this.addChild(view);
			return view;
		},
		
		initSwapView: function(view) {
			this.addChild(view);
		},
		
		addOptions: function(options) {
			var view = null;
			array.forEach(options, function(option, i) {
				if (i % 5 == 0) {
					view = this.createSwapView();
				}
				view.addChild(this.createItem(option.name, option.value));
			}, this);
			
			if (query('.mblIconItem', this.domNode).length > 5) {
				var pageIndi = new PageIndicator();
				this.addChild(pageIndi);
				domStyle.set(pageIndi.domNode, {
					top: '7rem',
					position: 'absolute'
				});
			} else {
				domStyle.set(this.domNode, "height", "7.5rem");
			}
		},
		
		clearAll: function() {
			this.items = [];
			array.forEach(this.getChildren(), function(widget) {
				if (widget.destroy) {
					widget.destroy();
				}
			});
		},
		
		setSelectedItem: function(value) {
			array.forEach(this.items, function(item) {
				var val = (item.value == value);
				if (item.selected != val) {
					item.set("selected", val);
				}
			}, this);
		},
		
		resizeView: function() {
			this.defer(function() {
				var sc = viewRegistry.getEnclosingScrollable(this.domNode);
				sc.fixedHeaderHeight = this.domNode.offsetHeight;
				sc.resize();
			}, 0);
		},
		
		refresh: function() {
			var methodsGroup = query("#operationMethodsGroup");
			if (methodsGroup.length == 0) {
				this.clearAll();
				this.domNode.style.display = 'none';
				this.resizeView();
				return;
			}
			var options = methodsGroup[0].options;
			this.clearAll();
			if (options.length == 0) {
				this.domNode.style.display = 'none';
				this.resizeView();
				return;
			}
			var opts = [];
			array.forEach(options, function(option) {
				opts.push({name: option.text, value: option.value});
			}, this);
			this.addOptions(opts);
			this.setSelectedItem(lbpm.defaultOperationType || methodsGroup[0].value);
			if (this.oneHide && this.items && this.items.length < 2) {
				domStyle.set(this.domNode, "display", "none");
			} else {
				domStyle.set(this.domNode, "display", "")
			}
			this.resizeView();
		},
		
		_initOptions: function() {

			query("#operationMethodsRow").style("display", "none");
			var sc = viewRegistry.getEnclosingScrollable(this.domNode);
			if (sc && sc.addFixedBar) {
				sc.addFixedBar(this);
			}
			var domNode = this.domNode;
			var self = this;
			sc.on('beforetransitionin', lang.hitch(this, this.resizeView));
			this.refresh();
			lbpm.events.addListener(lbpm.constant.EVENT_CHANGEWORKITEM, lang.hitch(this, "refresh"));
		},
		
		startup: function() {
			if(this._started){ return; }
			this._initOptions(); // 假设流程初始化先执行
			this.inherited(arguments);
			
			// bind to globle
			lbpm.globals.destroyOperations = destroyOperations;
		},
		
		buildRendering: function() {
			this.inherited(arguments);
			domClass.add(this.domNode, "lbpmOptionsPane");
			domStyle.set(this.domNode, {
				"height": "9rem",
				"overflow": "hidden"
			});
		}
	});
});