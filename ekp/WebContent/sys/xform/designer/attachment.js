/**********************************************************
功能：附件控件
使用：
	
作者：傅游翔
创建时间：2009-04-28
**********************************************************/
Designer_Config.controls.attachment = {
	type : 'attachment',
	storeType : 'none',
	inherit    : 'base',
	onDraw : _Designer_Control_Attachment_OnDraw,
	drawXML : _Designer_Control_Attachment_DrawXML,
	attrs : {
		label : {
			text : Designer_Lang.controlAttrLabel,
			value: "",
			type: 'label',
			show: true,
			required: true,
			validator: [Designer_Control_Attr_Required_Validator,Designer_Control_Attr_Label_Validator],
			checkout: [Designer_Control_Attr_Required_Checkout,Designer_Control_Attr_Label_Checkout]
		},
		required: {
			text: Designer_Lang.controlAttrRequired,
			value: "false",
			type: 'checkbox',
			checked: false,
			show: true
		},
		fileType : {
			text : Designer_Lang.controlAttachAttrFileType,
			value: "",
			type: 'text',
			hint: Designer_Lang.controlAttachAttrFileTypeHint,
			show: true
		},
		sizeType: {
			text : Designer_Lang.controlAttachAttrSizeType,
			value: 'multi',
			type: 'radio',
			opts: [
				{text:Designer_Lang.controlAttachAttrSizeTypeSingle,value:'single'},
				{text:Designer_Lang.controlAttachAttrSizeTypeMulti,value:'multi'}
			],
			show: true
		}
	},
	info : {
		name: Designer_Lang.controlAttachInfoName
	},
	resizeMode : 'no'
}

function _Designer_Control_Attachment_OnDraw(parentNode, childNode){
	var values = this.options.values;
	var multi = (values.sizeType == 'multi' || values.sizeType == null);
	
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	domElement.style.width = '235px';
	domElement.style.textAlign = 'left';
	if (values.fileType != null && values.fileType != '') {
		domElement.title = Designer_Lang.controlAttachDomTitle.replace(/\{type\}/, values.fileType);
	}
	if(values.id == null)
		values.id = "fd_" + Designer.generateID();
	domElement.setAttribute('id', values.id);
	domElement.setAttribute('enabledFileType', (values.fileType == null ? '' : values.fileType));
	domElement.setAttribute('fdMulti', multi.toString());
	domElement.setAttribute('label', _Get_Designer_Control_Label(this.options.values, this));
	domElement.setAttribute('required', values.required==null?'false':values.required);
	if (this.parent != null) {
		domElement.setAttribute('tableName', _Get_Designer_Control_TableName(this.parent));
	}
	var buf = [' <button onclick="return false;" class="btnopt">',Designer_Lang.controlAttachDomAddBtn,'</button> ',
		' <button onclick="return false;" class="btnopt">',Designer_Lang.controlAttachDomDelBtn,'</button>'];
	buf.push('<table><tr>');
	buf.push('<td class="td_normal_title"><input type="checkbox" onclick="return false;"></td>');
	buf.push('<td class="td_normal_title">',Designer_Lang.controlAttachDomFileName,'</td>');
	buf.push('<td class="td_normal_title">',Designer_Lang.controlAttachDomFileSize,'</td>');
	buf.push('</tr><tr>');
	buf.push('<td ><input type="checkbox" onclick="return false;"></td>');
	buf.push('<td >',Designer_Lang.controlAttachDomSampleFileName,'</td>');
	buf.push('<td >',Designer_Lang.controlAttachDomSampleFileSize,'</td>');
	if (multi) {
		buf.push('</tr><tr>');
		buf.push('<td ><input type="checkbox" onclick="return false;"></td>');
		buf.push('<td >',Designer_Lang.controlAttachDomSample2FileName,'</td>');
		buf.push('<td >',Designer_Lang.controlAttachDomSample2FileSize,'</td>');
	}
	buf.push('</tr></table>');
	domElement.innerHTML = buf.join('');
}

function _Designer_Control_Attachment_DrawXML() {
	return '';
}