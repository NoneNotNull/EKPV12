//常用查询
define( [ "dojo/_base/declare", "mui/panel/SlidePanel", "mui/util", "dojo/query"],
		function(declare, SlidePanel, util, query) {
			var query = declare("mui.query.CommonQueryDialogMixin", null, {
				filterURL:null,
				
				redirectURL: null,
				
				SLIDE_PANEL_CLICK : '/mui/panel/slide/click',
				
				//数组，格式对象包含信息，text，dataURL，icon
				store:[],
				
				postCreate : function() {
					this.inherited(arguments);
					this.subscribe(this.SLIDE_PANEL_CLICK,"doValueChange");
				},
			
				doValueChange:function(srcObj, evt){
					if(!this.dealed){
						if(evt && evt.index){
							var selected = this.store[evt.index];
							this.defer(function(){
								window.open(this._formatParam(selected) , "_self");
								this.dealed = false;
							},200);
						}else{
							this.dealed = false;
						}
					}
					this.dealed = true;
				},
				
				show:function(evt){
					var slides = query("#_common_query_panel");
					if(slides.length>0) 
						return;
					var slidePanel = new SlidePanel({id:'_common_query_panel',store:this.store,dir:'right',
						width:'45%',icon:'mui-file-text'});
					document.body.appendChild(slidePanel.domNode);
					slidePanel.startup();
				},
				
				_formatParam:function(item){
					var url = location.href;
					if(this.redirectURL){
						item.text = encodeURIComponent(item.text);
						url =  util.formatUrl(util.urlResolver(this.redirectURL,item));
					}
					return util.setUrlParameter(url,"queryStr",item['dataURL']);
				}
			});
			return query;
	});