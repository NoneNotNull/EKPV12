/**
 * 审批意见展示控件
 * @作者：曹映辉 @日期：2012年4月13日  
 */

function Dialog_List_ShowNode(idField, nameField, splitStr, isMulField,action){
	var dialog = new KMSSDialog(true, true);
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	
	dialog.SetAfterShow(action);
	
	//获取流程中所有节点
	var wfNodes=(window.XForm_GetWfAuditNodes == null)?[]:XForm_GetWfAuditNodes();
	var data=new KMSSData();
	var ary = new Array();
	for(var i=0;i<wfNodes.length;i++){
		//只有审批节点和签字节点可供选择
		if('signNode'==wfNodes[i].type || 'reviewNode'==wfNodes[i].type || 'sendNode'==wfNodes[i].type){
			//设置选中节点
			var temp = new Array();
			temp["id"]= wfNodes[i].value;
			temp["name"]=wfNodes[i].name;
			ary.push(temp);
					
		}
	}
	
	data.AddHashMapArray(ary);
	dialog.optionData.AddKMSSData(data);
	dialog.Show(520, 400);
}
var StylePlugin=function(){
	var self=this;
	this.init=function(){
		//获取扩展点中定义的样式信息
		//this.extStyle='';
		$.ajax({
		  url: "auditshow_style.jsp",
		  type:'post',
		  async:false,//同步请求
		  success: function(json){
		    self.extStyle=json;
		  },
		  dataType: 'json'
		});
	};
	this.GetAllExtStyle=function(){
		
		return self.extStyle;
	};
	this.GetStyleByValue=function(val){
		for(var i=0;i<self.extStyle.length;i++){
			if(self.extStyle[i].viewValue==val){
				return self.extStyle[i];
			}
		}
	};
	//设置控件属性面板选项数组
	this.GetOptionsArray=function(){
		var styleOptions=[];
		var extStyle = self.extStyle;
		for(var i=0;i<extStyle.length;i++){
			
			styleOptions.push({name: extStyle[i].order , text: extStyle[i].viewName , value: extStyle[i].viewValue});
		}
		return styleOptions;
	}
	this.init();
}

var StylePluginInstance =new StylePlugin();

Designer_Config.operations['auditShow']={
		lab : "5",
		imgIndex : 47,
		title:Designer_Lang.auditshow_name_insert,
		run : function (designer) {
			designer.toolBar.selectButton('auditShow');
		},
		type : 'cmd',
		shortcut : 'N',
		sampleImg : 'style/img/auditshow/auditShow.png',
		select: true,
		cursorImg: 'style/cursor/auditshow.cur'
};
Designer_Config.controls.auditShow={
			type : "auditShow",
			inherit : 'base',
			storeType : 'field',
			onDraw : _Designer_Control_AuditShow_OnDraw,
			onDrawEnd : _Designer_Control_AuditShow_OnDrawEnd,
			drawXML : _Designer_Control_AuditShow_DrawXML,
			//onInitialize:_Designer_Control_AuditShow_DoInitialize,
			//destroyMessage:Designer_Lang.controlAuditShow_msg_del,
			onAttrLoad : _Designer_Control_Attr_Tab_OnAttrLoad,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				
				detail_attr_value:{
					//控件隐藏值
					text: Designer_Lang.auditshow_attr_hiddenValue,
					value : '',
					type: 'hidden',
					show: true
				},
				detail_attr_name:{
					text: Designer_Lang.auditshow_attr_hiddenName,
					value : '',
					type: 'hidden',
					//只对隐藏的name校验必填，主要兼容 自定义模式时，value可以为空。其他模式name不为空，value必不为空
					validator: [Designer_Control_Attr_Required_Validator],
					show: true
				},
			
				mould : {
					text: Designer_Lang.auditshow_attr_type,
					value : '11',
					type : 'select',
					opts: [
						{name: 'handler1', text: Designer_Lang.auditshow_mould_handler1, value:'11'},
						{name: 'handler2', text: Designer_Lang.auditshow_mould_handler2, value:'12'},
						{name: 'node1', text: Designer_Lang.auditshow_mould_node1, value:'21'},
						{name: 'node2', text: Designer_Lang.auditshow_mould_node2, value:'22'},
						{name: 'custom', text: Designer_Lang.auditshow_mould_custom, value:'91'}
					],
					onchange:'_Designer_Control_Attr_Mould_Change(this)',
					show: true
				},
				mouldDetail : {
 					//审批人属于
					text: Designer_Lang.auditshow_auditorOwner,
					value : '',
					type: 'self',
					draw: _Designer_Control_Attr_MouldDetail_Self_Draw,
					show: true
				},
				showStyle : {
					//展示样式
					text: Designer_Lang.auditshow_attr_exhibitionStyle,
					value : 'auditNoteStyleDefaultOnlyHandler',
					type : 'select',
					opts: StylePluginInstance.GetOptionsArray(),
					onchange:'_Designer_Control_Attr_ShowStyle_Change(this)',
					show: true
				},
				previewImg :{
					//预览图
					text: Designer_Lang.auditshow_attr_preview,
					value : '',
					type: 'self',
					draw:_Designer_Control_Attr_PreviewImg_Self_Draw,
					show: true
				},
				filterNote:{
					//意见筛选
					text: Designer_Lang.auditshow_attr_noteFilter,
					value : '',
					type : 'checkGroup',
					opts:[{name:'samePersonLast',text:Designer_Lang.auditshow_filterNote_sameHandler,value:"1"},{name:'sameDepartmentLast',text:Designer_Lang.auditshow_filterNote_sameDept,value:"2"}],
					show:true
				},
				sortNote:{
					//意见排序	
					text: Designer_Lang.auditshow_attr_noteSort,
					value : 'asc',
					type : 'radio',
					opts:[{text:Designer_Lang.auditshow_sortNote_Asc,value:"asc"},{text:Designer_Lang.auditshow_sortNote_Desc,value:"desc"}],
					show:true
				},
				width : {
					text: Designer_Lang.controlAttrWidth,
					value: "",
					type: 'text',
					show: true,
					validator: Designer_Control_Attr_Width_Validator,
					checkout: Designer_Control_Attr_Width_Checkout
				},
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info:{
				//审批意见展示控件
				name:Designer_Lang.auditshow_name,
				preview: "mutiTab.png"
			}
			,
			resizeMode : 'onlyWidth'
};
Designer_Config.buttons.control.push("auditShow");
Designer_Menus.add.menu['auditShow'] = Designer_Config.operations['auditShow'];

function _Designer_Control_Attr_PreviewImg_Self_Draw(name, attr, value, form, attrs, values,control){
	
	var showStyleValue=Designer.instance.control.attrs.showStyle.value;
	
	if(values.showStyle){
		showStyleValue=values.showStyle;
	}

	var styleJSON=StylePluginInstance.GetStyleByValue(showStyleValue);
	
	var html="<img id='auditshow_reivewImg_url' src='"+styleJSON.previewPictureURL+"' width='170px' height='80px'/>";
	
	
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _Designer_Control_Attr_ShowStyle_Change(showStyle){
	
	var styleJSON=StylePluginInstance.GetStyleByValue(showStyle.value);
	
	
	$("#auditshow_reivewImg_url").attr("src",styleJSON.previewPictureURL);
	
}
function _Designer_Control_Attr_Mould_Change(mouldSelect){
	
	var html=_GetHTMLByMouldType(mouldSelect.value);
	
	$("#auditshow_mouldDetail_html").html(html);
}
function _Designer_Control_Attr_Tab_OnAttrLoad(form,control){
	if(document.getElementsByName("detail_attr_name")[0]){
		document.getElementsByName("detail_attr_name")[0].value=control.options.values.detail_attr_name||"";
	}
	if(document.getElementsByName("detail_attr_value")[0]){
	    document.getElementsByName("detail_attr_value")[0].value=control.options.values.detail_attr_value||"";
	}
}

function _Designer_Control_Attr_MouldDetail_Self_Draw(name, attr, value, form, attrs, values,control){	
	var mouldValue = attrs.mould.value;
	if(values.mould){
		mouldValue=values.mould;
	}
	html="<div id='auditshow_mouldDetail_html'>"+_GetHTMLByMouldType(mouldValue)+"</div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

function After_Select_Set_Name(returnValue){
	document.getElementsByName("detail_attr_name")[0].value=document.getElementsByName("detail_attr_name2")[0].value;
}
function SetBack_Detail_attr_name(obj){
	//Designer.instance.control.options.values.detail_attr_name=obj.value;
	document.getElementsByName("detail_attr_name")[0].value=obj.value;
}
function SetBack_Detail_attr_value(obj){
	//Designer.instance.control.options.values.detail_attr_value=obj.value;
	document.getElementsByName("detail_attr_value")[0].value=obj.value;
}
function _GetHTMLByMouldType(mouldValue){
	var html=[];
	var lableText="";
	var control = Designer.instance.control;
	//是否为初始是的模式，如果不是则需要将控件的值设置为空
	var isInitMould=false;
	//选择回初始模式时，需要将初始值重新设置回去。
	
	if(control.options.values.mould==mouldValue){
		isInitMould=true;
		
		
		if(document.getElementsByName("detail_attr_name")[0]){
			document.getElementsByName("detail_attr_name")[0].value=control.options.values.detail_attr_name||"";
		}
	    if(document.getElementsByName("detail_attr_value")[0]){
	    	document.getElementsByName("detail_attr_value")[0].value=control.options.values.detail_attr_value||"";
	    }
		
	}
	else
	{
		if(document.getElementsByName("detail_attr_name")[0]){
			document.getElementsByName("detail_attr_name")[0].value="";
		}
		if(document.getElementsByName("detail_attr_value")[0]){
			document.getElementsByName("detail_attr_value")[0].value="";
		}
		
	}
	switch(mouldValue)
	{
		case '11':
		{
			//onpropertychange 审批人属于
			lableText=Designer_Lang.auditshow_auditorOwner;
			html.push("<input type='text' id='detail_attr_name2' name='detail_attr_name2' readonly='true'  class='inputsgl' value='"+(isInitMould?(control.options.values.detail_attr_name||""):"")+"'/>");
			html.push("<span class='txtstrong'>*</span>");
			//html.push("<input type='hidden' id='detail_attr_value2' name='detail_attr_value2' onchange='SetBack_Detail_attr_value(this);' onpropertychange='SetBack_Detail_attr_value(this);' value='"+(isInitMould?(control.options.values.detail_attr_value||""):"")+"'/>");
			html.push("<a href='#' id='handlerSelect' onclick=\"Dialog_Address(true, 'detail_attr_value','detail_attr_name2', ';',ORG_TYPE_ALL,After_Select_Set_Name);\">"+Designer_Lang.auditshow_choose+"</a>");
			break;
		}
		case '12':
		{
			//审批人属于
			lableText=Designer_Lang.auditshow_auditorOwner;
			html.push("<input type='text' id='detail_attr_name2' name='detail_attr_name2' readonly='true'  class='inputsgl' value='"+(isInitMould?(control.options.values.detail_attr_name||""):"")+"'/>");
			html.push("<span class='txtstrong'>*</span>");
			//html.push("<input type='hidden' id='detail_attr_value2' name='detail_attr_value2' onchange='SetBack_Detail_attr_value(this);' onpropertychange='SetBack_Detail_attr_value(this);' value='"+(isInitMould?(control.options.values.detail_attr_value||""):"")+"'/>");
			html.push("<a href='#' id='handlerSelect' onclick=\"Formula_Dialog('detail_attr_value','detail_attr_name2',Designer.instance.getObj(true),'Object',After_Select_Set_Name,null,Designer.instance.control.owner.owner._modelName);\">"+Designer_Lang.auditshow_choose+"</a>");
			break;
		}
		case '21':
		case '22':
		{
			//选择展示节点
			lableText=Designer_Lang.auditshow_chooseExhibitionNodes;
			html.push("<input type='text' id='detail_attr_name2' name='detail_attr_name2'   readonly='true'  class='inputsgl' value='"+(isInitMould?(control.options.values.detail_attr_name||""):"")+"'/>");
			html.push("<span class='txtstrong'>*</span>");
			//html.push("<input type='hidden' id='detail_attr_value2' name='detail_attr_value2' onchange='SetBack_Detail_attr_value(this);' onpropertychange='SetBack_Detail_attr_value(this);' value='"+(isInitMould?(control.options.values.detail_attr_value||""):"")+"'/>");
			html.push("<a href='#' id='handlerSelect' onclick=\"Dialog_List_ShowNode('detail_attr_value','detail_attr_name2', ';','',After_Select_Set_Name);\">"+Designer_Lang.auditshow_choose+"</a>");
			break;
		}
		case '91':
		{	//自定义
			lableText=Designer_Lang.auditshow_preference;
			//参数	
			html.push(Designer_Lang.auditshow_preferenceParam+"：<input name='detail_attr_value2' id='detail_attr_value2' onkeyup='SetBack_Detail_attr_value(this);' value='"+(isInitMould?(control.options.values.detail_attr_value||""):"")+"'/>");
			html.push(" Bean：<input name='detail_attr_name2' id='detail_attr_name2'  onkeyup='SetBack_Detail_attr_name(this);'   value='"+(isInitMould?(control.options.values.detail_attr_name||""):"")+"'/><span class='txtstrong'>*</span>");
			//对自定义模式的帮助描述
			html.push("<div style='color:grey;font-size:11px;'>"+Designer_Lang.auditshow_preferenceHint+"</div>");
			break;
		}
	}
	
	//设置mouldDetail Label
	if($("#auditshow_mouldDetail_html")[0]){
		//<tr><td width="25%" class="panel_td_title">' + attr.text + '</td><td>' + html + '</td></tr>'
		
		$("#auditshow_mouldDetail_html").parent().prev().text(lableText);
	}
	html=html.join('');
	return html;
}
function _Designer_Control_AuditShow_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();

	domElement.id = this.options.values.id;
	
	domElement.label=_Get_Designer_Control_Label(this.options.values, this);
	
	var values =this.options.values;
	
	if (this.options.values.width ) {
		if( this.options.values.width.toString().indexOf('%') > -1){
			domElement.style.whiteSpace = 'nowrap';
			domElement.style.width = this.options.values.width;
		}
		else{
			domElement.style.width = this.options.values.width+"px";
		}
		
	}
	else{
		values.width = "100%";
		domElement.style.width=values.width;
	}
	domElement.width=values.width;
	if(!values.mould){
		//初始值为1
		values.mould=this.attrs.mould.value;
	}
	//设置用户选择的模式
	domElement.mould=values.mould;
	
	
	var params=values.detail_attr_name;
	if(params){
		params=params.split(";");
	}
	
	domElement.innerHTML=GetExhibitionHTML(this,params);
	
	//该属性为 showStyle下拉框的value值，及plugin中的viewValue
	if(!values.showStyle){
		values.showStyle=this.attrs.showStyle.value;
	}
	
	domElement.exhibitionStyleClass=values.showStyle;
	
	var checkedFilterNotes=[];
	var filterNoteOpts=this.attrs.filterNote.opts;
	
	for(var i=0;i<filterNoteOpts.length;i++){
		if(values[filterNoteOpts[i].name]=='true'){
			checkedFilterNotes.push(filterNoteOpts[i].value);
		}
	}
	//设置过滤类型
	domElement.filterNote=checkedFilterNotes.join(',');
	//没有选择过滤类型 则去默认值。
	if(checkedFilterNotes.length==0){
		domElement.filterNote=this.attrs.filterNote.value;
	}
	
	if(!values.sortNote){
		values.sortNote=this.attrs.sortNote.value;
	}
	//设置排序类型属性
	domElement.sortNote=values.sortNote;
	
	if(values.detail_attr_value){
		domElement.value=values.detail_attr_value;
	}
	if(values.detail_attr_name){
		domElement.attr_name=values.detail_attr_name;
	}
	// 判断是否为签名的样式
	if ("auditNoteStyleDefaultOnlySignature" == values.showStyle
			|| "auditNoteStyleDefaultSignatureDate" == values.showStyle
			|| "auditNoteStyleDefaultSignature" == values.showStyle) {
		switch (domElement.mould) {
		case '11':
		case '12': {
			domElement.attr_name = "auditNoteDataByHandlerSignature";
			break;
		}
		case '21':
		case '22': {
			domElement.attr_name = "auditNoteDataByNodeSignature";
			break;
		}
		}
		domElement.mould = "91";
	}
}
function _Designer_Control_AuditShow_DrawXML(){
	
		
}
function _Designer_Control_AuditShow_OnDrawEnd(){
	
	//this.options.domElement.exhibitionBusinessClass=this.options.values.exhibitionBusinessClass;
	//alert(val);
	
	
}
//根据不同的类型获取显示格式
function GetExhibitionHTML(control,params){
	var html=[];
//	var baseHTML="<img id='auditshow_reivewImg_url' src='"+styleJSON.previewPictureURL+"' width='170px' height='80px'/>";
	
	//设置初始值为默认样式
	var showStyleValue=control.options.values.showStyle||"auditNoteStyleDefaultOnlyHandler";

	var styleJSON=StylePluginInstance.GetStyleByValue(showStyleValue);
	//动态设置图片宽度。防止无法拖动到小于图片宽度的值。
	var tempWidth="100%";
    if(control.options.domElement.style.width)
    {
    	tempWidth=control.options.domElement.style.width;
    }
	var baseHTML="<img  src='"+styleJSON.previewPictureURL+"' width='"+tempWidth+"' height='80px'/>";
	
	
	switch(control.options.values.mould)
	{
		case '11':
		case '12':
		case '21':
		case '91':
		
			html.push(baseHTML);
			
		break;
		
			case '22':
			               //审批节点1，审批节点2，审批节点3，
			params=params||[Designer_Lang.auditshow_auditNode+'1',Designer_Lang.auditshow_auditNode+'2',Designer_Lang.auditshow_auditNode+'3'];
			html.push("<table align='center' class='tb_normal' width='100%' >");
			for(var i=0;i<params.length;i++){
				html.push("<tr>");
				
				html.push("<td noWrap=true>");
				html.push(params[i]);
				html.push("</td>");
				
				html.push("<td>");
				html.push(baseHTML);
				html.push("</td>");
				
				html.push("</tr>");
			}
			html.push("</table>");
		break;
	}
	return html.join('');
}
