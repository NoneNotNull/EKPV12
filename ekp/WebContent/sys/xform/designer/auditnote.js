Com_IncludeFile('json2.js');
Designer_Config.operations['auditNote']={
		lab : "5",
		imgIndex : 56,
		title:'插入审批操作控件',
		run : function (designer) {
			designer.toolBar.selectButton('auditNote');
		},
		type : 'cmd',
		shortcut : '',
		sampleImg : 'style/img/auditNote/auditNote.png',
		select: true,
		cursorImg: 'style/cursor/auditnote.cur'
};
Designer_Config.controls.auditNote={
			type : "auditNote",
			inherit : 'base',
			storeType : 'field',
			onDraw : _Designer_Control_auditNote_OnDraw,
			onDrawEnd : _Designer_Control_auditNote_OnDrawEnd,
			drawXML : _Designer_Control_auditNote_DrawXML,
			//onInitialize:_Designer_Control_auditNote_DoInitialize,
			//destroyMessage:Designer_Lang.controlauditNote_msg_del,
			onAttrLoad : _Designer_Control_Attr_Tab_OnAttrLoad,
			implementDetailsTable : false,
			attrs : {
				label : Designer_Config.attrs.label,
				mould : {
					text: Designer_Lang.auditshow_attr_type,
					value : '21',
					type : 'select',
					opts: [
					    {name: 'node1', text: '流程节点', value:'21'},
						{name: 'handler1', text: '处理人(地址本)', value:'11'},
						{name: 'handler2', text: '处理人(公式计算)', value:'12'}
						
					],
					onchange:'_Designer_Control_AuditNote_Attr_Mould_Change(this)',
					show: true
				},
				mouldDetail : {
 					//审批人属于
					text: '选择节点',
					value : '',
					type: 'self',
					draw: _Designer_Control_AuditNote_Attr_MouldDetail_Self_Draw,
					checkout:function(msg, name, attr, value, values, control){
						if(!value||value=='~'){
							msg.push(values.label+',必填属性不能为空');
							return false;
						}
						return true;
					},
					show: true
				},
				rejectType: {
					text: '驳回类型',
					value: '0',
					type: 'radio',
					opts: [{text:'驳回上一级',value:"0"},{text:'可选节点驳回',value:"1"}],
					show: true
				},
				width : {
					text: Designer_Lang.controlAttrWidth,
					value: "",
					type: 'text',
					show: true,
					validator: Designer_Control_Attr_Width_Validator,
					checkout: Designer_Control_Attr_Width_Checkout
				},
				height : {
					text: Designer_Lang.controlAttrHeight,
					value: "",
					type: 'text',
					show: true,
					validator: Designer_Control_Attr_Int_Validator,
					checkout: Designer_Control_Attr_Int_Checkout
				}
				,
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info:{
				//审批意见展示控件
				name:'审批操作控件',
				preview: "mutiTab.png"
			}
			,
			resizeMode : 'onlyWidth'
};
Designer_Config.buttons.control.push("auditNote");
Designer_Menus.add.menu['auditNote'] = Designer_Config.operations['auditNote'];

function _Designer_Control_auditNote_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();

	domElement.id = this.options.values.id;
	
	domElement.label=_Get_Designer_Control_Label(this.options.values, this);
	
	domElement.style.border="0px solid #DFDFDF";
	
	var values =this.options.values;
	
	
	if (this.options.values.width) {
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
	domElement.rejectType=values.rejectType;
	domElement.mould=values.mould;
	domElement.mouldDetail=values.mouldDetail;
	if (this.options.values.height) {
		if( this.options.values.height.toString().indexOf('%') > -1){
			domElement.style.whiteSpace = 'nowrap';
			domElement.style.height = this.options.values.height;
		}
		else{
			domElement.style.height = this.options.values.height+"px";
		}
	}
	else{
		values.height = "60";
		domElement.style.height=values.height;
	}
	domElement.height=values.height;
	var textarea="<textarea style='width:100%;height:100%;margin-top:0px'>";
	textarea +="</textarea>";
	
	var btnSubmit="<input type='button' class='btnopt' style='width:60px;height:25px' value='提交'>";
	btnSubmit +="</input>";
	var btnReject="<input type='button' class='btnopt' style='width:60px;height:25px' value='驳回'>";
	btnReject +="</input>";
	
	var usageSelect="<label>常用意见</label>&nbsp<select><option>==请选择==</option></select>";
	
	domElement.innerHTML=textarea+"<br/>"+btnSubmit+"&nbsp;"+btnReject+"&nbsp;&nbsp;"+usageSelect;
}
function _Designer_Control_auditNote_DrawXML(){
}
function _Designer_Control_auditNote_OnDrawEnd(){
}
function _Designer_Control_AuditNote_Attr_Mould_Change(mouldSelect){
	
	var html=_GetHTMLByHanderType(mouldSelect.value);
	
	$("#auditnote_mouldDetail_html").html(html);
}
function _Designer_Control_AuditNote_Attr_MouldDetail_Self_Draw(name, attr, value, form, attrs, values,control){	
	var mouldValue = attrs.mould.value;
	if(values.mould){
		mouldValue=values.mould;
	}
	html="<div id='auditnote_mouldDetail_html'>"+_GetHTMLByHanderType(mouldValue,value)+"</div>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}
function _GetHTMLByHanderType(mouldValue,val){
	var html=[];
	var names="";
	var labels="";
	if(val){
		mames=val.split("~")[0];
		labels=val.split("~")[1];
	}
	switch(mouldValue)
	{
		case '11':
		{
			//onpropertychange 审批人属于
			lableText=' 审批人属于';
			html.push("<input type='text' id='detail_attr_name' name='detail_attr_name' readonly='true'  class='inputsgl' value='"+labels+"'/>");
			html.push("<span class='txtstrong'>*</span>");
			html.push("<input type='hidden' id='detail_attr_value' name='detail_attr_value' value='"+names+"'/>");
			html.push("<a href='#' id='handlerSelect' onclick=\"Dialog_Address(true, 'detail_attr_value','detail_attr_name', ';',ORG_TYPE_ALL,After_MouldDetailSelect_Set);\">"+Designer_Lang.auditshow_choose+"</a>");
			break;
		}
		case '12':
		{
			//审批人属于
			lableText=' 审批人属于';
			html.push("<input type='text' id='detail_attr_name' name='detail_attr_name' readonly='true'  class='inputsgl' value='"+labels+"'/>");
			html.push("<span class='txtstrong'>*</span>");
			html.push("<input type='hidden' id='detail_attr_value' name='detail_attr_value'  value='"+names+"'/>");
			html.push("<a href='#' id='handlerSelect' onclick=\"Formula_Dialog('detail_attr_value','detail_attr_name',Designer.instance.getObj(true),'Object',After_MouldDetailSelect_Set,null,Designer.instance.control.owner.owner._modelName);\">"+Designer_Lang.auditshow_choose+"</a>");
			break;
		}
		case '21':
		{
			//选择展示节点
			lableText=' 选择节点';
			html.push("<input type='text' id='detail_attr_name' name='detail_attr_name'   readonly='true'  class='inputsgl' value='"+labels+"'/>");
			html.push("<span class='txtstrong'>*</span>");
			html.push("<input type='hidden' id='detail_attr_value' name='detail_attr_value'  value='"+names+"'/>");
			html.push("<a href='#' id='handlerSelect' onclick=\"Dialog_List_ShowNode('detail_attr_value','detail_attr_name', ';','',After_MouldDetailSelect_Set);\">"+Designer_Lang.auditshow_choose+"</a>");
			break;
		}
	}
	
	//设置mouldDetail Label
	if($("#auditnote_mouldDetail_html")[0]){
		//<tr><td width="25%" class="panel_td_title">' + attr.text + '</td><td>' + html + '</td></tr>'
		
		$("#auditnote_mouldDetail_html").parent().prev().text(lableText);
	}
	html=html.join('');
	return html;
}
function After_MouldDetailSelect_Set(rtnvalue){
	if(!rtnvalue){
		return;
	}
	var control=Designer.instance.attrPanel.panel.control;
	var values=control.options.values;
	
	var names=[];
	var labels=[];
	
	for(var i=0;i<rtnvalue.data.length;i++){
		names.push(rtnvalue.data[i].id);
		labels.push(rtnvalue.data[i].name);
	}
	if(names.length>0){
		values.mouldDetail=names.join(";")+"~"+labels.join(";");
	}
	else{
		values.mouldDetail="";
	}
}