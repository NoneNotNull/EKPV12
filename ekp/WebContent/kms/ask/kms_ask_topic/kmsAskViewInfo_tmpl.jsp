<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%-- 右上角个人信息 --%>
<script type="text/html" id="myInfo-tmp" class="js_tmpl">
	<div class="about_inf about_inf2 c">
		<a class="img_b" href="#" onclick="showUserInfo('{{fdPersonId}}');return false;"><img src="{{attUrl}}" /></a>
		<ul class="l_e c">
			<li><span onclick="showUserInfo('{{fdPersonId}}');return false;" style="cursor: pointer;">{{fdPersonName}}</span></li>
			<li>
				<strong>等级：</strong>{{totalGrade}}
				<strong class="m_l20 ask">积分：</strong>{{askScore}}分
			</li>
		</ul>
		<div class="btn_l m_t10 l"><a href="#" title=""><span onclick="showUserInfo('{{fdPersonId}}');return false;" style="cursor: pointer;">进入个人中心</span></a></div>
		<div class="clear"></div>
	</div>
	<div class="clear"></div>
	<div id = "unsolvedDiv" ></div>
</script>

<!-- 未解决问题 -->
<script type="text/html" id="unsolved-tmp" >
	<ul class="l_a4 m_t10">
		{{#each unsolveAskList as unsolveAsk index}}
			<li><a href="<c:url value='/kms/ask/kms_ask_topic/kmsAskTopic.do?method=view&fdId={{unsolveAsk.fdTopicId}}' />" target="_blank" title="{{unsolveAsk.docSubject }}">
			<span>
				[{{unsolveAsk.fdCategoryName}}]
			</span>{{unsolveAsk.docSubject}}</a></li>
		{{/each}}
	</ul>
</script>

<!-- 最佳答案 -->
<script type="text/html" id="bestPost-tmp" class="js_tmpl">
	<h2 class="h2_7">最佳答案</h2>
	<p class="p_a m_t40">{{bestPost.docContent}}</p>
	<br>
	{{#each bestPost.additionArray as addition indx}}
		<div class="clear"></div>
		<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
		<br>
		<div>
			<span style="float: left;padding-left: 10px">
				补充回答：
				<div style="margin-left: 20px;margin-top: 5px">{{addition.docContent}}</div>
			</span>
			<span style="float: right;color: #999" >
				{{addition.fdTime}}
			</span>  
		</div>
		<br>
		<br>  
	{{/each}}
	<div id="div_{{bestPost.fdId}}" style="float:right"> 
		{{#if bestPost.flagAgree}}
		 	<a href="#" onclick="kmsAsk_agree('{{bestPost.fdId}}');return false" id = "agreeClick{{bestPost.fdId}}">
		 {{/if}}
		 	<bean:message bundle="kms-ask" key="kmsAskPost.agree"/> 
		 {{#if bestPost.flagAgree}}
			 </a>
		{{/if}}
		<b>(<span style="color: red;" id="agree{{bestPost.fdId}}">{{(bestPost.fdAgreeNum==null)?0:(bestPost.fdAgreeNum)}}</span>)</b>
	</div>
	<div class='comment_count' style = "width:100%" id='comment_count{{bestPost.fdId}}' onclick=openSectionBest('{{bestPost.fdId}}')  align="center"">
        <img id='img{{bestPost.fdId}}' src="${KMSS_Parameter_StylePath}answer/ic_cocl.gif"/> 
		<bean:message bundle="kms-ask" key="kmsAskComment.total"/>
		<span id='num{{bestPost.fdId}}' class=ar>{{(bestPost.fdCommentNum == null) ? 0 : (bestPost.fdCommentNum)}} </span>
		<bean:message bundle="kms-ask" key="kmsAskComment.pieces"/>	
	</div>
	<div class='comment' id='comment{{bestPost.fdId}}' style="display: none; width:100%">
		 <div  > 
			<div >
				<div id="record{{bestPost.fdId}}" ></div>
				<div > 
					<span > <bean:message bundle='kms-ask' key='kmsAskComment.comment.title'/></span>  
					<textarea style="width: 100%" name="docContent{{bestPost.fdId}}" style="float:right;" ></textarea> 
				</div>
		    </div> 
		 	<div style="float: right;color: #999" ><bean:message bundle="kms-ask" key="kmsAskComment.input"/></div><br>
			<div style="padding-left: 90px;float: right">
				<input onclick="return submitComment(this,'{{bestPost.fdId}}');"  type="button" align="absMiddle" value='<bean:message bundle="kms-ask" key="kmsAskComment.publish.title"/>' > 
			    <input onclick="cancelCommnet('{{bestPost.fdId}}')"  type="button" align="absMiddle" value='<bean:message bundle="kms-ask" key="kmsAskComment.cancel"/>' >
		   	</div>
		</div>
	</div>
	        
	<div class="clear"></div>
	<div class="about_inf m_t10 c" id="bestPosterInfoDiv">
		<a href="javascript:void(0)" class="img_b" title="">
			<img class="img1" src="${KMSS_Parameter_StylePath}answer/ic_best_2.jpg" alt="<bean:message bundle='kms-ask' key='kmsAskPost.fdIsBest'/>"/>
		</a>
		<ul class="l_e c">
			<li><strong>回答者：</strong><span onclick="showUserInfo('{{bestPost.posterId}}');return false;" style="cursor: pointer;">{{bestPost.posterName}}</span>
			</li>
			<li><strong class="s2">等级：</strong>{{bestPost.bestPosterGrade}}</li>
			<li style="width:100%;white-space:nowrap;"><strong>精通领域：</strong>{{bestPost.fdCategoryNames}}</li>
		</ul>
	</div>
</script>

<!-- 回复评论信息 -->
<script type="text/html" id="commentInfo-tmp">
{{#each commentArray as kmsAskComment indx}}
	<div class="clear"></div>
	<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
	<br>
	<div>
		<span style="float: left;padding-left: 10px">
			<a href="javascript:void(0)" class="aherf " onclick="showUserInfo('{{kmsAskComment.fdCommentaterId}}');return false;">{{kmsAskComment.fdCommentaterName}}</a>
				<bean:message bundle="kms-ask" key="kmsAskComment.says"/>
		</span>
		<span style="float: right;color: #999" >
			{{kmsAskComment.fdCommentTime}}
			&nbsp;
			{{#if checkCanDel }}
				<a href ="javascript:void(0)" onclick="delComment('{{fdPostId}}','{{kmsAskComment.fdId}}')"><bean:message key='button.delete'/></a>
			{{/if}}
		</span>  
	</div>
	<br>
	<div style="margin-left: 20px;margin-top: 5px">{{kmsAskComment.docContent}}</div><br>  
{{/each}}
</script>

<!-- 其他回复列表 -->
<script type="text/html" id="otherPostsList-tmp">
	<div class="title6">
		<h3 class="h3_1">
			其它回答
			<span class="m_l10"><bean:message bundle="kms-ask" key="kmsAskPost.record.msg" arg0="{{page.totalrows}}" /></span>
			{{#if page.totalrows>0}}
			<span>
				<a href="javascript:void(0)" title="按时间查看回复" onclick="viewOtherPostsByTime();" title="按时间查看回复" class="a_b m_l10" >
					按时间查看回复
				</a>
			</span>
			{{/if}}
		</h3>
	</div>
	{{#each itemList as post indexs}}
		<dl class="dl_f c">
				<span class="a1">{{post.fdPosterName}}</span>|
				<span class="a1">{{post.fdPosterGrade}}</span>
				<span class="a2" style="float: right;">{{post.fdPostTime}}</span>
			<dt style = "padding-top:5px;padding-bottom:5px;">{{post.docContent}}</dt>

			{{#each post.additionArray as addition indx}}
				<div class="clear"></div>
				<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
				<br>
				<div>
					<span style="float: left;padding-left: 10px">
						补充回答：
						<div style="margin-left: 20px;margin-top: 5px">{{addition.docContent}}</div>
					</span>
					<span style="float: right;color: #999" >
						{{addition.fdTime}}
						{{#if post.flagDeleteAddition}}
							<a href ="javascript:void(0)" onclick="delAddition('{{addition.fdId}}')"><bean:message key='button.delete'/></a>
						{{/if}}
					</span>  
				</div>
				<br>
				<br>  
			{{/each}}
			<dd id="div_{{post.fdId}}">
				{{#if post.flagSetBest}}
					<a href="javascript:void(0)" onclick="bestPost('{{post.fdId}}');" >
					<span class="a1"><bean:message bundle="kms-ask" key="button.kmsAsk.best"/></span></a>
				{{/if}}
				{{#if post.flagPostAddition}}
					<span class="a1">
						<a href="javascript:void(0);" onclick="showPostAddition('{{post.fdId}}','reply_addition');" >
							补充回答
						</a>
					</span>
				{{/if}}
				{{#if post.flagOpe}}
					<span class="a1">
						<a href="javascript:void(0)"  onclick="delPost('{{post.fdId}}',false);" >
							<bean:message key="button.delete"/>
						</a>
					</span>
				{{/if}} 
		 		{{#if post.flagAgree}}
		 			<a href="javascript:void(0)" onclick="kmsAsk_agree('{{post.fdId}}');return false" id = "agreeClick{{post.fdId}}">
		 		{{/if}}
		 			<span class="a1">
						<bean:message bundle="kms-ask" key="kmsAskPost.agree"/>
						<b>(<span style="color: red;" id="agree{{post.fdId}}">{{(post.fdAgreeNum==null)?0:(post.fdAgreeNum)}}</span>)</b>
					</span>
		 		{{#if post.flagAgree}}
		 			</a>
		 		{{/if}}
				<span ><a href="javascript:void(0)" onclick="openSectionOther('{{post.fdId}}')">评论<b>(<span style="color: red;" id="num{{post.fdId}}">{{(post.fdCommentNum==null)?0:(post.fdCommentNum)}}</span>)</b></a></span>
			</dd>
			<div class="clear"></div>
			<div class='comment' id='comment{{post.fdId}}' style="display: none; width:100%;padding-top:5px">
				 <div > 
					<div >
						<div id="record{{post.fdId}}" ></div>
					{{#if post.flagComment}}
						<div > 
							<span ><bean:message bundle='kms-ask' key='kmsAskComment.comment.title'/></span>  
							<textarea style="width: 100%" name="docContent{{post.fdId}}" style="float:right;" onkeyup="checkOverInput(this,100)"></textarea> 
						 </div>
					{{/if}}
				   	</div>
					{{#if post.flagComment}}
				 	<div style="float: right;color: #999" ><bean:message bundle="kms-ask" key="kmsAskComment.input"/></div><br>
					<div style="float: right;">
						<input onclick="return submitComment(this,'{{post.fdId}}');"  type="button" align="absMiddle" value='<bean:message bundle="kms-ask" key="kmsAskComment.publish.title"/>' > 
					   	<input onclick="cancelCommnet('{{post.fdId}}')"  type="button" align="absMiddle" value='<bean:message bundle="kms-ask" key="kmsAskComment.cancel"/>' >
				   	</div>
					{{/if}}
				</div>
			</div>
		</dl>
	{{/each}}
</script>
<!-- 其他回复列表分页 -->
<script type="text/html" id="kms-page-tmp">
{{#if page.totalrows > 0}}
<p class="jump">每页<input type="text" value="{{page.rowsize}}" class="i_a" id="_page_rowsize">条<input type="text" value="{{page.pageno}}" class="i_a m_l20" id="_page_pageno">/共{{page.totalPage}}页<span class="btn_b"><a href="javascript:jump();" title="跳转到"><span>Go</span></a></span></p>
<div class="page_box c">
	{{#if page.hasPrePage}}<div class="btn_b"><a title="上一页" href="javascript:setPageTo({{page.pageno-1}}, {{page.rowsize}});"><span>上一页</span></a></div>{{/if}}
	<p class="page_list">
		{{#each page.pagingList as pgn n}}
		<a title="第{{pgn}}页" href="javascript:setPageTo({{pgn}}, {{page.rowsize}});" {{page.pageno == pgn ? 'class="on"' : ''}}>{{pgn}}</a>
		{{/each}}
		{{#if page.hasNextPageList }}
		……
		{{/if}}
	</p>
	{{#if page.hasNextPage}}<div class="btn_b"><a title="下一页" href="javascript:setPageTo({{page.pageno+1}}, {{page.rowsize}});"><span>下一页</span></a></div>{{/if}}
	<div class="btn_b"><a title="刷新" href="javascript:setPageTo({{page.pageno}}, {{page.rowsize}});"><span>刷新</span></a></div>
</div>
{{/if}}
</script>

<!-- 增加悬赏 -->
<script type="text/html" id="kms-addscore-tmp">
<table width='150' height='30' cellspacing='1' cellpadding='6' style='border-color:#000000;background-color:#FFFFFF;font-size:11px;border-style:solid;border-width:thin;text-align:center;'>
	<tr>
		<td>
			<bean:message key='kmsAskMoneyAlter.fdMoneyAlter' bundle='kms-ask' />&nbsp;&nbsp;
			<select name='fdScoreAdd' onChange='kmsAsk_validateMoeny(this);' style='width:50'>
				<option value='0'>0</option>
				<option value='5'>5</option>
				<option value='10'>10</option>
				<option value='15'>15</option>
				<option value='20'>20</option>
				<option value='30'>30</option>
				<option value='50'>50</option>
				<option value='80'>80</option>
				<option value='100'>100</option>
			</select>
		</td>
	</tr>
	<tr>
		<td>您目前货币为：<span id='span_money'>{{fdMoneyTotal}}</span></td>
	</tr>
	<tr>
		<td>
			<input type='button' class='btnopt' value='<bean:message key='kmsAskPost.submit' bundle='kms-ask' /> ' onclick='kmsAsk_addMoney()' >&nbsp;&nbsp;
			<input type='button' class='btnopt' value='<bean:message key='button.close'/>' onclick='kmsAsk_showAdd_close()'>
		</td>
	</tr>
</table>
</script>

<!-- 当前路径 -->
<script type="text/html" id="kms_current_path-tmp" class="js_tmpl">
	<a title="首页" class="home" href="${kmsBasePath}/common/kms_common_main/kmsCommonMain.do?method=module">首页</a>&gt;
	<a title="爱问" href="${kmsBasePath}/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.ask">爱问</a>
	{{#each fdCategoryList as fdCategory index}}
		&gt;<a href = "javascript:void(0)" >{{fdCategory.fdName}}</a>
	{{/each}}
</script>

<!-- 补充提问显示 -->
<script type="text/html" id = "kms_addition_ask-tmp" >
	{{#each jsonArray as json index}}
		<br>
		<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
		<br>
		<div>
			<span style="float: left;padding-left: 10px">
				补充提问：
				<div style="margin-left: 20px;margin-top: 5px">{{json.docContent}}</div>
			</span>
			<span style="float: right;color: #999" >
				{{json.docCreateTime}}
				{{#if json.flag}}
					<a href ="javascript:void(0)" onclick="delAddition('{{json.fdId}}',true)"><bean:message key='button.delete'/></a>
				{{/if}}
			</span>
		</div>
		<div class="clear"></div>
	{{/each}}
</script>