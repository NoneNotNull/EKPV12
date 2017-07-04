Doc_LabelInfos = new Array("Label_Tabels");
function triggerEvent(obj) {
	if (!Com_Parameter.IE) {
		$(obj).find("*[onresize]:visible").each(function() {
					var funStr = this.getAttribute("onresize");
					if (funStr != null && funStr != "") {
						var tmpFunc = new Function(funStr);
						tmpFunc.call(this, Com_GetEventObject());
					}
				});
	}
}

function setLable() {
	if (Doc_LabelInfos != null) {
		for (var i = 0; i < Doc_LabelInfos.length; i++) {
			var tbObj = document.getElementById(Doc_LabelInfos[i]);
			for (var j = 0; j < tbObj.rows.length; j++) {
				var tagName = tbObj.rows[j].getAttribute("LKS_LabelName"), showNum = tbObj.rows[j]
						.getAttribute("SHOW_NUM"), tag_title = $("#tags")[0], li = document
						.createElement("li"), a = document.createElement("a");
				a.href = "javascript:void(0);";
				a.id = tagName;
				a.setAttribute("hidefocus", "true");
				a.onclick = function() {
					$(this).parent().siblings().removeClass('selectTag');
					$(this).parent().addClass('selectTag');
					showTR(this.id);
				};
				if (showNum == 'true') {
					var tagNum = tbObj.rows[j].getAttribute("TAG_NUM");
					a.rev = tagNum;
					a.appendChild(document.createTextNode(tagName + '' + tagNum
							+ ''));
				} else {
					a.rev = '';
					a.appendChild(document.createTextNode(tagName));
				}
				li.appendChild(a);
				tag_title.appendChild(li);
				if (j == 0) {
					li.className = "selectTag";
					tbObj.rows[j].style.display = "table-row";
					triggerEvent(tbObj.rows[j]);
				}
			}
		}
	}
}

$(function() {
			// 显示机制的Tag
			setTimeout('setLable()', 100);
		});

// 显示页签
function showTR(kms_tr_tag_name) {
	for (var i = 0; i < Doc_LabelInfos.length; i++) {
		var tbObj = document.getElementById(Doc_LabelInfos[i]);
		for (var j = 0; j < tbObj.rows.length; j++) {
			var tagName = tbObj.rows[j].getAttribute("LKS_LabelName");
			if (tagName == kms_tr_tag_name) {
				tbObj.rows[j].style.display = "table-row";
				triggerEvent(tbObj.rows[j]);
			} else {
				tbObj.rows[j].style.display = "none";
			}
		}
	}
}

// 根据标签名字显示页签
function showTrByTagName(kms_tr_tag_name) {
	var obj = $('a[id*=' + kms_tr_tag_name + ']')[0];// 
	if (obj != null) {
		$(obj).parent().siblings().removeClass('selectTag');
		$(obj).parent().addClass('selectTag');
	}
	for (var i = 0; i < Doc_LabelInfos.length; i++) {
		var tbObj = document.getElementById(Doc_LabelInfos[i]);
		for (var j = 0; j < tbObj.rows.length; j++) {
			var tagName = tbObj.rows[j].getAttribute("LKS_LabelName");
			if (tagName.indexOf(kms_tr_tag_name) > -1) {
				tbObj.rows[j].style.display = "table-row";
				triggerEvent(tbObj.rows[j]);
			} else {
				tbObj.rows[j].style.display = "none";
			}
		}
	}
}