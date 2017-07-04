define(function(require, exports, module) {
	
	var $=require('lui/jquery');
	
	
	var arrayUtil={};
	
	/**
	 * 唯一
	 */
	arrayUtil.uniquelize=function(a){
		var ra = new Array();  
	     for(var i = 0; i < a.length; i ++){  
	         if($.inArray(a[i],ra)<0){  
	            ra.push(a[i]);  
	         }  
	     }
	     return ra;  
	};
	
	/**
	 * 求两个集合的交集
	 */
	arrayUtil.intersect =function(a,b,unique){
		var ra=new Array();
		for(var i=0 ;i< a.length; i++){
			if(!unique || $.inArray(a[i],ra)<0){
				if($.inArray(a[i],b)>-1 ){
					ra.push(a[i]);
				}
			}
		}
		return ra;
	};
	
	/**
	 * 求两个集合的差集
	 */
	arrayUtil.minus =function(a,b,unique){
		var ra=new Array();
		for(var i=0 ;i< a.length; i++){
			if(!unique || $.inArray(a[i],ra)<0){
				if($.inArray(a[i],b)<0){
					ra.push(a[i]);
				}
			}
		}
		return ra;
	};
	
	/**
	 * 将多个字符串合并成数组，第一个参数为分割符，后面是合并的字符串
	 */
	arrayUtil.convertToArray=function(split){
		var slice=Array.prototype.slice,
			args=slice.call(arguments,0),
			arr=[];
		if(args.length){
			args.shift();//第一个参数为分隔符，剔除
			for(var i=0;i<args.length;i++){
				if(args[i]){
					var ids=args[i].split(split);
					for(var j=0;j<ids.length;j++){
						if(ids[j])
							arr.push(ids[j]);
					}
				}
			}
		}
		return arr;
	};
	
	module.exports = arrayUtil;
	
	
});