(function(seajs, global) {
	var uriCache = {};
	var theme = function(str){
	 	var urls = str.split(";");
	 	var newurl = [];
		for(var i=0;i<urls.length;i++){
			var url = urls[i];
			if(url.substring(0,6)=="theme!"){
			 	url = url.substring(6,url.length);
				newurl.push(seajs.data.themes[url].join(";"));
			}
		}
		return newurl.join(";").split(";");
	 }
	 var load = function(urls,index,callback){
		 
		if(index < urls.length){
			var url = urls[index];
			var xu = [];
			xu.push(seajs.resolve(url))
			seajs.use(xu,function(){
				var x = index+1;
				load(urls,x,callback);
			});
		}else{
			callback();
		}
		 
		//callback();
	}
	
	seajs.on("resolve", function(data) {
		var id = data.id
	    if (!id) return ""
	    var uri = seajs.resolve(id, data.refUri);
		if(id.indexOf("theme!")>=0){
	      uriCache[uri] = id;
	      data.uri = uri;
		}
	});
	seajs.on("request", function(data) {
	    var name = uriCache[data.uri]

	    if (name) {  
	    	data.requested = true;
	    	
	    	//嵌套加载css
			var urls = theme(name);
	    	load(urls,0,data.onRequest);
	    }	 
	});
})(seajs, this);

