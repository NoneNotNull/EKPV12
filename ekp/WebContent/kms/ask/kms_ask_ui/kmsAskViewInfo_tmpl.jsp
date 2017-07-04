<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>

<!-- 最佳答案 -->
<script type="text/html" id="bestPost-tmp" class="js_tmpl">
	<h3><i class="insignia"></i></h3><h2><span style="margin-left:10px">${lfn:message('kms-ask:kmsAskPost.fdIsBest') }</span></h2>
	<p >{{bestPost.docContent}}</p>
	<br>
	{{#each bestPost.additionArray as addition indx}}
		<div class="lui_ask_view_clear"></div>
		<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
		<br>
		<div>
			<span style="float: left;padding-left: 10px">
				${lfn:message('kms-ask:kmsAskPost.fdMoreAnsw') }
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
		<b>(<span class="com_number" id="agree{{bestPost.fdId}}">{{(bestPost.fdAgreeNum==null)?0:(bestPost.fdAgreeNum)}}</span>)</b>
	</div>
	<div class='lui_ask_comment_count' style = "width:100%" id='comment_count{{bestPost.fdId}}' onclick=openSectionBest('{{bestPost.fdId}}')  align="center"">
        <img id='img{{bestPost.fdId}}' src="${KMSS_Parameter_StylePath}answer/ic_cocl.gif"/> 
		<bean:message bundle="kms-ask" key="kmsAskComment.total"/>
		<span id='num{{bestPost.fdId}}' class="com_number">{{(bestPost.fdCommentNum == null) ? 0 : (bestPost.fdCommentNum)}} </span>
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
				<table>
					<tr>
						<td id="btn1{{bestPost.fdId}}" style="padding-right: 8px;"></td>
						<td id="btn2{{bestPost.fdId}}"></td>
					</tr>
				</table>
		   	</div>
		</div>
	</div>
	        
	<div class="lui_ask_view_clear"></div>
	<div class="lui_ask_about_infl m_t10 c" id="bestPosterInfoDiv" style="margin-left: 0px;">
		<a href="javascript:void(0)" class="lui_ask_img_b" title="">
			<img class="img1" src="${KMSS_Parameter_ContextPath}kms/ask/kms_ask_ui/style/img/ic_best_2.jpg" alt="<bean:message bundle='kms-ask' key='kmsAskPost.fdIsBest'/>"/>
		</a>
		<ul class="lui_ask_l c">
			<li><strong>${lfn:message('kms-ask:kmsAskPost.fdAnswerer') }</strong><span onclick="showUserInfo('{{bestPost.posterId}}');return false;" style="cursor: pointer;color:#F19703">{{bestPost.posterName}}</span>
			</li>
			<li style="width:100%;white-space:nowrap;"><strong>${lfn:message('kms-ask:kmsAskPost.fdBestArea') }</strong><span>{{bestPost.fdCategoryNames}}</span></li>
		</ul>
	</div>
</script>

<!-- 回复评论信息 -->
<script type="text/html" id="commentInfo-tmp">
{{#each commentArray as kmsAskComment indx}}
	<div class="lui_ask_view_clear"></div>
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
	<div class="lui_ask_otanswer_title">
		<h3 class="lui_ask_h3_1">
			${lfn:message('kms-ask:kmsAskPost.fdOtherAnsw') }
			<bean:message bundle="kms-ask" key="kmsAskPost.record.msgcount" arg0="{{page.totalrows}}" />
			{{#if page.totalrows>0}}
			<span>
				<a href="javascript:void(0)" title="${lfn:message('kms-ask:kmsAskPost.orderByTime')}" onclick="viewOtherPostsByTime();" class="a_b m_l10" >
					${lfn:message('kms-ask:kmsAskPost.orderByTime') }
				</a>
				<a href="javascript:void(0)" title="${lfn:message('kms-ask:kmsAskPost.orderByAgree')}" onclick="viewOtherPostsByAgree();" class="a_b m_l10" >
					${lfn:message('kms-ask:kmsAskPost.orderByAgree') }
				</a>
			</span>
			{{/if}}
		</h3> 
	</div>
	{{#each itemList as post indexs}}
		<dl class="lui_ask_dlfc">
			<div class="lui_ask_pic">
				<a href="#">
					{{#if post.attUrl != null}}
						<img src="{{post.attUrl}}"></img>
					{{/if}}
					{{#if post.attUrl == null}}
						<img src="${KMSS_Parameter_ContextPath}kms/ask/kms_ask_ui/style/img/head.jpg"></img>
					{{/if}}
				</a>
		
			</div>
			<div>
				<span class="lui_ask_lname"><ui:person personId="{{post.fdPosterId}}" personName="{{post.fdPosterName}}">
			</ui:person></span>${lfn:message('kms-ask:kmsAskPost.fdFrom') }
				<span class="lui_ask_ldept">{{post.fdDept}}</span>
				<span>{{post.fdPostTime}}</span>
			<dt style = "padding-top:5px;padding-bottom:5px;">{{post.docContent}}</dt>
			</div>

			{{#each post.additionArray as addition indx}}
				<div class="lui_ask_view_clear"></div>
				<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
				<br>
				<div>
					<span style="float: left;padding-left: 10px">
						${lfn:message('kms-ask:kmsAskPost.fdMoreAnsw') }
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
					<span class="lui_ask_addition"><bean:message bundle="kms-ask" key="button.kmsAsk.best"/></span></a>
				{{/if}}
				{{#if post.flagPostAddition}}
					<span class="lui_ask_addition">
						<a href="javascript:void(0);" onclick="showPostAddition('{{post.fdId}}','reply_addition');" >
							${lfn:message('kms-ask:kmsAskTopic.addAnswer') }
						</a>
					</span>
				{{/if}}
				{{#if post.flagOpe}}
					<span class="lui_ask_addition">
						<a href="javascript:void(0)"  onclick="delPost('{{post.fdId}}',false);" >
							<bean:message key="button.delete"/>
						</a>
					</span>
				{{/if}} 
		 		{{#if post.flagAgree}}
		 			<a href="javascript:void(0)" onclick="kmsAsk_agree('{{post.fdId}}');return false" id = "agreeClick{{post.fdId}}">
		 		{{/if}}
		 			<span class="lui_ask_addition">
						<bean:message bundle="kms-ask" key="kmsAskPost.agree"/>
						<b>(<span class="com_number" id="agree{{post.fdId}}">{{(post.fdAgreeNum==null)?0:(post.fdAgreeNum)}}</span>)</b>
					</span>
		 		{{#if post.flagAgree}}
		 			</a>
		 		{{/if}}
				<span >
				{{#if post.flagComment ||(!post.flagComment && post.fdCommentNum > 0)}}
					<a href="javascript:void(0)" onclick="openSectionOther('{{post.fdId}}')">
				{{/if}}
						${lfn:message('kms-ask:kmsAskComment.comment') }<b>(<span class="com_number" id="num{{post.fdId}}">{{(post.fdCommentNum==null)?0:(post.fdCommentNum)}}</span>)</b>
				{{#if post.flagComment ||(!post.flagComment && post.fdCommentNum > 0)}}
				</a>
				{{/if}}
				</span>
			</dd>
			<div class="lui_ask_view_clear"></div>
			<div class='lui_ask_tmpl_comment' id='comment{{post.fdId}}' style="display: none; width:100%;padding-top:5px">
				 <div > 
					<div >
						<div id="record{{post.fdId}}" ></div>
					{{#if post.flagComment}}
						<div style="height:125px;"> 
							<span ><bean:message bundle='kms-ask' key='kmsAskComment.comment.title'/></span>  
							<textarea style="width: 100%" name="docContent{{post.fdId}}" style="float:right;" onkeyup="checkOverInput(this,100)"></textarea> 
						 </div>
					{{/if}}
				   	</div>
					{{#if post.flagComment}}
				 	<div style="float: right;color: #999;margin-top:-25px;" ><bean:message bundle="kms-ask" key="kmsAskComment.input"/></div><br>
					<div style="float: right;margin-top:-25px;" >
						<table>
							<tr>
								<td id="btn1{{post.fdId}}" style="padding-right: 8px;"></td>
								<td id="btn2{{post.fdId}}"></td>
							</tr>
						</table>
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
<p class="lui_ask_jump">${lfn:message('kms-ask:kmsAskTopic.fdEachPage') }<input type="text" value="{{page.rowsize}}" class="i_a" id="_page_rowsize">${lfn:message('kms-ask:kmsAskTopic.fdRow') }<input type="text" value="{{page.pageno}}" class="i_a" id="_page_pageno">/${lfn:message('kms-ask:kmsAskTopic.fdTotal')} {{page.totalPage}}${lfn:message('kms-ask:kmsAskTopic.fdPagez')} <span class="lui_ask_btn_b"><a href="javascript:jump();" title="${lfn:message('kms-ask:kmsAskTopic.fdGoTo')}"><span>Go</span></a></span></p>
<div >
	{{#if page.hasPrePage}}<div class="lui_ask_btn_b"><a title="${lfn:message('kms-ask:kmsAskTopic.fdPrePage')}" href="javascript:setPageTo({{page.pageno-1}}, {{page.rowsize}});"><span>${lfn:message('kms-ask:kmsAskTopic.fdPrePage')}</span></a></div>{{/if}}
	<span class="lui_ask_page_list">
		{{#each page.pagingList as pgn n}}
		<a title="${lfn:message('kms-ask:kmsAskTopic.fdDi')}{{pgn}}${lfn:message('kms-ask:kmsAskTopic.fdPagez') }" href="javascript:setPageTo({{pgn}}, {{page.rowsize}});" {{page.pageno == pgn ? 'class="on"' : ''}}>{{pgn}}</a>
		{{/each}}
		{{#if page.hasNextPageList }}
		……
		{{/if}}
	</span>
	{{#if page.hasNextPage}}<div class="lui_ask_btn_b"><a title="${lfn:message('kms-ask:kmsAskTopic.fdNextPage') }" href="javascript:setPageTo({{page.pageno+1}}, {{page.rowsize}});"><span>${lfn:message('kms-ask:kmsAskTopic.fdNextPage') }</span></a></div>{{/if}}
	<div class="lui_ask_inf_btn"><a title="${lfn:message('kms-ask:kmsAskTopic.fdReFresh') }" href="javascript:setPageTo({{page.pageno}}, {{page.rowsize}});"><span>${lfn:message('kms-ask:kmsAskTopic.fdReFresh') }</span></a></div>
</div>
{{/if}}
</script>

<!-- 补充提问显示 -->
<script type="text/html" id = "kms_addition_ask-tmp" >
	{{#each jsonArray as json index}}
		<br>
		<div class=f12 style="border-top: #cae7ad 1px solid;width:100%"></div>  
		<br>
		<div style="width:100%;overflow:hidden;">
			<span style="float: left;padding-left: 10px">
				${lfn:message('kms-ask:kmsAskTopic.fdMoreAsk') }
				<div style="width:100%;margin-left: 20px;margin-top: 5px;overflow:hidden;">{{json.docContent}}</div>
			</span>
			<span style="float: right;color: #999" >
				{{json.docCreateTime}}
				{{#if json.flag}}
					<a href ="javascript:void(0)" onclick="delAddition('{{json.fdId}}',true)"><bean:message key='button.delete'/></a>
				{{/if}}
			</span>
		</div>
		<div class="lui_ask_view_clear"></div>
	{{/each}}
</script>