;(function() {
	
	window.jsPlumbDemo = {
		init : function() {
			// 设置点、线的默认样式
			jsPlumb.importDefaults({
				DragOptions : { cursor: 'pointer', zIndex:2000 },
				HoverPaintStyle: { strokeStyle: "#42a62c", lineWidth: 2 },
				ConnectionOverlays: [
					["Arrow", { location: 0.7, id: "arrow", width:6, foldback:0.5 }]
				]
			});		
		
			var tleftColor = "#00f";
			var tleftEndpoint = {
				endpoint:["Dot", {radius:7} ],
				anchor:"RightMiddle",
				paintStyle:{ fillStyle:tleftColor, opacity:0.5 },
				isSource:true,
				connectorStyle:{ strokeStyle:tleftColor, lineWidth:2 },
				connector : "Straight",
				isTarget:false,				
				maxConnections:50
			};
			var trightColor = "#ff0000";
			var trightEndpoint = {
				endpoint:["Dot", {radius:7} ],
				anchor:"LeftMiddle",
				paintStyle:{ fillStyle:trightColor, opacity:0.5 },
				isSource:false,
				connectorStyle:{ strokeStyle:tleftColor, lineWidth:2 },
				connector : "Straight",
				isTarget:true,
				maxConnections:1,
				dropOptions:{ tolerance:'touch',hoverClass:"dropHover", activeClass:"dragActive" }
			};
			
			
			var tleft = jsPlumb.CurrentLibrary.getSelector(".tleft");
			jsPlumb.draggable(tleft);			
			jsPlumb.addEndpoint(tleft, tleftEndpoint);
			
			var tright = jsPlumb.CurrentLibrary.getSelector(".tright");
			jsPlumb.draggable(tright);			
			jsPlumb.addEndpoint(tright, trightEndpoint);
			
			// bind a click listener to each connection; the connection is deleted.
			jsPlumb.bind("dblclick", function(c) { 
				jsPlumb.detach(c); 
			});
			
			
			//var divsWithWindowClass = jsPlumb.CurrentLibrary.getSelector(".tright1");
			//jsPlumb.draggable(divsWithWindowClass);
			// add the third example using the '.tright' class.				
			//jsPlumb.addEndpoint(divsWithWindowClass, trightEndpoint);
			
			jsPlumbDemo.attachBehaviour();			
		},
		
		setTibJsPlumb_endpoint : function() {
			// 设置鼠标移动到圆点变粗
//			$("._jsPlumb_endpoint").bind("mouseover", function(){
//				var topValue = parseInt(this.parentNode.style.top);
//				var leftValue = parseInt(this.parentNode.style.left);
//				var widthValue = parseInt(this.style.width);
//				var heightValue = parseInt(this.style.height);
//				this.parentNode.style.top=topValue-5;
//				this.parentNode.style.left=leftValue-5;
//				this.style.width = (widthValue + 11)+"px";
//				this.style.height = (heightValue + 11)+"px";
//			});
//			$("._jsPlumb_endpoint").bind("mouseout", function(){
//				var topValue = parseInt(this.parentNode.style.top);
//				var leftValue = parseInt(this.parentNode.style.left);
//				var widthValue = parseInt(this.style.width);
//				var heightValue = parseInt(this.style.height);
//				this.parentNode.style.top=topValue+5;
//				this.parentNode.style.left=leftValue+5;
//				this.style.width = (widthValue - 11)+"px";
//				this.style.height = (heightValue - 11)+"px";
//			});
		},
		
		// 设置拉线颜色
		setPaintStyleYellow : function(conn){
			conn.connection.setPaintStyle( {
				strokeStyle : "rgb(255,204,0)",
				lineWidth : "2"
			});
		},
		setPaintStyleRed : function(conn){
			conn.connection.setPaintStyle( {
				strokeStyle : "rgb(255,0,0)",
				lineWidth : "2"
			});
		}
	};
	
})();

