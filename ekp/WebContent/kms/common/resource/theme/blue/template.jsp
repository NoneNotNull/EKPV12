<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>

<script>
Com_IncludeFile("dialog.js");
</script>
<script type="text/html" id="topBanner_info_tmpl">
欢迎您，<span><a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={{userId}}">{{userName}}</a></span>！ 
<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
<c:if test="${not empty currentUser.authAreaName}"><bean:message key="home.locale" arg0="${currentUser.authAreaName}"/></c:if>
<%}%>
待审<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={{userId}}&selected=0">({{manualCount}})</a> 
待阅<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={{userId}}&selected=1">({{onceCount}})</a> 
积分<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={{userId}}">（{{totalScore}}）</a><span class="a_a">{{totalGrade}}</span>
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
<script id="portlet_nav_tmpl" type="text/template">
	{$
	<div class="title8">
		<ul class="tab_ul c">
	 $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')"><span><strong style="background-image:none;padding-left:5px">{%tabs[i].kms.title%}</strong></span></a></li> $} 
		}
	{$ </ul> 
	</div> $} 
</script>
<script id="portlet_nav_tmpl_ask" type="text/template">
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
<script id="portlet_item_tmpl" type="text/template">
				for(i=0;i<data.rows.length;i++){
					{$ 
						<div>ss</div>
					$}
				}
</script>

<script id="kms_header" type="text/template">
{$ 
	<div class="toplinks"><div class="box">
		<p id="userInfoTips">加载中......</p>
		<div class="personal_edit">
<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
			<a class="travel" style="background-image:none;" href="javascript:parent.switchArea();" target="_self" name="travel">
				<bean:message key="home.travel" />
			</a>|
<%}%>
			<a onclick="changePwd('${user.fdId}');" href="javascript:void(0);">
				<bean:message bundle="kms-common" key="button.alterpwd"/>
			</a>|
			<a href="#" class="quit" onclick="logout();" title=""><bean:message bundle="kms-common" key="button.logout"/></a>
			<kmss:authShow roles="ROLE_KMSHOME_VIEWMODULEINFO">
				|<a href="<c:url value="/kms/common.index" />" target="_blank" class="manage" title="">
					<bean:message bundle="kms-common" key="button.admin"/>
				</a>
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
	<div id="logo" $} if(data.bgImg){ {$ style="background-image:url('{%data.bgImg%}')" $} } {$><div class="box"  >
		<div class="logo_box c" id="rightImg" $} if(data.rightImg){ {$ style="background-image:url('{%data.rightImg%}')" $} } {$>
			<a href="$}if(data.fdLogoUrl){{$ {%data.fdLogoUrl%} $} }else{ {$ javascript:void(0) $} } {$" class="logo" $} if(data.fdLogoUrl){ {$ target="_blank" $} } {$ title="" style="FILTER:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);width:184px;height:46px;"><img src="$} if(data.logoImg){{$ {%data.logoImg%} $}}else{{$ ${kmsThemePath}/img/logo.gif $}} {$" id="logoImg" style="width:184px;height:46px;" ></a>
			<ul class="search_box" style="display: $} if(data.fdSearchDisplay ||typeof(data.fdSearchDisplay)=='undefined'){{$ block $} } else { {$ none $} }{$">
				<li class="search"><input type="text" class="input_search" id="searchTextInput" value="请输入关键字" onfocus="if(value=='请输入关键字'){value=''}" onblur="if(value==''){value='请输入关键字'}"><a href="#" id="btnSearch" class="btn_search3" title="搜索"><span><em>搜索</em></span></a>	
					<input id="searchModel" style="display:none" value="{%data.searchMode%}"/>
				</li>
			</ul>
		</div>
		<div class="mainnav"><div class="inner">  
		    <ul class="c">
$}
				for(i=0;i<data.navList.length;i++){
	     			{$<li class="{%data.fdId==data.navList[i].fdId?'on ':''%}{%i==data.navList.length-1?'none':''%}"><a href="{%data.navList[i].fdPath%}" target="{%data.navList[i].fdTarget%}">{%data.navList[i].fdName%}</a><div class="li_l"></div><div class="li_r"></div></li>$}
				}
{$
		    </ul>
			<div class="clear"></div> 
		</div></div>
		<div class="subnav">
$}
		 
{$
		</div>
	</div></div> 
$}
</script>
<script id="kms_footer" type="text/template">
{$
<div class="box">
	<p><span><bean:message bundle="kms-common" key="text.copyright"/></span><br /><bean:message bundle="kms-common" key="text.browser"/></p>
</div>
$}
</script>

<!-- 爱问模板 -->
<script type="text/template" id="portlet_ask_tmpl">
{$ <ul class="l_d"> $}
	for(i=0;i<data.topicList.length;i++){
		{$<li>
			<span class={% data.topicList[i].fdStatus <= 0 ? 'state2': 'state' %} ></span>
			<span class="answer_num">{% data.topicList[i].fdReplyCount %}回答 </span>
			<span class="score">{% data.topicList[i].fdScore %}</span>
			<a href="{% data.topicList[i].fdUrl %}" target="_blank" title="{% data.topicList[i].docSubject %}">{% resetStrLength(data.topicList[i].docSubject,54) %}</a>
		</li>$}
	}
{$ </ul> $}
</script>

<!-- 常用链接模板 -->
<script type="text/template" id="portlet_link_tmpl">
{$<div class="title1"><h2>{% parameters.kms.title %}</h2></div>  
<div class="box2">
<ul class="l_a"> $}
	for(i=0;i<data.dataList.length;i++){
		{$<li>
			<a href="{%data.dataList[i].fdUrl%}" target="_blank" title="{%data.dataList[i].docSubject%}">{%data.dataList[i].docSubject%}</a>
		</li>$}
	}
{$ </ul> 
</div> $}
</script>

<!--  推荐知识 -->
<script type="text/template" id="portlet_intro_index_tmpl">
{$ 
	<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2 c">
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
		<dt><span>{%data.docIntroList[i].fdTopName%}</span></dt>
		<dd>{%resetStrLength(data.docIntroList[i].fdTopContent||'', 120)%}<a href="{%data.docIntroList[i].fdTopUrl%}" title="{%data.docIntroList[i].fdTopContent%}" target="_blank">[详情]</a></dd>
	</dl>

	<div class="m_t10">
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
{$
</div>
$}
</script>

<!-- 专家专栏 -->
<script type="text/template" id="portlet_intro_expert_tmpl">
{$
<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
<div id="kmsIntroExpertPortlet" class="box2">
$}
for(i=0;i<data.kmsExpertList.length;i++){
{$
<div class="expert_box c" id = "div-{%i%}" 
$}
	if(i>0){{$style="display:none"$}}
{$   >
	<a href="{%data.kmsExpertList[i].fdUrl%}" class="img_a" title=""><img src="{%data.kmsExpertList[i].fdImg%}" alt="" onload="javascript:drawImage(this,this.parentNode)"/></a>
	<dl>
		<dt><em style="color:#00f;">{%data.kmsExpertList[i].fdName%}</em>$}
		if(data.kmsExpertList[i].hasAsk){
			{$<div class="btn_d" style="float:right;" ><a href="javascript:void(0)" title="向他提问" onclick="askToExpert('{%data.kmsExpertList[i].fdId%}')"><span>向他提问</span></a></div>$}
		}
{$		</dt>
		<dd><a href="{%data.kmsExpertList[i].docUrl%}" title="{%data.kmsExpertList[i].docSubject%}" target = "_blank">{%resetStrLength(data.kmsExpertList[i].docSubject||'',45)%}</a></dd>
	</dl>
</div>

<dl class="dl_c" style="height:42px;
$}
	if(i==0){{$display:none$}}{$" id = "dl-{% i %}">
	<dt><a href="{%data.kmsExpertList[i].fdUrl%}" title="{%data.kmsExpertList[i].fdName%}" style="color:#00f;" >{%data.kmsExpertList[i].fdName%}</a></dt>
	<dd><a href="{%data.kmsExpertList[i].docUrl%}" title="{%data.kmsExpertList[i].docSubject%}" target = "_blank">{%resetStrLength(data.kmsExpertList[i].docSubject||'',30)%}</a></dd>
</dl>
$}
}
{$
</div>
$}
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

<!--  知识数显示 -->
<script type="text/template" id="portlet_home_count_tmpl">
{$
	<p>经全体人员努力，已收录知识<span>{%data.totalCount%}</span>份；今日共更新<span>{%data.updateTodayCount%}</span>份；共<span>{%data.introTotalCount%}</span>份被推荐</p>
$}
	if(data.hasMultidoc){
{$
		<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
			<ul class="ul2">
				<li><a href="javascript:void(0)" class="btn_share" title="我要分享文档"></a></li>
			</ul>
		</kmss:auth>
$}
	}
</script><!--  知识数显示 -->
<script type="text/template" id="portlet_home_count_tmpl">
{$
	<p>经全体人员努力，已收录知识<span>{%data.totalCount%}</span>份；今日共更新<span>{%data.updateTodayCount%}</span>份；共<span>{%data.introTotalCount%}</span>份被推荐</p>
$}
	if(data.hasMultidoc){
{$
		<kmss:auth requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add" requestMethod="GET">
			<ul class="ul2">
				<li><a href="javascript:void(0)" class="btn_share" title="我要分享文档"></a></li>
			</ul>
		</kmss:auth>
$}
	}
</script>


<!-- 最新知识模板 -->
<script id="portlet_doc_tmpl" type="text/template">
{$
	<div class="title1 c"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2">
		<ul class="l_c">
$}

for(i=0;i<data.docList.length;i++){
	{$	
		<li>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[i].docCreator,10)%}</span>
			<div><a class="a_classify" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%resetStrLength(data.docList[i].docCategory,10)%}]</a>
			<a class="a_text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%resetStrLength(data.docList[i].docSubject,20)%}</a></div>
		</li>
	$}
}
{$
		</ul>
	</div>
$}
</script>

<!-- 最新主页知识模板 -->
<script id="portlet_index_doc_tmpl" type="text/template">
{$
		<ul class="l_c1">
$}

	for(i=0;i<data.docList.length;i++){
{$	
		<li>
			<span class="date">{%data.docList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.docList[i].docCreator,10)%}</span>
			<div><a class="a_classify" href="{%data.docList[i].docCategoryUrl%}" target = "_blank" title="{%data.docList[i].docCategory%}">[{%resetStrLength(data.docList[i].docCategory,10)%}]</a>
			<a class="a_text" title="{%data.docList[i].docSubject%}" target="_blank" href="{%data.docList[i].fdUrl%}">{%resetStrLength(data.docList[i].docSubject,20)%}</a></div>
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
	<div>
		<ul class="l_c1">
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
	</div>
$}
</script>

<script id="portlet_kmap_tmpl" type="text/template">
{$
	<div class="title1 c"><h2>{% parameters.kms.title %}</h2></div>
	<div class="box2">
		<ul class="l_c">
$}

for(i=0;i<data.jsonArray.length;i++){
var topic = data.jsonArray[i];
	{$	
		<li>
			<span class="date">{%topic.docCreateTime%}</span>
			<span class="author">{%topic.docCreator%}</span>
			<div><a class="a_classify" href="{%topic.docCategoryUrl%}" target = "_blank" title="{%topic.docCategory%}">[{%resetStrLength(topic.docCategory,10)%}]</a>
			<a class="a_text" title="{%topic.docSubject%}" target="_blank" href="{%topic.fdUrl%}">{%resetStrLength(topic.docSubject,20)%}</a></div>
		</li>
	$}
}
{$
		</ul>
	</div>
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
				curSlide.img.show();
				curSlide.content.show();
			} else {
				oSlide = slideCache[c];
				oSlide.cursor.removeClass("current");
				oSlide.img.hide();
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

function bindShareButton(){
	var docOptions = {
			s_modelName:'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
			open : '<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=',
			width : '440px',
			extendFilter:"fdExternalId is null"
		};

	var createDoc = new KMS.opera(docOptions, $('.btn_share'));
	createDoc.bind_add();
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

</script>
