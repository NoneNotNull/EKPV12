

var Erp_func_object ;
var Erp_temp_xml;

jQuery.ajax({
	type : "GET",
	url : Com_Parameter.ContextPath + "tib/soap/mapping/tib_soap_mapping_func/form_event_script.jsp",
	dataType : "script",
	// 设置同步,待加载完成以后才往下执行
	async : false
});

$(document).ready(
	function() {
		Erp_func_object = window.dialogArguments;
		Erp_temp_xml = Erp_func_object.fdRfcParamXml;
		if (Erp_func_object.fdJspSegmen == ""
				|| Erp_func_object.fdJspSegmen == null)
			document.getElementById("fdJspSegmen").value = "<script>\nfunction xxx(){\n      doBAPI(); \n}\n<\/script>";
		else
			document.getElementById("fdJspSegmen").value = Erp_func_object.fdJspSegmen.replace("&lt;script&gt;", "<script>").replace("&lt;/script&gt;", "<\/script>");
		$("#fdFuncMark").text(Erp_func_object.fdFuncMark);

		$("#fdSoapuiMainName").val(Erp_func_object.fdRefName);
		$("#fdSoapuiMainId").val(Erp_func_object.fdRefId);
		if (Erp_temp_xml) {
			Erp_rebuild_xml(Erp_temp_xml);
		}
	}
);



function Erp_getTemplateXml(refId){
	var fdSoapMainId=$("#fdSoapuiMainId").val();
	if (fdSoapMainId == null || fdSoapMainId == "") {
		emptyData();
		return;
	} else {
		var data = new KMSSData();						
		data.SendToBean("tibSoapMappingFuncXmlService&fdSoapMainId="
				+ fdSoapMainId, Erp_rebuild_page);
	}
}

/********************
 * 重新绘画配置页面
 */
function Erp_rebuild_page(rtnData){
	if(rtnData.GetHashMapArray().length==0) {
		alert(TibSoapMapping_lang.notDataReturn);
		return;
	}
	//在重新设置fdRfcParamXmlObject前先保留原来的tables的长度，用于删除原有表格用
	if(rtnData.GetHashMapArray()[1]["MSG"]!="SUCCESS"){
		alert(rtnData.GetHashMapArray()[1]["MSG"]);
		   return ;
		}
    var rtnXml=rtnData.GetHashMapArray()[0]["funcXml"];
    if(!rtnXml){ return ; }
    emptyData(); 
    Erp_rebuild_xml(rtnXml);
}

function Erp_rebuild_xml(rtnXml){
 Erp_temp_xml=rtnXml;
    var dom=ERP_parser.parseXml(rtnXml);
    Erp_build_render(dom,"tib_sys_soap_input","erp_query_template",getInputSchema(),"Input");
    Erp_build_render(dom,"tib_sys_soap_output","erp_query_outtemplate",getOutputSchema(),"Output");
     Erp_build_render(dom,"tib_sys_soap_falut","erp_query_faulttemplate",getFaultSchema(),"Fault");
    
    $(".erp_template").treeTable({
		initialState: "expanded"
	});

}

function oneKeyMatch(range){
	if(!window.confirm(TibSoapMapping_lang.likeQueryConfirm)){
	   return ;
	}
	var matchList=$("#"+range).find("input[keyMatch]");
	var formVar=XForm_getXFormDesignerObj();
	$(matchList).each(function(index,item){
	 	var nodeKey=$(item).attr("nodeKey");
	 	var m_value=$(item).val();
	 	var elem_name=$("#"+nodeKey+"_matchName");
	 	var elem_id=$("#"+nodeKey+"_matchID");
	 	if(!m_value&&(!elem_name&&!elem_id)){
	 	}
	 	else{
	 		for(var j=0;j<formVar.length;j++){
	 			var field=formVar[j];
	 			var labels=field["label"].split('.');
	 			if(labels[labels.length-1]==m_value){
	 				if(elem_id){
	 					$(elem_id).val("$"+field["name"]+"$");
	 				}
	 				if(elem_name){
	 					$(elem_name).val(field["label"]);
	 				}
	 				break;
	 			}
	 		}
	 	}
	
	});
	

}

function getInputSchema(){

	var m_info_in = {
		info : {
			caption : "",
			thead : [{
						th : TibSoapMapping_lang.inputParam
					}, 
					{
						th : TibSoapMapping_lang.dataType
					}, 
					{
						th : TibSoapMapping_lang.count
					}, 
					{
						th : TibSoapMapping_lang.fieldExplain
					},
					{
						th : TibSoapMapping_lang.mappingName
					},
					{
						th : TibSoapMapping_lang.mappingForm
					},
					{
						th : "<img src='"+Com_Parameter.StylePath+"calendar/finish.gif' alt=\""+TibSoapMapping_lang.oneMapping+"\" onclick=\"oneKeyMatch('tib_sys_soap_input');\" style=\"cursor: hand\"/>"
					}
					
					],
			tbody : []
		}
	};
	
	return m_info_in;

}

function getOutputSchema(){

	var m_info_out = {
		info : {
			caption : "",
			thead : [{
						th : TibSoapMapping_lang.outputParam
					}, 
					{
						th : TibSoapMapping_lang.dataType
					}, 
					{
						th : TibSoapMapping_lang.count
					}, 
					{
						th : TibSoapMapping_lang.fieldExplain
					},
					{
						th : TibSoapMapping_lang.mappingName
					},
					{
						th : TibSoapMapping_lang.mappingForm
					},
					{
						th : "<img src='"+Com_Parameter.StylePath+"calendar/finish.gif' alt=\""+TibSoapMapping_lang.oneMapping+"\" onclick=\"oneKeyMatch('tib_sys_soap_output');\" style=\"cursor: hand\"/>"
					}
					
					],
			tbody : []
		}
	};
	
	return m_info_out;

}

function getFaultSchema(){

	var m_info_out = {
		info : {
			caption : "",
			thead : [{
						th : TibSoapMapping_lang.faultParam
					}, 
					{
						th : TibSoapMapping_lang.dataType
					}, 
					{
						th : TibSoapMapping_lang.count
					}, 
					{
						th : TibSoapMapping_lang.fieldExplain
					},
					{
						th : TibSoapMapping_lang.mappingName
					},
					{
						th : TibSoapMapping_lang.mappingForm
					},
					{
						th : "<img src='"+Com_Parameter.StylePath+"calendar/finish.gif' alt=\""+TibSoapMapping_lang.oneMapping+"\" onclick=\"oneKeyMatch('tib_sys_soap_falut');\" style=\"cursor: hand\"/>"
					}
					
					],
			tbody : []
		}
	};
	
	return m_info_out;

}

function emptyData(){
	$("#tib_sys_soap_input").empty();	
	$("#tib_sys_soap_output").empty();	
	$("#tib_sys_soap_falut").empty();	
}

/**
 * 重新勾画xml
 * @param {} dom
 * @param {} renderElement
 * @param {} templateId
 * @param {} schema
 * @param {} tagName
 */
function Erp_build_render(dom,renderElement,templateId,schema,tagName){
	var renderDom=$(dom).find(tagName);
	var parseJson=ERP_parser.parseDom2Json(renderDom,schema,"erp-node");
	var template=$("#"+templateId).html();
	if(!template){
		return ;
	}
	var in_html = Mustache.render(template, schema);
	$("#"+renderElement).append($(in_html));

}




function Erp_reset_comment(elements,tardom,targetName){
	var m_dom=$(tardom).find(targetName);
	$(elements).each(function(index,element){
	   var nodeKey=$(element).attr("nodeKey");
	   var commentName=$(element).attr("commentName"); 
	   //  没有需要修改的
	   if(!commentName){
	    	return ;
	   }
		var node =ERP_parser.getTargetNodeByKey(nodeKey,null,m_dom,"erp-node-");
		// 获取注析代码
		var comment_str = ERP_parser.getCommentString(node);
		// 注析代码修改成对象
		var comment_info = ERP_parser.getCommentInfo(comment_str,
						ERP_parser.defalutCommentHandler);
		// 如果原来没有comment
		if(!comment_info){
				comment_info={};
		}
		// 增加title属性
		comment_info[commentName]=$(element).val();
		// 设置注释代码
		ERP_parser.setNodeComment(node,comment_info);
	});

}

