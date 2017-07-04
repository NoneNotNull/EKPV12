/**********************************************************
功能：控件配置
使用：
	
作者：龚健
创建时间：2009-02-21
**********************************************************/
Designer_Config = {}
Designer_Config.font = {
		style : [
			{text:Designer_Lang.configFontSelect, value:''},
			{text:Designer_Lang.configFontSongTi, value:Designer_Lang.configFontSongTi, style:'font-family:'+Designer_Lang.configFontSongTi},
			{text:Designer_Lang.configFontXinSongTi, value:Designer_Lang.configFontXinSongTi, style: 'font-family:'+Designer_Lang.configFontXinSongTi},
			{text:Designer_Lang.configFontKaiTi, value:Designer_Lang.configFontKaiTi, style: 'font-family:'+Designer_Lang.configFontKaiTi},
			{text:Designer_Lang.configFontHeiTi, value:Designer_Lang.configFontHeiTi, style: 'font-family:'+Designer_Lang.configFontHeiTi},
			{text:Designer_Lang.configFontYouYuan, value:Designer_Lang.configFontYouYuan, style: 'font-family:'+Designer_Lang.configFontYouYuan},
			{text:Designer_Lang.configFontYaHei, value:Designer_Lang.configFontYaHei, style: 'font-family:'+Designer_Lang.configFontYaHei},
			{text:Designer_Lang.configFontCourierNew, value:Designer_Lang.configFontCourierNew, style: 'font-family:\"'+Designer_Lang.configFontCourierNew+'\"'},
			{text:Designer_Lang.configFontTimesNewRoman, value:Designer_Lang.configFontTimesNewRoman, style: 'font-family:\"'+Designer_Lang.configFontTimesNewRoman+'\"'},
			{text:Designer_Lang.configFontTahoma, value:Designer_Lang.configFontTahoma, style: 'font-family:\"'+Designer_Lang.configFontTahoma+'\"'},
			{text:Designer_Lang.configFontArial, value:Designer_Lang.configFontArial, style: 'font-family:\"'+Designer_Lang.configFontArial+'\"'},
			{text:Designer_Lang.configFontVerdana, value:Designer_Lang.configFontVerdana, style: 'font-family:\"'+Designer_Lang.configFontVerdana+'\"'}
		],
		size : (function() {
			var ops = [];
			ops.push({text: Designer_Lang.configSizeSelect, value:''});
			for (var i = 9; i < 26; i ++) {
				ops.push({text: i + Designer_Lang.configSizePx, value: i + 'px'});
			}
			return ops;
		})()
	};
Designer_Config.attrs = {
	label : {
		text : Designer_Lang.controlAttrLabel,
		value: "",
		type: 'label',
		show: true,
		required: true,
		validator: [Designer_Control_Attr_Required_Validator,Designer_Control_Attr_Label_Validator],
		checkout: [Designer_Control_Attr_Required_Checkout,Designer_Control_Attr_Label_Checkout],
		convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
	},
	defaultValue : {
		text: Designer_Lang.controlAttrDefaultValue,
		value: "",
		type: 'defaultValue',
		show: true,
		validator: Designer_InputText_DefaultValue_Validator,
		checkout: Designer_InputText_DefaultValue_Checkout,
		convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
	},
	formula : {
		text: Designer_Lang.controlAttrFormula,
		value: "",
		type: '',
		show: false,
		convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
	},
	reCalculate : {
		text: Designer_Lang.controlAttrReCalculate,
		value: "",
		type: '',
		show: false
	},
	readOnly : {
		text : Designer_Lang.controlAttrReadOnly,
		value : false,
		type : 'checkbox',
		show: true
	}
};
Designer_Config.controls = {
		//===== textLabel begin =====
		textLabel : {
			type : "textLabel",
			storeType : 'none',
			isTextLabel : true,
			inherit    : 'base',
			onDraw : _Designer_Control_TextLabel_OnDraw,
			onDrawEnd : _Designer_Control_TextLabel_OnDrawEnd,
			setBold : _Designer_Control_SetLabel_Bold,
			setItalic : _Designer_Control_SetLabel_Italic,
			setUnderline : _Designer_Control_SetLabel_Underline,
			setColor : _Designer_Control_SetLabel_Color,
			getColor : _Designer_Control_GetLabel_Color,
			setFontStyle : _Designer_Control_SetLabel_FontStyle,
			getFontStyle : _Designer_Control_GetLabel_FontStyle,
			setFontSize : _Designer_Control_SetLabel_FontSize,
			getFontSize : _Designer_Control_GetLabel_FontSize,
			implementDetailsTable : true,
			attrs : {
				content : {
					text: Designer_Lang.controlTextLabelAttrContent,
					value: "",
					type: 'textarea',
					show: true,
					required: true,
					validator: Designer_Control_Attr_Required_Validator,
					convertor: Designer_Control_Attr_HtmlEscapeConvertor
				},
				font : {
					text: Designer_Lang.controlTextLabelAttrFont,
					value: "",
					type: 'select',
					opts: Designer_Config.font.style,
					show: true
				},
				size : {
					text: Designer_Lang.controlTextLabelAttrSize,
					value: "",
					type: 'select',
					opts: Designer_Config.font.size,
					show: true
				},
				color : {
					text: Designer_Lang.controlTextLabelAttrColor,
					value: "#000",
					type: 'color',
					show: true
				},
				effect : {
					text: Designer_Lang.controlTextLabelAttrEffect,
					value : '',
					type : 'checkGroup',
					opts: [
						{name: 'b', text: Designer_Lang.controlTextLabelAttrBold, value:'true'},
						{name: 'i', text: Designer_Lang.controlTextLabelAttrItalic, value:'true'},
						{name: 'underline', text: Designer_Lang.controlTextLabelAttrUnderline, value:'true'}
					],
					show: true
				},
				b : {
					text: Designer_Lang.controlTextLabelAttrBold,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: false
				},
				i : {
					text: Designer_Lang.controlTextLabelAttrItalic,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: false
				},
				underline : {
					text: Designer_Lang.controlTextLabelAttrUnderline,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: false
				}
			},
			info : {
				name: Designer_Lang.controlTextLabelInfoName
			},
			resizeMode : 'no'  //尺寸调整模式(onlyWidth, onlyHeight, all, no)
		},
		//===== textLabel end =====
		//===== inputText begin =====
		inputText : {
			type : "inputText",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_InputText_OnDraw,
			drawXML : _Designer_Control_InputText_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow : {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'checkbox',
					checked: true,
					show: true
				},
				readOnly : Designer_Config.attrs.readOnly,
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
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
				dataType : {
					text: Designer_Lang.controlAttrDataType,
					value: "String",
					opts: [{text:Designer_Lang.controlAttrDataTypeText,value:"String"},
						{text:Designer_Lang.controlAttrDataTypeNumber,value:"Double"},
						{text:Designer_Lang.controlAttrDataTypeBigNumber,value:"BigDecimal"}],
					onchange: '_Designer_Control_Attr_InputText_DataTypeOnchange(this);',
					show: true,
					type: 'select'
				},
				validate :{
					text: Designer_Lang.controlInputTextAttrValidate,
					value: "false",
					show: true,
					type: 'self',
					draw: _Designer_Control_Attr_InputText_Self_Draw
				},
				maxlength: {
					text: Designer_Lang.controlInputTextAttrMaxlength,
					show: false,
					validator: Designer_Control_Attr_Int_Validator,
					checkout: Designer_Control_Attr_Int_Checkout
				},
				decimal: {
					text: Designer_Lang.controlInputTextAttrDecimal,
					show: false,
					validator: [Designer_Control_Attr_Required_Validator,
						Designer_Control_Attr_Int_Validator],
					checkout: Designer_Control_Attr_Int_Checkout
				},
				begin: {
					text: Designer_Lang.controlInputTextAttrBegin,
					show: false,
					validator: [Designer_Control_Attr_Number_Validator,
						Designer_InputText_NumberValue_Validator],
					checkout: [Designer_Control_Attr_Number_Checkout,
						Designer_InputText_NumberValue_Checkout]
				},
				end: {
					text: Designer_Lang.controlInputTextAttrEnd,
					show: false,
					validator: [Designer_Control_Attr_Number_Validator,
						Designer_InputText_NumberValue_Validator],
					checkout: [Designer_Control_Attr_Number_Checkout,
						Designer_InputText_NumberValue_Checkout]
				},
				thousandShow : {
					text: Designer_Lang.controlAttrThousandShow,
					value: "false",
					type: 'checkbox',
					checked: false,
					show: true
				},
				defaultValue: Designer_Config.attrs.defaultValue,
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			
			},
			info : {
				name: Designer_Lang.controlInputTextInfoName,
				preview: "input.bmp"
			},
			resizeMode : 'onlyWidth'
		},
		//===== inputText end =====
		//===== textarea begin =====
		textarea : {
			type : "textarea",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_Textarea_OnDraw,
			drawXML : _Designer_Control_Textarea_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow : {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'hidden',
					checked: true,
					show: true
				},
				readOnly : Designer_Config.attrs.readOnly,
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
				},
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: true
				},
				dataType : {
					text: Designer_Lang.controlAttrDataType,
					value: "String",
					type : "hidden",
					show: true
				},
				maxlength: {
					text: Designer_Lang.controlTextareaMaxlength,
					show: true,
					type: 'text',
					value: '',
					hint: Designer_Lang.controlTextareaMaxlength_hint,
					validator: Designer_Control_Attr_Int_Validator,
					checkout: Designer_Control_Attr_Int_Checkout
				},
				defaultValue: Designer_Config.attrs.defaultValue,
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info : {
				name: Designer_Lang.controlTextareaInfoName,
				preview: "textarea.bmp"
			},
			resizeMode : 'all'
		},
		//===== testarea end =====
		//===== inputCheckbox begin =====
		inputCheckbox : {
			type : "inputCheckbox",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_InputCheckbox_OnDraw,
			drawXML : _Designer_Control_InputCheckbox_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow: {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'hidden',
					checked: true,
					show: true
				},
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: true
				},
				alignment: {
					text: Designer_Lang.controlAttrAlignment,
					value: 'H',
					type: 'radio',
					opts: [{text:Designer_Lang.controlAttrAlignmentH,value:"H"},{text:Designer_Lang.controlAttrAlignmentV,value:"V"}],
					show: true
				},
				dataType : {
					text: Designer_Lang.controlAttrDataType,
					value: "String",
					opts: [{text:Designer_Lang.controlAttrDataTypeText,value:"String"},
						{text:Designer_Lang.controlAttrDataTypeNumber,value:"Double"}],
					show: true,
					type: 'hidden'
				},
				items: {
					text: Designer_Lang.controlAttrItems,
					value: "",
					type: 'textarea',
					hint: Designer_Lang.controlAttrItemsHint,
					show: true,
					required: true,
					validator: [Designer_Control_Attr_Required_Validator,Designer_Items_NumberType_Validator],
					checkout: [Designer_Control_Attr_Required_Checkout,Designer_Items_NumberType_Checkout],
					convertor: Designer_Control_Attr_ItemsTrimConvertor
				},
				defaultValue : {
					text: Designer_Lang.controlAttrDefaultValue,
					defaultValueHint: Designer_Lang.controlAttrItemsDefaultValueHint,
					value: "",
					type: 'defaultValue',
					show: true,
					validator: Designer_Items_DefaultValues_Validator,
					checkout: Designer_Items_DefaultValues_Checkout,
					convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
				},
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info : {
				name: Designer_Lang.controlInputCheckboxInfoName,
				preview: "checkbox.bmp"
			},
			resizeMode : 'no'
		},
		//===== inputCheckbox end =====
		//===== inputRadio begin =====
		inputRadio : {
			type : "inputRadio",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_InputRadio_OnDraw,
			drawXML : _Designer_Control_InputRadio_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow: {
					text: Designer_Lang.controlAttrLabel,
					value: "true",
					type: 'hidden',
					checked: true,
					show: true
				},
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: true
				},
				alignment: {
					text: Designer_Lang.controlAttrAlignment,
					value: 'H',
					type: 'radio',
					opts: [{text:Designer_Lang.controlAttrAlignmentH,value:"H"},{text:Designer_Lang.controlAttrAlignmentV,value:"V"}],
					show: true
				},
				dataType : {
					text: Designer_Lang.controlAttrDataType,
					value: "String",
					opts: [{text:Designer_Lang.controlAttrDataTypeText,value:"String"},
						{text:Designer_Lang.controlAttrDataTypeNumber,value:"Double"}],
					show: true,
					type: 'select'
				},
				items: {
					text: Designer_Lang.controlAttrItems,
					value: "",
					type: 'textarea',
					hint: Designer_Lang.controlAttrItemsHint,
					show: true,
					required: true,
					validator: [Designer_Control_Attr_Required_Validator,Designer_Items_NumberType_Validator],
					checkout: [Designer_Control_Attr_Required_Checkout,Designer_Items_NumberType_Checkout],
					convertor: Designer_Control_Attr_ItemsTrimConvertor
				},
				defaultValue : {
					text: Designer_Lang.controlAttrDefaultValue,
					value: "",
					type: 'defaultValue',
					show: true,
					validator: Designer_Items_DefaultValue_Validator,
					checkout: Designer_Items_DefaultValue_Checkout,
					convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
				},
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info : {
				name: Designer_Lang.controlInputRadioInfoName,
				preview: "radio.bmp"
			},
			resizeMode : 'no'
		},
		//===== inputRadio end =====
		//===== select begin =====
		select : {
			type : "select",
			storeType : 'field',
			inherit : 'base',
			onDraw : _Designer_Control_Select_OnDraw,
			drawXML : _Designer_Control_Select_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow: {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'hidden',
					checked: true,
					show: true
				},
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: true
				},
				dataType : {
					text: Designer_Lang.controlAttrDataType,
					value: "String",
					opts: [{text:Designer_Lang.controlAttrDataTypeText,value:"String"},
						{text:Designer_Lang.controlAttrDataTypeNumber,value:"Double"}],
					show: true,
					type: 'select'
				},
				items: {
					text: Designer_Lang.controlAttrItems,
					value: "",
					type: 'textarea',
					hint: Designer_Lang.controlAttrItemsHint,
					show: true,
					required: true,
					validator: [Designer_Control_Attr_Required_Validator,Designer_Items_NumberType_Validator],
					checkout: [Designer_Control_Attr_Required_Checkout,Designer_Items_NumberType_Checkout],
					convertor: Designer_Control_Attr_ItemsTrimConvertor
				},
				defaultValue : {
					text: Designer_Lang.controlAttrDefaultValue,
					value: "",
					type: 'defaultValue',
					show: true,
					validator: Designer_Items_DefaultValue_Validator,
					checkout: Designer_Items_DefaultValue_Checkout,
					convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
				},
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info : {
				name: Designer_Lang.controlSelectInfoName,
				preview: "select.bmp"
			},
			resizeMode : 'no'
		},
		//===== select end =====
		//===== rtf begin =====
		rtf : {
			type : "rtf",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_Rtf_OnDraw,
			drawXML : _Designer_Control_Rtf_DrawXML,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow: {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'hidden',
					checked: true,
					show: true
				},
				width: {
					text: Designer_Lang.controlAttrWidth,
					value: "80%",
					type: 'text',
					show: true,
					validator: Designer_Control_Attr_Width_Validator,
					checkout: Designer_Control_Attr_Width_Checkout
				},
				height: {
					text: Designer_Lang.controlAttrHeight,
					value: "220",
					type: 'text',
					show: true
				},
				dataType : {
					text : Designer_Lang.controlAttrDataType,
					type : 'hidden',
					show : true,
					value : 'RTF'
				},
				needFilter: {
					text: Designer_Lang.controlAttrNeedFilter,
					value: "true",
					type: 'checkbox',
					checked: true,
					show: false
				},
				defaultValue: Designer_Config.attrs.defaultValue,
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			info : {
				name: Designer_Lang.controlRtfInfoName,
				preview: "rtf.bmp"
			},
			resizeMode : 'all'
		},
		//===== rtf end =====
		//===== address begin =====
		address : {
			type : "address",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_Address_OnDraw,
			drawXML : _Designer_Control_Address_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow : {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'hidden',
					checked: true
				},
				readOnly : Designer_Config.attrs.readOnly,
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
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
				businessType : {
					text: Designer_Lang.controlAddressAttrBusinessType,
					value: "addressDialog",
					type: 'hidden',
					show: true
				},
				multiSelect : {
					text: Designer_Lang.controlAddressAttrMultiSelect,
					value: "true",
					type: 'checkbox',
					checked: false,
					show: true,
					onclick: '_Show_Address_DefaultValue(this.form.defaultValue);'
				},
				orgType :{
					text: Designer_Lang.controlAddressAttrOrgType,
					value: "ORG_TYPE_PERSON",
					type: 'checkGroup',
					opts: [{text:Designer_Lang.controlAddressAttrOrgTypeOrg,value:"ORG_TYPE_ORG", name: '_org_org', onclick: "_Show_Address_DefaultValue(this.form.defaultValue)"},
						{text:Designer_Lang.controlAddressAttrOrgTypeDept,value:"ORG_TYPE_DEPT", name: '_org_dept', onclick: "_Designer_Control_Attr_Address_SelectDept(this.form);_Show_Address_DefaultValue(this.form.defaultValue)"},
						{text:Designer_Lang.controlAddressAttrOrgTypePost,value:"ORG_TYPE_POST", name: '_org_post', onclick: "_Show_Address_DefaultValue(this.form.defaultValue)"},
						{text:Designer_Lang.controlAddressAttrOrgTypePerson,value:"ORG_TYPE_PERSON", name: '_org_person', checked: true, onclick: "_Show_Address_DefaultValue(this.form.defaultValue)"},
						{text:Designer_Lang.controlAddressAttrOrgTypeGroup,value:"ORG_TYPE_GROUP", name: '_org_group', onclick: "_Designer_Control_Attr_Address_SelectGroup(this.form);_Show_Address_DefaultValue(this.form.defaultValue)"}],
					show: true,
					validator : Designer_Address_OrgType_Validator,
					checkout: Designer_Address_OrgType_Checkout
				},
				defaultValue: {
					text: Designer_Lang.controlAttrDefaultValue,
					value: "null",
					type: 'self',
					draw: _Designer_Control_Attr_Address_Self_Draw,
					opts: [{text:Designer_Lang.controlAddressAttrDefaultValueNull,value:"null"},
						{text:Designer_Lang.controlAddressAttrDefaultValueSelf,value:"ORG_TYPE_PERSON"},
						{text:Designer_Lang.controlAddressAttrDefaultValueSelfOrg,value:"ORG_TYPE_ORG"},
						{text:Designer_Lang.controlAddressAttrDefaultValueSelfDept,value:"ORG_TYPE_DEPT"},
						{text:Designer_Lang.controlAddressAttrDefaultValueSelfPost,value:"ORG_TYPE_POST"},
						{text:Designer_Lang.controlAddressAttrDefaultValueSelect,value:"select"}],
					show: true,
					validator : Designer_Address_DefaultValue_Validator,
					checkout: Designer_Address_DefaultValue_Checkout
				},
				formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			onAttrLoad : _Designer_Control_Attr_Address_OnAttrLoad,
			info : {
				name: Designer_Lang.controlAddressInfoName,
				preview: "address.bmp"
			},
			resizeMode : 'onlyWidth'
		},
		//===== address end =====
		//===== datetime begin =====
		datetime : {
			type : "datetime",
			storeType : 'field',
			inherit    : 'base',
			onDraw : _Designer_Control_Datetime_OnDraw,
			drawXML : _Designer_Control_Datetime_DrawXML,
			implementDetailsTable : true,
			attrs : {
				label : Designer_Config.attrs.label,
				canShow : {
					text: Designer_Lang.controlAttrCanShow,
					value: "true",
					type: 'hidden',
					checked: true,
					show: true
				},
				readOnly : Designer_Config.attrs.readOnly,
				required: {
					text: Designer_Lang.controlAttrRequired,
					value: "true",
					type: 'checkbox',
					checked: false,
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
				businessType : {
					text: Designer_Lang.controlDatetimeAttrBusinessType,
					value: "dateDialog",
					type: 'select',
					opts: [{text:Designer_Lang.controlDatetimeAttrBusinessTypeDate,value:"dateDialog"},
						{text:Designer_Lang.controlDatetimeAttrBusinessTypeTime,value:"timeDialog"},
						{text:Designer_Lang.controlDatetimeAttrBusinessTypeDatetime,value:"datetimeDialog"}],
					onchange: "_Designer_Control_Attr_Datetime_ShowDefaultValue(this.form.defaultValue)",
					show: true
				},
//				history: {
//					text: "不允许历史值",
//					value: "true",
//					type: 'checkbox',
//					checked: false,
//					show: true
//				},
				defaultValue: {
					text: Designer_Lang.controlAttrDefaultValue,
					value: "null",
					type: 'self',
					opts: [{text:Designer_Lang.controlDatetimeAttrDefaultValueNull,value:"null"},
						{text:Designer_Lang.controlDatetimeAttrDefaultValueNowTime,value:"nowTime"},
						{text:Designer_Lang.controlDatetimeAttrDefaultValueSelect,value:"select"}],
					show: true,
					draw: _Designer_Control_Attr_Datetime_Self_Draw,
					validator : Designer_Datetime_DefaultValue_Validator,
					checkout : Designer_Datetime_DefaultValue_Checkout
				}, //formula: Designer_Config.attrs.formula,
				reCalculate: Designer_Config.attrs.reCalculate
			},
			onAttrLoad : _Designer_Control_Attr_Datetime_OnAttrLoad,
			info : {
				name: Designer_Lang.controlDatetimeInfoName,
				preview: "date.bmp"
			},
			resizeMode : 'onlyWidth'
		},
		//===== datetime end =====
		//===== standardTable begin =====
		standardTable : {
			type : "standardTable",
			storeType : 'layout',
			inherit    : 'table',
			onDraw : _Designer_Control_StandardTable_OnDraw,
			onDrawEnd : _Designer_Control_StandardTable_OnDrawEnd,
			drawXML : _Designer_Control_StandardTable_DrawXML,
			implementDetailsTable : true,
			//onInitialize:_Designer_Contro_StandardTable_DoInitialize,
			onShiftDrag   : _Designer_Control_Base_DoDrag,
			onShiftDragMoving: _Designer_Control_Base_DoDragMoving,
			onShiftDragStop: _Designer_Control_Base_DoDragStop,
			onDragStop    : function(){
				_Designer_Control_Base_DoDragStop.call(this);
				this.rowStart=-1;
				this.columnStart=-1;
			},     //拖拽结束
			
			onDrag:function(event){
				var _prevDragDomElement = this.owner._dragDomElement, currElement = event.srcElement || event.target;
				//右键不认为是点击事件  2009-05-18 傅游翔
				if (Designer.eventButton(event) == 2) return;
				
				var currElement = event.srcElement || event.target;
				//若选中的不是单元格，则退出
				if (Designer.checkTagName(currElement, 'td')){
					this.columnStart=currElement.cellIndex;
					this.rowStart=currElement.parentNode.rowIndex;
				}
				_Designer_Control_Base_DoDrag.call(this,event);
				
				
			},
			onDragMoving:function(event){
				
			
				if(Designer.UserAgent == 'msie') {
					this.options.domElement.setCapture();
					event.cancelBubble = true;
				} else {
					event.preventDefault();
					event.stopPropagation();
				}
				window.getSelection ? window.getSelection().removeAllRanges() : document.selection.empty();
				//控件锁定，则不能移动
				if (event.ctrlKey) return;
				if (this.dragAction.onMove)
					this.dragAction.onMove(event, this);
				
				
				
				var builder = this.owner,currElement=table = this.options.domElement;
				var mousePos = builder.getMouseRelativePosition(event);
				//减少循环次数
				if(mousePos.x%5!=0&&mousePos.y%3!=0){
					return ;
				}
				
				var rows = table.rows;		
				if(this.rowStart<0||this.columnStart<0){
					return ;
				}
				var startCell=rows[this.rowStart].cells[this.columnStart];
				var startPos=Designer.absPosition(startCell);
				
				for(var i=0;i<rows.length;i++){
					var height=rows[i].offsetHeight;
					var columns=rows[i].cells.length;
					for(var j=0;j<columns;j++){
						var cellPos=Designer.absPosition(rows[i].cells[j]);	
						var width=parseInt(rows[i].cells[j].width);
					
						var leftX=startPos.x;
						var rightX=mousePos.x;
						
						if(mousePos.x<startPos.x){
							leftX=mousePos.x-width;
							rightX=startPos.x;
						}
						var leftY= startPos.y;
						var rightY= mousePos.y;
						if(mousePos.y<startPos.y){
							leftY=mousePos.y-height ;
							rightY=startPos.y;
						}
						if(cellPos.x>=leftX && cellPos.x<=rightX &&cellPos.y>=leftY &&cellPos.y<=rightY ){
							this.chooseCell(rows[i].cells[j],true);
							//this.onSelect();
						}
						else{
							this.chooseCell(rows[i].cells[j],false);
						}
						
					}
				}
			},
			attrs : {
				label : {
					text : Designer_Lang.controlAttrLabel,
					value: "",
					type: 'text',
					show: true,
					required: true,
					validator: Designer_Control_Attr_Required_Validator,
					checkout: Designer_Control_Attr_Required_Checkout
				}
				,
				tableStyle : {
					text : '表格样式',
					value : '',
					type : 'self',
					draw : _Designer_Control_Attr_standardTable_style_Self_Draw,
					//checkout:Designer_Layout_Control_fieldParams_Required_Checkout,
					show : true
				},
				help:{
					text: Designer_Lang.controlStandardTableLabelHelp,
					type: 'help',
					align:'left',
					show: true
				}
			},
			domAttrs : {
				td : {
					chooseTable:{
						text: "<a href='#' style='text-decoration:underline' onclick='javascript:if(Designer.instance.attrPanel.panel.control.onUnLock)Designer.instance.attrPanel.panel.control.onUnLock();Designer.instance.attrPanel.open();'>打开表格属性</a>",
						type: 'help',
						align:'right'
					}
					,
					style_textAlign: {
						text: Designer_Lang.controlStandardTableDomAttrTdAlign,
						value: "left",
						type: 'radio',
						opts: [
							{text:Designer_Lang.controlStandardTableDomAttrTdAlignLeft,value:"left"}, // left
							{text:Designer_Lang.controlStandardTableDomAttrTdAlignCenter,value:"center"},
							{text:Designer_Lang.controlStandardTableDomAttrTdAlignRight,value:"right"}
						]
					},
					style_verticalAlign: {
						text: Designer_Lang.controlStandardTableDomAttrTdVAlign,
						value: "middle",
						type: 'radio',
						opts: [
							{text:Designer_Lang.controlStandardTableDomAttrTdVAlignTop,value:"top"},
							{text:Designer_Lang.controlStandardTableDomAttrTdVAlignMiddle,value:"middle"}, // middle
							{text:Designer_Lang.controlStandardTableDomAttrTdVAlignBottom,value:"bottom"}
						]
					},
					className: {
						text: Designer_Lang.controlStandardTableDomAttrTdClassName,
						value: "tb_normal",
						type: 'radio',
						opts: [
							{text:Designer_Lang.controlStandardTableDomAttrTdClassNameNormal,value:"tb_normal"}, // tb_normal
							{text:Designer_Lang.controlStandardTableDomAttrTdClassNameTitle,value:"td_normal_title"}
						]
					},
					style_borderLeftWidth : {
						text: '左边框',
						value: "null",
						type: 'select',
						opts: [
						       	{text:'默认',value:"null"},
						       	{text:'0px',value:"0px"},
								{text:'1px',value:"1px"}, // tb_normal
								{text:'2px',value:"2px"},
								{text:'3px',value:"3px"},
								{text:'4px',value:"4px"},
								{text:'5px',value:"5px"}
							]
					}
					,
					style_borderRightWidth : {
						text: '右边框',
						value: "null",
						type: 'select',
						opts: [
						   	{text:'默认',value:"null"},
					       	{text:'0px',value:"0px"},
							{text:'1px',value:"1px"}, // tb_normal
							{text:'2px',value:"2px"},
							{text:'3px',value:"3px"},
							{text:'4px',value:"4px"},
							{text:'5px',value:"5px"}
							]
					},
					style_borderTopWidth : {
						text: '上边框',
						value: "null",
						type: 'select',
						opts: [
						       	{text:'默认',value:"null"},
						       	{text:'0px',value:"0px"},
								{text:'1px',value:"1px"}, // tb_normal
								{text:'2px',value:"2px"},
								{text:'3px',value:"3px"},
								{text:'4px',value:"4px"},
								{text:'5px',value:"5px"}
							]
					},
					style_borderBottomWidth : {
						text: '下边框',
						value: "null",
						type: 'select',
						opts: [
						   	{text:'默认',value:"null"},
					       	{text:'0px',value:"0px"},
							{text:'1px',value:"1px"}, // tb_normal
							{text:'2px',value:"2px"},
							{text:'3px',value:"3px"},
							{text:'4px',value:"4px"},
							{text:'5px',value:"5px"}
							]
					}
					,
					help:{
						text: Designer_Lang.controlStandardTableLabelHelp,
						type: 'help',
						align:'left'
					}
				}
			},
			info : {
				name: Designer_Lang.controlStandardTableInfoName,
				td: Designer_Lang.controlStandardTableInfoTd
			},
			resizeMode : 'no'
		}
		//===== standardTable end =====
	}

// =================== 控件绘制 
// 生成控件Dom对象
function _CreateDesignElement(type, control, parentNode, childNode) {
	var domElement = document.createElement(type);
	domElement.setAttribute("formDesign", "landray");
	domElement.style.display = 'inline';
	control.options.domElement = domElement;
	parentNode.insertBefore(domElement, childNode);
	return domElement;
}

_Designer_Index_Object = {
	label : 1,
	textLabel : 1,
	linkLabel : 1,
	test: 1,
	table: 0
};
function _Get_Designer_Control_Label(values, control) {
	if (control.attrs.label && values._label_bind == null) {
		values._label_bind = 'true';
	}
	if (values._label_bind == 'true') {
		var textLabel = control.getRelatedTextControl();
		values.label = textLabel ? textLabel.options.values.content : '';
		values._label_bind_id = textLabel ? textLabel.options.values.id : '';
	}
	return values.label;
}

function _Get_Designer_Control_TableName(parent) {
	if (parent == null) return "";
	var tableName = parent.options.domElement.id;
	if (tableName == null || tableName == "") {
		tableName = _Get_Designer_Control_TableName(parent.parent);
	}
	return tableName;
}

function _Designer_Control_SetLabel_Bold() {
	this.options.values.b = this.options.values.b == "true" ? "false" : "true";
	this.owner.setProperty(this);
}

function _Designer_Control_SetLabel_Italic() {
	this.options.values.i = this.options.values.i == "true" ? "false" : "true";
	this.owner.setProperty(this);
}

function _Designer_Control_SetLabel_Underline() {
	this.options.values.underline = this.options.values.underline == "true" ? "false" : "true";
	this.owner.setProperty(this);
}

function _Designer_Control_SetLabel_Color(value) {
	this.options.values.color = value;
	this.owner.setProperty(this);
}

function _Designer_Control_GetLabel_Color() {
	return this.options.values.color;
}

function _Designer_Control_SetLabel_FontStyle(value) {
	this.options.values.font = value;
	this.owner.setProperty(this);
}

function _Designer_Control_GetLabel_FontStyle() {
	return this.options.values.font;
}

function _Designer_Control_SetLabel_FontSize(value) {
	this.options.values.size = value;
	this.owner.setProperty(this);
}

function _Designer_Control_GetLabel_FontSize() {
	return this.options.values.size;
}

//生成文本标签Dom对象
function _Designer_Control_TextLabel_OnDraw(parentNode, childNode){
	var domElement = _CreateDesignElement('label', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	if(this.options.values.content==null || this.options.values.content==''){
		this.options.values.content = Designer_Lang.controlTextLabelInfoName + _Designer_Index_Object.textLabel ++;
		domElement.innerHTML = this.options.values.content;
	} else {
		var html = this.options.values.content.replace(/\r\n/g, '<br>');
		html = html.replace(/ /g, '&nbsp;');
		domElement.innerHTML = html;
	}
	if(this.options.values.font)	
	_Designer_Control_TextLabel_SetStyle(domElement, this.options.values.font, "fontFamily");
	if(this.options.values.size)
	_Designer_Control_TextLabel_SetStyle(domElement, this.options.values.size, "fontSize");
	if(this.options.values.color)
	_Designer_Control_TextLabel_SetStyle(domElement, this.options.values.color, "color");
	domElement.style.fontWeight = this.options.values.b=="true"?"bold":"normal";
	domElement.style.fontStyle = this.options.values.i=="true"?"italic":"normal";
	domElement.style.textDecoration = this.options.values.underline=="true"?"underline":"none";
	domElement.style.width="auto";
}

function _Designer_Control_TextLabel_OnDrawEnd() {
	_Designer_Control_TextLabel_OnDrawReleaseEvent(this, this.owner.controls);
	_Designer_Control_TextLabel_OnDrawRelationEvent(this);
}

_Designer_Control_TextLabel_BorderType = {left: 'right', right: 'left', up : 'down', down: 'up', self : 'self'};

function _Designer_Control_TextLabel_OnDrawReleaseEvent(textLabel, controls) {
	for (var i = 0; i < controls.length; i ++) {
		var c = controls[i];
		if (!c.isTextLabel && c.options.values._label_bind == 'true'
			&& textLabel.options.values.id == c.options.values._label_bind_id) {
			textLabel.owner.setProperty(c);
		}
		_Designer_Control_TextLabel_OnDrawReleaseEvent(textLabel, c.children);
	}
}

function _Designer_Control_TextLabel_OnDrawRelationEvent(textLabel) {
	var parent = textLabel.parent, currElement = textLabel.options.domElement, controls = [];
	if (parent && parent.getTagName() == 'table') {
		var pCell = textLabel.getBorderCell(currElement, _Designer_Control_TextLabel_BorderType[ parent.getRelateWay ? parent.getRelateWay(textLabel) : (parent.relatedWay ? parent.relatedWay : 'left') ]);
		if (pCell == null) return null;
		//获得后一单元格里所有控件
		var children = pCell.childNodes, element, control;
		for (var i = children.length - 1; i >= 0; i--) {
			element = children[i];
			if (element.nodeType != 3 && Designer.isDesignElement(element)) {
				control = parent.getControlByDomElement(element);
				if (control && !control.isTextLabel) controls.push(control);
			}
		}
	} else {
		var element = currElement.nextSibling;
		if (element && element.nodeType != 3 && Designer.isDesignElement(element)) {
			control = textLabel.owner.getControlByDomElement(element);
			if (control && !control.isTextLabel) controls.push(control);
		}
	}
	for (var i = 0; i < controls.length; i ++) {
		textLabel.owner.setProperty(controls[i]);
	}
}

function _Designer_Control_TextLabel_SetStyle(domElement, targetValue, styleName){
	if(targetValue==null || targetValue=='') {
		domElement.style[styleName] = null;
	} else {
		domElement.style[styleName] = targetValue;
	}
}

//生成单行文本Dom对象
function _Designer_Control_InputText_OnDraw(parentNode, childNode){
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
	}
	var htmlCode = _Designer_Control_InputText_DrawByType(this.parent, this.attrs, this.options.values, this);
	domElement.innerHTML = htmlCode;
	
	if (this.options.values.canShow == 'false') {
		domElement.setAttribute('canShow', 'false');
	} else {
		domElement.setAttribute('canShow', 'true');
	}
	
}

// 生成XML
function _Designer_Control_InputText_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="', values.dataType ? values.dataType : 'String', '" ');
	if (values.validate == 'string') {
		if ( values.maxlength != null &&  values.maxlength != '') {
			buf.push('length="', values.maxlength, '" ');
		} else {
			buf.push('length="', '200', '" ');
		}
	} else if (values.validate == 'number') {
		if(values.dataType=='BigDecimal'){
			buf.push('length="', '16', '" ');
		}
		else{
			buf.push('length="', '10', '" ');
		}
		if (values.decimal == "0") {
			
		} else {
			buf.push('scale="', values.decimal, '" ');
			//buf.push('length="', '10', '" ');
		}
	} else {
		buf.push('length="200" ');
	}
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	if (values.canShow == 'false') {
		buf.push('canDisplay="false" ');
	}
	buf.push('/>');
	return buf.join('');
}

// input text 类型HTML生成基础函数
function _Designer_Control_InputText_DrawByType(parent, attrs, values, control) {
	var htmlCode = '<input id="'+values.id+'" class="' + (values.canShow=='false'?'inputhidden':'inputsgl');
	if (values.canShow == 'false') {
		htmlCode += '" canShow="false"';
	} else {
		htmlCode += '" canShow="true"';
	}
	if (values.thousandShow == 'false') {
		htmlCode += '" thousandShow="false"';
	} else {
		htmlCode += '" thousandShow="true"';
	}
	if (values.readOnly == 'true') {
		htmlCode += '" _readOnly="true"';
	} else {
		htmlCode += '" _readOnly="false"';
	}
	if(values.width==null || values.width==''){
		values.width = "120";
	}
	if (values.width.toString().indexOf('%') > -1) {
		htmlCode += ' style="width:'+values.width+'"';
	} else {
		htmlCode += ' style="width:'+values.width+'px"';
	}
	if (values.required == "true") {
		htmlCode += ' required="true"'
		htmlCode += ' _required="true"'
	} else {
		htmlCode += ' required="false"'
		htmlCode += ' _required="false"'
	}
	if (parent != null) {
		htmlCode += ' tableName="' + _Get_Designer_Control_TableName(parent) + '"';
	}
	if (values.description != null) {
		htmlCode += ' description="' + values.description + '"';
	}
	htmlCode += ' label="' + _Get_Designer_Control_Label(values, control) + '"';
	if (values.validate != null && values.validate != 'false') {
		htmlCode += ' dataType="' + values.validate + '"';
		htmlCode += ' _dataType="' + values.dataType + '"';
		if (values.validate == 'string') {
			htmlCode += ' maxlength="' + values.maxlength + '"';
			htmlCode += ' validate="{dataType:\'string\'';
			if ( values.maxlength != null &&  values.maxlength != '') {
				htmlCode += ',maxlength:' + values.maxlength;
			}
			htmlCode += '}"';
		} else if (values.validate == 'number') {
			htmlCode += ' scale="' + values.decimal + '"'; // 小数位
			htmlCode += ' beginNum="' +  values.begin + '"';
			htmlCode += ' endNum="' +  values.end + '"';
			htmlCode += ' validate="{dataType:\'number\',decimal:' + values.decimal; // 小数位
			if (values.begin != null && values.begin != '')
				htmlCode += ',begin:' + values.begin;
			if (values.end != null && values.end != '')
				htmlCode += ',end:' + values.end;
			htmlCode += '}"';
		} else if (values.validate == 'email') {
			htmlCode += ' validate="{dataType:\'email\'}"';
		}
	}
	if (values.defaultValue != null && values.defaultValue != '') {
		htmlCode += ' defaultValue="' + values.defaultValue + '"';
		if (!attrs.businessType) {
			htmlCode += ' value="' + values.defaultValue + '"';
		}
	}
	if (attrs.businessType) {
		htmlCode += ' businessType="' + (values.businessType == null ? attrs.businessType.value : values.businessType) + '"';
		if ((values.businessType == 'dateDialog' ||  values.businessType == 'timeDialog' ||  values.businessType == 'datetimeDialog')) {
			if (values.defaultValue == 'select') {
				htmlCode += ' selectedValue="' + values._selectValue + '"';
				htmlCode += ' value="' + values._selectValue + '"';
			} else if (values.defaultValue == 'nowTime') {
				htmlCode += ' value="' + attrs.defaultValue.opts[1].text + '"';
			}
		} else if (values.businessType == "addressDialog") {
			if (values.defaultValue == 'select') {
				htmlCode += ' selectedValue="' + values._selectValue + '"';
				htmlCode += ' selectedName="' + values._selectName + '"';
				htmlCode += ' value="' + values._selectName + '"';
			} else if (values.defaultValue != 'null') {
				for (var jj = 0, l = attrs.defaultValue.opts.length; jj < l; jj ++) {
					if (attrs.defaultValue.opts[jj].value == values.defaultValue) {
						htmlCode += ' value="' + attrs.defaultValue.opts[jj].text + '"';
						break;
					}
				}
			}
		}
	}
	if (attrs.multiSelect) {
		htmlCode += ' multiSelect="' + (values.multiSelect == 'true' ? 'true' : 'false') + '"';
	}
	if (attrs.orgType) {
		var orgType = [];
		var opts = attrs.orgType.opts;
		if (values['_org_group'] == "true") {
			for (var i = 0; i < opts.length; i ++) {
				values[opts[i].name] = "true"
			}
		} else if (values['_org_dept'] == "true") {
			values['_org_org'] = "true"
		}
		for (var i = 0; i < opts.length; i ++) {
			var opt = opts[i];
			if (values[opt.name] == null && attrs.orgType.value != null && opts[i].value == attrs.orgType.value) {
				values[opt.name] = "true";
			}
			if (values[opt.name] == "true") {
				orgType.push(opt.value);
			}
		}
		values._orgType = orgType.join('|');
		htmlCode += ' orgType="' + values._orgType + '"';
	}
	if (attrs.history) {
		htmlCode += ' history="' + (values.history == "true" ? 'true' : 'false') + '"';
	}
	htmlCode += ' readOnly >';
	
	if(values.required == 'true') {
		htmlCode += '<span class=txtstrong>*</span>';
	}
	
	if (attrs.businessType && values.readOnly != 'true') {
		htmlCode += '<label>&nbsp;<a>'+Designer_Lang.controlAttrSelect+'</a></label>';
	}
	
	return htmlCode;
}

//生成地址本Dom对象
function _Designer_Control_Address_OnDraw(parentNode, childNode) {
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('label', this, parentNode, childNode);
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
		domElement.style.overflow = 'visible';
	}
	var htmlCode = _Designer_Control_InputText_DrawByType(this.parent, this.attrs, this.options.values, this);
	domElement.innerHTML = htmlCode;
}

// 生成XML
function _Designer_Control_Address_DrawXML() {
	var values = this.options.values;
	var buf = [];//mutiValueSplit
	buf.push('<extendElementProperty ');
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="com.landray.kmss.sys.organization.model.SysOrgElement" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	if (values.multiSelect == 'true') {
		buf.push('mutiValueSplit=";" ');
	}
	if (values.defaultValue == 'select') {
		buf.push('formula="true" ');
		buf.push('defaultValue="OtherFunction.getModel(&quot;', values._selectValue
			, '&quot;, &quot;com.landray.kmss.sys.organization.model.SysOrgElement&quot;');
		if (values.multiSelect == "true") {
			buf.push(', &quot;;&quot;');
		} else {
			buf.push(', null');
		}
		buf.push(')" ');
	} else if (values.defaultValue != '' && values.defaultValue != 'null') {
		//ORG_TYPE_PERSON ORG_TYPE_ORG ORG_TYPE_DEPT ORG_TYPE_POST
		var dv = null;
		if (values.defaultValue == 'ORG_TYPE_PERSON') {
			dv = 'OrgFunction.getCurrentUser()';
		} else if (values.defaultValue == 'ORG_TYPE_ORG') {
			dv = 'OrgFunction.getCurrentOrg()';
		} else if (values.defaultValue == 'ORG_TYPE_DEPT') {
			dv = 'OrgFunction.getCurrentDept()';
		} else if (values.defaultValue == 'ORG_TYPE_POST') {
			if (values.multiSelect == 'true') {
				dv = 'OrgFunction.getCurrentPosts()';
			} else {
				dv = 'OrgFunction.getCurrentPost()';
			}
		}
		buf.push('defaultValue="', dv, '" ');
		buf.push('formula="true" ');
	}
	buf.push('dialogJS="Dialog_Address(!{mulSelect}, \'!{idField}\',\'!{nameField}\', \';\',', values._orgType,');" ');
	buf.push('/>');
	return buf.join('');
}

//生成日期Dom对象
function _Designer_Control_Datetime_OnDraw(parentNode, childNode) {
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	if (this.options.values.width && this.options.values.width.toString().indexOf('%') > -1) {
		domElement.style.whiteSpace = 'nowrap';
		domElement.style.width = this.options.values.width;
		domElement.style.overflow = 'visible';
	}
	var htmlCode = _Designer_Control_InputText_DrawByType(this.parent, this.attrs, this.options.values, this);
	domElement.innerHTML = htmlCode;
}

// 生成XML
function _Designer_Control_Datetime_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	if (values.businessType == 'timeDialog') {
		buf.push('type="Time" ');
	} else if (values.businessType == 'dateDialog' || values.businessType == null) {
		buf.push('type="Date" ');
	} else {
		buf.push('type="DateTime" ');
	}
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	if (values.defaultValue == 'select') {
		buf.push('defaultValue="', values._selectValue, '" ');
	}
	if (values.defaultValue == 'nowTime') {
		buf.push('formula="true" ');
		buf.push('defaultValue="DateTimeFunction.getNow()" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	}
	buf.push('/>');
	return buf.join('');
}

//生成多行文本Dom对象
function _Designer_Control_Textarea_OnDraw(parentNode, childNode){
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	var htmlCode = '<textarea id="'+this.options.values.id+'" class="' + (this.options.values.canShow=='false'?'inputhidden':'inputmul');
	if (this.options.values.canShow == 'false') {
		htmlCode += '" canShow="false"';
	} else {
		htmlCode += '" canShow="true"';
	}
	if (this.options.values.required == "true") {
		htmlCode += ' required="true"'
		htmlCode += ' _required="true"'
	} else {
		htmlCode += ' required="false"'
		htmlCode += ' _required="false"'
	}
	if (this.options.values.readOnly == 'true') {
		htmlCode += '" _readOnly="true"';
	} else {
		htmlCode += '" _readOnly="false"';
	}
	if (this.parent != null) {
		htmlCode += ' tableName="' + _Get_Designer_Control_TableName(this.parent) + '"';
	}
	if (this.options.values.defaultValue != null) {
		htmlCode += ' defaultValue="' + Designer.HtmlEscape(this.options.values.defaultValue) + '"';
	}
	if (this.options.values.maxlength != null && this.options.values.maxlength != '') {
		htmlCode += ' maxlength="' + this.options.values.maxlength + '"';
	}
	var width = '250';
	if(this.options.values.width !=null && this.options.values.width !=''){
		if (this.options.values.width.toString().indexOf('%') > -1) {
			var pWidth = this.options.values.width;
			//width = '100%';
			width = pWidth;
			htmlCode += ' pWidth="' + pWidth + '"';
			domElement.style.width = pWidth;
			domElement.style.whiteSpace = 'nowrap';
		} else {
			width = this.options.values.width + 'px';
		}
	} else {
		this.options.values.width = "250";
	}
	var height = '80px';
	if(this.options.values.height !=null && this.options.values.height !=''){
		height = this.options.values.height + 'px';
	} else {
		this.options.values.height = "80";
	}
	if (this.options.values.description != null) {
		htmlCode += ' description="' + this.options.values.description + '"';
	}
	htmlCode += ' label="' + _Get_Designer_Control_Label(this.options.values, this) + '"';
	htmlCode += ' style="width:'+width+';height:'+height+';">';
	if (this.options.values.defaultValue != null) {
		htmlCode += Designer.HtmlEscape(this.options.values.defaultValue);
	}
	htmlCode += '</textarea>';
	if(this.options.values.required == 'true') {
		htmlCode += '<span class=txtstrong>*</span>';
	}
	domElement.innerHTML = htmlCode;
}

// 生成XML
function _Designer_Control_Textarea_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="String" ');
	if (values.maxlength != null || values.maxlength != '') {
		buf.push('length="'+values.maxlength+'" ');
	} else {
		buf.push('length="4000" ');
	}
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

function Designer_Control_MultiValues(items) {
	if (items == null || items == '') return '';
	var items = items.split("\r\n");
	var text, value, index;
	var newItems = [];
	for(var i=0; i<items.length; i++) {
		if (items[i] == '') continue;
		//items[i] = Designer.HtmlEscape(items[i]);
		index = items[i].lastIndexOf("|");
		if(index == -1){
			text = items[i];
			value = items[i];
		}else{
			text = items[i].substring(0, index);
			value = items[i].substring(index + 1);
			if (value == null || value == "")
				value = text;
		}
		newItems.push(text + "|" + value);
	}
	return (newItems.join(';'));
	//return Designer.HtmlEscape(newItems.join(';'));
}

//生成复选框Dom对象
function _Designer_Control_InputCheckbox_OnDraw(parentNode, childNode){
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('table', this, parentNode, childNode);
	domElement.className = 'tb_noborder';
	var name = this.options.values.id;
	var htmlCode = '';
	var htmlCode2 = '';
	var itemsTexts = '';
	var itemsValues = '';
	if(this.options.values.items==null || this.options.values.items==''){
		htmlCode = '<nobr><input type="checkbox" onclick="return false;" id="'+name;
		if (this.parent != null) {
			htmlCode += '" tableName="' + _Get_Designer_Control_TableName(this.parent);
		}
		htmlCode += '" label="' + _Get_Designer_Control_Label(this.options.values, this);
		htmlCode += '" value="0" items="'
			+ Designer_Lang.controlInputCheckboxItemsLabel + '" itemValues="0"><label attach="' + name + '">'
			+ Designer_Lang.controlInputCheckboxItemsLabel + '</label>&nbsp;</nobr>';
	} else {
		var itemStr = this.options.values.items;
		var items = [];
		if(itemStr.indexOf("\r\n")>-1){
			items = itemStr.split("\r\n");
		}else{
			items = itemStr.split("\n");
		}
		var isFirstCheckbox = true;
		var dv = null;
		var dvs = [];
		for(var i=0; i<items.length; i++){
			if(items[i]=="")
				continue;
			//items[i] = Designer.HtmlEscape(items[i]);
			var index = items[i].lastIndexOf("|");
			if(index == -1){
				var text = items[i];
				var value = items[i];
			}else{
				var text = items[i].substring(0, index);
				var value = items[i].substring(index+1);
			}
			if (isFirstCheckbox) {
				itemsTexts += text;
				itemsValues += value;
			} else {
				itemsTexts += ';' + text;
				itemsValues += ';' + value;
			}
			if(isFirstCheckbox) {
				isFirstCheckbox = false;
				htmlCode += '<nobr><input type="checkbox" onclick="return false;" id="'+name+'" value="'+value;
				if (this.parent != null) {
					htmlCode += '" tableName="' + _Get_Designer_Control_TableName(this.parent);
				}
				if (this.options.values.alignment == 'V') {
					htmlCode +=  '" alignment="V';
				} else {
					htmlCode +=  '" alignment="H';
				}
				if (this.options.values.description != null) {
					htmlCode += '" description="' + this.options.values.description;
				}
				htmlCode += '" label="' + _Get_Designer_Control_Label(this.options.values, this);
				htmlCode += '" required="' + (this.options.values.required == 'true' ? 'true' : 'false');
				htmlCode += '" _required="' + (this.options.values.required == 'true' ? 'true' : 'false');
				if (this.options.values.defaultValue != null) {
					dv = Designer.HtmlEscape(this.options.values.defaultValue)
					htmlCode += '" defaultValue="' + dv;
					dvs = dv.split(";");
				}
				for (var n = 0; n < dvs.length; n ++) {
					if (value == dvs[n]) {
						htmlCode += '" checked="checked';
						break;
					}
				}
				htmlCode2 += '"><label attach="' + name + '">'+text+'</label>&nbsp;</nobr>';
			} else {
				if(this.options.values.alignment == 'V'){
					htmlCode2 += '<br>';
				}else{
					//htmlCode2 += '<font>&nbsp;</font>';
				}
				htmlCode2 += '<nobr><input type="checkbox" onclick="return false;" id="'+name+'" value="'+value;
				for (var n = 0; n < dvs.length; n ++) {
					if (value == dvs[n]) {
						htmlCode2 += '" checked="checked';
						break;
					}
				}
				htmlCode2 += '" attach="' + name +'"><label attach="' + name + '">'+text+'</label>&nbsp;</nobr>';
			}
		}
		htmlCode += '" items="' + itemsTexts + '" itemValues="' + itemsValues + htmlCode2;
		if(this.options.values.required == 'true') {
			htmlCode += '<span class=txtstrong>*</span>';
		}
	}
	domElement.insertRow(-1).insertCell(-1).innerHTML = htmlCode;
}

// 生成XML
function _Designer_Control_InputCheckbox_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	buf.push('enumValues="', Designer_Control_MultiValues(values.items), '" ');
	buf.push('type="', values.dataType ? values.dataType : 'String', '" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

//生成单选按钮Dom对象
function _Designer_Control_InputRadio_OnDraw(parentNode, childNode){
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var name = this.options.values.id;
	var domElement = _CreateDesignElement('table', this, parentNode, childNode);
	domElement.className = 'tb_noborder';
	var htmlCode = '';
	var htmlCode2 = '';
	var itemsTexts = '';
	var itemsValues = '';
	if(this.options.values.items==null || this.options.values.items==''){
		htmlCode = '<nobr><input type="radio" id="'+name;
		if (this.parent != null) {
			htmlCode += '" tableName="' + _Get_Designer_Control_TableName(this.parent);
		}
		htmlCode += '" label="' + _Get_Designer_Control_Label(this.options.values, this);
		htmlCode += '" value="0" items="'
				+ Designer_Lang.controlInputRadioItemsLabel + '" itemValues="0"><label attach="' + name + '">'
				+ Designer_Lang.controlInputRadioItemsLabel + '</label>&nbsp;</nobr>';
	}else{
		var itemStr = this.options.values.items;
		var items = [];
		if(itemStr.indexOf("\r\n")>-1){
			items = itemStr.split("\r\n");
		}else{
			items = itemStr.split("\n");
		}
		var isFirstRadio = true;
		var dv = null;
		for(var i=0; i<items.length; i++){
			if(items[i]=="")
				continue;
			//items[i] = Designer.HtmlEscape(items[i]);
			var index = items[i].lastIndexOf("|");
			if(index == -1){
				var text = items[i];
				var value = items[i];
			}else{
				var text = items[i].substring(0, index);
				var value = items[i].substring(index+1);
			}
			if (isFirstRadio) {
				itemsTexts += text;
				itemsValues += value;
			} else {
				itemsTexts += ';' + text;
				itemsValues += ';' + value;
			}
			if(isFirstRadio){
				isFirstRadio = false;
				htmlCode += '<nobr><input type="radio" id="'+name+'" value="'+value;
				if (this.parent != null) {
					htmlCode += '" tableName="' + _Get_Designer_Control_TableName(this.parent);
				}
				if (this.options.values.alignment == 'V') {
					htmlCode +=  '" alignment="V';
				} else {
					htmlCode +=  '" alignment="H';
				}
				if (this.options.values.description != null) {
					htmlCode += '" description="' + this.options.values.description;
				}
				htmlCode += '" label="' + _Get_Designer_Control_Label(this.options.values, this);
				if (this.options.values.defaultValue != null && this.options.values.defaultValue != '') {
					dv = Designer.HtmlEscape(this.options.values.defaultValue)
					htmlCode += '" defaultValue="' + dv;
				}
				htmlCode += '" required="' + (this.options.values.required == 'true' ? 'true' : 'false');
				htmlCode += '" _required="' + (this.options.values.required == 'true' ? 'true' : 'false');
				if (value == dv) {
					htmlCode += '" checked="checked';
				}
				htmlCode2 += '"><label attach="' + name + '">'+text+'</label>&nbsp;</nobr>';
			}else{
				if(this.options.values.alignment == 'V'){
					htmlCode2 += '<br>';
				}else{
					//htmlCode2 += '<font>&nbsp;&nbsp;</font>';
				}
				htmlCode2 += '<nobr><input type="radio" id="'+name+'" value="'+value
					+ (value == dv ? '" checked="checked' : '') 
					+ '" attach="' + name +'"><label attach="' + name + '">'+text+'</label>&nbsp;</nobr>';
			}
		}
		htmlCode += '" items="' + itemsTexts + '" itemValues="' + itemsValues + htmlCode2;
		if(this.options.values.required == 'true') {
			htmlCode += '<span class=txtstrong>*</span>';
		}
	}
	domElement.insertRow(-1).insertCell(-1).innerHTML = htmlCode;
}

// 生成XML
function _Designer_Control_InputRadio_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	buf.push('enumValues="', Designer_Control_MultiValues(values.items), '" ');
	buf.push('type="', values.dataType ? values.dataType : 'String', '" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

//生成下拉框Dom对象
function _Designer_Control_Select_OnDraw(parentNode, childNode){
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('div', this, parentNode, childNode);
	var selectDom = document.createElement('select');
	selectDom.style.display = 'none';
	selectDom.id = this.options.values.id;
	if (this.options.values.description) {
		selectDom.description = this.options.values.description;
	}
	selectDom.label = _Get_Designer_Control_Label(this.options.values, this);
	if (this.parent != null) {
		selectDom.tableName=_Get_Designer_Control_TableName(this.parent);
	}
	selectDom.required = (this.options.values.required == 'true' ? 'true' : 'false');
	selectDom._required = (this.options.values.required == 'true' ? 'true' : 'false');
	selectDom.canShow = (this.options.values.canShow == 'true' ? 'true' : 'false');
	if (this.options.values.formula != null && this.options.values.formula != '') {
		selectDom.formula = 'true';
		selectDom.defaultValue = this.options.values.defaultValue;
		selectDom.reCalculate = (this.options.values.reCalculate == 'true' ? 'true' : 'false');
	}
	else if (this.options.values.defaultValue != null && this.options.values.defaultValue != '') {
		selectDom.defaultValue = this.options.values.defaultValue;
	}
	var itemsText = [];
	var itemsValue = [];
	var defaultValueName = "";
	if (this.options.values.items != null && this.options.values.items != '') {
		var itemStr = this.options.values.items;
		var items = [];
		if(itemStr.indexOf("\r\n")>-1){
			items = itemStr.split("\r\n");
		}else{
			items = itemStr.split("\n");
		}
		for(var i = 0; i < items.length; i++) {
			if(items[i] == "")
				continue;
			//items[i] = Designer.HtmlEscape(items[i]);
			var index = items[i].lastIndexOf("|");
			if(index == -1){
				itemsText.push(items[i]);
				itemsValue.push(items[i]);
			}else{
				itemsText.push(items[i].substring(0, index));
				itemsValue.push(items[i].substring(index+1));
			}
			if (selectDom.defaultValue == itemsValue[itemsValue.length - 1]) {
				defaultValueName = itemsText[itemsText.length - 1]
			}
		}
	} else {
		
	}
	if (itemsValue.length > 0) {
		selectDom.items = $('<input type="hidden" value="' + itemsText.join(';') + '"/>').val();
		selectDom.itemValues = $('<input type="hidden" value="' + itemsValue.join(';') + '"/>').val();
	}
	var buf = [];
	buf.push('<label class="select_tag_left"><label class="select_tag_right">');
	if (itemsText.length == 0) {
		buf.push('<label class="select_tag_face">',Designer_Lang.controlSelectPleaseAdd,'</label>');
	} else {
		if (selectDom.defaultValue != null && selectDom.defaultValue != ""
				&& (this.options.values.formula == null || this.options.values.formula == '')) {
			buf.push('<label class="select_tag_face">', defaultValueName, '</label>');
		} else {
			buf.push('<label class="select_tag_face">',Designer_Lang.controlSelectPleaseSelect,'</label>');
		}
	}
	buf.push('</label></label>');
	if(this.options.values.required == 'true') {
		buf.push('<span class=txtstrong>*</span>');
	}
	domElement.innerHTML = buf.join('');
	domElement.appendChild(selectDom);
	domElement.className = 'select_div_box'; // 修正未知的显示BUG
}

// 生成XML
function _Designer_Control_Select_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	if (values.required == "true") {
		buf.push('notNull="true" ');
	}
	buf.push('enumValues="', Designer_Control_MultiValues(values.items), '" ');
	buf.push('type="', values.dataType ? values.dataType : 'String', '" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	return buf.join('');
}

//生成RTF Dom对象
function _Designer_Control_Rtf_OnDraw(parentNode, childNode){
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	var domElement = _CreateDesignElement('img', this, parentNode, childNode);
	domElement.id = this.options.values.id;
	domElement.src = 'style/img/rtf.jpg';
	domElement.businessType = "rtfEditor";
	if (this.options.values.description) {
		domElement.description = this.options.values.description;
	}
	domElement.label = _Get_Designer_Control_Label(this.options.values, this);
	if (this.options.values.defaultValue != null) {
		domElement.defaultValue = Designer.HtmlEscape(this.options.values.defaultValue);
	}
	if (this.parent != null) {
		domElement.tableName=_Get_Designer_Control_TableName(this.parent);
	}
//	domElement.required = (this.options.values.required == 'true' ? 'true' : 'false');
	//修改为强制过滤 2014-08-12 曹映辉 
	domElement.needFilter = true;//(this.options.values.needFilter == 'true' ? 'true' : 'false');
	domElement.canShow = (this.options.values.canShow == 'true' ? 'true' : 'false');
	if (this.options.values.formula != null) {
		domElement.formula = this.options.values.formula;
		domElement.reCalculate = (this.options.values.reCalculate == 'true' ? 'true' : 'false');
	}
	if (this.options.values.width == null) {
		this.options.values.width = this.attrs.width.value;
	}
	domElement.pWidth = this.options.values.width;
	domElement.style.width = this.options.values.width;
	if (this.options.values.height == null) {
		this.options.values.height = this.attrs.height.value;
	}
	domElement.pHeight = this.options.values.height;
	domElement.style.height = this.options.values.height;
}

// 生成XML
function _Designer_Control_Rtf_DrawXML() {
	var values = this.options.values;
	var buf = ['<extendSimpleProperty '];
	buf.push('name="', values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('type="RTF" length="1000000" ');
	if (values.formula != '' && values.formula != null) {
		buf.push('formula="true" ');
		buf.push('defaultValue="', values.formula, '" ');
		if (values.reCalculate == 'true') {
			buf.push('recalculateOnSave="true" ');
		}
	} else if (values.defaultValue != '' && values.defaultValue != null) {
		buf.push('defaultValue="', values.defaultValue, '" ');
	}
	buf.push('/>');
	return buf.join('');
}
function StandardTable_ModelDialog_Show(url,data,callback){
	this.AfterShow=callback;
	this.data=data;
	this.width=600;
	this.height=400;
	this.url=url;
	this.setWidth=function(width){
		this.width=width;
	};
	this.setHeight=function(height){
		this.height=height;
	};
	this.setCallback=function(action){
		this.callback=action;
	};
	this.setData=function(data){
		this.data=data;
	};
	
	this.show=function(){
		var obj={};
		obj.data=this.data;
		obj.AfterShow=this.AfterShow;
		Com_Parameter.Dialog=obj;
		var left = (screen.width-this.width)/2;
		var top = (screen.height-this.height)/2;
		
		var winStyle = "resizable=1,scrollbars=1,width="+this.width+",height="+this.height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		var win= window.open(this.url, "_blank", winStyle);
		try{
			win.focus();
		}
		catch(e){
			
		}
		//用window.open 达到模态效果
		window.onfocus=function (){
			try{
				win.focus();
			}catch(e){
				
			}
		};
	    window.onclick=function (){
	    	try{
				win.focus();
			}catch(e){
				
			}
	    };
	};
	
}
function _Designer_Control_Attr_standardTable_style_Self_Draw(name, attr, value,
		form, attrs, values, control){
	var html="";
	html+="<a href='#' onclick='_Designer_Control_standardTable_style_Set(this);' style='text-decoration:underline;margin-left:5px'>设置样式<a>";
	return Designer_AttrPanel.wrapTitle(name, attr, value, html);
}

function _Designer_Control_standardTable_style_Set(){
	var control=Designer.instance.attrPanel.panel.control;
	//document.writeln("<link href='<%=request.getContextPath() %>/sys/xform/designer/standardtable/tablestyle/tb_normal_redsolid/tb_normal_redsolid.css' type='text/css' rel='stylesheet' />");
	var data=new KMSSData().AddBeanData("sysStandardTableStyleExt").GetHashMapArray();
	var paramObj={};
	paramObj.data=data;
	
	var values=control.options.values;
	//加载表格样式
	if(values.tableStyle){
		var tableStyle=JSON.parse(values.tableStyle.replace(/quot;/g,"\""));
		paramObj.chooseStyle=tableStyle.tbClassName;
		//$("#"+control.options.domElement.getAttribute("id")).attr("class",tableStyle["tbClassName"]);
	}
	
	var dialog=new StandardTable_ModelDialog_Show(Com_Parameter.ContextPath+"sys/xform/designer/standardtable/stylePreview.jsp",paramObj,function(rtnValue){
		if(!rtnValue){
			return;
		}
		$("#"+control.options.domElement.getAttribute("id")).prev("[name='dynamicTableStyle']").remove();
		$("#"+control.options.domElement.getAttribute("id")).before("<link rel='stylesheet' name='dynamicTableStyle' type='text/css' href='"+Com_Parameter.ContextPath+rtnValue['pathProfix']+"/standardtable.css'/>");
		$("#"+control.options.domElement.getAttribute("id")).attr("class",rtnValue["tbClassName"]);
		control.options.values.tableStyle=JSON.stringify(
				rtnValue).replace(/"/g,"quot;");
		control.options.domElement.tableStyle=control.options.values.tableStyle;
	});
	dialog.setWidth("514");
	dialog.show();
	
	
}
//标准表格样式
function _Designer_Control_StandardTable_OnDraw(parentNode, childNode) {
	var cells = {row:this.attrs.row.value, cell:this.attrs.cell.value}, domElement, row, cell;
	this.options.domElement = document.createElement('table');
	var index = _Designer_Index_Object.table ++;
	var label = index == 0 ? Designer_Lang.controlStandardTableMainLabelName : Designer_Lang.controlStandardTableLabelName + index;
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	this.options.domElement.id = this.options.values.id;
	this.options.domElement.label = label;
	this.options.values.label = label;
	parentNode.appendChild(this.options.domElement);
	//设置表格相应属性
	domElement = this.options.domElement;
	domElement.setAttribute('formDesign', 'landray');
	domElement.setAttribute('align', 'center');
	domElement.className = 'tb_normal';
	domElement.setAttribute('id', 'fd_' + Designer.generateID());
	domElement.style.width = '98%';
	//绘制行和列
	for (var i = 0; i < cells.row; i++) {
		row = domElement.insertRow(-1);
		for (var j = 0; j < cells.cell; j++) {
			cell = row.insertCell(-1);
			cell.setAttribute('row', '' + i);            //记录行数(多值，以逗号分割，有严格顺序)
			cell.setAttribute('column', '' + j);         //记录列数(多值，以逗号分割，有严格顺序)
			cell.innerHTML = '&nbsp;';
			if (j % 2 == 0) {
				cell.className = this.attrs.cell.style!=null?this.attrs.cell.style:'td_normal_title';
				cell.width = '15%';
			} else {
				cell.width = '35%';
			}
		}
	}

}

function _Designer_Control_StandardTable_OnDrawEnd() {
	this.options.domElement.label = this.options.values.label;
}

// 生成XML
function _Designer_Control_StandardTable_DrawXML() {
	if (this.children.length > 0) {
		var xmls = [];
		this.children = this.children.sort(Designer.SortControl);
		for (var i = 0, l = this.children.length; i < l; i ++) {
			var c = this.children[i];
			if (c.drawXML) {
				var xml = c.drawXML();
				if (xml != null)
					xmls.push(xml, '\r\n');
			}
		}
		return xmls.join('');
	}
	return '';
}

function _Designer_Control_StandardTable_AddCommons(children, tables, commons) {
	for (var i = 0, l = children.length; i < l; i ++) {
		var c = children[i];
		if (c.drawXML) {
			var xml = c.drawXML();
			if (xml != null)
				commons.push(xml, '\r\n');
		}
	}
}



// ============ 链接控件
Designer_Config.controls.linkLabel = {
	type : "linkLabel",
	storeType : 'none',
	inherit    : 'textLabel',
	onDraw : _Designer_Control_LinkLabel_OnDraw,
	onDrawEnd : null,
	onInitialize : _Designer_Control_LinkLabel_OnInitialize,
	attrs : {
		link : {
			text: Designer_Lang.controlLinkLabelAttrLink,
			value: "http://",
			hint: Designer_Lang.controlLinkLabelAttrLinkHint,
			type: 'textarea',
			show: true,
			required: true,
			validator: Designer_Control_Attr_Required_Validator,
			convertor: Designer_Control_Attr_HtmlQuotEscapeConvertor
		}
	},
	info : {
		name: Designer_Lang.controlLinkLabelInfoName
	},
	resizeMode : 'no'
}

function _Designer_Control_LinkLabel_OnInitialize() {
	var attrs = this.attrs;
	this.attrs = {};
	var index = 1;
	for (var name in attrs) {
		if (name == 'link') {
			break;
		}
		if (index == 2) {
			this.attrs.link = attrs.link;
		}
		this.attrs[name] = attrs[name];
		index ++;
	}
	this.options.values.underline = "true"
	var linkObj = this.options.domElement.getElementsByTagName('a')[0];
	linkObj.style.textDecoration = this.options.values.underline == "true" ? "underline" : "none";
}

function _Designer_Control_LinkLabel_OnDraw(parentNode, childNode) {
	var domElement = _CreateDesignElement('label', this, parentNode, childNode);
	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
		
	var linkObj = document.createElement("a");
	linkObj.href = this.options.values.link ? this.options.values.link : "#";
	linkObj.onclick = "return false;";
	linkObj.target = "_blank";
	
	if(this.options.values.content==null || this.options.values.content==''){
		this.options.values.content = this.info.name + _Designer_Index_Object.linkLabel ++;
		linkObj.innerHTML = this.options.values.content;
	} else {
		linkObj.innerHTML = this.options.values.content.replace(/\r\n/g, '<br>');
	}
	linkObj.style.fontFamily = this.options.values.font ? this.options.values.font : null;
	linkObj.style.fontSize = this.options.values.size ? this.options.values.size : null;
	linkObj.style.color = this.options.values.color ? this.options.values.color : null;
	linkObj.style.fontWeight = this.options.values.b == "true" ? "bold" : "normal";
	linkObj.style.fontStyle = this.options.values.i == "true" ? "italic" : "normal";
	linkObj.style.textDecoration = this.options.values.underline == "true" ? "underline" : "none";
	
	domElement.innerHTML = linkObj.outerHTML; // only ie
}