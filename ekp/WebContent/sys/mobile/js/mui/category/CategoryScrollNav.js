define( [ "dojo/_base/declare", "dijit/_WidgetBase" , "dojo/_base/array", "dojo/dom", "dojo/dom-construct" ,
          "dojo/dom-style" , "dojo/topic" , "mui/dialog/Tip" ], function(declare,
		WidgetBase, array, dom, domConstruct, domStyle, topic , Tip) {
			var nav = declare("mui.category.CategoryScrollNav", [ WidgetBase], {
				//高度参考dom元素,计算时使用此dom高度
				refrenceDom : null,
				
				//高度相对dom元素,计算时将减去此dom高度
				absoluteDom : null,
				
				baseClass : 'muiCateNav',
				
				//导航数据
				navDatas: [],
				
				//导航dom元素
				navItems :[],
				
				//对外事件对应的唯一标示
				key:null,
				
				buildRendering : function() {
					this.inherited(arguments);
					if(typeof(this.refrenceDom)=='string'){
						this.refrenceDom = dom.byId(this.refrenceDom);
					}
					if(typeof(this.absoluteDom)=='string'){
						this.absoluteDom = dom.byId(this.absoluteDom);
					}
					this.navDatas=[];
					this.navItems=[];
				},

				postCreate : function() {
					this.inherited(arguments);
					this.subscribe("/mui/view/resized","_resizeNav");
					this.subscribe("/mui/category/addNav","_addNavItem");
				},
				
				_resizeNav:function(srcObj){
					if(srcObj.key==this.key){
						domConstruct.empty(this.domNode);
						var height = this.refrenceDom.offsetHeight;
						var absH = 0;
						if(this.absoluteDom)
							absH = this.absoluteDom.offsetHeight;
						var _self = this;
						array.forEach(this.navDatas,function(txt,idx){
							if(txt!='2' && txt!='4'){
								var navItem = domConstruct.create('span',{"className":"muiCateNavItem",innerHTML:txt},_self.domNode);
								_self.connect(navItem,'click',function(){
									_self._ItemClick({label:txt,refHeight:height});
								});
								_self.navItems.push(navItem);
							}
						});
						if(this.navItems.length>0){
							domStyle.set(this.domNode,{
								'display':'block',
								'top':(this.refrenceDom.offsetTop + absH) +'px',
								'height':(height-absH) + 'px'});
							var toTop = domConstruct.create('span',{"className":"muiCateNavItem"},this.domNode,'first');
							var searchIcon = domConstruct.create('i',{"className":"mui mui-search"},toTop);
							this.connect(toTop,'click','_toTop');
							this.navItems.push(toTop);
							var tmpH = 18;
							if(this.navItems.length>20)
								tmpH = Math.floor((height-absH)/this.navItems.length) ;
							domStyle.set(searchIcon,{'font-size': '12px'});
							domStyle.set(searchIcon,{'height': tmpH + 'px'});
							domStyle.set(searchIcon,{'line-height': tmpH + 'px'});
							array.forEach(this.navItems,function(item){
								domStyle.set(item,{'height':tmpH + 'px','line-height':tmpH + 'px','font-size':'12px'});
							});
						}else{
							domStyle.set(this.domNode,{'display':'none'});
						}
						this.navDatas = [];
						this.navItems = [];
					}
				},
				
				_ItemClick:function(evt){
					Tip.tip({text:evt.label,time:900});
					this.defer(function(){
						topic.publish("/mui/cate/navTo",this,evt);
					},200);
				},
				
				_toTop:function(evt){
					this.defer(function(){
						topic.publish("/mui/view/scrollTo",this);
					},200);
				},
				
				_addNavItem:function(srcObj,evt){
					if(srcObj.key==this.key){
						if(evt && evt.label){
							this.navDatas.push(evt.label);
						}
					}
				},
					
				startup : function() {
					if (this._started) {
						return;
					}
					this.inherited(arguments);
				}
				
			});
			return nav;
});