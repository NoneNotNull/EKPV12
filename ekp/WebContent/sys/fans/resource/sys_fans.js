define(function(require, exports, module) {
	var $ = require('lui/jquery');
	var env = require('lui/util/env');
	var dialog = require('lui/dialog');
	var lang = require('lang!sys-fans');
	var fansFollow = function fansFollow(fdUserId, isFollowed, isFollowPerson, 
			attentModelName, fansModelName, $element, action, ctx, config) {
		if(!config)
			config = {};
		var ele = config.dialogEle ? $element.parents(config.dialogEle+ ":eq(0)") : null;
		$.ajax({
			url : env.fn.formatUrl( "/sys/fans/sys_fans_main/sysFansMain.do?method=addFollow"),
			async : false, 
			cache : false,
			data : "isFollowed=" + isFollowed + "&fdPersonId=" + fdUserId
					 + "&isFollowPerson=" + isFollowPerson + "&attentModelName=" 
					 + attentModelName + "&fansModelName=" + fansModelName,
			type : "POST",
			dataType : "json",
			success : function(data) {
				if (action && data.result == "success") {
					if(isFollowed == 'followed')
						dialog.success(lang['sysFansMain.cancelFollowSuccess'], ele);
					else dialog.success(lang['sysFansMain.followSuccess'], ele);
					action.apply(ctx || this, [data, fdUserId, isFollowed, 
					                  $element, config, isFollowPerson, attentModelName, fansModelName]);
				} else if(data.result == "canNotCancel"){
					dialog.failure(lang['sysFansMain.canNotCancelFollow'], ele);
				}else {
					if(isFollowed == 'followed')
						dialog.failure(lang['sysFansMain.cancelFollowFailure'], ele);
					else dialog.failure(lang['sysFansMain.followFailure'], ele);
				}
			},
			error : function() {
				if(isFollowed == 'followed')
					dialog.failure(lang['sysFansMain.cancelFollowFailure'], ele);
				else dialog.failure(lang['sysFansMain.followFailure'], ele);
			}
		});
	};
	
	//caredType为当前已经发生的操作
	var followcb =  function(data, fdToElementId, caredType, $element, config, isFollowPerson, attentModelName, fansModelName) {
		var orgId = fdToElementId,
		   rela = data.relation,
		   extend = config.extend ? "_" + config.extend :  "",
		   text,
		   title,
		   actionType,
		   clas;
		var clasBtn = "lui_fans_listfollow_btn" + extend;
		if(rela == 0 || rela == 2) {
			text = config.caredText ? config.caredText : "+ " + lang['sysFansMain.cared'];
			title = lang['sysFansMain.cared'];
			actionType = "unfollowed";
			clas="lui_fans_btn_focus" + extend;
		} else if(rela == 1 || rela == 3) {
			if(rela == 1) {//已关注
				text = config.cancelText ? config.cancelText : " - " + lang['sysFansMain.followed'];
			} else {//互相关注
				text = config.eachText ? config.eachText : " - " + lang['sysFansMain.follow.each'];
			}
			title = lang['sysFansMain.cancelFollow'];
			actionType = "followed";
			clas="lui_fans_btn_focused" + extend;
		}
		if($element) {
			var parent = $element.parent();
			var html =  ['<a class="',clasBtn,'" href="javascript:void(0)" fans-model-name="',fansModelName,'" attent-model-name="',attentModelName,
			             '" is-follow-person="', isFollowPerson ,'" data-action-id="' , orgId ,'" data-action-type="',actionType,'">',
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
					var isFollowPerson = $target.attr("is-follow-person");
					var attentModelName = $target.attr("attent-model-name");
					var fansModelName = $target.attr("fans-model-name");
					fansFollow(orgId , type, isFollowPerson, attentModelName,fansModelName, 
							$target, callback ? callback : followcb, ctx || null, config ? config : {});
					break;
				}
			}
		});
	};
	
	var changeFansStatus = function(personIds,ele,config){
		if(!config){
			config = {};
		}
		var personIdsStr = personIds.join(",");
		var extend = config.extend ? "_" + config.extend :  "",text,clas; 
		var clasBtn = "lui_fans_listfollow_btn" + extend;
		
		if(extend!=""){
			$("a[id='fans_follow_btn']").each(function() {
				var $this = $(this);
				$this.attr("class",clasBtn);
				var child = $this.find("span[id='fans_btn']");
				child.attr("class","lui_fans_btn_focus" + extend);
				child.html(lang['sysFansMain.follow']);
			});
		}
		$.ajax({
			url : env.fn.formatUrl( "/sys/fans/sys_fans_main/sysFansMain.do?method=getRelationType"),
			async : false, 
			cache : false,
			data : "&personIdsStr=" + personIdsStr,
			type : "POST",
			dataType : "json",
			success : function(data) {
				var relation = data['relation'];
				for(var i=0;i<relation.length;i++){
					var userId = relation[i][0];
					var relaType = relation[i][1];
					var evt = $("a[data-action-id="+userId+"]");
					evt.attr("class",clasBtn);
					clas="lui_fans_btn_focused" + extend;
					//已经关注
					if(relaType == 1 || relaType == null){
						text = config.cancelText ? config.cancelText : " - " + lang['sysFansMain.followed'];
						evt.attr("data-action-type","followed");
						var child = evt.find("span[id='fans_btn']");
						child.attr("class",clas);
						child.attr("title","取消关注");
						child.html(text);
					}
					//相互关注
					else if(relaType == 2){
						text = config.eachText ? config.eachText : " - " + lang['sysFansMain.follow.each'];
						evt.attr("data-action-type","followed");
						var child = evt.find("span[id='fans_btn']");
						child.attr("class",clas);
						child.attr("title","取消关注");
						child.html(text);
					}
				}
			},
			error : function() {
				
			}
		});
		
	}
	
	exports.fansFollow = fansFollow;
	exports.bindButton = bindButton;
	exports.changeFansStatus = changeFansStatus;
	exports.ready = function() {
		window.fansFollow = fansFollow;
	};
});