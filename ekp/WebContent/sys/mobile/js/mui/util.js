define(["dojo/_base/declare", "dojo/_base/window", "dojo/on", "dojo/query", "mui/base64"], function(declare, win, on, query, base64) {
			var claz = declare("mui.util", null, {
						formatUrl : function(url , isFull) {
							var rtnUrl = "";
							if (url == null) {
								rtnUrl = "";
							}else if (url.substring(0, 1) == '/') {
								rtnUrl = dojoConfig.baseUrl + url.substring(1);
							} else {
								rtnUrl = url;
							}
							if(isFull)
								rtnUrl = this.getHost() + rtnUrl;
							return rtnUrl;
						},
						getHost:function(){
							var host = location.protocol.toLowerCase()+"//" + location.hostname;
							if(location.port!='' && location.port!='80'){
								host = host+ ":" + location.port;
							}
							return host;
						},
						formatText : function(str) {
							if (str == null || str.length == 0)
								return "";
						 	return str.replace(/&/g, "&gt;")
										.replace(/</g, "&lt;")
										.replace(/>/g, "&gt;")
										.replace(/ /g, "&nbsp;")
										.replace(/\'/g,"&#39;")
										.replace(/\"/g, "&quot;")
										.replace(/\n/g, "<br>");
						},
						urlResolver:function(url , params){
							return url.replace(/\!\{([\w\.]*)\}/gi, function (_var , _key) {
								var value=null;		  
								if(params)
							         value = params[_key];  
							     return (value === null || value === undefined) ? "" : value;  
							  });
						},
						//首字母转为大写
						capitalize : function(str) {
							if (str == null || str.length == 0)
								return "";
							return str.substr(0,1).toUpperCase()+str.substr(1);
						},
						getScreenSize: function(){
							return {
								h: win.global.innerHeight||win.doc.documentElement.clientHeight||win.doc.documentElement.offsetHeight,
								w: win.global.innerWidth||win.doc.documentElement.clientWidth||win.doc.documentElement.offsetWidth
							};
						},
						addTopView: function(view) {
							var parent = query('#content .mblView')[0].parentNode;
							if (view && view.domNode) {
								query(parent).append(view.domNode);
							} 
							else if (view && view.nodeType) {
								query(parent).append(view);
							}
						},
						// 获取url对应参数
						getUrlParameter : function(url, param) {
							var re = new RegExp();
							re.compile("[\\?&]" + param + "=([^&]*)", "i");
							var arr = re.exec(url);
							if (arr == null)
								return null;
							else
								return decodeURIComponent(arr[1]);
						},
						
						setUrlParameter : function(url , param , value) {
							var re = new RegExp();
							re.compile("([\\?&]"+param+"=)[^&]*", "i");
							if(value==null){
								if(re.test(url)){
									url = url.replace(re, "");
								}
							}else{
								value = encodeURIComponent(value);
								if(re.test(url)){
									url = url.replace(re, "$1"+value);
								}else{
									url += (url.indexOf("?")==-1?"?":"&") + param + "=" + value;
								}
							}
							if(url.charAt(url.length-1)=="?")
								url = url.substring(0, url.length-1);
							return url;
						},
						
						disableTouch : function(domNode, touchSign){
							if(domNode){
								var disableFun = function(evt){
									evt.preventDefault();
								};
								on(domNode,touchSign,disableFun);
							}
						},
						
						base64Encode : function(str) {
							var val = str;
							if(str != null && str.length > 0)
								str = "\u4241\u5345\u3634{"+ base64.encode(str)+"}";
							if(val != str){
								val = "\u4649\u5820\u4d45" + str;
							}
							return val;
						}
					});
			return new claz();
		});