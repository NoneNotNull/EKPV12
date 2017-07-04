//how to use?  KmsTemplate("xxx").render({});

var KmsTmpl = KmsTmpl || function(str){
			//核心分析方法
			var  _analyze = function(text){
					return text.replace(/{\$(\s|\S)*?\$}/g,function(s){	
								return s.replace(/("|\\)/g,"\\$1")
												.replace("{$",'_s.push("')
												.replace("$}",'");')
												.replace(/{\%([\s\S]*?)\%}/g, '",$1,"');
					}).replace(/\r|\n/g,"");
			};
			var _ajax = function(requestUrl){ 
				var returnText = "";
				if(window.tmplateCache == null){
					window.tmplateCache = [];
				}
				if(window.tmplateCache[requestUrl] != null){
					returnText = window.tmplateCache[requestUrl];
				}else{
					var http = {};
					if (window.XMLHttpRequest){
						http=new XMLHttpRequest();
					}else if (window.ActiveXObject){
						http=new ActiveXObject("Microsoft.XMLHTTP");
					}
					http.open("GET", requestUrl, false);
					http.setRequestHeader("Accept", "text/plain");
					http.setRequestHeader("Content-Type","text/plain; charset=utf-8")
					http.send(null); 
					returnText = http.responseText;
					window.tmplateCache[requestUrl] = returnText;
				}
				return returnText; 
			};
			var _getTemplate = function(str){
				//中间代码
				var template = "";
				var tempObj = document.getElementById(str);
				if(tempObj){
					if(tempObj.getAttribute("src") && tempObj.getAttribute("src").length > 0){
						template = _ajax(tempObj.getAttribute("src"));
					}else{
						template = tempObj.innerHTML;
					}
				}else if(str.substr(0,4)=="src:"){
					template = _ajax(str.substr(4,str.length));
				}else{				
					template = str;
				}
				return template;
			};
			var _temp = _analyze(_getTemplate(str));
			//返回生成器render方法
			return {render:function(mapping){
						var _a = []; 
						var _v = []; 
						var i;
						for(i in mapping){
							_a.push(i);
							_v.push(mapping[i]);
						}
						return (new Function(_a,"var _s=[];"+_temp+" return _s;")).apply(null,_v).join("");
					}
			};
};