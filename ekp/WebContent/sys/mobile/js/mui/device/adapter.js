/*******************************************************************************
 * 功能：外部设备接入适配器
 * 
 ******************************************************************************/
define( [ "mui/device/device", "dojo/_base/lang", "mui/device/weixinapi",
		"mui/device/kkapi", "mui/device/kk5api", "mui/device/webapi" ], function(device, lang,
		weixinapi, kkapi, kk5api, webapi) {
	var defaultApi = lang.clone(webapi);
	var deviceType = device.getClientType();
	if (deviceType == 6) {						//微信
		return lang.mixin(defaultApi, weixinapi);
	}
	if (deviceType == 7 || deviceType == 8) {	//kk
		return lang.mixin(defaultApi, kkapi);
	}
	if(deviceType == 9 || deviceType == 10){  //kk5
		return lang.mixin(defaultApi, kk5api);
	}
	return defaultApi;
});