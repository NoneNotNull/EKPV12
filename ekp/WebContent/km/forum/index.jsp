<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<template:include ref="default.view" sidebar="no" width="100%">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-forum:module.km.forum') }"></c:out>
	</template:replace>
	<template:replace name="head">  
	    <script type="text/javascript">
			seajs.use(['theme!list', 'theme!portal']);	
		</script>
		<portal:header var-width="980px" />
	</template:replace>
	<template:replace name="content">  
	<script type="text/javascript">
		   window.replaceStr = function(testStr){
				var re=/<[^>]+>/gi;
				testStr=testStr.replace(re,'');
				return testStr;
			};
		    var _str = new Object();
			_str.textEllipsis = function(str, num) {
				if (str) {
					if (str.length * 2 <= num)
						return str;
					var rtnLength = 0;
					for (var i = 0; i < str.length; i++) {
						if (Math.abs(str.charCodeAt(i)) > 200)
							rtnLength = rtnLength + 2;
						else
							rtnLength++;
						if (rtnLength > num)
							return str.substring(0, i)
									+ (rtnLength % 2 == 0 ? ".." : "...");
					}
					return str;
				}
			};

			window.openUrl = function(object) {
				var url = object.getAttribute("href");
				if(url == ""){
					return;
				}
				window.open(url, "_blank");
			};

		    var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.forum.model.KmForumTopic";
			seajs.use(['lui/dialog','lui/topic','lui/jquery'], function(dialog,topic,$) {
				window.del_load1 = dialog.loading();
	});
</script>	    
    <link href="./resource/css/forum.css" rel="stylesheet" type="text/css" />
	<!-- 论坛头部 开始 -->
    <div class="lui_forum_header">
        <div class="lui_forum_headerC">
            <!-- 帖子导航 开始 -->
            <ui:dataview>
		       <ui:source type="AjaxXml">
					  {"url":"/sys/common/dataxml.jsp?s_bean=kmForumIndexDataService&type=newTopics"}
				</ui:source>
			    <ui:render type="Template">
			    {$<div class="lui_forum_Qicknav"> 
			        <ul>
			        <li><img src="./resource/images/forum_img_1.png" alt="" /></li> 
	                <li class="item_color1" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[1].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[1].href)%}" target="_blank" title="{%env.fn.formatText(data[1].subject)%}">
		                        {%_str.textEllipsis(data[1].subject,75)%}
		                    </a>
		                 </p>
	                     <p class="comment">$}
	                       if(data[1].count!=""){
	                        {$<a href="{%env.fn.formatUrl(data[1].href)%}">
	                          {%data[1].count%}
	                         $}
	                        }
	                        {$</a>
	                     </p>
	                  </li>
			        <li><img src="./resource/images/forum_img_2.png" alt="" /></li> 
			        
			     	<li class="item_color2" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[2].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[2].href)%}" target="_blank" title="{%env.fn.formatText(data[2].subject)%}">
		                       {%_str.textEllipsis(env.fn.formatText(data[2].subject),75)%}
		                     </a>
		                 </p>
	                     <p class="comment">$}
	                       if(data[2].count!=""){
	                        {$<a href="{%env.fn.formatUrl(data[2].href)%}">
	                          {%data[2].count%}
	                         $}
	                        }
	                        {$</a>
	                     </p>
	                  </li>
	                  
	                 <li class="item_color3" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[3].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[3].href)%}" target="_blank" title="{%env.fn.formatText(data[3].subject)%}">
		                       {%_str.textEllipsis(env.fn.formatText(data[3].subject),75)%}
		                    </a>
		                 </p>
	                      <p class="comment">$}
	                        if(data[3].count!=""){
	                        {$<a href="{%env.fn.formatUrl(data[3].href)%}">
	                          {%data[3].count%}
	                         $}
	                        }
	                        {$</a>
	                     </p>
	                  </li>
			         <li class="heart" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[0].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[0].href)%}" target="_blank" title="{%env.fn.formatText(data[0].subject)%}">
		                       {%_str.textEllipsis(env.fn.formatText(data[0].subject),75)%}
		                    </a>
		                 </p>
	                     <p class="summary">
                            <a href="{%env.fn.formatUrl(data[0].href)%}" id="content" target="_blank" title="{%env.fn.formatText(data[0].subject)%}">
                               {%_str.textEllipsis(replaceStr(data[0].content),75)%}
                            </a>
                         </p>
	                  </li>
	                  
			         <li><img src="./resource/images/forum_img_3.png" alt="" /></li> 
			       
			         <li><img src="./resource/images/forum_img_4.jpg" alt="" /></li> 
			         <li class="item_color2" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[4].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[4].href)%}" target="_blank" title="{%env.fn.formatText(data[4].subject)%}">
		                       {%_str.textEllipsis(env.fn.formatText(data[4].subject),75)%}
		                     </a>
		                 </p>
	                      <p class="comment">$}
	                       if(data[4].count!=""){
	                        {$<a href="{%env.fn.formatUrl(data[4].href)%}">
	                          {%data[4].count%}
	                         $}
	                        }
	                        {$</a>
	                     </p>
	                  </li>
	                  <li class="item_color4" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[5].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[5].href)%}" target="_blank" title="{%env.fn.formatText(data[5].subject)%}">
		                   	    {%_str.textEllipsis(env.fn.formatText(data[5].subject),75)%}
		                    </a>
		                 </p>
	                        <p class="comment">$}
	                     if(data[5].count!=""){
	                        {$<a href="{%env.fn.formatUrl(data[4].href)%}">
	                          {%data[5].count%}
	                         $}
	                        }
	                        {$</a>
	                     </p>
	                  </li>
	                  <li class="item_color1" onclick="openUrl(this)" href="{%env.fn.formatUrl(data[6].href)%}">
		                 <p class="title">
		                    <a href="{%env.fn.formatUrl(data[6].href)%}" target="_blank" title="{%env.fn.formatText(data[6].subject)%}">  
		                        {%_str.textEllipsis(env.fn.formatText(data[6].subject),75)%}
		                    </a>
		                 </p>
	                       <p class="comment">$}
	                    if(data[6].count!=""){
	                        {$<a href="{%env.fn.formatUrl(data[6].href)%}">
	                          {%data[6].count%}
	                         $}
	                        }
	                        {$</a>
	                     </p>
	                  </li>
			      </ul>
			     </div>$}
			   </ui:render>
			   <ui:event event="load">
				   if(window.del_load1!=null){
						window.del_load1.hide();
				   }
			   </ui:event>
		   </ui:dataview> 
            <!-- 帖子导航 结束 -->
            <!-- 用户信息 开始 --> 
              <ui:dataview>
		       <ui:source type="AjaxXml">
					  {"url":"/sys/common/dataxml.jsp?s_bean=kmForumIndexDataService&type=userInfo"}
				</ui:source>
			    <ui:render type="Template">
					  {$<div class="lui_forum_userinfo">
				              <div class="post_numSummary">
					               <p class="p1">
					                  <span>${lfn:message('km-forum:kmForumIndex.today')}：<em>{%data[0].count1%}</em></span>
					                  <span>${lfn:message('km-forum:kmForumIndex.yestoday')}：<em>{%data[0].count2%}</em></span>
					               </p>
					               <p class="p2">
					                  <span>${lfn:message('km-forum:kmForumIndex.topicCount')}：<em>{%data[0].count3%}</em></span>
					               </p>
				             </div>
		                     <div class="post_userinfo">
				                    <div class="basic_info">
				                        <div class="user_img"></div>
				                          <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId={%data[0].id%}"/>
				                        <strong>{%data[0].name%}</strong>
				                      <!--<p class="sign">{%data[0].sign%}</p> -->
				                    </div>
				                    <div class="summary_info">
				                        <ul>
				                            <li><em>{%data[0].pcount%}</em><span>${lfn:message('km-forum:kmForumIndex.postCount')}</span></li>
				                            <li class="split"></li>
				                            <li><em>{%data[0].rcount%}</em><span>${lfn:message('km-forum:kmForumIndex.replyCount')}</span></li>
				                            <li class="split"></li>
				                            <li><em>{%data[0].score%}</em><span>${lfn:message('km-forum:kmForumIndex.score')}</span></li>
				                        </ul>
				                    </div>
				                    <div class="qucik_alink">
										<p class="p1"><a
											href="${ LUI_ContextPath }/km/forum/indexCriteria.jsp" target="_self">${lfn:message('km-forum:kmForumIndex.newTopic')}</a><a
											href="${ LUI_ContextPath }/km/forum/indexCriteria.jsp?myTopic=create" target="_self">${lfn:message('km-forum:kmForumIndex.myTopic')}</a></p>
										<p class="p2">
											 <kmss:auth requestURL="/km/forum/km_forum/kmForumPost.do?method=add&owner=true" requestMethod="GET">
						                            <a class="btn_quickPost" href="javascript:addDoc();"><i></i>${lfn:message('km-forum:kmForumIndex.quickPost')}</a>
						                     </kmss:auth>
						                 </p>
				                    </div>
		                	</div>
		            </div>$}
			   </ui:render>
		   </ui:dataview>
          <!-- 用户信息结束 -->   
        </div>
    </div>
    <script type="text/javascript">
			seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
				//新建
				window.addDoc = function() {
				      dialog.simpleCategoryForNewFile({modelName:"com.landray.kmss.km.forum.model.KmForumCategory",
					                                         url:"/km/forum/km_forum_cate/simple-category.jsp",
					                                    urlParam:"/km/forum/km_forum/kmForumPost.do?method=add&fdForumId=!{id}"});
						};
			});
	</script>	
    <!-- 论坛板块信息开始 -->
    <iframe src="${LUI_ContextPath}/km/forum/km_forum_cate/kmForumCategory.do?method=main" width="100%" style="margin-bottom: -4px" height="auto" frameborder="0" scrolling="auto"> 
    </iframe>
    <!-- 论坛板块信息结束 -->
</template:replace>
</template:include>