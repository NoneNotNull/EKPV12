/*
 * 用于微信客户端对应功能接口调用
 */
define(["dojo/request","mui/util", "mui/i18n/i18n!sys-attachment"], function(request, util, Msg) {
		var wenxinApi = {
			
			download : function(options) {
				var isWechatAndriod = function() {
					var ua = navigator.userAgent.toLowerCase();
					if (ua.indexOf('android') > -1) {
						return true;
					} 
					return false;
				};
				if (!isWechatAndriod()){
					location.href = util.formatUrl(options.href);
					return;
				}
					
				var params = "{\"fdFileId\" : \"" + options.fdId
						+ "\", " + "\"fdFileName\" : \""
						+ options.name + "\", "
						+ "\"fdContentType\" : \"" + options.type
						+ "\"}";
				var url = util
						.formatUrl("/third/wechat/wechatLoginHelper.do?method=wechatDownload&params="
								+ params);
				var promise = request.post(url);
				alert(Msg['mui.sysAttMain.msg.wechatDownload']);
			}
		};
		
		return wenxinApi;
	});
