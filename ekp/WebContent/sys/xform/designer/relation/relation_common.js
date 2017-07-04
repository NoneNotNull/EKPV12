function ModelDialog_Show(url,data,callback){
	this.AfterShow=callback;
	this.data=data;
	this.width=600;
	this.height=400;
	this.url=url;
	this.setWidth=function(width){
		this.width=width;
	};
	this.setHeight=function(height){
		this.height=height;
	};
	this.setCallback=function(action){
		this.callback=action;
	};
	this.setData=function(data){
		this.data=data;
	};
	
	this.show=function(){
		var obj={};
		obj.data=this.data;
		obj.AfterShow=this.AfterShow;
		Com_Parameter.Dialog=obj;
		var left = (screen.width-this.width)/2;
		var top = (screen.height-this.height)/2;
		
		var winStyle = "resizable=1,scrollbars=1,width="+this.width+",height="+this.height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		var win= window.open(this.url, "_blank", winStyle);
		try{
			win.focus();
		}
		catch(e){
			
		}
		//用window.open 达到模态效果
		window.onfocus=function (){
			try{
				win.focus();
			}catch(e){
				
			}
		};
	    window.onclick=function (){
	    	try{
				win.focus();
			}catch(e){
				
			}
	    };
	};
	
}