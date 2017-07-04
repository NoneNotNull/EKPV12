<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/index_top.jsp" %> 
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<script type="text/javascript">
// 增加左边树收缩展开功能
$(document).ready(function() {
	(function(){
		var h2s = $('.search_nav h2');
		h2s.each(function(i){
			$(this).toggle(
					function(){
						if($(this).hasClass('add')){
							$(this).next().css('display','none');
							$(this).removeClass('add');
						}else{
							$(this).next().css('display','block');
							$(this).addClass('add');
						}
					},
					function(){
						if($(this).hasClass('add')){
							$(this).next().css('display','none');
							$(this).removeClass('add');
						}else{
							$(this).next().css('display','block');
							$(this).addClass('add');
						}
					}
			)
		});
	}())
})


 

</script>
	<div id="main" class="box c">
		<div class="leftbar">
			<div class="box1">
			
				<div class="title1">
					<h2>组合搜索</h2>
				</div>
				<div class="search_nav">
				 
					
					<table class="tb_noborder">
								<tr>
									<td width="10pt"></td>
									<td>
										<div id=treeDiv class="treediv"></div>
									</td>
								</tr>
							</table>
							<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
							<script>
								window.onload = generateTree;
								var LKSTree;
								//Com_Parameter.XMLDebug = true;
								function generateTree()
								{
									LKSTree = new TreeView("LKSTree", "搜索条件", document.getElementById("treeDiv"));
									LKSTree.isShowCheckBox=true;
									LKSTree.isMultSel=true;
									LKSTree.isAutoSelectChildren = false;
									//LKSTree.DblClickNode = viewCategory;
									var n1, n2;
									n1 = LKSTree.treeRoot;	
									//var modelName = "com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate";
									n1.authType = "01"
									//n2 = n1.AppendSimpleCategoryData(modelName);
									n2 =n1.AppendBeanData("kmsMultidocSearchTreeService&type_parentId_settingId=!{value}",null,null,null);
									LKSTree.Show();

									showKeyword() ;
								}
								function showKeyword(){
									var kw= '${keyword}'  ;
									if(kw!=null && kw!='')
										document.getElementById('searchKeyword').value=kw ;
								 } 

								function searchList() {
									var searchKeyword= document.getElementById('searchKeyword') ;
									var keyword="&keyword=" ;
									if(searchKeyword.value=='请输入关键字'){
										keyword="" ;
									 }else{
									 	keyword	=keyword + searchKeyword.value ;
								 	}
								    var param = "&param=" ;
								    var selList = LKSTree.GetCheckedNode();
									for(var i=selList.length-1;i>=0;i--){
										param = param+"__"+selList[i].value; //两个下划线做分隔符
										 
									}
								    
								    action= "${KMSS_Parameter_ContextPath}kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=searchList"+keyword+param;
								    window.frames["searchListFrame"].submitForm(action); 
								 
								}
						</script>
				</div>
				 
			</div><!-- end box1 -->	
		</div><!-- end leftbar -->

		<div id="searchDiv" class="content2">
			<div class="c"><input class="input_search2" name="" id="searchKeyword" value="请输入关键字" onfocus="if(value=='请输入关键字'){value=''}" onblur="if(value==''){value='请输入关键字'}" type="text"><a href="javascript:void(0);" onclick='searchList()' class="btn_search2" title="搜索"></a></div>
 			 
 			 <iframe name="searchListFrame" id="searchListFrame" src="${KMSS_Parameter_ContextPath}kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=searchList&keyword=${keyword}" width=100%   height="100%" frameborder=0 scrolling=no>
			 </iframe>
		</div>
		
	</div><!-- main end -->
<%@ include file="/kms/common/resource/jsp/index_down.jsp" %> 