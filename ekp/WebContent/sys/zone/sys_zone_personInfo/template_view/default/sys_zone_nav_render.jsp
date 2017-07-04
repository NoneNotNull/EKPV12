<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
function addPersonNav($element, isOnly) {							
			var personInfoHref = "/sys/zone/sys_zone_personInfo/sysZonePersonInfo_personData_edit.jsp?method=${isSelf == true ? 'edit' : 'view'}";
			var classInfo = "";
			if(isOnly) {
				$("#iframe_body").attr("src", __navLinkUrl(personInfoHref));
				classInfo = "class='selected'";
			}
			$element.append("<li><a " + classInfo +" href='javascript:;' data-info='&text=${lfn:message("sys-zone:sysZonePersonInfo.fdPersonData")}&href=" + personInfoHref +"'>"
						 + "${lfn:message("sys-zone:sysZonePersonInfo.fdPersonData")}</a></li>");
}
	var element = render.parent.element;
	if (data == null || data.length == 0) {
		addPersonNav(element, true);
		done();
		return;
	}
	
	
	var taText = '<c:out value="${zone_TA_text }" />';
	var length  =  data.length;
	var lenOut,lenIn;
	if(length <= 6) {
		lenOut = length;
		lenIn = 0;
	} else if(length >= 7) {
		lenOut = 5;
		lenIn = length - 5;
	}
	for(var i = 0; i < lenOut; i ++) {
		var text = data[i].text;
		if (text != null && taText != '' && taText != 'TA' && text.indexOf('TA') > -1) {
			text = text.replace('TA', taText);
		}
		
		var info = ["&id=", data[i].id, "&text=", $.trim(data[i].text), 
						"&href=", data[i].href, "&serverPath=", data[i].serverPath,
							 "&target=",data[i].target,"&key=", data[i].key].join("");
		var infoText = "data-info='" + info + "'";
		var href = "javascript:;";
		var targrText = "";
		if("_blank" == data[i].target) {
			href = __navLinkUrl(data[i].href, data[i].serverPath, data[i].key);
			targrText = "  target='_blank'";
			infoText = "";
		}
		var ele = $('<li ><a ' + targrText +' title="'+ text +'" href="' + href +'" '+ infoText +' data-nav-out="'+ i +'" >'
					+ text +'</a></li>');
		element.append(ele);
		element.append("<li class='line'/>");
	}
	addPersonNav(element, false);
	if(lenIn > 0) {
		element.append("<li class='line'/>");
		var more = $("<li class='lui_zone_nav_more'><a href='javascript:;' data-role='more'>更多&nbsp&nbsp</a><span class='lui_zone_more_down'></span></li>");
		element.append(more);
		var moreul = $("<ul class='lui_zone_nav_bar_more' />");
		for(; i < length; i++) {
			text = data[i].text;
			if (text != null && taText != '' && taText != 'TA' && text.indexOf('TA') > -1) {
				text = text.replace('TA', taText);
			}
			var info = ["&id=", data[i].id, "&text=", $.trim(data[i].text), 
						"&href=", data[i].href, "&serverPath=", data[i].serverPath,
						"&target=",data[i].target,"&key=", data[i].key ].join("");
			var infoText = "data-info=" + info;
			var href = "javascript:;";
			var targetText = "";
			if("_blank" == data[i].target) {
				href = __navLinkUrl(data[i].href, data[i].serverPath, data[i].key);
				targetText = "target='_blank'";
				infoText = "";
			}
			var ele = $('<li ><a title="' + text + '" href="' + href +'" '+ targetText +' data-nav-in="'+ i +'"  '+ infoText +'  >' + 
					  text +'</a></li>');
			moreul.append(ele);
		}
		more.append(moreul);
	}
	
	done();
	
	var cId = render.parent.cid;
	
	var exchangeInfo =  function($t0, $tt) {
			var info0 = $t0.attr("data-info");
			var infoT = $tt.attr("data-info");
			var text0 = $t0.text();
			var textT = $tt.text();
			$t0.attr("data-info", infoT);
			$t0.text(textT);
			$t0.attr("title", textT);
			$tt.attr("data-info", info0);
			$tt.text(text0);
			$tt.attr("title", text0);
	};
	$("#" + cId).on("click", function(e) {
		var $target = $(e.target);
		var info = $(e.target).attr("data-info");
		if(!info) {
			return;
		}
		var target = Com_GetUrlParameter(info, "target");
		
		if("_blank" == target) {
			return;
		}
		var href = Com_GetUrlParameter(info, "href"),
			serverPath = Com_GetUrlParameter(info,"serverPath"),
			key = Com_GetUrlParameter(info,"key"),
			text = Com_GetUrlParameter(info, "text");	
		$("[data-info]").removeClass("selected");
		var indexIn = $target.attr("data-nav-in");
		if(indexIn) {
			var $target0 = $("[data-nav-out][data-info]:eq(0)");
			exchangeInfo($target0,$target);
			$target0.addClass("selected");
		} else {
			 $target.addClass("selected");
		}
	
		$("#iframe_body").attr("src", __navLinkUrl(href, serverPath, key));
	});
	$("[data-nav-out][data-info]:eq(0)").trigger("click");