/*压缩类型：标准*/
function createAjaxObj(){
	var ajaxObj = null;
	if (window.XMLHttpRequest) {
		ajaxObj = new XMLHttpRequest();
 	} else if (window.ActiveXObject) {
 		var requestArray = ["Msxml2.XMLHTTP","Microsoft.XMLHTTP"];
 		for ( var i = requestArray.length - 1; ajaxObj == null && i >= 0; i--) {
 			try {
 				ajaxObj = new ActiveXObject(requestArray[i]);
 			} catch (e) {
 			}
 		}
 	}
 	return ajaxObj;
}
function successAlert(successStr){
	var _id = "_top_layer_div_success";
	var domObj = document.getElementById(_id);
	if(domObj!=null){
		document.body.removeChild(domObj);
	}else{
		domObj = document.createElement("DIV");
		domObj.id = _id ;
		domObj.className = "topLayer";
		var getWidth = function(obj){
			var widthTmp = obj.offsetWidth;
			if(widthTmp==null || widthTmp==0)
				widthTmp = obj.clientWidth?obj.clientWidth:widthTmp;
			return (widthTmp-domObj.offsetWidth)/2;
		};
	
		domObj.innerHTML = "<div class='innerTopLayer'></div>"+(successStr==null?"":successStr);
		document.body.appendChild(domObj);
		domObj.style.top = (document.body.scrollTop + 150) + "px";
		domObj.style.left = getWidth(document.body)+"px";
		setTimeout("successAlert();", 1000);
	}
}
function Map() {
	this.arr = new Array();
	this.get = function(key) {
		for ( var i = 0; i < this.arr.length; i++) {
			if (this.arr[i].key === key) {
				return this.arr[i].value;
			}
		}
		return null;
	};
	
	this.put = function(key, value) {
		for ( var i = 0; i < this.arr.length; i++) {
			if (this.arr[i].key === key) {
				this.arr[i].value = value;
				return;
			}
		}
		this.arr[this.arr.length] = new _Map_struct(key, value);
	};
	
	this.remove = function(key) {
		var v;
		for ( var i = 0; i < this.arr.length; i++) {
			v = this.arr.pop();
			if (v.key === key) {
				continue;
			}
			this.arr.unshift(v);
		}
	};
	
	this.size = function() {
		return this.arr.length;
	};
	
	this.modify = function(key, value) {
		for ( var i = 0; i < this.arr.length; i++) {
			if (this.arr[i].key === key) {
				this.arr[i].value = value;
				return true;
			}
		}
		return false;
	};
	
	this.isEmpty = function() {
		return this.arr.length <= 0;
	};
	
	function _Map_struct(key, value) {
		this.key = key;
		this.value = value;
	};
}
