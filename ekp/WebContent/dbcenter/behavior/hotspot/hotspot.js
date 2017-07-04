define(function(require, exports, module) {
	var panel = require("lui/panel");
	var $ = require("lui/jquery");
	
	if(Com_Parameter.CurrentPageId==null || window.localStorage==null){
		return;
	}
	
	var data = null;
	var iframe = null;
	var lastClick = null;
	var config = {
		gx : 10,
		gy : 10,
		savePath : Com_Parameter.ContextPath + 'dbcenter/behavior/hotspot.do?',
		graphPath : null,
		user : Com_Parameter.CurrentUserId,
		pageId : Com_Parameter.CurrentPageId,
		version : 1,
		graphing : false,
		cache : {
			key : 'dbcenter_hotspot',
			size : 1800,
			count : 20,
			time : 600000
		}
	};
	
	function initData(){
		return {t:new Date().getTime(), c:0, v:config.version, e:[]};
	}
	
	function filterNoise(x, y, now){
		if(config.graphing){
			return true;
		}
		if(lastClick!=null){
			if(Math.abs(x-lastClick.x)<10 && Math.abs(y-lastClick.y)<10 && now - lastClick.time<1000){
				lastClick.time = now;
				return true;
			}
		}
		lastClick = {x:x, y:y, time:now};
		return false;
	}
	//data={t:Time, c:count, v:version, e:[{u:'user', i:'id', p:[[x,y,count]], w:[[id, index, c]]}]}
	function saveData(x, y, dom){
		//过滤噪音
		var now = new Date().getTime();
		if(filterNoise(x, y, now)){
			return;
		}
		// 取数据
		if(data==null){
			var cache = localStorage.getItem(config.cache.key);
			if(cache!=null){
				data = LUI.toJSON(cache);
			}
		}
		// 校验版本/时间
		if(data==null || data.v!=config.version){
			data = initData();
		}
		if(Math.abs(data.t-now)>config.cache.time){
			sendData(LUI.stringify(data));
		}
		// 计算坐标和点击对象，x轴的起点在屏幕中央
		var env = null;
		var point = [Math.round((x-domain.getBodySize().width/2.0)/config.gx), Math.round(y*1.0/config.gy), 1];
		var widget = searchWidget(dom);
		// 合并值
		for(var i=0; i<data.e.length; i++){
			var _env = data.e[i];
			if(_env.u == config.user && _env.i==config.pageId){
				env = _env;
				for(var j=0; j<env.p.length; j++){
					var _point = env.p[j];
					if(_point[0]==point[0] && _point[1]==point[1]){
						_point[2]++;
						point = null;
						break;
					}
				}
				if(widget!=null){
					for(var j=0; j<env.w.length; j++){
						var _widget = env.w[j];
						if(_widget[0]==widget[0] && _widget[1]==widget[1]){
							_widget[2]++;
							widget = null;
							break;
						}
					}
				}
				break;
			}
		}
		if(env==null){
			env = {u:config.user, i:config.pageId, p:[], w:[]};
			data.e.push(env);
		}
		if(point!=null){
			env.p.push(point);
		}
		if(widget!=null){
			env.w.push(widget);
		}
		data.c++;
		// 保存数据
		var s = LUI.stringify(data);
		if(data.c>=config.cache.count || s.length>config.cache.size){
			sendData(s);
		}else{
			localStorage.setItem(config.cache.key, s);
		}
	}
	function sendData(info){
		if(iframe==null){
			iframe = $('<iframe style="display:none;"></iframe>');
			iframe.appendTo(document.body);
		}
		iframe.attr('src', config.savePath + 'method=record&data='+info);
		localStorage.removeItem(config.cache.key);
		data = initData();
	}
	
	function searchWidget(dom){
		for(var widget = dom; widget!=null; widget = widget.parentNode){
			if(widget.getAttribute){
				if(widget.getAttribute('data-lui-cid')){
					break;
				}
			}
		}
		if(widget==null){
			return null;
		}
		widget = LUI(widget.getAttribute('data-lui-cid'));
		var _panel = null;
		var _content = null;
		for(; widget!=null; widget = widget.parent){
			if(widget instanceof panel.Content){
				_content = widget;
			}else if(widget instanceof panel.AbstractPanel){
				_panel = widget;
				break;
			}
		}
		if(_panel==null || _content==null){
			return null;
		}
		for(var i=0; i<_panel.contents.length; i++){
			if(_panel.contents[i]==_content){
				return [_panel.id, i, 1];
			}
		}
		return null;
	}
	
	function showGraph(){
		if(config.graphPath==null){
			$.ajax({
				url : config.savePath + 'method=server',
				cache : true,
				dataType : 'json',
				success : function(data){
					config.graphPath = data.server + '/hotspot';
					showGraph();
				}
			});
		}else{
			seajs.use([config.graphPath+'/graph.js', config.graphPath+'/graph.css'], function(graph){
				graph.show(config);
			});
		}
	}
	
	function formatPath(path){
		if(path==null){
			return null;
		}
		var i = path.indexOf('#');
		if(i==-1){
			return path;
		}
		return path.substring(0, i);
	}
	function startup(){
		// iframe内部点击事件记录
		domain.register('hotspotClick', function(href, x, y){
			href = formatPath(href);
			var luiId = domain.getParam(href,'LUIID');
			$('iframe').each(function(){
				var href2 = formatPath(this.src); 
				if(href2==href || domain.getParam(href2,'LUIID')==luiId){
					var offset = $(this).offset();
					saveData(offset.left+x, offset.top+y, this);
					return false;
				}
				return true;
			});
		});
		$(document).bind({
			// 鼠标点击记录坐标
			'click':function(e){
				saveData(e.pageX, e.pageY, e.target);
			},
			//Ctrl+Alt+Shift+F12 显示图形
			'keydown':function(e){
				if(e.shiftKey && e.altKey && e.ctrlKey && e.keyCode==123){
					showGraph();
				}
			}
		});
	}
	
	startup();
});