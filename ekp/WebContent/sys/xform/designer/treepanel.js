/**********************************************************
功能：控件树
使用：

备注：
	依赖于dTree

作者：傅游翔
创建时间：2009-03-18
**********************************************************/
var Designer_TreePanel = function() {
	this.domElement = document.createElement('div');
//	this.width = '252px';
}

Designer_TreePanel.prototype = {
	
	init : function(panel) {
		this.panel = panel;
		this.designer = panel.owner;
		this.builder = this.designer.builder;
		this.refName = this.panel.owner.id + '.treePanel';
		this.builderName = this.panel.owner.id + '.builder';
		this.attrPanelName = this.panel.owner.id + '.attrPanel';
		
		this.initTitle();
		this.initMain();
		this.initBottomBar();
		this.setTitle(Designer_Lang.treepanelTitle);
		this.panel.open = function() {
			if (this.domElement._clientTop != null) {
				this.domElement.style.top = parseInt(this.domElement._clientTop) + document.body.scrollTop + 'px';
			}
			else if (this.domElement.offsetTop < document.body.scrollTop) {
				this.domElement.style.top = document.body.scrollTop + Designer.absPosition(this.owner.builder.domElement).y + 'px';
			}
			else if (this.domElement.offsetTop > 
				(document.body.scrollTop + document.body.clientHeight)) {
				var top = (document.body.scrollTop + document.body.clientHeight)
						 - this.domElement.offsetHeight;
				top = top < 0 ? 0 : top;
				this.domElement.style.top = (top + 'px');
			}
			else {
				this.domElement.style.top = Designer.absPosition(this.owner.builder.domElement).y + 'px';
			}
			Designer_Panel_Open.call(this);
			this.domElement._clientTop = this.domElement.offsetTop - document.body.scrollTop;
		};
		var _domElement = this.panel.domElement;
		Designer.addEvent(window , 'scroll' , function() {
			if  (_domElement._clientTop != null) {
				_domElement.style.top = parseInt(_domElement._clientTop) + document.body.scrollTop + 'px';
			}
		});
	},

	initTitle : Designer_Panel_Default_TitleDraw,

	initMain : function() {
		var self = this;
		this.mainWrap = document.createElement('div');
		this.mainWrap.className = 'panel_main_tree';
		this.mainBox = document.createElement('div');
		this.mainBox.className = 'panel_main_tree_box';

		this.mainWrap.appendChild(this.mainBox);
		this.domElement.appendChild(this.mainWrap);
		this.setNoControl();

		this.panel.draw = function() {
			self.draw();
		}
	},

	setTitle : Designer_Panel_Default_SetTitle,

	initBottomBar : Designer_Panel_Default_BottomDraw,

	setNoControl: function() {
		this.mainBox.innerHTML = '<center>'+Designer_Lang.treepanelNoControl+'</center>';
		this.mainWrap.style.height = this.mainBox.offsetHeight + 'px';
	},

	_treeId : 0,

	getNodeId: function() {
		return this._treeId ++;
	},

	draw : function() {
		if (this.panel.isClosed) return; // 不执行操作
		this.controls = []; // 当前控件集合
		_d_tree_panel = new dTree('_d_tree_panel');
		this.tree = _d_tree_panel;

		if (this.builder.controls.length == 0) {
			this.setNoControl();
			return;
		}
		this.buildTree(this.builder.controls, -1);
		this.mainBox.innerHTML = '<div style="position : relative">'+ this.tree.toString()+'</div>';
		if (this.mainBox.offsetHeight > 300) {
			this.mainBox.style.height = '300px';
			this.mainBox.style.overflow = 'auto';
		}
		this.mainWrap.style.height = this.mainBox.offsetHeight + 'px';
	},

	buildTree : function(controls, pid) {
		for (var i = 0; i < controls.length; i ++) {
			var c = controls[i];
			this.controls.push(c);
			var _index = this.controls.length - 1;
			var text = (c.info ? c.info.name : '');
			var name = (c.type != 'textLabel' && c.type != 'linkLabel' ? c.options.values.label : c.options.values.content);
			if (name == null) name = text;
			var nodeId = this.getNodeId();
			var title = name;
			
			var hasName = true;
			if (name == null || name == '') {
				name = '<span style=\"color:#f00\">'+Designer_Lang.treepanelNoLabel+'</span>';
				title = Designer_Lang.treepanelNoLabel;
				hasName = false;
			}
			//name = text + name;
			if (name.length > 16 && hasName) name = name.substring(0, 13) + '...';
			if (title.length > 16 && hasName) title = title.substring(0, 13) + '...';
			var n = this.tree.add(
				nodeId, // id
				pid, // pid
				name, // name
				'javascript:Designer_TreePanel.selectControl('+this.builderName+','+this.refName+','+ _index +');',
				title, // title
				null, // target
				null, // icon
				null, // iconOpen
				open, // iconOpen
				this.attrPanelName + '.show()'
			);
			if (Designer_Config && Designer_Config.operations) {
				var opt = Designer_Config.operations[c.type];
				if (opt == null && c.inherit) {
					opt = Designer_Config.operations[c.inherit];
				}
				if (opt) {
					n.iconIndex = 16 * opt.imgIndex;
					n.iconTitle = text;
					n.iconDraw = function(node, status) {
						return '<span title="'
							+node.iconTitle
							+'" style="background:url(style/img/icon.gif) no-repeat 0 -'
							+node.iconIndex+';width:16px;height:16px;"></span>';
					};
				}
			}
			
			this.buildTree(c.children, nodeId);
		}
	}
}
Designer_TreePanel.selectControl = function(builder, treePanel, _index) {
	var control = treePanel.panel.controls[_index];
	if (control == null) return;
	if (control.onUnLock) {
		control.onUnLock();
	}
	builder.selectedControl(control);
}