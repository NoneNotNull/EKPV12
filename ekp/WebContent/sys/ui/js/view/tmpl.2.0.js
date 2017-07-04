	module.exports = function(str){
		var _s, _sl, _sn, _sd, temp, array, len, identifierstr, value, valuemap, temnum, temarr, keyword, render;

	    if (typeof document === "object"&&typeof navigator === "object"){
	        _s = /msie (\d+\.\d+)/i.test(navigator.userAgent)?(document || + RegExp['$1'])>=8:true;
	    }else{
	        _s = true;
	    }

	    if (_s){
	        _sl = "+=";
	        _sd = "''";
	        _sn = "";
	    }else{
	        _sl = ".push";
	        _sd = "[]";
	        _sn = ".join('')";
	    }

	    function isKeyword(id) {
	        keyword = false;
	        switch (id.length) {
	        case 2:
	            keyword = (id === 'if') || (id === 'in') || (id === 'do');
	            break;
	        case 3:
	            keyword = (id === 'var') || (id === 'for') || (id === 'new') || (id === 'try') || (id === 'let');
	            break;
	        case 4:
	            keyword = (id === 'this') || (id === 'else') || (id === 'case') || (id === 'void') || (id === 'with') ||(id === 'enum') || (id==='null') || (id === "Date") || (id === "Math");
	            break;
	        case 5:
	            keyword = (id === 'while') || (id === 'break') || (id === 'catch') || (id === 'throw') || (id === 'const') || (id === 'yield') || (id === 'class') || (id === 'export') || (id === 'import') || (id === 'super') || (id === "isNaN") || (id === "Array") || (id === "Error") || (id === "alert");
	            break;
	        case 6:
	            keyword = (id === 'return') || (id === 'typeof') || (id === 'delete') || (id === 'switch') || (id === 'public') || (id === 'static') || (id === "window") || (id === "Number") || (id === "Object") || (id==="RegExp") || (id === "Global") || (id === "String");
	            break;
	        case 7:
	            keyword = (id === 'default') || (id === 'finally') || (id === 'package') || (id === 'private') || (id === 'extends') || (id === "Boolean");
	            break;
	        case 8:
	            keyword = (id === 'function') || (id === 'continue') || (id === 'debugger') || (id === "parseInt");
	            break;
	        case 9:
	            keyword = (id === 'interface') || (id === 'protected') || (id === 'undefined') || (id === "arguments");
	            break;
	        case 10:
	            keyword = (id === 'instanceof') || (id === 'implements') || (id === "parseFloat");
	            break;
	        }
	        return keyword;
	    }
	    
	    function analyze(text){
	        temnum=-1;
	        temarr=[]; 
	        temp =  text.replace(/{\%([\s\S]*?)\%}/g,function(a,b){
	            temarr[++temnum] = '");_YayaTemplateString'+_sl+'('+b+');_YayaTemplateString'+_sl+'("';
	            return "YayaTemplateFLAG"+temnum
	        }).replace(/{\$([\s\S]*?)\$}/g,function(a,b){
	            return '_YayaTemplateString'+_sl+'("'+b.replace(/("|\\|\r|\n)/g,"\\$1")+'");';
	        }).replace(/YayaTemplateFLAG(\d+)/g,function(a,b){
	            return temarr[b];
	        });
	        array = temp.replace(/"([^\\"]|\\[\s\S])*"|'([^\\']|\\[\s\S])*'/g,"").replace(/\.[\_\$\w]+/g,"").match(/[\_\$a-zA-Z]+[0-9]*/g);
	        valuemap = {};
	        identifierstr = '';
	        if(array!=null){
		        len = array.length;
		        while(len--){
		            value = array[len];
		            if (!valuemap[value]&&!isKeyword(value))
		            {
		                identifierstr+=value+'=_YayaTemplateObject["'+value+'"],';
		                valuemap[value] = true;
		            }
		        }
	        }
	        var funBody = "var "+identifierstr+"_YayaTemplateString="+_sd+";"+temp+" return _YayaTemplateString"+_sn+";";
	        return funBody;
	    }
    	
	    return {
	        render:new Function("_YayaTemplateObject",analyze(str))
	    };
	};
	 