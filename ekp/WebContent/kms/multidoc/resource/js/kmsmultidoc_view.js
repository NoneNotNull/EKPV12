Doc_LabelInfos = new Array("Label_Tabels");
$(document).ready(function() {
	$('#sysPropertyTemplateTable').show();
});

// 点击新版本
function showNewEdtion(obj) {
	var url = obj.rev;
	var version = Dialog_PopupWindow(url, 497, 310);
	if (version != null) {
		var href = assemblyHref();
		href = href + "&version=" + version;
		window.location.href = href;
	}
}
function assemblyHref() {
	var href = window.location.href;
	var reg = /method=\w*/;
	href = href.replace(reg, "method=newEdition");
	var reg1 = /fdId/;
	href = href.replace(reg1, "originId");
	return href;
}
// 显示评分星

var staron = "<span class='staron' ></span>";
var staroff = "<span class='staroff'  ></span>";
var starhalf = "<span class='starhalf' ></span>";

function showStars() {
	var starons = "";
	var staroffs = "";
	var docScore = null;
	var score = null;
	docScore = document.getElementById('docScore');
	if (docScore != null) {
		score = docScore.value;
	}
	if (score != null) {
		var a = score.substr(0, 1);
		var b = score.substr(2, 1);
		var count = 0;
		if (a > 0) {
			for (i = 0; i < a; i++) {
				starons = starons + staron;
				count++;
			}
		}
		if (b > 0) {
			starons = starons + starhalf;
			count++;
		}
		if (count < 5) {
			for (j = count; j < 5; j++) {
				staroffs = staroffs + staroff;
			}
		}
	}
	$('#xing').html(starons + staroffs);
}
// 打开同类文档
function openDocWindow(fdId) {
	var url = "kmsMultidocKnowledge.do?method=view&fdId=" + fdId;
	Com_OpenWindow(url, "_blank");
}

function showButtonBar() {
	// window.onscroll=showButtonBar;
	var oTextbox = document.getElementById("buttonBarDiv");
	if (oTextbox) {
		var posX, posY;
		if (window.innerHeight) {
			posX = window.pageXOffset;
			posY = window.pageYOffset;
		} else if (document.documentElement
				&& document.documentElement.scrollTop) {
			posX = document.documentElement.scrollLeft;
			posY = document.documentElement.scrollTop;
		} else if (document.body) {
			posX = document.body.scrollLeft;
			posY = document.body.scrollTop;
		}
		oTextbox.style.top = posY;
	}
}
