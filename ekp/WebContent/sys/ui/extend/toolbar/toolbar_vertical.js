var topDom = null;
var contentDom = null;
var cssExtend = "";
if(param!=null ){
	if(param.extend!=null){
		cssExtend = "_" + param.extend;
	}
}
function createFrame(){
	topDom = $("<div class='lui_toolbar_frame_ver"+cssExtend+"'></div>");
	contentDom = $("<div class='lui_toolbar_left'></div>").appendTo(topDom);
	contentDom = $("<div class='lui_toolbar_right'></div>").appendTo(contentDom);
	contentDom = $("<div class='lui_toolbar_content'></div>").appendTo(contentDom);
}
function createLayout(html){
	var tr = $("<tr lui-button-container='1'/>");
	$("<td/>").append(html).appendTo(tr);
	return tr;
}
function getLayoutTable(){
	var tableObj = contentDom.find("table[lui_toolbar_mark='1']");
	if(tableObj.length<=0){
		tableObj = $("<table lui_toolbar_mark='1' style='margin:5px auto;'/>").appendTo(contentDom);
	}
	return tableObj;
}
function createButton(button,more){
	var btnLayout = $("<div class='lui_toolbar_btn' data-lui-on-class='lui_toolbar_btn_on '"+ (more==true? "isMore='true'":"")
				+" data-lui-status-class='lui_toolbar_btn_toggle_on'></div>");
	var btnContent = $("<div class='lui_toolbar_btn_l' data-lui-mark='toolbar_button_inner'></div>").appendTo(btnLayout);
	btnContent = $("<div class='lui_toolbar_btn_r'></div>").appendTo(btnContent);
	btnContent = $("<div class='lui_toolbar_btn_c' data-lui-mark='toolbar_button_content'></div>").appendTo(btnContent);
	button.setLayout(btnLayout);
	button.draw();
	return btnLayout;
}
function addButton(button){
	createLayout(createButton(button)).appendTo(getLayoutTable());
}
function removeButton(button){
	var tdContent = button.element.parents('tr[lui-button-container="1"]');
	button.erase();
	tdContent.remove();
}
function redrawButton(){
	buildNewBtnTable();
	drawButton();
	clearDeletedDom();
}
function buildMoreBtn(buttons){
	if(buttons!=null && buttons.length>0){
		seajs.use(['lui/toolbar','lui/popup'],function(toolbar,popup){
			var button = toolbar.buildButton({'icon':'lui_icon_s_more_default'});
			createLayout(createButton(button,true)).appendTo(getLayoutTable());
			button.element.attr("data-lui-switch-class","lui_widget_btn_ver_swh");
			var tmpToolbar = toolbar.buildToolBar(buttons,{
					'type':'Javascript',
					"src":"/sys/ui/extend/toolbar/toolbar.js"
					},{"count":1000});
			var popDiv = $('<div>').attr('class', 'lui_toolbar_popup_ver'+cssExtend);
			popDiv.append(tmpToolbar.element);
			tmpToolbar.draw();
			button.addChild(popup.build(button.element,popDiv,{"align":"right-top"}));
		});
	}
}
function buildNewBtnTable(){
	var tableTab = contentDom.find("table[lui_toolbar_mark='1']");
	if(tableTab.length>0){
		tableTab.attr('lui_toolbar_mark','0');
		tableTab.hide();
		$("<table lui_toolbar_mark='1'  style='margin:5px auto;'/>").appendTo(contentDom);
	}
}
function clearDeletedDom(){
	var tableTab = contentDom.find("table[lui_toolbar_mark='0']");
	if(tableTab.length>0){
		tableTab.remove();
	}
}
function drawButton(){
	var buttons = layout.toolbar.buttons;
	var count =  layout.toolbar.count;
	if(buttons.length>0){
		var showButtons = $.grep(buttons,function(button,index){
			return button.visible;
		});
		for(var i=0;i<showButtons.length;i++){
			if(i > (count-1)){
				break;
			}
			addButton(showButtons[i]);
		}
		if(showButtons.length>count){
			buildMoreBtn(showButtons.slice(count));
		}
	}
}
createFrame();
drawButton();
layout.toolbar.on("addButton",addButton);
layout.toolbar.on("removeButton",removeButton);
layout.toolbar.on("redrawButton",redrawButton);
layout.toolbar.onErase(function(){
	layout.toolbar.off('addButton', addButton);
	layout.toolbar.off('removeButton', removeButton);
	layout.toolbar.off("redrawButton",redrawButton);
});
done(topDom);
