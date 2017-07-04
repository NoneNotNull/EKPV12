define(	["dojo/_base/declare", "dojo/dom-construct", "dojo/dom-class",
				"dojo/topic", "dojox/mobile/_ItemBase", "mui/util", "mui/iconUtils"],
		function(declare, domConstruct, domClass, topic, ItemBase, util, iconUtils) {
			var item = declare("mui.category.CategoryItemMixin", [ItemBase], {

						fdId : '',
						
						//名称
						label : '',
						
						// 文档附件类型
						icon : '',
						
						//组织架构,类别,模板类型
						type : null,
						
						//是否是分类
						header : "false",
						
						tag : 'li',
						
						//事件key
						key : null,
						
						_enterClass:'mblListItemSelected',
						
						buildRendering : function() {
							this._templated = !!this.templateString;
							if (!this._templated) {
								this.domNode = this.containerNode = this.srcNodeRef
										|| domConstruct.create(this.tag, {
											className : 'muiCateItem'
										});
								var className = 'muiCateInfoItem';
								if(this.header == 'true'){
									className = ' muiGroupItem';
								}
								this.contentNode = domConstruct.create(
										'div', {
											className : className
										}, this.domNode);
							}
							this.inherited(arguments);

							if (!this._templated)
								this._buildItemBase();
						},
						
						postCreate : function() {
							this.inherited(arguments);
							this.subscribe('/mui/category/cancelSelected','_cancelSelected');
							this.subscribe('/mui/category/setSelected','_setSelected');
						},
						
						//构建基本框架
						_buildItemBase : function() {
							this.cateContainer = domConstruct.create("div",{className:"muiCateContainer"},this.contentNode);
							if(this.header != 'true' ){
								this.iconNode = domConstruct.create('div', {
												'className' : 'muiCateIcon'
											}, this.cateContainer);
								this.buildIcon(this.iconNode);
								this.infoNode = domConstruct.create('div', {
												'className' : 'muiCateInfo'
											}, this.cateContainer);
								this.titleNode = domConstruct.create('div', {
												'className' : 'muiCateName',
												'innerHTML' : this.label 
											}, this.infoNode);
								this.connect(this.iconNode,"click","_selectCate");
								this.connect(this.infoNode,"click","_selectCate");
							}else{
								this.titleNode = domConstruct.create('div', {
									'className' : 'muiCateName muiCateTitle',
									'innerHTML' : this.getTitle()
								}, this.cateContainer);
							}
							this.moreArea = domConstruct.create("div",{className:"muiCateMore"},this.cateContainer);
						},

						startup : function() {
							if (this._started) {
								return;
							}
							this.inherited(arguments);
							var parent = this.getParent();
							this.key = parent.key;
							if(this.header != 'true' ){
								if( parent.showMore && this.showMore()){		//构建更多
									domConstruct.create("i",{className:"mui mui-forward"},this.moreArea);
									this.connect(this.moreArea,"click","_openCate");
								}
								
								if(parent.selType!=null){	//构建选择区域
									this.selectArea = domConstruct.create('div', {
											'className' : 'muiCateSelArea'
										}, this.cateContainer,'first');//用于占位
									if(this.showSelect()){
										 this.selectNode = domConstruct.create('div', {
												'className' : 'muiCateSel'
											}, this.selectArea);
										 if(this.isSelected()){
											 this.checkedIcon= domConstruct.create('i', {
													'className' : 'mui mui-checked muiCateSelected'
												}, this.selectNode);
											 domClass.add(this.selectNode,"muiCateSeled");
										 }
										 this.connect(this.selectArea,"click","_selectCate");
									}
								}
							}else{
								topic.publish("/mui/category/addNav",this,{label:this.label});
							}
						},
						
						_openCate:function(evt){
							this.set("entered", true);
							this.defer(function(){
								this.set("entered", false);
								topic.publish("/mui/category/changed",this,{
									'fdId':this.fdId,
									'label':this.label
								});
							}, 200);
							return;
						},
						
						_cancelSelected:function(srcObj , evt){
							if(srcObj.key==this.key){
								if(evt && evt.fdId){
									if(evt.fdId.indexOf(this.fdId)>-1){
										if(this.checkedIcon){
											 domClass.remove(this.selectNode,"muiCateSeled");
											 domConstruct.destroy(this.checkedIcon);
											 this.checkedIcon= null;
											 topic.publish("/mui/category/unselected",this,{
													'label':this.label,
													'fdId':this.fdId,
													'icon':this.icon,
													'type':this.type
												});
										}
									}
								}
							}
						},
						
						_setSelected:function(srcObj,evt){
							if(srcObj.key==this.key){
								if(evt && evt.fdId){
									if(evt.fdId==this.fdId){
										domClass.add(this.selectNode,"muiCateSeled");
										this.checkedIcon= domConstruct.create('i', {
											'className' : 'mui mui-checked muiCateSelected'
										}, this.selectNode);
										this.set("entered", true);
										this.defer(function(){
											this.set("entered", false);
										},200);
										topic.publish("/mui/category/selected",this,{
											'label':this.label,
											'fdId':this.fdId,
											'icon':this.icon,
											'type':this.type
										});
								     }
								}
							}
						},
						
						_selectCate:function(evt){
							if(evt){
								if (evt.stopPropagation)
									evt.stopPropagation();
								if (evt.cancelBubble)
									evt.cancelBubble = true;
								if (evt.preventDefault)
									evt.preventDefault();
								if (evt.returnValue)
									evt.returnValue = false;
							}
						
							if(this.selectArea){
								if(this.selectNode){//存在选择区域时设置是否选中
									if(this.checkedIcon != null){
										this._cancelSelected(this,this);
									}else{
										this._setSelected(this,this);
									}
									return;
								}
							}
							if(this.showMore()){
								this._openCate();
							}else{
								this.showItemDetail();
							}
							return;
						},
						
						//获取分组标题信息
						getTitle:function(){
							return this.label;
						},
						
						//是否显示往下一级
						showMore : function(){
							return true;
						},
						
						//是否显示选择框
						showSelect:function(){
							return true;
						},
						
						//是否选中
						isSelected:function(){
							return true;
						},
						
						showItemDetail:function(){
							
						},
						
						buildIcon:function(iconNode){
							if(this.icon){
								iconUtils.setIcon(this.icon, null,
										this._headerIcon, null, iconNode);
							}
						},
						
						_setLabelAttr : function(text) {
							if (text)
								this._set("label", text);
						},
						
						_setEnteredAttr: function(entered){
							domClass.toggle(this.domNode, this._enterClass, entered);
						}
					});
			return item;
		});