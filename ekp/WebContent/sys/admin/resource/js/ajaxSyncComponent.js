// ajax异步请求顺序执行，依赖jquery.js
function ajaxSyncComponent(_url) {
	return {
		url : _url,
		count : 0, // 总数量
		index : 0, // 当前运行索引
		datas : new Array(),
		isStop : false, // 是否停止
		addData : function(_params) {
			this.datas[this.count] = _params;
			this.count += 1;
			return this;
		},
		traverse : function(obj) { // 遍历
			if (!obj) {
				obj = this;
			}
			var data = obj.datas[obj.index];
			if (!data || obj.isStop) {
				if (obj.onComplate) {
					obj.onComplate(obj);
				}
				obj.clear(obj);
				return;
			}
			if (obj.beforeRequest) {
				obj.beforeRequest(obj);
			}
			obj.index += 1;
			var params = {};
			for ( var k in data) {
				if (typeof data[k] == "object") {
					params[k] = JSON.stringify(data[k]);
					continue;
				}
				params[k] = data[k];
			}
			$.post(obj.url, params, function(data, status) {
				if (obj.afterResponse) {
					obj.afterResponse(data, obj);
				}
				obj.traverse(obj);
			}, "json");
		},
		stop : function() {
			this.isStop = true;
			return this;
		},
		clear : function(obj) {
			if (!obj) {
				obj = this;
			}
			obj = null;
		},
		beforeRequest : null, // 请求前事件
		afterResponse : null, // 响应后事件
		onComplate : null // 完成后事件
	};
}