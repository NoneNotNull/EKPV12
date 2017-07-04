(function(){
	if(window.domain != null)
		return;

	var domain = {}; 
	
	var cbcount = 0;
	var catchFunction = {};
	var regFunction = {};
	domain.register = function(functionName,func){
		regFunction[functionName] = func;
	};
	domain._receiver = function (evt) {
		var callFunction = domain.toJSON(evt.data);
		var functionName = callFunction.functionName;
		var args = callFunction.args;
		var ret = {};
		if(catchFunction[functionName]){
			ret = catchFunction[functionName].apply(window,args);
		}else if(regFunction[functionName]!= null){
			ret = regFunction[functionName].apply(window,args);			 
		}else{
			//if(window.console)
			//	window.console.log("函数"+functionName+"没有注册");
		}
		if(callFunction.callback != null){
			domain.call(evt.source,callFunction.callback,[ret]);
		} 
    };
    
	if (window.addEventListener)
        window.addEventListener('message', domain._receiver, false);
    else if (window.attachEvent)
    	window.attachEvent('onmessage', domain._receiver);
	
	domain.call = function(win,fn,val,cb){
		var callFunction = {};
		callFunction.functionName = fn;
		callFunction.args = val;
		if(cb!=null){
			callFunction.callback = "__$cb$__"+(cbcount++);
			catchFunction[callFunction.callback] = (cb);
		}
		callFunction = domain.stringify(callFunction);
		if (win && window != win) {
    		if (win.postMessage)
    			win.postMessage(callFunction, '*');
    		return;
    	}
	};
	domain.toJSON = function(str){
		return (new Function("return (" + str + ");"))();
	};
	domain.getParam = function(url, param){
		var re = new RegExp();
		re.compile("[\\?&]"+param+"=([^&#]*)", "i");
		var arr = re.exec(url);
		if(arr==null)
			return null;
		else
			return decodeURIComponent(arr[1]);
	};
	domain.getBodySize = function(){
		var chs = document.body.childNodes;
		var bh = 0;
		var bw = 0;
		for(var i=0;i<chs.length;i++){
			var tbh = chs[i].offsetTop + chs[i].offsetHeight;
			var tbw = chs[i].offsetLeft + chs[i].offsetWidth;
			if(tbh > bh){
				bh = tbh;
			}
			if(tbw > bw){
				bw = tbw;
			}
		}
		return {"width":bw,"height":bh};		
	};
	
	var bodySizeCache = {};
	domain.autoResize = function(){
		domain.resize();
		window.setTimeout(domain.autoResize, 300);
	};
	domain.resize = function(luiid){
		var size = domain.getBodySize();
		//debugger;
		if(size.width===bodySizeCache.width && size.height===bodySizeCache.height){
			return;
		}
		bodySizeCache = size;
		domain.call(parent,"fireEvent",[{
			type:"event", 
			target: (luiid == null ? domain.getParam(window.location.href,'LUIID') : luiid),
			name:"resize",
			data:{
				height: size.height,
				width: size.width				
			}
		}]);
	};
	////////////////////////////
	//以下内容来源与www.json.org
	////////////////////////////
	
	
	var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
    escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
    gap,indent,
    meta = {    // table of character substitutions
        '\b': '\\b',
        '\t': '\\t',
        '\n': '\\n',
        '\f': '\\f',
        '\r': '\\r',
        '"' : '\\"',
        '\\': '\\\\'
    },rep;


	function quote(string) {
	    escapable.lastIndex = 0;
	    return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
	        var c = meta[a];
	        return typeof c === 'string'
	            ? c
	            : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
	    }) + '"' : '"' + string + '"';
	}
	
	
	function str(key, holder) {
	    var i,          // The loop counter.
	        k,          // The member key.
	        v,          // The member value.
	        length,
	        mind = gap,
	        partial,
	        value = holder[key];
	    if (value && typeof value === 'object' &&
	            typeof value.toJSON === 'function') {
	        value = value.toJSON(key);
	    } 
	    if (typeof rep === 'function') {
	        value = rep.call(holder, key, value);
	    } 
	    switch (typeof value) {
	    case 'string':
	        return quote(value);
	    case 'number': 
	        return isFinite(value) ? String(value) : 'null';
	    case 'boolean':
	    case 'null':
			return String(value);
	    case 'object':
			if (!value) {
	            return 'null';
	        }
			gap += indent;
	        partial = [];
			if (Object.prototype.toString.apply(value) === '[object Array]') {
	            length = value.length;
	            for (i = 0; i < length; i += 1) {
	                partial[i] = str(i, value) || 'null';
	            }
	            v = partial.length === 0
	                ? '[]'
	                : gap
	                ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
	                : '[' + partial.join(',') + ']';
	            gap = mind;
	            return v;
	        }
	        if (rep && typeof rep === 'object') {
	            length = rep.length;
	            for (i = 0; i < length; i += 1) {
	                if (typeof rep[i] === 'string') {
	                    k = rep[i];
	                    v = str(k, value);
	                    if (v) {
	                        partial.push(quote(k) + (gap ? ': ' : ':') + v);
	                    }
	                }
	            }
	        } else {
	            for (k in value) {
	                if (Object.prototype.hasOwnProperty.call(value, k)) {
	                    v = str(k, value);
	                    if (v) {
	                        partial.push(quote(k) + (gap ? ': ' : ':') + v);
	                    }
	                }
	            }
	        }
	        v = partial.length === 0
	            ? '{}'
	            : gap
	            ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
	            : '{' + partial.join(',') + '}';
	        gap = mind;
	        return v;
	    }
	}
	domain.stringify = function (value, replacer, space) {
	        var i;
	        gap = '';
	        indent = '';
	        if (typeof space === 'number') {
	            for (i = 0; i < space; i += 1) {
	                indent += ' ';
	            }
	        } else if (typeof space === 'string') {
	            indent = space;
	        }
	        rep = replacer;
	        if (replacer && typeof replacer !== 'function' &&
	                (typeof replacer !== 'object' ||
	                typeof replacer.length !== 'number')) {
	            throw new Error('JSON.stringify');
	        }
	        return str('', {'': value});
	 };
	 function registHotspot(){
		 if (document.addEventListener)
			 document.addEventListener('click', hotspotClick, false);
		 else if (document.attachEvent)
			 document.attachEvent('onclick', hotspotClick);
	 }
	 function hotspotClick(e){
		 var event = e || window.event;
		 if(event){
			 domain.call(parent, 'hotspotClick', [window.location.href, event.clientX, event.clientY]);
		 }
	 }
	 registHotspot();
	 /**
	 if (typeof define === "function" && define.cmd){
		 define(function(require, exports, module) {
			 window.domian = module.exports = domain;
		 });
	 }else{
		 window.domain = domain;
	 }
	 **/
	 window.domain = domain;
})();