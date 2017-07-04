define(function(require, exports, module) {
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	var dialog = require('lui/dialog');
	var lang = require('lang!sys-zone');
	var zoneCared = function zoneCared(fdToElementId, caredType, $element, action, ctx, config) {
		if(!config)
			config = {};
		var ele = config.dialogEle ? $element.parents(config.dialogEle+ ":eq(0)") : null;
		$.ajax({
			url : env.fn.formatUrl( '/sys/zone/sys_zone_personInfo/sysZonePersonInfo.do?method=addCared'),
			async : false, 
			cache : false,
			data : "fdToElementId=" + fdToElementId + "&caredType="
					+ caredType,
			type : "POST",
			dataType : "json",
			success : function(data) {
				
				if (action && data.success == true) {
					if(caredType == 'cared')
						dialog.success(lang['sysZonePerson.caredSuccess'], ele);
					else dialog.success(lang['sysZonePerson.cancelCaredSuccess'], ele);
					action.apply(ctx || this, [data, fdToElementId, caredType, $element, config]);
				} else {
					if(caredType == 'cared')
						dialog.failure(lang['sysZonePerson.caredFailure'], ele);
					else dialog.failure(lang['sysZonePerson.cancelCaredFailure'], ele);
				}
			},
			error : function() {
				if(caredType == 'cared')
					dialog.failure(lang['sysZonePerson.caredFailure'], ele);
				else dialog.failure(lang['sysZonePerson.cancelCaredFailure'], ele);
			}
		});
	};
	
	//caredType为当前已经发生的操作
	var followcb =  function(data, fdToElementId, caredType, $element, config) {
		var orgId = fdToElementId,
		   rela = data.relation,
		   extend = config.extend ? "_" + config.extend :  "",
		   text,
		   title,
		   actionType,
		   clas;
		var clasBtn = "lui_zone_listfollow_btn" + extend;
		if(rela == 0 || rela == 2) {
			text = config.caredText ? config.caredText : "+ " + lang['sysZonePerson.cared'];
			title = lang['sysZonePerson.cared'];
			actionType = "cared";
			clas="lui_zone_btn_focus" + extend;
		} else if(rela == 1 || rela == 3) {
			if(rela == 1) {//已关注
				text = config.cancelText ? config.cancelText : " - " + lang['sysZonePerson.followed'];
			} else {//互相关注
				text = config.eachText ? config.eachText : " - " + lang['sysZonePerson.follow.each'];
			}
			title = lang['sysZonePerson.cancelCared'];
			actionType = "cancelCared";
			clas="lui_zone_btn_focused" + extend;
		}
		if($element) {
			var parent = $element.parent();
			var html =  ['<a class="',clasBtn,'" href="javascript:void(0)" data-action-id="' , orgId ,'" data-action-type="',actionType,'">',
              '<span title="',title,'"  class="' , clas , '">' ,text , '</span></a>'].join("");
			parent.html(html);
		}
	};
	
	var bindButton = function(ele, callback, ctx, config) {
		$(ele).click(function(evt) {
			var cls = $(ele).attr("class");
			var $target = $(evt.target);
			for(; cls != $target.attr("cls"); $target = $target.parent()) {
				var type =  $target.attr("data-action-type");
				if(type) {
					var orgId = $target.attr("data-action-id");
					zoneCared(orgId , type, $target, callback ? callback : followcb, ctx || null, config ? config : {});
					break;
				}
			}
		});
	};
	
	exports.cared = zoneCared;
	exports.bindButton = bindButton;
	exports.ready = function() {
		window.zoneCared = zoneCared;
	};
});