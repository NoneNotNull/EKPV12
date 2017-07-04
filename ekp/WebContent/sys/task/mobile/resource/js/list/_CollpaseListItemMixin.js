define([
    "dojo/_base/declare",
    "dojo/ready",
    "dojo/dom-construct",
    "dojo/dom-style",
    "dojo/dom-attr",
    "mui/util"
	], function(declare,ready,domConstruct,domStyle,domAttr,util) {
	
	return declare("sys.task.list._CollpaseListItemMixin", null , {
		
		maxCount:3,
		
		collpase:true,
		
		buildRendering:function(){
			this.inherited(arguments);
			var self=this,
				maxCount=this.maxCount;
			
			this.url=util.setUrlParameter(this.url,'rowsize',maxCount);
			
			this.subscribe('/mui/list/loaded', function(widget,items){
				if(this == widget ){
					//var children=widget.getChildren();
					//总数超过maxcount，多余行隐藏(点击可展开)
					var page=items.page,
						leftCount=page.totalSize-(page.currentPage*page.pageSize);
					if(self.collpase && leftCount > 0){
						//for(var i=maxCount;i<children.length;i++){
						//	domStyle.set(children[i].domNode,'display','none');
						//}
						self.buildToggleDom(items);//构造展开节点
					}else{
						self.collpase=false;
						self.buildToggleDom(items);//销毁展开节点
					}
				}
			});
		},
		
		buildToggleDom:function(items){
			if(!this.toggleDom){
				this.toggleDom=domConstruct.create('li',{className:'toggle'},this.domNode,'last');
				domStyle.set(this.toggleDom,{
					'text-align':'center',
					'margin':'0.5rem 0'
				});
				this.connect(this.toggleDom,'click','___toggle');
			}
			if(this.collpase){
				//折叠情况,显示dom为展开
				var page=items.page,
					leftCount=page.totalSize-(page.currentPage*page.pageSize);
				domConstruct.empty(this.toggleDom);
				domAttr.set(this.toggleDom,'innerHTML','还有'+leftCount+'项');
				domConstruct.create('i',{className:'mui mui-down-n'},this.toggleDom);
			}else{
				domConstruct.destroy(this.toggleDom);
				//domAttr.set(this.toggleDom,'innerHTML','');
				//domConstruct.create('i',{className:'mui mui-up-n'},this.toggleDom);
			}
		},
		
		___toggle:function(){
			if(this.collpase){
				
				if(this._loadOver){
					
				}else{
					this.loadMore();
				}
				
				//for(var i=this.maxCount;i<children.length;i++){
				//	domStyle.set(children[i].domNode,'display','block');
				//}
				//this.collpase=false;
			}else{
				//for(var i=this.maxCount;i<children.length;i++){
				//	domStyle.set(children[i].domNode,'display','none');
				//}
				//this.collpase=true;
			}
			//this.buildToggleDom();
		},
		

		buildNoDataItem:function(){
			//不做nodata处理...
		},
		
		handleOnPush:function(){
			//滑动到底部不刷加载更多操作
		}
		
	});
});