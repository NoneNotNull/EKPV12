/**
 * 主要作用是用来做查询界面的构造
 */
//$(document).ready(function(){
//   	Erp_build_view();
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
	Erp_build_view();
}

/**
 * 构造数据查询表格
 */
function Erp_build_view(){
	var query_xml=$("#resultXml").val();
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
	};
	
	var m_info_out = {
		info : {
			caption : "",
			thead : [{
						th : Res_Properties.outputParam,
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
	};
	
	var m_info_fault = {
			info : {
				caption : "",
				thead : [{
					th : Res_Properties.faultParam,
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
	};
	
	var dom=ERP_parser.parseXml(query_xml);
	
	Erp_build_render(dom,"erp_input_div","erp_query_template",m_info_in,"Input");
	Erp_build_render(dom,"erp_output_div","erp_query_template",m_info_out,"Output");
	Erp_build_render(dom,"erp_fault_div","erp_query_template",m_info_fault,"Fault");
	
	$(".erp_template").treeTable({
		initialState: "expanded"
	});//alert(query_xml);
	  //erp_query_template
	
	//alert(in_html);
}


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


