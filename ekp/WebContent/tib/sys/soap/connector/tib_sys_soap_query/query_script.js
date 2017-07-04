/**
 * 主要作用是用来做查询界面的构造
 */
//$(document).ready(function(){
//   	Erp_build_query();
//})

/**
 * 使用资源文件
 */
$(function(){
	var SPAN_Node = document.createElement("span");
	SPAN_Node.id = "INCLUDE_Span_Id";
	document.body.appendChild(SPAN_Node);
	$("#INCLUDE_Span_Id").load(Com_Parameter.ContextPath +"tib/sys/soap/connector/resource/js/resource_properties.jsp", callBackLoad);
	//alert("Res_Properties.inputParam2="+Res_Properties.inputParam);
	
});

/**
 * 回调加载
 */
function callBackLoad() {
	Erp_build_query();
}

/**
 * 构造数据查询表格
 */
function Erp_build_query(){
	var query_xml=$("#idXml").val();
	if(!query_xml){
	  return ;
	  }
	  
	  	var m_info_in = {
		info : {
			caption : "",
			thead : [{
						th : Res_Properties.inputParam,
						width:"35%"
					}, {
						th : Res_Properties.dataType,
						width:"10%"
					}, {
						th : Res_Properties.numbers,
						width:"15%"
					}, {
						th : Res_Properties.descs,
						width:"10%"
					},
					{
						th : Res_Properties.writeData,
						width:"30%"
					}
					],
			tbody : []
		}
	}
	//alert(query_xml);
	  
	var dom=ERP_parser.parseXml(query_xml);
	var input=$(dom).find("Input");
	
	var parseJson=ERP_parser.parseDom2Json(input,m_info_in,"erp-node");
	var template=$("#erp_query_template").html();
	if(!template){
		return ;
	}
	var in_html = Mustache.render(template, m_info_in);
	$("#erp_query_input").append($(in_html));
	$(".erp_template").treeTable({
		initialState: "expanded"
	});
}

function  Erp_execute_func(form,type){
	
	var xmlstr=$(document.getElementsByName("idXml")[0]).val();
	var xmldom=ERP_parser.parseXml(xmlstr);
	var input = $(xmldom).find("Input");
	if(!input){
	  return ;
	 }
	var keyElements =$("#erp_query_input").find("input[erpNodeValue='true']");
	$(keyElements).each(function(index,element){
	  var nodeKey=$(element).attr("nodeKey");
	  var nodeValue=$(element).val();
	  var node =ERP_parser.getTargetNodeByKey(nodeKey,null,input,"erp-node-");
	  ERP_parser.setNodeText(node,nodeValue);
	});
	//alert($(xmldom).find("Input")[0].xml);
	$(document.getElementsByName("idXml")[0]).val(XML2String(xmldom));//为了兼容firefox 需要将此转化成string
	$("#docInputParam").val(XML2String(xmldom));
    Com_Submit(form, type);
}

/**
* xml转化为String字符串
*/
 function XML2String (xmlObject) {
	// for IE
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
		return xmlObject.xml;
	} else {
		// for other browsers
		return (new XMLSerializer()).serializeToString(xmlObject);
	}
}

