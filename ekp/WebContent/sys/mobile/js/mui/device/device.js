/**
 * 用于客户端设备检查
 */
var device = {
	PC : -1,			//PC端
	
	WEB : 0,			//普通手机web浏览器
	
	WEB_IPHONE:1,       //iphone/ipad手机浏览器，已废弃
	
	EKP_IPHONE:2,       //移动ekp，苹果客户端 
	
	EKP_IPAD:3,			//移动ekp，ipad客户端 
	
	EKP_ANDRIOD:4,		//移动ekp，安卓客户端 
	
	EKP_ANDRIODPAD:5,   //移动ekp，安卓宽频客户端，暂未使用 
	
	THIRD_WEIXIN:6,		//第三方接入，微信客户端
	
	KK_IPHONE:7,		//移动KK，iphone客户端
	
	KK_ANDRIOD:8,		//移动KK，andriod客户端
	
	KK5_IPHONE:9,		//移动KK5，iphone客户端
	
	KK5_ANDRIOD:10,		//移动KK5，andriod客户端
	
	//类型，ua特征标识，是否有做接口支持
	_UA_MAP :[
          {type : 6, value : 'micromessenger'},
          {type : 10, value : 'ekp-i-kk5'},
          {type : 9, value : 'ekp-i-android-kk5'},
          {type : 7, value : 'ekp-i-kk'},
          {type : 8, value : 'ekp-i-android-kk'},
          {type : 4, value : 'ekp-i-android'},
          {type : 5, value : 'ekp-i-hd-android'},
          {type : 3, value : 'ekp-i-hd'},
          {type : 2, value : 'ekp-i'}
	],
	
	__getClientUAKey:function(){
		var ua = window.navigator.userAgent;
		for ( var i = 0; i < this._UA_MAP.length; i++) {
			var uaObj = this._UA_MAP[i];
			if(ua.toLowerCase().indexOf(uaObj.value)>-1){
				return uaObj;
			}
		}
		return null; 
	},

	/**
	 * 获取客户端类型
	 */
	getClientType: function(){
		var _uaKey = this.__getClientUAKey();
		if(_uaKey != null){
			return _uaKey.type;
		}
		return this.WEB; 
	}
	
};

if(window.dojoConfig && window.define) {
	window.define(["mui/i18n/i18n!sys-mobile:sysMobile.pda.comefrom"],function(Msg) {
		device.getClientTypeStr = function(type){
			var typeStr = type!=null ? type:this.getClientType();
			var info = Msg['sysMobile.pda.comefrom.' + typeStr];
			if(info!=null)
				return info;
			else
				return typeStr;
		};
		return device;
	});
}