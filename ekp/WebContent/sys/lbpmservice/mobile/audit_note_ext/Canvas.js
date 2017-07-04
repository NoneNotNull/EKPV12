define(["dojo/_base/declare", "dojo/touch", "dojo/dom-geometry",], 
        function(declare, touch, domGeom) {
	return declare("sys.lbpmservice.mobile.audit_note_ext.Canvas", null, {
		
		domCanvas:null,
		
		context:null,
		
		offsetPos : null,
		
		lastPos : null,
	
		isPress : false,
		
		constructor : function(canvas) {
			this.inherited(arguments);
			this.domCanvas = (canvas || document.createElement('canvas'));
			this.init();
			this.bindEvents();
		},
		
		init:function(){
			this.context = this.domCanvas.getContext("2d");
		},
		
		getContext:function(){
			return this.context ;
		},
		
		getDomCanvas:function(){
			return this.domCanvas ;
		},
		
		clearRect:function(){
			this.context.clearRect(0, 0, this.domCanvas.width, this.domCanvas.height);
		},
		
		toDataURL:function(fileType){
			return this.domCanvas.toDataURL(fileType);
		},
		
		drawImage:function(img){
			var x=0,y=0;
			var width = this.domCanvas.width;
			var height = this.domCanvas.height;
			var imgW = img.width;
			var imgH = img.height;
			if(width>imgW){
				x = (width-imgW)/2;
				width = imgW;
			}else{
				x = 0;
			}
			if(height > imgH){
				y = (height-imgH)/2;
				height = imgH;
			}else{
				y = 0;
			}
			this.context.drawImage(img,x,y,width,height);
		},
		
		bindEvents:function(){
			var self = this;
			touch.press(this.domCanvas, function(e) {
				self.start(e);
				e.preventDefault();
			});
			touch.move(this.domCanvas,function(e){
				self.move(e);
				e.preventDefault();
			});
			touch.release(this.domCanvas, function(e) {
				self.end();
				e.preventDefault();
			});
		},
		
		start:function(e){
			this.offsetPos = domGeom.position(this.domCanvas);
			this.isPress = true;
		},
		
		move:function(e){
			if(!this.isPress) return;
			 var tmpPost = {x: e.pageX - this.offsetPos.x, y: e.pageY - this.offsetPos.y};
			 if(this.lastPos != null){
				 this.context.lineJoin = "round";
				 this.context.lineCap = "round";
				 this.context.beginPath();
				 this.context.moveTo(this.lastPos.x, this.lastPos.y);
				 this.context.lineTo(tmpPost.x, tmpPost.y);
				 this.context.stroke();
			 }
			 this.lastPos = tmpPost;
		},
		
		end:function(e){
			this.isPress = false;
			this.lastPos = null;
		}
	});
});