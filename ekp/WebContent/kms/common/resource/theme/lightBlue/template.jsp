<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp"%>
<script src="${kmsResourcePath }/js/kms_slider.js"></script>

<script>
Com_IncludeFile("dialog.js");
</script>
<script type="text/html" id="topBanner_info_tmpl">
欢迎您，<span><a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={{userId}}">{{userName}}</a></span>！ 
<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
<c:if test="${not empty currentUser.authAreaName}"><bean:message key="home.locale" arg0="${currentUser.authAreaName}"/></c:if>
<%}%>
</script>

<script id="portlet_tmpl" type="text/template">
				{$ 
				<div class="box1">
					<div class="title1"><h2>{%parameters.kms.title%}</h2><a href="#" class="more" title="">更多</a></div>
					<div class="box2">
				$}
				
				for(i=0;i<data.rows.length;i++){
					{$ 
						<div>{%data.rows[i].title%}</div>
					$}
				}
				{$
					</div>
				</div> 
				$} 
</script>

<script id="kms_header" type="text/template">
{$ 
	<div class="toplinks"><div class="box">
		<p id="userInfoTips">加载中......</p>
		<div class="personal_edit">
			<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId=${user.fdId}" class="none" title="" >个人知识中心</a>|
<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
			<a class="travel" style="background-image:none;" href="javascript:parent.switchArea();" target="_self" name="travel">
				<bean:message key="home.travel" />
			</a>|
<%}%>			
			<a href="#" title="" onclick="changePwd('${user.fdId}');">
				<bean:message bundle="kms-common" key="button.alterpwd"/>
			</a>|
			<a href="javascript:void(0)" class="quit" title="" onclick = "logout();">
				<bean:message bundle="kms-common" key="button.logout"/>
			</a>
			<kmss:authShow roles="ROLE_KMSHOME_VIEWMODULEINFO">
				|<a href="<c:url value="/kms/common.index" />" class="manage" title="" target="_blank"><bean:message bundle="kms-common" key="button.admin"/></a>
			</kmss:authShow>
			<select onChange="portalChange(this)" style="width:100px;">
$}
				for(i=0;i<data.portalList.length;i++){
	     			{$<option {%'${CurrentKmsPortalId}'==data.portalList[i].fdId?' SELECTED':''%} value="{%data.portalList[i].fdId%}" fdUrl="{%data.portalList[i].fdUrl%}">{%data.portalList[i].fdName%}</option>$}
				}
{$ 	
			</select>
		</div>
	</div></div>
 
	<div id="logo" $} if(data.bgImg){ {$ style="background-image:url('{%data.bgImg%}')" $} } {$><div class="box" id="rightImg"$} if(data.rightImg){ {$ style="background-image:url('{%data.rightImg%}')" $} } {$>
		<div class="logo_box c">
			<a href="$}if(data.fdLogoUrl){{$ {%data.fdLogoUrl%} $} }else{ {$ javascript:void(0) $} } {$" class="logo" $} if(data.fdLogoUrl){ {$ target="_blank" $} } {$ title="" style="FILTER:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);width:184px;height:46px;"><img src="$} if(data.logoImg){{$ {%data.logoImg%} $}}else{{$ ${kmsThemePath}/img/logo.gif $}} {$" id="logoImg" style="width:184px;height:46px;" ></a>
			<ul class="search_box" style="display: $} if(data.fdSearchDisplay==true||typeof(data.fdSearchDisplay)=='undefined'){{$ block $} } else { {$ none $} }{$">
				<li class="search"><input type="text" class="input_search" id="searchTextInput" value="请输入关键字" onfocus="if(value=='请输入关键字'){value=''}" onblur="if(value==''){value='请输入关键字'}">
					<a href="#" class="btn_search" title="搜索" id="btnSearch">搜索</a><a href="#" id="btnSearchAdvance" class="btn_gaoji" title="高级">高级</a>
					<input id="searchModel" style="display:none" value="{%data.searchMode%}"/>
				</li>
			</ul>
		</div>
	</div></div>

		<div class="mainnav">  
		    <ul class="box c silderNav">
$}
				for(i=0;i<data.navList.length;i++){
	     			{$<li class="{%data.fdId==data.navList[i].fdId?'on ':''%}{%i==data.navList.length-1?'none':''%}"><a href="{%data.navList[i].fdPath%}" target="{%data.navList[i].fdTarget%}">{%data.navList[i].fdName%}</a></li>$}
				}
{$
		    </ul>
			<div class="clear"></div> 
		</div>
		<div class="subnav">
$}
		 
{$
		</div>
$}
</script>

<script id="kms_footer" type="text/template">
{$
<div class="box">
	<p><span><bean:message bundle="kms-common" key="text.copyright"/></span><br /><bean:message bundle="kms-common" key="text.browser"/></p>
</div>
$}
</script>

<!-- 积分排行tab模板 -->
<script id="portlet_nav_tmpl" type="text/template">
	{$ 
	<div class="title_y">
		<ul id="tags" class="c"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a>$}
			if(i<tabs.length-1){
				{$|$}
			}
			{$</li> $} 
		}
	{$ </ul></div> $} 
</script>

<!-- 百科tab模板 -->
<script id="portlet_lightBlue_nav_wiki_tmpl" type="text/template">
	{$ 
	<div class="title_y">
		<a href="javascript:void(0)" class="more" title="" onclick = "wikiListPage()">更多</a>
		<ul id="tags" class="c"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a>$}
			if(i<tabs.length-1){
				{$|$}
			}
			{$</li> $} 
		}
	{$ </ul></div> $} 

</script>

<!-- 知识tab模板 -->
<script id="portlet_lightBlue_nav_doc_tmpl" type="text/template">
	{$ 
	<div class="title_y">
		<a href="javascript:void(0)" class="more" title="" onclick="docListPage('')">更多</a>
		<ul id="tags" class="c"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a>$}
			if(i<tabs.length-1){
				{$|$}
			}
			{$</li> $} 
		}
	{$ </ul></div> $} 
</script>

<!-- 爱问tab模板 -->
<script id="portlet_lightBlue_nav_ask_tmpl" type="text/template">
	{$ 
	<div class="title_y">
		<a href="javascript:void(0)" class="more" title="" onclick="askListPage('')">更多</a>
		<ul id="tags" class="c"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a>$}
			if(i<tabs.length-1){
				{$|$}
			}
			{$</li> $} 
		}
	{$ </ul></div> $} 
</script>

<!-- 爱问模板 -->
<script type="text/template" id="portlet_lightBlue_ask_tmpl">
{$ <ul class="l_d m_t10"> $}
	for(i=0;i<data.topicList.length;i++){
		{$<li>
			<span class="answer_num"><em>{% data.topicList[i].fdReplyCount %}</em>回答</span>
			<span class={% data.topicList[i].fdStatus <= 0 ? 'state2': 'state' %} ></span>
			<span class="score">{% data.topicList[i].fdScore %}</span>
			<a href="{% data.topicList[i].fdUrl %}" target="_blank" title="{% data.topicList[i].docSubject %}">{% resetStrLength(data.topicList[i].docSubject,54) %}</a>
		</li>$}
	}
{$ </ul> $}
</script>

<!-- 最新知识模板 -->
<script id="portlet_lightBlue_doc_tmpl" type="text/template">
{$
	<ul class="l_c m_t10" style="padding:5px 5px 0 5px">
$}
for(i=0;i<data.docList.length;i++){
	{$	
		<li>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[i].docCreator,10)%}</span>
			<a class="sort" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%resetStrLength(data.docList[i].docCategory,10)%}]</a>
			<a class="text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%resetStrLength(data.docList[i].docSubject,20)%}</a>
		</li>
	$}
}
{$
	</ul>
$}
</script>

<!-- 最新订阅知识模板 -->
<script id="portlet_index_follow_tmpl" type="text/template">
{$
	<ul class="l_c m_t10" style="padding:5px 5px 0 5px">
$}
	var itemList = data.itemList;
	for(i=0;i<itemList.length;i++){
{$	
		<li>
			<span class="date">{%itemList[i].fdCreateTime%}</span>
			<span class="author">{%itemList[i].status%}</span>
			<div><a class="a_classify" href="javascript:void(0)" onclick="javascript:void(0)"  title="">[{%resetStrLength(itemList[i].from,10)%}]</a>
			<a class="a_text" title="{%itemList[i].fdSubject%}" target="_blank" href="{%itemList[i].fdUrl%}">{%resetStrLength(itemList[i].fdSubject,20)%}</a></div>
		</li>
$}
	}
{$
	</ul>
$}
</script>

<!-- 精彩推荐~知识库 -->
<script type="text/template" id="portlet_lightBlue_doc_intro_index_tmpl">
{$ 
	<h2 class="h2_z">{% parameters.kms.title %}</h2>
	<ul class="l_z">
$}
	for(var i = 0;i < data.dataList.length;i++){
{$		
		<li>
			<a href="{%data.dataList[i].docCategoryUrl%}" class="a_z" title="{%data.dataList[i].docCategory%}" target="_blank">【{%resetStrLength(data.dataList[i].docCategory,8)%}】</a>
			<a href="{%data.dataList[i].fdUrl%}" title="{%data.dataList[i].docSubject%}" target="_blank">{%resetStrLength(data.dataList[i].docSubject,12)%}</a>
		</li>
$}
	}
{$
	</ul>
$}
</script>
<!--  推荐知识 -->
<script type="text/template" id="portlet_lightBlue_intro_index_tmpl">
{$ 
	<h2 class="h2_x">{% parameters.kms.title %}</h2>
	<div class="lunhuan">
		<div id="ifocus">
			<div id="ifocus_pic">
				<div id="ifocus_piclist" style="left:0; top:0;">
					<ul>
$}
					for(i=0;i<data.docIntroList.length;i++){
{$ 
						<li><a href="{%data.docIntroList[i].fdTopUrl%}" target="_blank"><img src="{%data.docIntroList[i].fdImgUrl%}" height="196" width="214" border="0" /></a></li>
$}
					}
{$
					</ul>
				</div>
			</div>
							
			<ul id="ifocus_btn" class="c">
$}
			for(i=0;i<data.docIntroList.length;i++){
{$				
				<li>{%i+1%}</li>
$}
			}
{$ 
			</ul>
		</div>
	</div>
$}

for(i=0;i<data.docIntroList.length;i++){
{$
<div class="news_box slide_content" style="display:none;height:228px;overflow:hidden; ">
	<dl class="dl_b">
		<dt>{%data.docIntroList[i].fdTopName%}</dt>
		<dd>{%resetStrLength(data.docIntroList[i].fdTopContent||'', 120)%}<a href="{%data.docIntroList[i].fdTopUrl%}" title="{%data.docIntroList[i].fdTopContent%}" target="_blank">[详情]</a></dd>
	</dl>

	<div class= box2"m_t10">
		<h2 class="h2_4">相关知识：</h2>
		<ul class="l_b">
$}
			var docIntro = data.docIntroList[i];
			for(j=0;j<docIntro.relatedDocList.length;j++){
				if(j<2){
{$
					<li><a href="{%docIntro.relatedDocList[j].fdUrl%}" target="_blank" title="{%docIntro.relatedDocList[j].fdName%}"> {%docIntro.relatedDocList[j].fdName%}</a></li>
$}
				}
			}
{$
		</ul>
	</div>
</div>
$}
}
</script>

<!-- 个人知识中心 -->
<script type="text/template" id="portlet_lightBlue_doc_per_center_tmpl">
{$
		<h2 class="h2_z">{% parameters.kms.title %}</h2>
		<ul class="l_y">
			<li>我的待审<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={% data.userId %}&selected=0" class="a_c" title="">({% data.manualCount %})</a></li>
			<li>我的待阅<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={% data.userId %}&selected=1" class="a_c" title="">({% data.onceCount %})</a></li>
			<li>我的收藏<a href="javascript:void(0)" class="a_c" title="" onclick="myKmDetails('km_path=/km/bookmark','{% data.userId %}')">({% data.bookCount %})</a></li>
			<li>我的知识<a href="javascript:void(0)" class="a_c" title="" onclick = "myKmDetails('km_path=/kms/multidoc','{% data.userId %}')">({% data.docCount %})</a></li>
		</ul>
		<ul class="l_x c">$}
			if(data.hasDoc){{$<li><a href="javascript:void(0)" class="btn_z" id="btn_share" title="新建知识文档">新建知识文档</a></li>$}}
			if(data.hasDoc){{$<li><a href="javascript:void(0)" class="btn_z" id="btn_wiki" title="新建维基知识">新建维基知识</a></li>$}}
			if(data.hasDoc){{$<li><a href="javascript:void(0)" class="btn_z" id="btn_ask" title="我要提问">我要提问</a></li>$}}
			if(data.hasDoc){{$<li><a href="javascript:void(0)" class="btn_z" id="btn_expert" title="申请专家">申请专家</a></li>$}}
		{$</ul>
$}
</script>

<!-- 热门标签 -->
<script type="text/template" id="portlet_lightBlue_hot_tags_tmpl">
{$
	<div class="title1"><h2>{% parameters.kms.title %}</h2><a href="${kmsBasePath}/common/kms_tag_main/kmsTagMain.do?method=searchTop" class="more" title="" target="_blank">更多</a></div>
	<div class="tag_box" style="word-wrap: break-word; word-break: normal;">
$}
	for(var i = 0;i<data.length;i++){
		{$<a href="{%data[i].fdUrl%}" target="_blank" title="{%data[i].fdName%}" class="{% data[i].font %}" >{%data[i].fdName%}</a>$}
	}
{$
	</div>

$}
</script>

<script type="text/template" id="portlet_lightBlue_nav_tmpl">
{$
	<div class="title8">
		<ul class="tab_ul c">
	 $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a $}if(i==1){{$class="a_already"$}}{$ href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')"><span><strong>{%tabs[i].kms.title%}</strong></span></a></li> $} 
		}
	{$ </ul> 
	</div> $} 
</script>

<!-- 知识地图概览 -->
<script type="text/template" id="portlet_lightBlue_kmap_pre_tmpl">
{$
	<h2 class="h2_y">{% parameters.kms.title %}</h2>

	<dl class="dl_a" >
		<dd id="category_Detail" style="border-bottom:0px">
$}
for(var i = 0; i<data.jsonArray.length;i++){
	{$
		{% data.jsonArray[i].content %}
	$}
}
{$
		</dd>
	</dl>
$}

</script>


<!-- 专家专栏 -->
<script type="text/template" id="portlet_lightBlue_intro_expert_tmpl">
if(data[0]){
{$	
	<div class="title1"><h2>{% parameters.kms.title %}</h2><a href="${kmsBasePath}/common/kms_common_main/kmsCommonMain.do?method=module&fdId=com.landray.kmss.kms.expert" class="more" title="" target="_blank">更多</a></div>
	<div class="expert_box m_t10 c">
		<a title="{%data[0].fdName%}" class="img_a" href="{%data[0].fdUrl%}"><img alt="" src="{%data[0].fdImg%}" onload="javascript:drawImage(this,this.parentNode)"></a>
		<ul>
			<li><a href="{% data[0].fdUrl %}" title="{%data[0].fdName%}">{%data[0].fdName%}</a></li>
			<li><a href="javascript:void(0)" title="{%data[0].expertType%}">擅长领域</a><em>{%resetStrLength(data[0].expertType||'',20)%}</em></li>
			<li><div style="float: left;" class="btn_d"><a title="向他提问" onclick="askToExpert('{%data[0].fdId%}')" href="javascript:void(0)"><span>向他提问</span></a></div></li>
		</ul>
	</div>
	<ul class="l_w m_t10 c" style="padding-bottom:32px">
$}
		if(data[1]){
{$
			<li>
				<a href="{%data[1].fdUrl%}" class="img_z" title="{%data[1].fdName%}"><img src="{%data[1].fdImg%}" alt="" onload="javascript:drawImage(this,this.parentNode)"/></a>
				<div class="img_z_r">{%data[1].fdName%}<br />$}if(data[1].expertType){{$ {%resetStrLength(data[1].expertType||'',10)%} $}}{$<br /><div style="float: left;" class="btn_d"><a title="向他提问" onclick="askToExpert('{%data[1].fdId%}')" href="javascript:void(0)"><span>向他提问</span></a></div></div>
			</li>
$}			
			if(data[2]){
{$
				<li>
					<a href="{%data[2].fdUrl%}" class="img_z" title="{%data[2].fdName%}"><img src="{%data[2].fdImg%}" alt="" onload="javascript:drawImage(this,this.parentNode)" /></a>
					<div class="img_z_r">{%data[2].fdName%}<br />$}if(data[2].expertType){{$ {%resetStrLength(data[2].expertType||'',10)%} $}}{$<br /><div style="float: left;" class="btn_d"><a title="向他提问" onclick="askToExpert('{%data[2].fdId%}')" href="javascript:void(0)"><span>向他提问</span></a></div></div>
				</li>
$}
			}
		}
{$
	</ul>
$}
}
	
</script>

<!-- 概览 -->
<script type="text/template" id="portlet_doc_pre_tmpl">
{$ 
	<div class="title1"><h2>{% parameters.kms.title %}</h2>
$}
	if(data.more){
{$
		<a href="javascript:docListPage('{% data.fdCategoryId %}');" class="more">更多&gt;&gt;</a>
$}
	}
{$
	</div>
	<div class="box2">
$}
	for(i=0;i<data.jsonArray.length;i++){
{$ 
		{% data.jsonArray[i].content %}
$}
	}
{$</div>$}
</script>


<!-- 推荐之星 -->
<script type="text/template" id="portlet_intro_star_tmpl">
for(i=0;i<data.introStar.length;i++){
{$ 
	<a href="{%data.introStar[i].fdUrl%}" class="img_a" title=""><img src="{%data.introStar[i].fdImgUrl%}" alt="" onload="javascript:drawImage(this,this.parentNode)"/></a>
	<ul>
		<li>本月知识之星：<strong>{%data.introStar[i].fdName%}</strong></li>
		<li>本月知识贡献量：<span>{%data.introStar[i].num%}篇</span></li>
		<li>总积分：<span>{%subStr(data.introStar[i].fdScore)%}分</span></li>
		<li><a title="" class="a_a" href="javascript:void(0)">{%data.introStar[i].grade%}</a><em>{%data.introStar[i].level%}</em></li>
	</ul>
$}
}
</script>

<!-- 个人排行榜 -->
<script type="text/template" id="portlet_per_integral_tmpl">
{$ 
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t20">
		<tr>
			<th>排行</th>
			<th>姓名</th>
			<th>积分</th>
			<th>上传数</th>
		</tr>
$}
		for(i=0;i<data.personalIntegrals.length;i++){
{$ 
			<tr>
$}
			if(i<3){
{$ 
				<td class="num pre">
$}
			}else{
{$ 
				<td class="num">
$}
			}
{$
				{%i+1%}</td>
				<td class="name">{%data.personalIntegrals[i].fdName%}</td>
				<td>
$}

			if(data.personalIntegrals[i].fdDynamic=="down"){
{$
				<span class="down"></span>
$}
			}else if(data.personalIntegrals[i].fdDynamic=="up"){
{$
				<span class="up"></span>
$}
			}
{$				
				{%subStr(data.personalIntegrals[i].score)%}</td>
				<td>{%data.personalIntegrals[i].num%}篇</td>
			</tr>
$}
		}
{$
	</table>
$}

</script>


<!-- 部门成员排行榜 
<script id="portlet_perdept_nav_tmpl" type="text/template">
	{$ 
	<div class="title_y">
		<ul id="tags" class="c"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a style="padding-left:8px;padding-right:8px;" href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a>$}
			if(i<tabs.length-1){
				{$|$}
			}
			{$</li> $} 
		}
	{$ </ul></div> $} 
</script>-->
<!-- 部门成员排行榜 
<script type="text/template" id="portlet_perdept_integral_tmpl">
{$ 
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="t_a m_t20">
		<tr>
			<th>排行</th>
			<th>姓名</th>
			<th>积分</th>
			<th>上传数</th>
		</tr>
$}
		for(i=0;i<data.personalIntegrals.length;i++){
{$ 
			<tr>
$}
			if(i<3){
{$ 
				<td class="num pre">
$}
			}else{
{$ 
				<td class="num">
$}
			}
{$
				{%i+1%}</td>
				<td class="name">{%data.personalIntegrals[i].fdName%}</td>
				<td>
$}

			if(data.personalIntegrals[i].fdDynamic=="down"){
{$
				<span class="down"></span>
$}
			}else if(data.personalIntegrals[i].fdDynamic=="up"){
{$
				<span class="up"></span>
$}
			}
{$				
				{%subStr(data.personalIntegrals[i].score)%}</td>
				<td>{%data.personalIntegrals[i].num%}篇</td>
			</tr>
$}
		}
{$
	</table>
$}
</script>

<script type="text/template" id="portlet_lightBlue_common_link_tmpl">
{$
	<div class="title_z"><h2>{% parameters.kms.title %}</h2></div>
		<ul class="l_o">
$}
for(var i = 0;i<data.dataList.length; i++){
var item = data.dataList[i];
{$
	<li><a href="{%item.fdUrl%}" title="{%item.docSubject %}">{%resetStrLength(item.docSubject,30) %}</a></li>
$}
}
{$
		</ul>
$}
</script>
-->
<!-- 公告区 -->
<script type="text/template" id="portlet_lightBlue_news_tmpl">
{$ 
	<div class="r2_t"></div>
	<div class="r2_m">
		<div class="title_x"><h2>{% parameters.kms.title %}</h2></div>
		<ul class="l_p c">
$}
for(var i = 0;i<data.jsonArray.length;i++){
var item = data.jsonArray[i];
{$
	<li><a href="{%KMS.contextPath.substring(0,KMS.contextPath.length-1)+item.href%}" title="{%item.text%}" target="_blank">{%resetStrLength(item.text,30)%}</a>
$}
		if(getWeekTime(item.publishTime)){
			{$<img src="${kmsThemePath}/img/new.gif" class="new" alt="" />$}
		}
{$
	</li>
$}
}
{$ 
		</ul>
	</div>
	<div class="r2_b"></div>	
$}
</script>

<script type="text/javascript">
/**
 * 推荐知识回调函数
 */
function sliderDocIntro() {
	var slideCache = [],
	curpos = 0, timer;
	$("#ifocus_btn li").each( function(c) {
		var slide = {};
		slide["cursor"] = $(this);
		this["pos"] = c;
		slideCache[c] = slide;
	});
	$("#ifocus_piclist li").each( function(c) {
		var slide = slideCache[c];
		slide["img"] = $(this);
	});
	$(".slide_content").each( function(c) {
		var slide = slideCache[c];
		slide["content"] = $(this);
	});

	var slen = slideCache.length, curSlide = null, oSlide = null;
	function autoSlide() {
		if (curpos == slen)
			curpos = 0;
		for ( var c = 0; c < slen; c++) {
			if (c == curpos) {
				curSlide = slideCache[c];
				curSlide.cursor.addClass("current");
				curSlide.img.fadeIn('slow')
				curSlide.content.show();
			} else {
				oSlide = slideCache[c];
				oSlide.cursor.removeClass("current");
				oSlide.img.fadeOut('slow');
				oSlide.content.hide();
			}
		}
		curpos++;
	}
	autoSlide();
	timer = setInterval(autoSlide, 5000);

	$("#ifocus_btn li").bind("click", function() {
		clearInterval(timer);
		timer = setInterval(autoSlide, 5000);
		curpos = this["pos"];
		autoSlide();
	});
}

/**
 * 专家切换
 */
function expertChange() {
	var index = '0';
	$('#kmsIntroExpertPortlet').children().each( function(i) {
		var arr = $(this).attr('id').split('-');
		var timeOut;
		$(this).mouseover( function() {
			timeOut = setTimeout( function() {
				$('#div-' + arr[1]).show();
				$('#dl-' + arr[1]).hide();
				if (arr[1] != index) {
					$('#div-' + index).hide();
					$('#dl-' + index).show();
				}
				index = arr[1];
			}, 500);
		});
		$(this).mouseout( function() {
			clearTimeout(timeOut);
		});
	});
}

function portalChange(obj){
	window.open(obj.options[obj.selectedIndex].getAttribute("fdUrl"),'_self');
}

function askToExpert(fdId) {
	window
			.open('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdPosterTypeListId=' + fdId);
}

$(function(){

	$('.toufu').hover(function(){
		$(this).addClass('divOver');	
	},function(){
		$(this).removeClass('divOver');
	})
})

function bindShareButton(){
	var docOptions = {
		s_modelName:'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
		open : '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=',
		width : '440px',
		extendFilter:"fdExternalId is null"
	};

	var expertOptions = {
		s_modelName:'com.landray.kmss.kms.expert.model.KmsExpertType',	
		s_bean : 'kmsHomeExpertService',
		s_method : 'getCategoryList',
		open : '<c:url value="/kms/expert/kms_expert_info/kmsExpertInfo.do" />?method=add&fdCategoryId=',
		width : '440px'
	};

	var wikiOptions = {
		s_modelName:"com.landray.kmss.kms.wiki.model.KmsWikiCategory",
		s_bean : 'kmsHomeWikiService',
		s_method : 'getCategoryList',
		open : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=add&fdCategoryId=',
		width : '320px',
		delUrl : '<c:url value ="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=deleteallList'
	};

	var askOptions = {
		s_modelName:'com.landray.kmss.kms.ask.model.KmsAskCategory',
		s_bean : 'kmsHomeAskService',
		s_method : 'getCategoryList',
		open : '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdCategoryId=',
		width : '440px'
	};

	var createDoc = new KMS.opera(docOptions, $('#btn_share'));
	createDoc.bind_add();
	var createWiki = new KMS.opera(wikiOptions, $('#btn_wiki'));
	createWiki.bind_add();
	var createAsk = new KMS.opera(askOptions, $('#btn_ask'));
	createAsk.bind_add();
	var createExpert = new KMS.opera(expertOptions, $('#btn_expert'));
	createExpert.bind_add();
}

function myKmDetails(kmPath , personId) {
	if (arguments.length > 1) {
		var fdCategoryId = "fdCategoryId=" + arguments[1];
	}
	var baseUrl = '<c:url value="/kms/common/kms_person_info/kmsPersonInfo.do?method=myKmDetails" />';
	var docScrollTop = "docScrollTop="
			+ (document.documentElement || document.body).scrollTop;
	var url = [ baseUrl, kmPath, "fdPersonId="+personId,
			docScrollTop, "expert=${param.expert}",
			'fdExpertId=${param.fdExpertId}', fdCategoryId ].join("&");
	location.href = url;
	return false;
}

function getWeekTime(time){
	var publishTime = new Date(time);
	var now = new Date();
	return now.getTime() - publishTime.getTime() > 1000*60*60*24*7 ? false : true;
}

function switchArea() {
	Dialog_Area_Tree(false,null,null,null,'sysAuthAreaSwitchService&id=!{value}', '<bean:message key="dialog.locale.winTitle" />', null, afterAreaSelect, null, null,true);
}

//选择场所后的回调函数
function afterAreaSelect(rtnData){ 
	if(rtnData && rtnData.data && rtnData.data[0]) {
		if(rtnData.data[0].flag == 'defArea') {
			rtnData.SendToBean('sysAuthDefaultAreaService&selectId='+rtnData.data[0].id, function () {});
		} else {
			rtnData.SendToBean('sysAuthAreaSwitchService&selectId='+rtnData.data[0].id, function () {
				location.reload();
			});
		};
	}
}

function Dialog_Area_Tree(mulSelect, idField, nameField, splitStr, treeBean, treeTitle, treeAutoSelChildren, action, exceptValue, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, false);
	var node = dialog.CreateTree(treeTitle);
	dialog.winTitle = winTitle==null?treeTitle:winTitle;
	dialog.URL = Com_Parameter.ResPath + "html/dialog_area.html";
	node.AppendBeanData(treeBean, null, null, null, exceptValue);
	dialog.tree.isAutoSelectChildren = treeAutoSelChildren;
	dialog.BindingField(idField, nameField, splitStr, isMulField);
	dialog.SetAfterShow(action);
	if(notNull!=null)
		dialog.notNull = notNull;
	dialog.Show();
}

/**
 * [randomColor 更新元素为随机颜色]
 */
function randomColor() {
	var chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
	$('.tag_box a').each(function() {
		var c = (function(n) {
			var res = "";
			for(var i = 0; i < n; i++) {
				var id = Math.floor(Math.random() * 16);
				res += chars[id];
			}
			return res;
		})(6);
		$(this).css('color', '#' + c);

	})
}
</script>

