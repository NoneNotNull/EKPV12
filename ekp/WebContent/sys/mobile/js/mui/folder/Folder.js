define( [ "dojo/_base/declare", 
          "mui/folder/_Folder",
          "mui/util",
          "dojo/_base/array",
          "dojo/html",
          "dojo/dom-construct",
          "dojo/dom-style",
          "dojo/dom-class",
          "dojo/window",
          "dojo/query",
          "dojo/touch",
          "dojox/mobile/_css3",
          "dojo/topic"], function(declare, _Folder, util, array, html, domConstruct, domStyle, domClass, win, query, touch, css3, topic) {

	return declare("mui.folder.Folder", [_Folder], {
		//展开后，展示页面
		tmplURL: null,
		
		icon : 'mui mui-plus',
		
		HIDE_EVENT : '/mui/folder/hide',
		
		SHOW_EVENT: '/mui/folder/show',
		
		_scollTempl : "<div data-dojo-type=\"dojox/mobile/ScrollableView\" "
						+"data-dojo-props=\"scrollBar:true,height:'100%'\" class=\"muiFolderView\">!{tmplInfo}</div>",
		
		postCreate : function() {
			this.inherited(arguments);

		},
		
		hideStyle:{},
		
		showStyle:{},
		
		startup : function() {
			this.inherited(arguments);
			this.hideStyle[css3.name('transform')] = 'translate3d(0, -50%, 0)';
			this.showStyle[css3.name('transform')] = 'translate3d(0, 0, 0)';
		},
		
		show:function(evt){
			if(this._showed){
				this.hide();
				return ;
			}
			var topH = this.domNode.offsetHeight;
			domClass.add(this.domNode,"muiFolderRotate muiFolderRotate135");
			if(this.expandDiv == null){
				this.expandDiv = domConstruct.create("div", {className : 'muiFolderExpand'}, document.body,'last');
				domStyle.set(this.expandDiv,{top:topH + 'px', height: (win.getBox().h - topH)+'px'});
				if(this.tmplURL!=null && this.tmplURL!=''){
					var _self = this;
					require(["dojo/text!" + util.formatUrl(util.urlResolver(this.tmplURL , this))], function(tmplStr){
						tmplStr = _self._scollTempl.replace("!{tmplInfo}",tmplStr);
						tmplStr = tmplStr.replace("!{topHeight}",topH);
						var dhs = new html._ContentSetter({
							node: _self.expandDiv,
							parseContent : true,
							cleanContent : true
						});
						dhs.set(tmplStr);
						dhs.parseDeferred.then(function(results) {
							_self.parseResults = results;
							var viewDom = query(".muiFolderView", _self.expandDiv);
							domStyle.set(viewDom[0], _self.showStyle);
							_self._showed = true;
							topic.publish(_self.SHOW_EVENT,_self,{});
						});
						dhs.tearDown();
					});
				}
			}else{
				domStyle.set(this.expandDiv,{display:'block'});
				domStyle.set(this.expandDiv,{top:topH + 'px', height: (win.getBox().h-topH)+'px'});
				var viewDom = query(".muiFolderView", this.expandDiv);
				domStyle.set(viewDom[0], this.showStyle);
				this._showed = true;
				topic.publish(this.SHOW_EVENT,this,{});
			}
			this.expandHandle = this.connect(document.body, touch.press, 'hide');
		},
		
		hide:function(evt){
			topic.publish(this.HIDE_EVENT,this,{});
			if((evt && evt.target==this.domNode) || this.expandDiv == null){
				return ;
			}
			if(this._showed != true) return;
			domClass.remove(this.domNode,"muiFolderRotate muiFolderRotate135");
			var viewDom = query(".muiFolderView", this.expandDiv);
			domStyle.set(viewDom[0], this.hideStyle);
			this.defer(function(){
				domStyle.set(this.expandDiv,{display:'none'});
			},410);
			if(this.expandHandle){
				this.expandHandle.remove();
			}
			this._showed = false;
		}
	});
});
