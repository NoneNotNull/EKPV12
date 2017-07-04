<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.view" width="100%" sidebar="no">
	<template:replace name="title">
		<c:out value="${document.title}"></c:out>
	</template:replace>
    <template:replace name="head">
	    <link href="${LUI_ContextPath}/km/comminfo/resource/css/com_datum.css" rel="stylesheet" type="text/css" />
	    <script type="text/javascript">
		    Com_IncludeFile("ckresize.css", Com_Parameter.ContextPath + "resource/ckeditor/resource/", "css", true);
		</script>
	    <script type="text/javascript">
		    window.onload = function(){
		    	var h1, h2, h3, h4;
		        //获得当前文档的fdId
		   		var fdId = "${param.fdId}";
		   		//当前文档索引
		   		var currIndex = $("a[id^="+fdId+"]")[0].id.split('_')[1];
		   		$("#currIndex").val(currIndex);
	          	//文档总数
	         	var total = "${total}";

	         	window.onresize = onresize; //窗口大小改变时，光标自适应位置
	         	cursorLocation();
	            cursorDisable(currIndex,total);
	            setHeight();
	
			    //翻页效果
	            $(".com_datum_listItem ul li").each(function () {
	                $(this).click(function () {
		                //当前点击文档的索引值及ID
	                    var index = $(this).find("a")[0].id.split('_')[1];
	                    docId = $(this).find("a")[0].id.split('_')[0];
	                    //向右 下一页
	                    if (index > currIndex) {
	                    	freshLeft(docId,"right");
	                        $(".com_datum_listItem ul li.current").removeClass("current");
	                    }
	                    //向左 上一页
	                    else if (index < currIndex) {
	                    	freshLeft(docId,"left");
	                        $(".com_datum_listItem ul li.current").removeClass("current");
	                    }
	                    $(this).addClass("current");
	                    currIndex = index;
	                    $("#currIndex").val(currIndex);
	                    
	                    setHeight();
	                    cursorDisable(currIndex,total);
	                });
	            });
	            //向右 下一页
	            $(".com_datum_arrowR").click(function (event) {
		            //获得下一页的索引值
		            var id = parseInt(currIndex) + 1;
	                //判断是否已经是最后一页
	                if (id > total) {
	                    return;
	                } else {
	    	            nextDocId = $("a[id$=_"+id+"]")[0].id.split('_')[0];
	                	changeDocOperation( nextDocId,"left");
	                    currIndex = id;
	                    changeCurrArea(nextDocId);
	                    //设置高度
	                   	setHeight();
	                   	cursorDisable(currIndex,total);
	                }
	                //点击下一页，自动回到内容顶部
	                $("html,body").animate({ scrollTop: $(".com_datum_wrapper").offset().top }, 400);
	            });
	            //向左 上一页
	            $(".com_datum_arrowL").click(function (event) {
		            //获得上一页的索引值
	            	var id = parseInt(currIndex) - 1;
	                if (id <= 0) {
	                    return;
	                }
	                else {
	                	nextDocId = $("a[id$=_"+id+"]")[0].id.split('_')[0];
	                	changeDocOperation(nextDocId,"right");
	                    currIndex = id;
	                    changeCurrArea(nextDocId);
	                    //设置高度
	                    setHeight();
	                    cursorDisable(currIndex,total);
	                }
	                $("html,body").animate({ scrollTop: $(".com_datum_wrapper").offset().top }, 400);
	            });
			    };

		    	 //获取下一条记录
			    window.changeDocOperation  = function(docId,direc){
                    window.document.getElementById("commMain").src="${LUI_ContextPath}/km/comminfo/km_comminfo_main/kmComminfoMain.do?"+
                        "method=view&fdId="+docId+"&forward=viewDoc&direc="+direc;
				};
				//左侧联动右侧高亮显示
				window.changeCurrArea = function(currdDocId){
					var index = $("a[id^="+currdDocId+"]")[0].id.split('_')[1];
					window.document.getElementById("currIndex").value = index;
					$(".com_datum_listItem ul li.current").removeClass("current");
		    	    $("#"+currdDocId+"_"+index).parent().addClass("current");
				};
			   //左右两侧翻页标志处理,在第一页和最后一页变灰
			    window.cursorDisable = function(currIndex,total){
					if(parseInt(currIndex) == 1){
						$(".com_datum_arrowL").addClass("disable");
					}
					if(parseInt(currIndex) == parseInt(total)){
						$(".com_datum_arrowR").addClass("disable");
					}
					if(currIndex > 1){
		                $(".com_datum_arrowL").removeClass("disable");
			        }
					if(currIndex < parseInt(total)){
		                $(".com_datum_arrowR").removeClass("disable");
		            }
				};
				//IFrame的局部刷新
			  	window.freshLeft = function(docId,direc){
			  		$("#commMain").attr("src","${LUI_ContextPath}/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=view&fdId="+docId+"&forward=viewDoc&direc="+direc);
			   	};

				//初始化光标定位
				window.cursorLocation = function(){
					var exp_previewC_left = $(".com_datum_contentC").offset().left+13;
	                var exp_previewC_right = $(".com_datum_contentLeft").width() - $(".com_datum_arrowL").width() + exp_previewC_left;
	                //左右翻页箭头定位
	                $(".com_datum_arrowL").css("left", exp_previewC_left + "px");
	                $(".com_datum_arrowR").css("left", exp_previewC_right + "px");
				};
			   	//设置高度
			     window.setHeight = function() {
	                $(".com_datum_contentListC").css({ "position": "static" });
	                h1 = $("#com_datum_contentLeft").height();//左侧内容的高度
	                h3 = $(".com_datum_contentListC").height();//右侧列表的高度
	                h4 = parseInt(h1, 10) > parseInt(h3, 10) ? h1 : h3;
	                h2 = parseInt(h4, 10) + 20 + "px";
	                var com_datum_wrapper_h=h4+20+28+17+15;
	
	                $(".com_datum_contentC").height(h4);
	                $("#com_datum_contentLeft").height(h4);
	                $(".com_datum_content").height(h2);
	                $(".com_datum_wrapper").height(com_datum_wrapper_h+"px");

	                fixList(); //右侧列表滚到底部即固定
			    };
			    //右侧列表滚到底部即固定
			    window.fixList = function() {
	                var top = $(".com_datum_contentListC").offset().top;
	                var left = $(".com_datum_contentListC").offset().left;
	                var pos = $(".com_datum_contentListC").position();
	                var window_h = $(window).height();//当前可见区域的大小
	                var scoll_h = h3- $(window).height()+top;
	                var rightList_h = h3 + top; //右侧列表的高度
	              //滚动时，让左右翻页箭头重新适应新的高度
                    var com_datum_contentC_top=$(".com_datum_contentC").offset().top;   
                    $(window).scroll(function () {
                        var scrolls = $(this).scrollTop();//滚动条的垂直偏移
                        if (scrolls > com_datum_contentC_top) { //如果滚动到页面超出了当前元素element的相对页面顶部的高度
                            $(".com_datum_arrowL span").css({ "top": 180+"px"});
                            $(".com_datum_arrowR span").css({ "top": 180+"px"});
                        } else {
                            $(".com_datum_arrowL span").css({"top": 240+"px" });
                            $(".com_datum_arrowR span").css({"top": 240+"px" });
                        }
                    });
	                if (rightList_h <= window_h) { //当右侧列表没有超过一屏时，即固定在头部
	                    //列表浮动
	                    $(window).scroll(function () {
	                        var scrolls = $(this).scrollTop();//滚动条的垂直偏移
	                        if (scrolls > top) { //如果滚动到页面超出了当前元素element的相对页面顶部的高度
	                            $(".com_datum_contentListC").css({ "position": "fixed", "left": left, top: "0px",width:"220px"});
	                        } else {
	                            $(".com_datum_contentListC").css({ "position": "static" });
	                        }
	                    });
	                }
	                else  {
	                    //列表浮动
	                    $(window).scroll(function () {
	                        var scrolls = $(this).scrollTop();//滚动条的垂直偏移
	                        if (scrolls > scoll_h) { //当右侧列表滚刀底部时
	                            $(".com_datum_contentListC").css({ "position": "fixed", "left": left, bottom: "10px",width:"220px" })
	                        } else {
	                            $(".com_datum_contentListC").css({ "position": "static" });
	                        }
	                    });
	                }
	            };
	           window.onresize = function() {
	            	cursorLocation();
	            	setHeight();
	    	   };
	    </script>
	</template:replace>
	<template:replace name="content">
	  <div class="com_datum_wrapper">
		  <div class="com_datum_content clrfix">
			  <div class="shadow_L">
			  </div>
		      <div class="com_datum_contentC clrfix" id="com_datum_contentC">
				<!--左边定义为一个iframe实现局部刷新-->
			   	<div class="com_datum_contentLeft" id="com_datum_contentLeft">
				   	<div class="com_datum_arrowL">
	                    <span></span>
	                </div>
	                <div class="com_datum_arrowR">
	                    <span></span>
	                </div>
				    <iframe style="margin-bottom: -4px; min-height:690px; width: 716px;" 
				    		id="commMain" frameborder="0" scrolling="no"
				    		src="${LUI_ContextPath}/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=view&fdId=${param.fdId}&forward=viewDoc">
				    </iframe>
			    </div>
			    <!-- 右边-->
				<div class="com_datum_contentList">
				    <input type="hidden" id="currIndex" value=""/>
				    <input type="hidden" id="total" value="${total}"/>
		            <div class="shadow_line">
		           	</div>
	               		<div class="com_datum_contentListC">
	                   		<div class="com_datum_listItem">
	                   		    <%int docIndex=0;%>
		                        <c:forEach items="${categoryList}" var="category">
			                        <h3>
			                            <span class="ico_head"></span>
			                            <span>
			                            	${category.fdName}
			                            </span>
			                        </h3> 
			                        <c:forEach items="${cateDocMap[category.fdId]}" var="doc" varStatus="index">
			                            <%docIndex++;request.setAttribute("docIndex",docIndex);%>
				                        <ul>
				                            <li class="${param.fdId==doc.fdId?'current':''}">
					                            <a href="#" id="${doc.fdId}_${docIndex}">
					                            	${doc.docSubject}
					                            </a>
				                            </li>
				                       </ul>
			                       </c:forEach>
		                        </c:forEach>
	                   		</div>
	               		</div>
	           		</div>
				</div>
				<div class="shadow_R">
	   			</div>
			</div>
			<div class="shadow_B">
    		</div>
		</div>
	</template:replace>
</template:include>
