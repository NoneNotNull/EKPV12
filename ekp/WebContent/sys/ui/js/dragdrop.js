define(function(require, exports, module) {	 
	var $ = require("lui/jquery");
	var Class = require("lui/Class");
	var ddmanager = {
		//是否处于拖动中
		__isDrag : false,
		
		//拖动中的临时对象
		__Drag : null,
		__Mark : null,
		
		//拖动过程中经过的对象
		__Drop : [],
		//拖动过程中最靠近鼠标坐标的Drop对象
		__ClosestDrop:null,
		
		__x : null,
		__y : null,
		__offsetY : null,
		__offsetX : null
	};
	var Droppable = new Class.create({
		initialize : function(_config) {
			this.config = _config;
			this.body = this.config.body || $(document.body);
			this.element = this.config.element;
			this.isOver = false;
			this.isActive = false;
			this.startDrop();
		},
		startDrop : function(){	
			ddmanager.__Drop.push(this);			
		},
		onStart : function(){
			if(this.config && this.config.start){
				this.config.start.apply(this);
			}
			this.element.addClass(this.config.activeClass);
		},
		onMove : function(){
			if(this.isActive==false){
				this.onStart();
			}
			this.setOver(this.isMouseover());
		},
		onDrop : function(obj){
			if(this.config && this.config.drop){
				this.config.drop.apply(this,[obj]);
			}
		},
		onEnd : function(obj){
			this.isActive = false;
			if(this.isOver){
				this.onDrop(obj);
			}
			this.element.removeClass(this.config.activeClass);
			this.element.removeClass(this.config.hoverClass);
			this.setOver(false);
			if(this.config && this.config.end){
				this.config.end.apply(this);
			}
		},
		setOver : function(_val){
			if(this.isOver != _val){
				if(_val){
					this.element.addClass(this.config.hoverClass);
					if(this.config && this.config.over){
						this.config.over.apply(this);
					}
				}else{
					this.element.removeClass(this.config.hoverClass);
					if(this.config && this.config.out){
						this.config.out.apply(this);
					}
				}
				this.isOver = _val;
			}
		},
		isMouseover : function(){
			if(false){
				//按照鼠标位置是否处于对象范围内的算法
				var pos = this.element.offset();
				var width = this.element.width();
				var height = this.element.height();
				//判断鼠标是否处于当前元素范围内
				if(ddmanager.__x > pos.left && ddmanager.__x < pos.left + width){
					if(ddmanager.__y > pos.top && ddmanager.__y < pos.top + height){					
						return true;
					}
				}
				return false;
			}else{
				//按照鼠标位置最接近对象坐标点的算法
				if(this == ddmanager.__ClosestDrop){
					return true;
				}else{
					return false;
				}
			}
		}
	});
	var Draggable = new Class.create({
		initialize : function(_config) {
			this.config = _config;
			this.body = this.config.body || $(document.body);
			this.element = this.config.element;
			this.isDrop = this.config.isDrop == null ? true : this.config.isDrop;
			this.isClone = this.config.isClone == null ? true : this.config.isClone;
			this.widget = this.config.drop;
			this.handle = this.config.handle ? this.config.handle : this.element;
			this.startDrag();
		},
		getRelativeOffset :function(obj,objParent){
			var b = $(obj).offset();
			var a = $(objParent).offset();
			return {
				left : b.left-a.left,
				top : b.top - a.top
			};
		},
		startDrag : function(){
			var self = this;
			this._move = function(evt){
					self.onDragMove(evt);
			};
			this._up = function(evt){
					self.onDragEnd(evt);
			};
			self.body.bind("mousedown",function(){
				
			});
			this.handle.mousedown(function(evt){
				self.clear();
				if(evt.which == 1){
					if(evt.target != evt.currentTarget){
						var pos = self.getRelativeOffset(evt.target,evt.currentTarget);
						ddmanager.__offsetX = pos.left + evt.offsetX;
						ddmanager.__offsetY = pos.top + evt.offsetY;
					}else{
						ddmanager.__offsetX = evt.offsetX;
						ddmanager.__offsetY = evt.offsetY;
					}
					//console.log("__offsetY="+ddmanager.__offsetY+",__offsetX="+ddmanager.__offsetX);
					// 拖动中 
					//ddmanager.__isDrag = true;
					//拷贝当前对象放置在拖动管理器中
					//var temp = self.element.offset();
					//console.log("pos1:x="+temp.left+",y="+temp.top);
					//ddmanager.__Drag = self.element.clone(true).off().appendTo(self.body).addClass("dragMove");
					//ddmanager.__Drag.width(self.element.width()).height(self.element.height());
					//ddmanager.__Drag.offset(self.element.offset());
					//ddmanager.__Drag.css("left",temp.left);
					//ddmanager.__Drag.css("top",temp.top);
					//temp = ddmanager.__Drag.offset();
					//console.log("pos2:x="+temp.left+",y="+temp.top);
					//记录鼠标位置
					ddmanager.__x = evt.pageX;
					ddmanager.__y = evt.pageY;
					
					//给document.body对象绑定拖动事件
					self.body.bind("mousemove",self._move);
					self.body.bind("mouseup",self._up);
					self.body.css({"-moz-user-select":"none","-webkit-user-select": "none",'cursor':'move'});
					//debugger;
					//evt.stopPropagation();
				}
			});
		},
		setClosestDropObject : function(){
			//ddmanager.__ClosestDrop = null;
			if(ddmanager.__Drop != null){
				var y=10000000000;
				for(var i=0;i<ddmanager.__Drop.length;i++){
					var pos = ddmanager.__Drop[i].element.offset();
					var width = ddmanager.__Drop[i].element.width();
					var height = ddmanager.__Drop[i].element.height();
					//X坐标在对象范围内的对象
					if(ddmanager.__x > pos.left && ddmanager.__x < pos.left + width){
						var abs = Math.abs(ddmanager.__y - pos.top);
						if(abs<y){					
							y=abs;
							ddmanager.__ClosestDrop = ddmanager.__Drop[i];
						}
					}
				}
			}
		},
		onDragMove : function(evt){
			var self = this;

			if(evt.which == 1){
				if(ddmanager.__Mark == null){
					ddmanager.__Mark = $("<div style='position: fixed; top: 0px; bottom: 0px; left: 0px; right: 0px; z-index: 10000000000;'></div>").appendTo(self.body).show();					
				}else{
					ddmanager.__Mark.show();
				}
			//判断是否处于拖动中
			//if(ddmanager.__isDrag){
				evt.stopPropagation();
				ddmanager.__isDrag = true;
				if(document.documentMode != null){
					//console.log("ie");
					ddmanager.__x = evt.clientX;
					ddmanager.__y = evt.clientY + self.body.parent().scrollTop();
				}else{
					//debugger;
					//console.log("||ie");
					ddmanager.__x = evt.clientX;
					ddmanager.__y = evt.clientY + self.body.scrollTop();
				}
				//console.log("self.body[0].scrollTop="+self.body[0].scrollTop);
				//debugger;
				//console.log("evt.pageX="+evt.pageX+";evt.pageY="+evt.pageY);
				//console.log("evt.clientX="+evt.clientX+";evt.clientY="+evt.clientY);
				//debugger;
				var left = ddmanager.__x - ddmanager.__offsetX;
				var top = ddmanager.__y - ddmanager.__offsetY;				
				//debugger;
				if(ddmanager.__Drag ==null){
					//console.log(left+","+top)
					if(self.isClone){
						var temp = self.element.offset();
						ddmanager.__Drag = self.element.clone(true).off().appendTo(self.body).addClass("dragMove");
						ddmanager.__Drag.width(self.element.width()).height(self.element.height());
					}else{						
						ddmanager.__Drag = self.element;
						ddmanager.__Drag.addClass("dragMove");
					}
				}else{
					//console.log("aaa"+left+","+top)
				}
				ddmanager.__Drag.css({"left":left,"top":top});
				if(self.isDrop){
					//处理drop
					if(ddmanager.__Drop != null){
						this.setClosestDropObject();
						for(var i=0;i<ddmanager.__Drop.length;i++){
							ddmanager.__Drop[i].onMove();
						}
					}
				}
			//}else{
			//	this.clear();
			//}
			}
		},
		clear : function(){
			try{
				//debugger;
				if(ddmanager.__Drag!=null){
					if(this.isClone){
						ddmanager.__Drag.remove();
					}
					ddmanager.__Drag = null;
				}
				if(ddmanager.__Mark!=null){
					ddmanager.__Mark.hide();			
				}
				this.body.unbind("mousemove",this._move);
				this.body.unbind("mouseup",this._up);
				this.body.css({"-moz-user-select":"","-webkit-user-select": "",'cursor':'default'});
			}catch(e){
				if(window.console)
					console.log(e);
			}
		},
		onDragEnd : function(){
			//判断是否处于拖动中
			if(ddmanager.__isDrag){
				//debugger;
				if(this.isDrop){
					//处理drop
					if(ddmanager.__Drop != null){
						for(var i=0;i<ddmanager.__Drop.length;i++){
							ddmanager.__Drop[i].onEnd(this.widget);
						}
					}
				}
				ddmanager.__isDrag = false;
				if(this.isClone){
					ddmanager.__Drag.remove();
				}
				ddmanager.__Drag = null;
				if(ddmanager.__Mark){
					ddmanager.__Mark.hide();			
				}
				this.body.unbind("mousemove",this._move);
				this.body.unbind("mouseup",this._up);
				this.body.css({"-moz-user-select":"","-webkit-user-select": "",'cursor':'default'});
			}else{
				//debugger;
				this.clear();
			}
		}
	});
	module.exports.Draggable = Draggable;
	module.exports.Droppable = Droppable;
});