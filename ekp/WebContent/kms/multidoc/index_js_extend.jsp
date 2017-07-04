<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script src="${kmsResourcePath }/js/kms_accordian.js"></script>
<script src="${kmsThemePath }/js/newOrHot.js"></script>
<script>
	$( function() {

		//  手风琴分类概览
		var accordian = new Accordian(
				$('#accordian'),
				{
					width : $('#accordian').width(),
					meta : [ {
						dataSource : {
							url : KMS.basePath
									+ "/common/kms_common_portlet/kmsCommonPortlet.do?method=execute",
							data : {
								s_bean : $('#accordian').attr('s_bean'),
								fdCategoryId : $('#accordian').attr(
										'fdCategoryId') || '',
								s_rowsize : $('#accordian').attr('s_rowsize') || ''
							}
						}
					} ]
				});
		bindButton();
		// 绑定搜索按钮
		$("#searchBtn").click(function() {
			// 搜索关键词
			var searchText = $("#queryString").val();
			var searchActionUrl = KMS.contextPath
					+ "sys/ftsearch/searchBuilder.do?method=search";
			var	searchModelClass = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";	
			if (searchText.equals("") || searchText.equals("请输入关键字")) {
				showAlert("搜索字段不能为空");
				return;
			}
			searchActionUrl += "&queryString=" + encodeURIComponent(searchText) + "&modelName=" + searchModelClass;
			window.open(searchActionUrl, "_blank");
		});
	})
	function bindButton() {
		var docOptions = {
			s_modelName : 'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
			open : '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=',
			width : '440px',
			extendFilter : "fdExternalId is null"
		};
		var createDoc = new KMS.opera(docOptions, $('#btn_share'));
		createDoc.bind_add();
	}

	//显示评分星
	var staron = "<img border='0' width='16px' height='16px' src='${kmsBasePath}/multidoc/resource/img/star_on.gif'/>";
	var staroff = "<img border='0' width='16px' height='16px' src='${kmsBasePath}/multidoc/resource/img/star_off.gif'/>";
	var starhalf = "<img border='0' width='16px' height='16px' src='${kmsBasePath}/multidoc/resource/img/star_half.gif'/>";

	function showStars(param) {
		var starons = "";
		var staroffs = "";
		var score = param.toString();
		var a = score.substr(0, 1);
		var b = score.substr(2, 1);
		var count = 0;
		if (a > 0) {
			for (i = 0; i < a; i++) {
				starons = starons + staron;
				count++;
			}
		}
		if (b > 0) {
			starons = starons + starhalf;
			count++;
		}
		if (count < 5) {
			for (j = count; j < 5; j++) {
				staroffs = staroffs + staroff;
			}
		}
		return starons + staroffs;
	}

	function docListPage(fdTemplateId) {
		window.open(
				"${kmsBasePath}/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?"
						+ "method=index2&fdId=${param.fdId}&templateId="
						+ fdTemplateId + "&filterType=template", "_blank");
	}

	// 积分取整
	function subStr(score) {
		var str = score.toString();
		var index = str.indexOf('.');
		if (index > 0) {
			return str.slice(0, index);
		}
		return str;
	}

	/**
	 * 广告图片回调函数
	 */
	function sliderDocIntro(){
		if($('#idTransformView')){
			showImg(0,0);//开始默认第一张
			var imgwidth = $('#idSlider li img').width();
			var len = $("#idNum > li").length;
			var index = 0;
			$('#idSlider').width(imgwidth*len);
			//控制第几副图片显示
			$("#idNum li").mouseover(function(){
			index = $("#idNum li").index(this);
			showImg(imgwidth,index);
			});
			var MyTime = setInterval(function(){
				showImg(imgwidth,index);
				index++;
				if(index==len){index=0;}
				} , 4000);
			//鼠标移入，移除
			$('#idTransformView').hover(function(){
			if(MyTime){
			clearInterval(MyTime);
			}
			},function(){
			MyTime = setInterval(function(){
			showImg(imgwidth,index);
			index++;
			if(index==len){index=0;}
			} , 4000);
			});
		}
	}
	//显示图片
	function showImg(w,i){
		 $("#idSlider").stop(true,false).animate({left : -w*i},800);
		 $("#idNum li").eq(i).addClass("current").siblings().removeClass("current");
		 $("#idIntro li").eq(i).show().siblings().hide();
	}

</script>