
define(function(require, exports, module) {
	var $ = require('lui/jquery');
	var dialog = require('lui/dialog');
	
	function AddSysLinks(id, links) {
		for (var i = 0; i < links.length; i ++) {
			var link = links[i];
			var linkId = $('#' + id + '  [name$=".fdLinkId"][value="'+link.id+'"]');
			if (linkId.length > 0) {
				continue;
			}
			var row = DocList_AddRow(id);
			$(row).find('[name$=".fdName"]').closest('td').html(link.name+"("+link.server+")");
			$(row).find('[name$=".fdUrl"]').closest('td').html(link.url);
			$(row).find('[name$=".fdLinkId"]').val(link.id);
		}
	}
	
	function SysLinksDialog(type, title) {
		var url = require.resolve('sys/person/sys_person_cfg_link/sysPersonCfgLink_dialog.jsp?type='+type+'#');
		dialog.build({
			config : {
					width : 600,
					height : 450,  
					title : title || "系统注册链接",
					content : {
						type : "iframe",
						url: url
					}
			},
			callback : function(data) {
				if(data==null) {
					return;
				} 
				if(window.console) {
					console.info(data);
				}
				AddSysLinks(type, data);
			}
		}).show(); 
	}
	
	exports.ready = function() {
		window.SysLinksDialog = SysLinksDialog;
	};
});
