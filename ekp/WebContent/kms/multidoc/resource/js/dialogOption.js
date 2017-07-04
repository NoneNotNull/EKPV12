document.writeln("<link rel=stylesheet href='../resource/style/dialogOption.css'>");
var _Dialog_OptionsId;
var _OptionFilterId;
var _AftionAction;
var _IdField,_NameField;

function Dialog_Options(optionFilterId,idField,nameField,aftionAction){
	
	// 初始变量
	this._Dialog_OptionsId = "Dialog_OptionsId_" + optionFilterId;
	this._OptionFilterId = optionFilterId;
	this._AftionAction = aftionAction;
	this._IdField = idField;
	this._NameField = nameField;
	
	var dialog = Dialog_OptionsIdDiv();
	var eventObj = window.event.srcElement;
	var pos = Dialog_OptionsPosition(eventObj);
	var x = pos.x + eventObj.offsetWidth;
	if (x < document.body.scrollLeft) x = document.body.scrollLeft;
	var y = pos.y + eventObj.offsetHeight;
	if (y + dialog.offsetHeight > document.body.clientHeight + document.body.scrollTop) {
		y = document.body.clientHeight + document.body.scrollTop - dialog.offsetHeight;
	}
	dialog.style.left = x + 'px';
	dialog.style.top = y + 'px';
	document.body.appendChild(dialog);
	//debugger;
	$("body>div:not(#"+_Dialog_OptionsId+")").bind("mousedown",Dialog_Options_Hidden);
}

function Dialog_OptionsPosition(node, stopNode) {
	var x = y = 0;
	for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
	}
	x = x + document.body.scrollLeft;
	y = y + document.body.scrollTop;
	return {'x':x, 'y':y};
};

function Dialog_OptionsIdDiv(){
	var dialog = document.getElementById(_Dialog_OptionsId);
	if(!dialog){
		dialog = document.createElement("div");
		dialog.id = _Dialog_OptionsId;
		dialog.className= "popup_dialog_options";
		//加载数据
		dataLoading();
	}
	dialog.style.display = "block";
	return dialog;
}

function dataLoading() {
	
	var url = "kmsMultidocLinkageFilter&defineId="+_OptionFilterId;
	var data = new KMSSData(); 
	data.SendToBean(url,function (rtnData){
		
		if(rtnData){
			var dialog = document.getElementById(_Dialog_OptionsId);
			var ul,li,a;
			var values = rtnData.data;
			if(values.length>0){
				var div = document.createElement("div");
				ul = $("<ul>").attr("class","popup_title");
				var num = 1;
				var row = values[0];
				for(var name in row){
					
					if(typeof(row[name])=="function")break;
					a = $("<a>").attr("id",row[name]).attr("title",name).text(name);
					a.attr("index",num);
					if(num++==1){
						a.attr("class","Selected");
					}
					a.attr("href","javascript:void(0)").click(function(){
						$("ul[ulIndex][ulIndex!="+this.index+"]").css("display","none");
						$("ul[ulIndex="+this.index+"]").css("display","block");
						$("ul[class=popup_title]").children().children().attr("class","UnSelect");
						this.className= "Selected";
					});
					ul.append($("<li>").append(a));
				}
				$(div).append(ul)
				$(dialog).append(div);
			}
			
			for (var i = 1; i < values.length; i++) {
				
				var row = values[i];
				ul = $("<ul>").attr("class","popup_content").attr("ulIndex",i);
				if(i>1)ul.css("display","none");
				for(var name in row){
					
					if(typeof(row[name])=="function")break;
					a = $("<a>").attr("id",row[name]).attr("title",name).text(name);
					a.attr("href","javascript:void(0)").click(function(){
						$("input[name="+_NameField+"]").val(this.title);
						$("input[name="+_IdField+"]").val(this.id);
						//隐藏窗口
						Dialog_Options_Hidden();
						optionDialog_Sel_After();
					});
					ul.append($("<li>").append(a));
				}
				$(dialog).append(ul);
			}
		}
	});	 
}

//筛选后事件
function optionDialog_Sel_After() {
	var settingId = KMS.filter.settingId;
	var obj = document.getElementsByName("moreOptionId_" + settingId)[0];
	var nameObj = document.getElementsByName("moreOptionName_" + settingId)[0];
	if (obj) {
		if (obj.value != '') {
			sysProp_doFilter(settingId, obj.value,
					nameObj.getAttribute('property'), nameObj
							.getAttribute('displayType'));
			
			var parent = $(obj).parent();
			parent.children().children().removeClass('gray');
		} else {
			sysProp_doFilter(settingId, '', '', '');
		}
		if (!KMS.filter.selectMore) {
			sysProp_doFilter_refresh();
		}
	}
}

//隐藏窗口
function Dialog_Options_Hidden(){
	var dialog = document.getElementById(_Dialog_OptionsId);
	dialog.style.display = "none";
	$("body>div:not(#"+_Dialog_OptionsId+")").unbind("mousedown");
}

