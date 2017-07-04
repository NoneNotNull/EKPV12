<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
	<%-- 
		有关目录的js代码
	--%>
	seajs.use(['lui/jquery'],function($) {
		$(function() {
			queryCatalog();
			//reflashCatelog_b();
			catelogScrollWindow();
		});
	});

	var wiki_catalogArray = [];
	//目录跳转
	function catelogScroll(_id) {
		var top = 0;
		if(_id) {
			top =  LUI.$("#" + _id).next().offset().top;
			top = top- 45;
			LUI.$('html,body').animate({
				scrollTop:top
			}, 300);
		}
	}

	//扫描目录
	function queryCatalog()  {
		//_hierarchy表示该目录的层级分别为1,2,3
		function pushCatalog(__id, __class, __title, _hierarchy) {
			wiki_catalogArray.push(
					{
						catalog_id : __id,
						catalog_class : __class,
						catalog_title : __title,
						catalog_hierarchy : _hierarchy
					}
			);
		}
		function insertTarget(_$obj, _no) {
			_$obj.before('<span class="lui_wiki_c_node" id="' + _no +'"></span>');
		}
	
		seajs.use(['lui/jquery'], function($) {
			var h2_no = 0, h3_no = 0, h4_no = 0;
			$('.lui_form_content_frame').find('.lui_wiki_catelog1,h3,h4').each(
				function() {
					if($(this).is('span')){
						h2_no ++ ;
						insertTarget($(this),'catalog_' + h2_no);
						pushCatalog(String(h2_no), 
								"lui_wiki_catalog_1", $.trim($(this).text()), 1);
						h3_no = 0;
					}else if($(this).is('h3')) { 
						h3_no ++;
						insertTarget($(this),'catalog_' + h2_no + h3_no);
						pushCatalog(String(h2_no) + String(h3_no), 
								"lui_wiki_catalog_2",  $.trim($(this).text()), 2);
						h4_no = 0;
					}else if($(this).is('h4')) {
						h4_no ++;
						insertTarget($(this),'catalog_' + h2_no + h3_no + h4_no);
						pushCatalog( String(h2_no) + h3_no + h4_no,"lui_wiki_catalog_3",
								$.trim($(this).text()), 3);
					}
				}
			);
			//计算并渲染上面目录
			calalogCal();
			//渲染下面目录
			drawCatalogBottom();
			
		});
	}

	
	
	function calalogCal() {
		var length = wiki_catalogArray.length,
			catalog_div = LUI.$("#wiki_catalog_content"),
			html = "";
		if(length > 0) {
			var rowNum = 0;
			if( length > 20 ) {
				 rowNum = 3;
			} else if (length <= 20 && length > 10) {
				rowNum = 2;
			} else if(length <=10 && length > 0) {
				rowNum = 1;
			}
			if(rowNum > 0) {
				seajs.use(['lui/view/Template', 'lui/jquery'], function(Template, $){
					html = new Template($('#wiki_catalog_template').html()).render({
								rowNum : rowNum,
								catalogArray : wiki_catalogArray
							}
					);
					$("#lui-wiki-catalog").show();
					catalog_div.append(html);
					if(rowNum == 2) {
						$('.lui_wiki_catalog_border_bottom,.lui_wiki_catalog_border_top').css({'width':'570px'});
					} else if(rowNum == 1) {
						$('.lui_wiki_catalog_border_bottom,.lui_wiki_catalog_border_top').css({'width':'350px'});
					}
					catalog_div.on("click",scorllTo);
					//LUI.ready(function(){queryCatalogTarget();alert();});
					bindScroll();
				});
			}
		}
	}
	
	function scorllTo(event) {
		var _id = LUI.$(event.target).attr("data-catalog-id") || LUI.$(event.target).attr("data-bottom-catalog-id");
		if(_id)
			catelogScroll("catalog_" + _id);
	}

	//渲染底下目录
	function drawCatalogBottom() {
		seajs.use(['lui/jquery'], function($){
			var html = "",
				_html_no = "";
			for(var i = 0 ; i< wiki_catalogArray.length; i++) {
				_html_no = "";
				if(wiki_catalogArray[i].catalog_hierarchy == 1) {
					_html_no =  "<span style=\"color: #3e9ece;margin-right:5px;\">" + wiki_catalogArray[i].catalog_id + "</span>";
				}
				html += [ "<li class='lui_catalog_bottom_common lui_catalog_bottom_" + wiki_catalogArray[i].catalog_hierarchy + "'>" ,
							"<span class=\"lui_catalog_bottom_select\"></span>",
							"<a href=\"javascript:;\"  data-bottom-catalog-id=\"" +  wiki_catalogArray[i].catalog_id + "\">",
							_html_no + wiki_catalogArray[i].catalog_title ,"</a></li>"].join(' ');
			}
			$('#catalog_ul_bottom').append(html);
			$('#catelog_bottom').on('click', scorllTo);
		});
	}

	
	//根据第一段落标题的高度来控制目录的出现
	var catelogflag = false;
	function catelogScrollWindow() {
			LUI.$(window).scroll( function() { 
				if(document.getElementById("catalog_1")) {
					var _top = LUI.$('#catalog_1').offset().top;
					if(LUI.$(document).scrollTop() >=  (_top -12)) {
						if(catelogflag == false) {
							setPos();
							LUI.$("#catelog_bottom").show();
							updownShow();
							catelogflag = true;
						}	
					}else {
						LUI.$("#catelog_bottom").hide();
						catelogflag = false;
					}
			}
		});
	}

	
	//目录右下角按钮事件
	function catelogScorllBtn(objId, guid,thisObj) {
		//目录总高度
		var height = LUI.$('#' + objId).height();
		//目录外层高度
		var b_height = LUI.$('.lui_wiki_catelog_bar').height(); 
		var step =  guid * 40;
		var _top = step + parseInt(document.getElementById(objId).style.top);
		if(-_top > height - b_height) {
			_top = b_height - height;
		}
		if(_top > 0 ) {
			_top = 0;
		}
		LUI.$('#' + objId).animate({
			top:_top
		}, 100);
		LUI.$(thisObj).blur();
	}
	function showCatelog() {
		//var sidebar = LUI.$(".lui_form_sidebar");
		//sidebar.parent().toggle();
		var $obj = LUI.$("#catelog_bottom");
		if($obj.is(":hidden")) {
			setPos();
			LUI.$("#catelog_bottom").show();
			updownShow();	
		}
		else $obj.hide();
	}
	//设置目录位置
	function setPos() {
		var _bottom = parseInt(LUI.$("#top").css('bottom').replace(/[A-Za-z]/g, "")) + LUI.$("#top").height();
		LUI.$("#catelog_bottom").css({
			position:'fixed',
			bottom: 179,
			right: 20
		});
	}
	//上下按钮的出现与否
	function updownShow() {
		//目录总高度
		var height = LUI.$('#wiki_catelog_side').height();
		//目录外层高度
		var b_height = LUI.$('.lui_wiki_catelog_bar').height();
		if(height <= b_height) {
				LUI.$('.lui_wiki_catelog_btnTop').hide();
				LUI.$('.lui_wiki_catelog_btnDown').hide();
		} 
	}
	
	//封装锚点高度对象集
	var catalogTargetArray = [];
	function queryCatalogTarget() {
		seajs.use(['lui/jquery'], function($) {
				$('.lui_wiki_c_node').each(
					function() {
						var self = $(this);
						catalogTargetArray.push( 
								{
									top : self.next().offset().top,
									id : (function(){
											var id = self.attr("id");
											return id.substring(id.indexOf("_") + 1);
										 })()
								}
						);
					}
				);
		});
	}
	//确定当前滚动的目录范围的下限id 参数scorllHight为滚动条卷起的高度
	function catalogIndex(cArray , scorllHight) {
		if(scorllHight < cArray[0].top) return -1;
		var low = 0,
		     high = cArray.length - 1;
		while(low <= high) {
			var middle = parseInt((low + high) / 2);
			if(scorllHight == cArray[middle].top) {
				return cArray[middle].id;
			}
			else if(scorllHight > cArray[middle].top){
				low = middle + 1;
			}
			if(scorllHight < cArray[middle].top) {
				high = middle - 1;
			}
		}
		return cArray[low - 1 ].id ;
	}

	//绑定滚动事件
	function bindScroll() {
		seajs.use(['lui/jquery'],function($) {
			$(window).scroll(function() {
				queryCatalogTarget();
				$(".lui_catalog_bottom_select_item").removeClass("lui_catalog_bottom_select_item");
				var sId = catalogIndex(catalogTargetArray,$(document).scrollTop() + 68);
				if(sId != -1)
					$('.lui_catalog_bottom_common').find("[data-bottom-catalog-id=" + sId + "]").each(
						function() {
							$(this).parent().addClass("lui_catalog_bottom_select_item");
							setCatalogPosition();
						}
					);
			});
		});
	}

	//设置被选中目录滚动到目录的中间
	function setCatalogPosition() {
		//目录总高度
		var catalogHeight = LUI.$('#wiki_catelog_side').height(),
			//目录外层高度
		    b_height = LUI.$('.lui_wiki_catelog_bar').height();
	    if(catalogHeight <= b_height)
		   return;
			//元素相对于目录总高度的偏移高度
		var _top = LUI.$(".lui_catalog_bottom_select_item").position().top,
			_setting_top = _top - b_height / 2;	
			if(_setting_top < 0)
				 _setting_top = 0;
			else if(_setting_top > catalogHeight - b_height ) 
				_setting_top = catalogHeight - b_height;
			LUI.$('#wiki_catelog_side').css({
				top : -_setting_top
			});
	}

</script>
<script type="text/template" id="wiki_catalog_template">
	var _rowNum = rowNum,
		_catalogArray = catalogArray,
		_length = catalogArray.length,
		_maxCol = Math.ceil(_length  / _rowNum),
		i = 0, 
		j = 0;
	for(var r = 0; r < rowNum; r++) {
		{$
			<div class="lui_wiki_catalog_row_{%_rowNum%} lui_wiki_catalog_row_common ">	
				<ul>
		$}
					for(i = r * _maxCol, j = 0; i < _length && j < _maxCol; i++,j++) {
					   {$ <li class="{%_catalogArray[i].catalog_class %}"> $}
							if(_catalogArray[i].catalog_hierarchy == 1 ) {
								{$<p class="lui_catalog_i1"><span class="lui_wiki_catalog_index"> {% _catalogArray[i].catalog_id %} </span> $}
							} 
							else if(_catalogArray[i].catalog_hierarchy == 2 ) {
								{$<span class="lui_wiki_catalog_index_tri"></span> $}
							}
							else if(_catalogArray[i].catalog_hierarchy == 3)	{
								{$<span class="lui_wiki_catalog_index_dot"></span> $}
							}	
							 {$ <a data-catalog-id ="{%_catalogArray[i].catalog_id%}"  href="javascript:;" title="{% _catalogArray[i].catalog_title%}">
								   {% _catalogArray[i].catalog_title%}	
							    </a>
							  $}
							if(_catalogArray[i].catalog_hierarchy == 1 ) {
								{$</p>$}
							}
						 {$ </li>$}
					}
		{$
				</ul>
			</div>
		$}
	}
</script>