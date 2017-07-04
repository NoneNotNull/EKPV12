<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.lang.reflect.*,com.landray.kmss.util.ResourceUtil"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
Designer_Lang = {
<%--
	panelCloseTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.panelCloseTitle" />',
	panelFoldTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.panelFoldTitle" />',
	panelExpandTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.panelExpandTitle" />',
	
	attrpanelLeftLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelLeftLabel" />',
	attrpanelUpLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelUpLabel" />',
	attrpanelRightLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelRightLabel" />',
	attrpanelDownLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelDownLabel" />',
	attrpanelSelfLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelSelfLabel" />',
	attrpanelSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelSelect" />',
	attrpanelSuccess : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelSuccess" />',
	attrpanelApply : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelApply" />',
	attrpanelCancel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelCancel" />',
	attrpanelTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelTitle" />',
	attrpanelTitlePrefix : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelTitlePrefix" />',
	attrpanelNoSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelNoSelect" />',
	attrpanelSuccessUpdate : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelSuccessUpdate" />',
	attrpanelNoAttrs : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelNoAttrs" />',
	attrpanelDefaultValueReCalculate : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelDefaultValueReCalculate" />',
	attrpanelDefaultValueFormula : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrpanelDefaultValueFormula" />',
	
	treepanelTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treepanelTitle" />',
	treepanelNoControl : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treepanelNoControl" />',
	treepanelNoLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treepanelNoLabel" />',
	
	toolbarSampleImg : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.toolbarSampleImg" />',
	
	buttonsCopyNotNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsCopyNotNull" />',
	buttonsCopyNotContainer : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsCopyNotContainer" />',
	buttonsSelectControl : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsSelectControl" />',
	buttonsSelectOptControl : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsSelectOptControl" />',
	buttonsDeleteTable : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteTable" />',
	buttonsDeleteControl : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteControl" />',
	buttonsDeleteHint : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteHint" />',
	buttonsInsertRowAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInsertRowAlert" />',
	buttonsAppendRowAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAppendRowAlert" />',
	buttonsDeleteRowConfirm : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteRowConfirm" />',
	buttonsDeleteRowAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteRowAlert" />',
	buttonsInsertColAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInsertColAlert" />',
	buttonsAppendColAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAppendColAlert" />',
	buttonsDeleteColConfirm : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteColConfirm" />',
	buttonsDeleteColAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteColAlert" />',
	buttonsUniteCellAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsUniteCellAlert" />',
	buttonsSplitCellAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsSplitCellAlert" />',
	buttonsOpenFontColorAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsOpenFontColorAlert" />',
	buttonsSetAlignAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsSetAlignAlert" />',
	buttonsTextMSelectAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsTextMSelectAlert" />',
	buttonsTextSelectAlert : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsTextSelectAlert" />',
	
	buttonsCopy : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsCopy" />',
	buttonsPaste : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsPaste" />',
	buttonsDeleteElem : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteElem" />',
	buttonsAttribute : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAttribute" />',
	buttonsTree : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsTree" />',
	buttonsTable : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsTable" />',
	buttonsTextLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsTextLabel" />',
	buttonsLinkLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsLinkLabel" />',
	buttonsInputText : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInputText" />',
	buttonsTextarea : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsTextarea" />',
	buttonsInputRadio : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInputRadio" />',
	buttonsInputCheckbox : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInputCheckbox" />',
	buttonsSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsSelect" />',
	buttonsRtf : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsRtf" />',
	buttonsAttachment : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAttachment" />',
	buttonsAddress : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAddress" />',
	buttonsDatetime : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDatetime" />',
	buttonsJsp : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsJsp" />',
	buttonsInsertRow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInsertRow" />',
	buttonsAppendRow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAppendRow" />',
	buttonsDeleteRow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteRow" />',
	buttonsInsertCol : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsInsertCol" />',
	buttonsAppendCol : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAppendCol" />',
	buttonsDeleteCol : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsDeleteCol" />',
	buttonsUniteCell : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsUniteCell" />',
	buttonsSplitCell : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsSplitCell" />',
	buttonsBold : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsBold" />',
	buttonsItalic : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsItalic" />',
	buttonsUnderline : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsUnderline" />',
	buttonsFontColor : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsFontColor" />',
	buttonsFontStyle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsFontStyle" />',
	buttonsFontSize : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsFontSize" />',
	buttonsAlignLeft : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAlignLeft" />',
	buttonsAlignCenter : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAlignCenter" />',
	buttonsAlignRight : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsAlignRight" />',
	buttonsExpBuilder : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsExpBuilder" />',
	buttonsCutBuilder : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsCutBuilder" />',
	buttonsShowAdvanced : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsShowAdvanced" />',
	
	menusAdd : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.menusAdd" />',
	menusShow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.menusShow" />',
	menusTable : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.menusTable" />',
	
	builderDeleteControlAlter : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.builderDeleteControlAlter" />',
	
	configFontSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontSelect" />',
	configFontSongTi : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontSongTi" />',
	configFontXinSongTi : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontXinSongTi" />',
	configFontKaiTi : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontKaiTi" />',
	configFontHeiTi : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontHeiTi" />',
	configFontYouYuan : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontYouYuan" />',
	configFontYaHei : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontYaHei" />',
	configFontCourierNew : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontCourierNew" />',
	configFontTimesNewRoman : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontTimesNewRoman" />',
	configFontTahoma : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontTahoma" />',
	configFontArial : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontArial" />',
	configFontVerdana : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configFontVerdana" />',
	
	configSizeSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configSizeSelect" />',
	configSizePx : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.configSizePx" />',
	
	controlTableSelectOneCell : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTableSelectOneCell" />',
	controlTableSelectInRowOrInColumn : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTableSelectInRowOrInColumn" />',
	controlTableSelectSplitCell : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTableSelectSplitCell" />',
	controlTableRow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTableRow" />',
	controlTableColumn : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTableColumn" />',
	
	controlJspInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlJspInfoName" />',
	controlJspSuccess : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlJspSuccess" />',
	controlJspCancel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlJspCancel" />',
	controlJspHelp : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlJspHelp" />',
	
	controlAttrLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrLabel" />',
	controlAttrSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrSelect" />',
	controlAttrDefaultValue : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrDefaultValue" />',
	controlAttrFormula : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrFormula" />',
	controlAttrReCalculate : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrReCalculate" />',
	controlAttrCanShow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrCanShow" />',
	controlAttrThousandShow : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrThousandShow" />',
	controlAttrReadOnly : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrReadOnly" />',
	controlAttrRequired : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrRequired" />',
	controlAttrWidth : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrWidth" />',
	controlAttrHeight : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrHeight" />',
	controlAttrDataType : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrDataType" />',
	controlAttrDataTypeText : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrDataTypeText" />',
	controlAttrDataTypeNumber : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrDataTypeNumber" />',
	controlAttrDataTypeBigNumber : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrDataTypeBigNumber" />',
	controlAttrAlignment : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrAlignment" />',
	controlAttrAlignmentH : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrAlignmentH" />',
	controlAttrAlignmentV : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrAlignmentV" />',
	controlAttrItems : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrItems" />',
	controlAttrItemsHint : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrItemsHint" />',
	controlAttrItemsDefaultValueHint : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrItemsDefaultValueHint" />',
	controlAttrNeedFilter : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrNeedFilter" />',
	
	controlAttrValChkId : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValChkId" />',
	
	controlAttrValRequired : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValRequired" />',
	controlAttrValNotNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValNotNull" />',
	controlAttrValLabelUnique : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValLabelUnique" />',
	controlAttrValSysLabelUnique : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValSysLabelUnique" />',
	controlAttrValLabelSpecialChar : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValLabelSpecialChar" />',
	controlAttrChkLabelUnique : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrChkLabelUnique" />',
	controlAttrChkSysLabelUnique : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrChkSysLabelUnique" />',
	controlAttrValInt : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValInt" />',
	controlAttrValInteger : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValInteger" />',
	controlAttrValNumber : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValNumber" />',
	controlAttrValNumValue : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValNumValue" />',
	controlAttrValDecimal : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValDecimal" />',
	controlAttrValDecimalSize : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValDecimalSize" />',
	controlAttrValNumRange : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValNumRange" />',
	controlAttrValStrLen : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValStrLen" />',
	controlAttrValMoreThan : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValMoreThan" />',
	controlAttrValLessThan : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValLessThan" />',
	controlAttrValItemsDefaultValue : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValItemsDefaultValue" />',
	controlAttrValWidth : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrValWidth" />',
	controlAttrChkWidth : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttrChkWidth" />',
	
	controlTextLabelInfoName: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelInfoName" />',
	controlTextLabelAttrContent : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrContent" />',
	controlTextLabelAttrFont : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrFont" />',
	controlTextLabelAttrSize : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrSize" />',
	controlTextLabelAttrColor : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrColor" />',
	controlTextLabelAttrEffect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrEffect" />',
	controlTextLabelAttrBold : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrBold" />',
	controlTextLabelAttrItalic : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrItalic" />',
	controlTextLabelAttrUnderline : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextLabelAttrUnderline" />',
	
	controlInputTextInfoName: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextInfoName" />',
	controlInputTextAttrValidate : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextAttrValidate" />',
	controlInputTextAttrMaxlength : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextAttrMaxlength" />',
	controlInputTextAttrDecimal : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextAttrDecimal" />',
	controlInputTextAttrBegin : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextAttrBegin" />',
	controlInputTextAttrEnd : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextAttrEnd" />',
	controlInputTextValFalse : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValFalse" />',
	controlInputTextValNumber : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValNumber" />',
	controlInputTextValString : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValString" />',
	controlInputTextValEmail : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValEmail" />',
	controlInputTextValMaxlengthP : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValMaxlengthP" />',
	controlInputTextValMaxlengthS : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValMaxlengthS" />',
	controlInputTextValDecimal : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValDecimal" />',
	controlInputTextValBegin : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValBegin" />',
	controlInputTextValTo : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValTo" />',
	controlInputTextValEnd : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValEnd" />',
	controlInputTextValDefValueEmail : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextValDefValueEmail" />',
	controlInputTextChkEmail : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputTextChkEmail" />',
	
	controlTextareaInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextareaInfoName" />',
	controlTextareaMaxlength : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextareaMaxlength" />',
	controlTextareaMaxlength_hint : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlTextareaMaxlength_hint" />',
	
	controlInputCheckboxInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputCheckboxInfoName" />',
	controlInputCheckboxItemsLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputCheckboxItemsLabel" />',
	
	controlInputRadioInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputRadioInfoName" />',	
	controlInputRadioItemsLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlInputRadioItemsLabel" />',
	
	controlSelectInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlSelectInfoName" />',
	controlSelectPleaseAdd : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlSelectPleaseAdd" />',
	controlSelectPleaseSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlSelectPleaseSelect" />',
	
	controlRtfInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRtfInfoName" />',
	
	controlAddressInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressInfoName" />',
	controlAddressAttrBusinessType : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrBusinessType" />',
	controlAddressAttrMultiSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrMultiSelect" />',
	controlAddressAttrOrgType : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrOrgType" />',
	controlAddressAttrOrgTypeOrg : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrOrgTypeOrg" />',
	controlAddressAttrOrgTypeDept : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrOrgTypeDept" />',
	controlAddressAttrOrgTypePost : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrOrgTypePost" />',
	controlAddressAttrOrgTypePerson : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrOrgTypePerson" />',
	controlAddressAttrOrgTypeGroup : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrOrgTypeGroup" />',
	controlAddressAttrDefaultValueNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrDefaultValueNull" />',
	controlAddressAttrDefaultValueSelf : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrDefaultValueSelf" />',
	controlAddressAttrDefaultValueSelfOrg : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrDefaultValueSelfOrg" />',
	controlAddressAttrDefaultValueSelfDept : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrDefaultValueSelfDept" />',
	controlAddressAttrDefaultValueSelfPost : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrDefaultValueSelfPost" />',
	controlAddressAttrDefaultValueSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressAttrDefaultValueSelect" />',
	controlAddressValAlterNotNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressValAlterNotNull" />',
	controlAddressChkAlterNotNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAddressChkAlterNotNull" />',
	
	controlDatetimeInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeInfoName" />',
	controlDatetimeAttrBusinessType : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrBusinessType" />',
	controlDatetimeAttrBusinessTypeDate : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrBusinessTypeDate" />',
	controlDatetimeAttrBusinessTypeTime : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrBusinessTypeTime" />',
	controlDatetimeAttrBusinessTypeDatetime : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrBusinessTypeDatetime" />',
	controlDatetimeAttrDefaultValueNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrDefaultValueNull" />',
	controlDatetimeAttrDefaultValueNowTime : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrDefaultValueNowTime" />',
	controlDatetimeAttrDefaultValueSelect : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlDatetimeAttrDefaultValueSelect" />',
	
	controlStandardTableInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableInfoName" />',
	controlStandardTableInfoTd : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableInfoTd" />',
	controlStandardTableDomAttrTdAlign : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdAlign" />',
	controlStandardTableDomAttrTdAlignLeft : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdAlignLeft" />',
	controlStandardTableDomAttrTdAlignCenter : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdAlignCenter" />',
	controlStandardTableDomAttrTdAlignRight : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdAlignRight" />',
	controlStandardTableDomAttrTdVAlign : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdVAlign" />',
	controlStandardTableDomAttrTdVAlignTop : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdVAlignTop" />',
	controlStandardTableDomAttrTdVAlignMiddle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdVAlignMiddle" />',
	controlStandardTableDomAttrTdVAlignBottom : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdVAlignBottom" />',
	controlStandardTableDomAttrTdClassName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdClassName" />',
	controlStandardTableDomAttrTdClassNameNormal : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdClassNameNormal" />',
	controlStandardTableDomAttrTdClassNameTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableDomAttrTdClassNameTitle" />',
	controlStandardTableMainLabelName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableMainLabelName" />',
	controlStandardTableLabelName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlStandardTableLabelName" />',
	
	controlAttachInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachInfoName" />',
	controlAttachAttrFileType : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachAttrFileType" />',
	controlAttachAttrFileTypeHint : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachAttrFileTypeHint" />',
	controlAttachAttrSizeType : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachAttrSizeType" />',
	controlAttachAttrSizeTypeSingle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachAttrSizeTypeSingle" />',
	controlAttachAttrSizeTypeMulti : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachAttrSizeTypeMulti" />',
	controlAttachDomTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomTitle" />',
	controlAttachDomAddBtn : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomAddBtn" />',
	controlAttachDomDelBtn : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomDelBtn" />',
	controlAttachDomFileName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomFileName" />',
	controlAttachDomFileSize : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomFileSize" />',
	controlAttachDomSampleFileName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomSampleFileName" />',
	controlAttachDomSampleFileSize : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomSampleFileSize" />',
	controlAttachDomSample2FileName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomSample2FileName" />',
	controlAttachDomSample2FileSize : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlAttachDomSample2FileSize" />',
	
	controlLinkLabelInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLinkLabelInfoName" />',
	controlLinkLabelAttrLink : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLinkLabelAttrLink" />',
	controlLinkLabelAttrLinkHint : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLinkLabelAttrLinkHint" />',
	
	controlHiddenInfoName :  '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlHiddenInfoName" />',
	buttonsHidden :  '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsHidden" />',
	
	controlRightDestroyMessage : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightDestroyMessage" />',
	controlRightUseDefault : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightUseDefault" />',
	controlRightNotUseDefault : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightNotUseDefault" />',
	controlRightModeView : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightModeView" />',
	controlRightModeEidt : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightModeEidt" />',
	controlRightModeHidden : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightModeHidden" />',
	controlRightInfoName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightInfoName" />',
	controlRightNotSetReader : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightNotSetReader" />',
	controlRightPleaseInputName : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightPleaseInputName" />',
	controlRightInputNameNotNull : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlRightInputNameNotNull" />',
	buttonsRight : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsRight" />',
	buttonsRightTree : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.buttonsRightTree" />',
	treeRightTreeTitle : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treeRightTreeTitle" />',
	treeRightTreeDefaultText : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treeRightTreeDefaultText" />',
	treeRightTreeDefaultAlt : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treeRightTreeDefaultAlt" />',
	treeRightTreeWfText : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treeRightTreeWfText" />',
	treeRightTreeWfAlt : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treeRightTreeWfAlt" />',
	treeRightTreeHandlerAlt : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.treeRightTreeHandlerAlt" />',
	controlLabelTable_toolbarTitle: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_toolbarTitle" />',
	controlLabelTable_exampleLabelTitle: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_exampleLabelTitle" />',
	controlLabelTable_buttonsInsertLabel: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_buttonsInsertLabel" />',
	controlLabelTable_buttonsAppendLabel: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_buttonsAppendLabel" />',
	controlLabelTable_buttonsDeleteLabel: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_buttonsDeleteLabel" />',
	controlLabelTable_buttonsModifyLabel : '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_buttonsModifyLabel" />',
	controlLabelTable_buttonsLabelTable: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.controlLabelTable_buttonsLabelTable" />',
	button_fullScreen: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.button_fullScreen" />',
	edit_form_HTMLCode: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.edit_form_HTMLCode" />',
	form_resource: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.form_resource" />',
	button_setterHTML: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.button_setterHTML" />',
	modifyAttr: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.modifyAttr" />',
	attrPanelSerialNumber: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrPanelSerialNumber" />',
	attrPanelInputTypeText: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrPanelInputTypeText" />',
	attrPanelMoveUp: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrPanelMoveUp" />',
	attrPanelMoveDown: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrPanelMoveDown" />',
	attrPanelAddBtn: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrPanelAddBtn" />',
	attrPanelDelBtn: '<kmss:message bundle="sys-xform-base" key="Designer_Lang.attrPanelDelBtn" />'
--%>
};

<%
	//设置缓存
	/* long expires = 7 * 24 * 60 * 60;
	long nowTime = System.currentTimeMillis();
	response.addDateHeader("Last-Modified", nowTime + expires);
	response.addDateHeader("Expires", nowTime + expires * 1000);
	response.addHeader("Cache-Control", "max-age=" + expires); */

	try {
		String bundle = request.getParameter("bundle");
		String resource = "com.landray.kmss.sys.xform.base."
				+ ResourceUtil.APPLICATION_RESOURCE_NAME;

		Method method = ResourceUtil.class
				.getDeclaredMethod("getLocaleByUser");
		method.setAccessible(true);
		Locale locale = (Locale) method.invoke(ResourceUtil.class);

		ResourceBundle resourceBundle = (locale == null) ? ResourceBundle
				.getBundle(resource)
				: ResourceBundle.getBundle(resource, locale);
		if (resourceBundle != null) {
			Enumeration<String> keys = resourceBundle.getKeys();
			for (; keys.hasMoreElements();) {
				String key = keys.nextElement();
				if (key.startsWith("Designer_Lang.")) {
					out.println(key + " = '"
							+ resourceBundle.getString(key) + "';");
				}
			}
		}

	} catch (Exception e) {
		e.printStackTrace();
		out.print("Designer_Lang.Error = 'error'");
	}
%>
Designer_Lang.GetMessage = function(msg, param1, param2, param3){
	var re;
	if(param1!=null){
		re = /\{0\}/gi;
		msg = msg.replace(re, param1);
	}
	if(param2!=null){
		re = /\{1\}/gi;
		msg = msg.replace(re, param2);
	}
	if(param3!=null){
		re = /\{2\}/gi;
		msg = msg.replace(re, param3);
	}
	return msg;
};