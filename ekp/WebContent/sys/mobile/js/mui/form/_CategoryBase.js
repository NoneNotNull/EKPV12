define( [ "dojo/_base/declare", "dojo/topic", "dojo/dom", "dojo/dom-construct", "dojo/dom-style",
          "dojo/_base/lang", "dojo/html", "dojo/_base/array", "mui/util", "dojo/touch", "dojox/mobile/_css3"],
		function(declare, topic, dom, domConstruct, domStyle, lang, html, array, util, touch, css3) {
			var cateOpt = declare("mui.form._CategoryBase", null, {
				
				key : null,
				
				type: null,
				
				//当前id值`
				curIds : '',
				
				//显示值
				curNames : '',
				
				splitStr: ';',
				
				//是否多选
				isMul : false,
				
				//模板地址
				templURL : null,
				
				_cateDialogPrefix: '__cate_dialog_',
				
				afterSelect : null,
				
				eventBind : function() {
					topic.subscribe("/mui/category/submit",lang.hitch(this,"returnDialog"));
					topic.subscribe("/mui/category/cancel",lang.hitch(this,"closeDialog"));
					topic.subscribe("/mui/category/clear",lang.hitch(this,"clearDialog"));
				},
				
				returnDialog : function(srcObj , evt){
					if(evt){
						if(srcObj.key == this.key){
							this.curIds = evt.curIds;
							this.curNames = evt.curNames;
							this.closeDialog(srcObj);
							if(this.afterSelect){
								this.afterSelect(evt);
							}
						}
					}
				},
				
				closeDialog : function(srcObj){
					if(this.dialogDiv && srcObj.key == this.key){
						domStyle.set(this.dialogDiv, css3.name('transform'),'translate3d(100%, 0, 0)');
						this.defer(function(){
							if(this.parseResults && this.parseResults.length){
								array.forEach(this.parseResults, function(w){
									if(w.destroy){
										w.destroy();
									}
								});
								delete this.parseResults;
							}
							domConstruct.destroy(this.dialogDiv);
							this.dialogDiv = null;
							this._working = false;
						},410);
					}
				},
				
				clearDialog : function(srcObj){
					if(srcObj.key == this.key){
						this.curIds = "";
						this.curNames = "";
						this.closeDialog(srcObj);
					}
				},
				
				_selectCate: function() {
					if(this.templURL && !this._working){
						var dialogId = this._cateDialogPrefix + this.key;
						this._working = true;
						this.dialogDiv = dom.byId(dialogId);
						if(this.dialogDiv == null){
							var _self = this;
							require(["dojo/text!" + util.urlResolver(this.templURL , this)], function(tmplStr){
								_self.dialogDiv = domConstruct.create("div" ,{id:dialogId, className:'muiCateDiaglog'},document.body,'last');
								util.disableTouch(_self.dialogDiv , touch.move);
								var dhs = new html._ContentSetter({
									node:_self.dialogDiv,
									parseContent : true,
									cleanContent : true,
									onBegin : function() {
										this.content = lang.replace(this.content,{categroy:_self});
										this.inherited("onBegin",arguments);
									}
								});
								dhs.set(tmplStr);
								dhs.parseDeferred.then(function(results) {
									_self.parseResults = results;
									domStyle.set(_self.dialogDiv, css3.name('transform'),'translate3d(0, 0, 0)');
								});
								dhs.tearDown();
							});
						}
					}
				}
			});
			return cateOpt;
		});