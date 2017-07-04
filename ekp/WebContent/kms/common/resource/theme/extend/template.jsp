<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp"%>
<script src="${kmsThemePath }/js/bootstrap.min.js"></script>
<script>
Com_IncludeFile("dialog.js");
</script>
<script id="portlet_tmpl" type="text/template">
				{$ 
				<div class="box1 m_t10">
							<div class="title1"><h2>{%parameters.kms.title%}</h2></div>
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
	{$ <ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> $} 
</script>

<script id="portlet_nav_home_tmpl" type="text/template">
	{$ <ul id="tabs" class="c tab_ul nav nav-tabs"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> $} 
</script>

<script id="portlet_nav_tmpl_ask" type="text/template">
	{$ <ul id="tags" class="c tab_ul"> $} 
		for(i=0;i<tabs.length;i++){
			{$ <li><a href="javascript:KMS_TAB_PORTLET_CHANGE('{%parameters.kms.id%}','{%tabs[i].kms.id%}')">{%tabs[i].kms.title%}</a></li> $} 
		}
	{$ </ul> $} 
</script>
<script id="portlet_item_tmpl" type="text/template">
				for(i=0;i<data.rows.length;i++){
					{$ 
						<div>ss</div>
					$}
				}
</script>

<script id="kms_banner" type="text/template">
{$
     	<a class="brand logo" href="javascript:void(0);"></a>
        <ul class="nav pull-right">
$}
			for(i=1;i<data.navList.length;i++){
				{$<li><a href="{%data.navList[i].fdPath%}"><i class="item">{%data.navList[i].fdName%}</i></a></li>$}
			}
{$
        </ul>
$}
</script>


<!-- 知识tab模板 -->
<script id="portlet_lightBlue_nav_doc_tmpl" type="text/template">
for(i=0;i<data.docList.length;i++){
{$	
						<div class="media">
							<a href="{%data.docList[i].fdUrl%}" target="_blank" class="pull-left">
                        		<img class="media-object" src="{%data.docList[i].fdImgUrl%}" width="106" height="150">
                        	</a>
                            <div class="media-body">
                            	<h4 class="media-heading">
                            		<a title="{%data.docList[i].docSubject%}" href="{%data.docList[i].fdUrl%}" target="_blank">
                            			<span class="newstitle">{%data.docList[i].docSubject%}</span>
                            		</a>
                            	</h4>
                                <p class="media-target">
                                	作者：<span class="author"><a href="">{%resetStrLength(data.docList[i].docCreator,10)%}</a></span> &nbsp; &nbsp;&nbsp;   
                                	<span class="time">{%data.docList[i].docCreateTime%}</span>
                                </p>
                                <p>{%resetStrLength(data.docList[i].fdDescription||'',310)%}</p>
                            </div>
						</div>
$}
}
</script>

<!-- 爱问tab模板 -->
<script id="portlet_lightBlue_nav_ask_tmpl" type="text/template">
	{$ <div class="media" style="padding-left:0"><ul class="l_d m_t10"> $}
	for(i=0;i<data.topicList.length;i++){
		{$<li>
			<span class="answer_num"><em>{% data.topicList[i].fdReplyCount %}</em>回答</span>
			<span class={% data.topicList[i].fdStatus <= 0 ? 'state2': 'state' %} ></span>
			<span class="score">{% data.topicList[i].fdScore %}</span>
			<a href="{% data.topicList[i].fdUrl %}" target="_blank" title="{% data.topicList[i].docSubject %}">{% resetStrLength(data.topicList[i].docSubject,54) %}</a>
		</li>$}
	}
{$ </ul></div> $}
</script>

<script id="portlet_intro_expert_tmpl" type="text/template">
for(i=0;i<data.length;i++){
{$
<a href="{%data[i].fdUrl%}" target="_blank" title="{%data[i].fdName%}"><img src="{%data[i].fdImg%}" width="49" height="49" /></a>
$}
}
</script>

<script id="kms_header" type="text/template">
{$ 
<div class="topHeader bgc01">
     <div class="wrap980 pr">
               <ul class="top_nav">
					<li id="banner_logo" onclick="window.open('{%data.navList[0].fdPath%}','_self')"></li>
				   <li><a href="{%data.navList[0].fdPath%}">{%data.navList[0].fdName%}</a></li>
                   <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">导航<b class="caret"></b></a>
	                   <ul class="dropdown-menu">
$}
						for(i=1;i<data.navList.length;i++){
							{$<li><a href="{%data.navList[i].fdPath%}">{%data.navList[i].fdName%}</a></li>$}
						}
{$ 
	                   </ul>
                   </li>
                   <li class="dropdown"><a class="dropdown-toggle" data-toggle="dropdown" href="#">切换门户<b class="caret"></b></a>
	                   <ul class="dropdown-menu">
$}
					for(i=0;i<data.portalList.length;i++){
	     				{$<li fdUrl="{%data.portalList[i].fdUrl%}"><a href="{%data.portalList[i].fdUrl%}" target="_self">{%data.portalList[i].fdName%}</a></li>$}
					}
{$
	                   </ul>
                   </li>

               </ul>
        <div class="col_right">
          <div class="KMS_quitsearch">
					<div class="KMS_txtQuitSearchC">
                    	<input type="text" class="KMS_txtQuitSearch" id="KMS_txtQuitSearch"/>
						<input id="searchModel" style="display:none" value="{%data.searchMode%}"/>
                    </div>
                    <input type="button" class="KMS_btnQuitSearch" id="KMS_btnQuitSearch"/>
               </div>

          <div class="message">
               <span class="span_01"><b><a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId=${currentUser.person.fdId}">${currentUser.person.fdName}</a></b>，欢迎回来！</span>
               <span class="span_02">
               <a href="<c:url value="/kms/common.index"/>" title="后台管理" class="ic ic-th" target="_blank"></a>
				<span class="span_01"><b><a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId=${currentUser.person.fdId}">个人中心</a></b></span>
				<a class="ic ic-off" title="退出" href="javascript:logout();"></a></span>
          </div>
           <div id="notify_box" class="no"></div>
       	 </div>
     </div>
</div>
<div style="width:1002px;margin:0 auto;padding-top:33px;height:auto">
<div class="navbar ixdf_nav clearfix">
     	<a class="brand logo"  href="javascript:window.open('{%data.navList[0].fdPath%}','_self')">
			<img src="$} if(data.logoImg){{$ {%data.logoImg%} $}}else{{$ ${kmsThemePath}/img/logo.gif $}} {$" id="logoImg" style="width:170px;height:70px;" >
		</a>
        <ul class="nav pull-right">
$}
			for(i=1;i<data.navList.length;i++){
				{$<li><a href="{%data.navList[i].fdPath%}"><i class="item">{%data.navList[i].fdName%}</i></a></li>$}
			}
{$
        </ul>
</div>
</div>
<div class="clear"></div>

$}
</script>
<script id="kms_footer" type="text/template">
{$
<div class="box">
	<p><span><bean:message bundle="kms-common" key="text.copyright"/></span><br /><bean:message bundle="kms-common" key="text.browser"/></p>
</div>
$}
</script>

<!-- 最新知识模板 -->
<script id="portlet_doc_tmpl" type="text/template">
{$
	<div class="title1"><h2>{% parameters.kms.title %}</h2></div>
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

<!-- 个人知识中心 -->
<script type="text/template" id="portlet_lightBlue_doc_per_center_tmpl">
{$
	<div class="title1" style="margin-top:-10px;"><h2 style="text-align:center;cursor:pointer"  onclick="window.open('${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId=${currentUser.person.fdId}','_self')">个人知识中心</h2></div>
	<div class="KMS_pkCenter_List">
		<ul>
			<li><a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={% data.userId %}&selected=0" class="a_c" title="">我的待审<span class="KMS_counts">({% data.manualCount %})</span></a></li>
			<li><a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=index&fdId={% data.userId %}&selected=1" class="a_c" title="">我的待阅<span class="KMS_counts">({% data.onceCount %})</span></a></li>
			<li><a href="javascript:void(0)" class="a_c" title="" onclick="myKmDetails('km_path=/km/bookmark','{% data.userId %}')">我的收藏<span class="KMS_counts">({% data.bookCount %})</span></a></li>
			<li><a href="javascript:void(0)" class="a_c" title="" onclick = "myKmDetails('km_path=/kms/multidoc','{% data.userId %}')">我的知识<span class="KMS_counts">({% data.docCount %})</span></a></li>
		</ul>
	</div>
	<div class="KMS_pkCenter_Btn">
		<ul class="l_x c">$}
			if(data.hasDoc){{$<li class="KMS_pkCenter_btn1" ><a href="javascript:void(0)" id="btn_share" title="新建知识文档">新建知识文档</a></li>$}}
			if(data.hasDoc){{$<li class="KMS_pkCenter_btn2" ><a href="javascript:void(0)" id="btn_wiki" title="新建维基知识">新建维基知识</a></li>$}}
			if(data.hasDoc){{$<li class="KMS_pkCenter_btn3" ><a href="javascript:void(0)" id="btn_ask" title="我要提问">我要提问</a></li>$}}
			if(data.hasDoc){{$<li class="KMS_pkCenter_btn4" ><a href="javascript:void(0)" id="btn_expert" title="申请专家">申请专家</a></li>$}}
		{$</ul>
</div>
$}
</script>

<!-- 最新知识模板 -->
<script id="portlet_wiki_tmpl" type="text/template">
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

<!-- rss模板 -->
<script id="portlet_rss_tmpl" type="text/template">
{$
	<ul class="l_c m_t10" style="padding:5px 5px 0 5px">
$}
for(i=0;i<data.dataList.length;i++){
	{$	
		<li>
			<span class="date">{%data.dataList[i].docCreateTime%}</span>
			<span class="author">{%resetStrLength(data.dataList[i].docCreator,10)%}</span>
			<a class="sort" href="javascript:void(0)" target = "_blank" title="{%data.dataList[i].docCategoryName%}">[{%resetStrLength(data.dataList[i].docCategoryName,10)%}]</a>
			<a class="text" title="{%data.dataList[i].docSubject%}" target="_blank" href="{%data.dataList[i].fdUrl%}">{%resetStrLength(data.dataList[i].docSubject,20)%}</a>
		</li>
	$}
}
{$
	</ul>
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

<!-- 知识地图 -->
<script type="text/template" id="portlet_kmap_tmpl">
{$ <ul class="l_c" style="margin:10px 10px 10px 10px;"> $}
for(i=0;i<data.jsonArray.length;i++){
	var topic = data.jsonArray[i];
	{$<li>
		<span class="date">{% topic.docCreateTime %}</span>
		<span class="author">{% topic.docCreator %}</span>
		<span ><a class="a_classify" href = "{% topic.docCategoryUrl %}" target = "_blank" title = "{% topic.docCategory %}">[{% resetStrLength(topic.docCategory,12) %}]</a></span>
		<a class="a_text" title="{% topic.docSubject %}" target="_blank" href="{% topic.fdUrl %}">{% resetStrLength(topic.docSubject,28) %}</a>
	</li>$}
}
{$ </ul> $}
</script>

<!-- 常用链接模板 -->
<script type="text/template" id="portlet_link_tmpl">
{$ <div class="title1 c"><h2 class="h2_2">{% parameters.kms.title %}</h2></div>  
<ul class="l_a"> $}
	for(i=0;i<data.dataList.length;i++){
		{$<li>
			<a href="{%data.dataList[i].fdUrl%}" target="_blank" title="{%data.dataList[i].docSubject%}">{%data.dataList[i].docSubject%}</a>
		</li>$}
	}
{$ </ul> $}
</script>

<!--  推荐知识 -->
<script type="text/template" id="portlet_intro_index_tmpl">
{$ 
	<div class="title1 c"><h2 class="h2_3">{% parameters.kms.title %}</h2></div>
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

	<div class="box2 m_t10">
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

<!-- 专家专栏 -->
<script type="text/template" id="portlet_intro_expert_tmpl">
{$
<div class="title1 c"><h2 class="h2_2">{% parameters.kms.title %}</h2></div>
<div id="kmsIntroExpertPortlet">
$}
for(i=0;i<data.kmsExpertList.length;i++){
{$
<div class="expert_box c" id = "div-{%i%}" 
$}
	if(i>0){{$style="display:none"$}}
{$   >
	<a href="{%data.kmsExpertList[i].fdUrl%}" class="img_a" title=""><img src="{%data.kmsExpertList[i].fdImg%}" onload="javascript:drawImage(this,this.parentNode)"/></a>
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
	<div class="title1"><h2>{% parameters.kms.title %}
$}
	if(data.more){
{$
		<a href="javascript:docListPage('{% data.fdCategoryId %}');" class="more">更多&gt;&gt;</a>
$}
	}
{$
	</h2>
	</div>
	<div class="box2">
$}
	for(i=0;i<data.jsonArray.length;i++){
{$ 
		{% data.jsonArray[i].content %}
	</div>
$}
	}
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
</script>



<script type="text/template" id="portlet_intro_slide_tmpl">
{$
<div class="carousel-inner">
$}
for(var i=0;i<data.docIntroList.length;i++){
	if(i==0){
{$ 
		<div class="item active">
			<a title="{%data.docIntroList[i].fdTopName%}" href="{%data.docIntroList[i].fdTopUrl%}" target="_blank">
				<img src="{%data.docIntroList[i].fdImgUrl%}" style="height:313px;width:682px">
    		</a>
    		<div class="carousel-caption" style="height:35px">
     	   		<p>{%resetStrLength(data.docIntroList[i].fdTopContent||'', 100)%}</p>
      	  	</div>
		</div>
$}
	}
	if(i!=0){
{$
		<div class="item">
			<a title="{%data.docIntroList[i].fdTopName%}" href="{%data.docIntroList[i].fdTopUrl%}" target="_blank">
				<img src="{%data.docIntroList[i].fdImgUrl%}"  style="height:313px;width:682px">
    		</a>
    		<div class="carousel-caption" style="height:35px">
        		<p>{%resetStrLength(data.docIntroList[i].fdTopContent||'', 100)%}</p>
			</div>
		</div>
$}
	}
}
{$
</div>
<a href="#portlet_mySlider" class="carousel-control left" data-slide="prev">&lsaquo;</a>
<a href="#portlet_mySlider" class="carousel-control right" data-slide="next">&rsaquo;</a>
<div class="carousel-nav">
$}
for(var j=0;j<data.docIntroList.length;j++){
	if(j==0){
{$
		<a href="#" class="cur"></a>
$}
	}else{
{$
		<a href="#" ></a>
$}
	}
}
{$
</div>
$}
</script>

<!-- 知识地图概览 -->
<script type="text/template" id="portlet_lightBlue_kmap_pre_tmpl">
{$
	<h2 class="h2_y">{% parameters.kms.title %}</h2>

	<dl class="dl_a" style="margin-bottom:5px">
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

<script id="portlet_per_info_tmpl" type="text/template">
{$
		<a href="${kmsBasePath}/common/kms_person_info/kmsPersonInfo.do?method=myKmInfo&fdPersonId={%data.fdPersonId%}" class="pull-left"><img src="{%data.fdImgUrl%}" width="65" height="65" /></a>
		<div class="media-body">
			<ul class="media-list">
				<li>岗位：{%data.fdPersonPost%} </li>
                <li>等级：{%data.fdTotalGrade%} </li>
                <li>头衔：{%data.fdLevel%}</li>
			</ul>
		</div>
$}
</script>

<!-- 知识tab模板 -->
<script id="portlet_nav_wiki_tmpl" type="text/template">
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


<script id="portlet_multimedia_category_slide_tmpl" type="text/template">
{$
<div id="KMS_shortcut_item1">
	<div class="hotPic">
		<div class="JQ-slide">
			<div class="JQ-slide-nav">
				<a class="next" href="javascript:void(0);">></a>
			</div>
			<div class="wrap">
				<ul class="JQ-slide-content imgList">
$}
var j=1;
for(i=0;i<data.docList.length;i++){
{$
					<li>
						<a href="{%data.docList[i].fdUrl%}"  class="img" target="_blank">
						<img src="${kmsThemePath}/img/imgFile_0{%j%}.jpg" width="80" height="56" alt="{%data.docList[i].fdName%}" /></a> 
						<a href="{%data.docList[i].fdUrl%}"
 							target="_blank" class="txt">{%data.docList[i].fdName%}</a>
					</li>
$}
j++;
if(j==6){
	j=1;
}
}
{$
				</ul>
			</div>
	</div>
</div>
$}
</script>

<script id="portlet_doc_category_slide_tmpl" type="text/template">
{$
<div id="KMS_shortcut_item1">
	<div class="hotPic">
		<div class="JQ-slide">
			<div class="JQ-slide-nav">
				<a class="next" href="javascript:void(0);">></a>
			</div>
			<div class="wrap">
				<ul class="JQ-slide-content imgList">
$}
var j = 1;
for(i=0;i<data.docList.length;i++){
{$
					<li>
						<a href="{%data.docList[i].fdUrl%}"  class="img" target="_blank">
						<img src="${kmsThemePath}/img/doc{%j%}.png" width="80" height="56" alt="{%data.docList[i].fdName%}" /></a> 
						<a href="{%data.docList[i].fdUrl%}"
 							target="_blank" class="txt">{%data.docList[i].fdName%}</a>
					</li>
$}
j++;
if(j==6){
	j=1;
}
}
{$
				</ul>
			</div>
	</div>
</div>
$}
</script>

<script id="portlet_wiki_category_slide_tmpl" type="text/template">
{$
<div id="KMS_shortcut_item1">
	<div class="hotPic">
		<div class="JQ-slide">
			<div class="JQ-slide-nav">
				<a class="next" href="javascript:void(0);">></a>
			</div>
			<div class="wrap">
				<ul class="JQ-slide-content imgList">
$}
var j = 1;
for(i=0;i<data.docList.length;i++){
{$
					<li>
						<a href="{%data.docList[i].fdUrl%}"  class="img" target="_blank">
						<img src="${kmsThemePath}/img/pic{%j%}.png" width="80" height="56" alt="{%data.docList[i].fdName%}" /></a> 
						<a href="{%data.docList[i].fdUrl%}"
 							target="_blank" class="txt">{%data.docList[i].fdName%}</a>
					</li>
$}
j++;
if(j==6){
	j=1;
}
}
{$
				</ul>
			</div>
	</div>
</div>
$}
</script>

<script type="text/javascript">

function silderBind(){
	var $slide = $("#portlet_mySlider");
	$slide.carousel({
		  interval: 4000
		  });
	$slide.on("slid",function(){
				var i = $(this).find(".carousel-inner .active").index();  
				$(this).find(".carousel-nav a").eq(i).addClass("cur").siblings().removeClass("cur");
			});
	$(".carousel-nav a").click(function(e){
		e.preventDefault();
		$(this).addClass("cur").siblings().removeClass("cur");
		$slide.carousel($(this).index());

	});
}
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



function changeNavClass(){
	
	if('${param.tab}'){
		$('.mainnav li').each(function(i,o){
			if('${param.tab}' == (i+1)){
				if(!$(o).hasClass('on')){
					$(o).addClass('on');
				}
			}else{
				$(o).removeClass('on');
			}
		}
	)}
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
				history.go(0);
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


$(function(){
	$(".search-opt").each(function(){
		$(this).hover(function(){
			$(this).children('.opts-list').show();
		},function(){
			$(this).children('.opts-list').hide();
		});
	});

	$(".topHeader .search-opt > .opts-list > li").each(function(){
		$(this).click(function(){
			$(this).addClass("active").siblings().removeClass("active");
			$(this).parent().prev().children("span").text($(this).text());
			var str = $(this).attr("sid");
			$("#goSearch").val(str);
		});
	});
	
})

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

$(function () {
    //change opacity
    $('div.word').css({ opacity: 0.85 });
    $('#select_info_type').bind('click', function () {
        if ($(this).attr("class") == "tag_select_hover") {
            $(this).attr("class", "tag_select");
            $("#options_type").css("display", "none");
        }
        else {
            $(this).attr("class", "tag_select_hover");
            $("#options_type").css("display", "");
        }
    });

    $('.KMS_txtQuitSearch_div ul li').bind('click', function () {
        var rel = $(this).attr('rel');
    	$("#select_info_type").attr('rel',rel);
        $("#select_info_type").text($(this).text());
        if ($("#select_info_type").attr("class") == "tag_select_hover") {
            $("#select_info_type").attr("class", "tag_select");
            $("#options_type").css("display", "none");
        }
        else {
            $("#select_info_type").attr("class", "tag_select_hover");
            $("#options_type").css("display", "");
        }
    });

    $('.KMS_btnQuitSearch').bind('click',function(){
			// 搜索关键词
			var searchText = $(".KMS_txtQuitSearch").val();
			var searchModel = $("#searchModel").val();
			var searchActionUrl;
			if("third"==searchModel){
				searchActionUrl = KMS.contextPath
				+ "kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=index";
			}else{
				searchActionUrl = KMS.contextPath
						+ "sys/ftsearch/searchBuilder.do?method=search";
			}
			var	searchModelClass = $("#select_info_type").attr('rel');	
			if (!searchModelClass=="") {
				searchActionUrl += "&modelName=" + searchModelClass;
			} else {
				searchActionUrl += "&type=1&ftHome=true";
			}
			if (searchText=="" || searchText=="请输入关键字") {
				showAlert("搜索字段不能为空");
				return;
			}
			searchActionUrl += "&queryString=" + encodeURIComponent(searchText) + "&modelName=" + searchModelClass;
			window.open(searchActionUrl, "_blank");
    });
});

(function($){
	$.fn.Slide=function(options){
		var opts = $.extend({},$.fn.Slide.deflunt,options);
		var index=1;
		var targetLi = $("." + opts.claNav + " li", $(this));//Ŀ
		var clickNext = $("." + opts.claNav + " .next", $(this));//һť
		var clickPrev = $("." + opts.claNav + " .prev", $(this));//һť
		var ContentBox = $("." + opts.claCon , $(this));//Ķ
		var ContentBoxNum=ContentBox.children().size();//Ԫظ
		var slideH=ContentBox.children().first().height();//Ԫظ߶ȣ൱ڹĸ߶
		var slideW=ContentBox.children().first().width();//Ԫؿȣ൱ڹĿ
		var autoPlay;
		var slideWH;
		if(opts.effect=="scroolY"||opts.effect=="scroolTxt"){
			slideWH=slideH;
		}else if(opts.effect=="scroolX"||opts.effect=="scroolLoop"){
			ContentBox.css("width",ContentBoxNum*slideW);
			slideWH=slideW;
		}else if(opts.effect=="fade"){
			ContentBox.children().first().css("z-index","1");
		}
		
		return this.each(function() {
			var $this=$(this);
			//
			var doPlay=function(){
				$.fn.Slide.effect[opts.effect](ContentBox, targetLi, index, slideWH, opts);
				index++;
				if (index*opts.steps >= ContentBoxNum) {
					index = 0;
				}
			};
			clickNext.click(function(event){
				$.fn.Slide.effectLoop.scroolLeft(ContentBox, targetLi, index, slideWH, opts,function(){
					for(var i=0;i<opts.steps;i++){
	                    ContentBox.find("li:first",$this).appendTo(ContentBox);
	                }
	                ContentBox.css({"left":"0"});
				});
				event.preventDefault();
			});
			clickPrev.click(function(event){
				for(var i=0;i<opts.steps;i++){
	                ContentBox.find("li:last").prependTo(ContentBox);
	            }
	          	ContentBox.css({"left":-index*opts.steps*slideW});
				$.fn.Slide.effectLoop.scroolRight(ContentBox, targetLi, index, slideWH, opts);
				event.preventDefault();
			});
			if (opts.autoPlay) {
				autoPlay = setInterval(doPlay, opts.timer);
				ContentBox.hover(function(){
					if(autoPlay){
						clearInterval(autoPlay);
					}
				},function(){
					if(autoPlay){
						clearInterval(autoPlay);
					}
					autoPlay=setInterval(doPlay, opts.timer);
				});
			}
			
			targetLi.hover(function(){
				if(autoPlay){
					clearInterval(autoPlay);
				}
				index=targetLi.index(this);
				window.setTimeout(function(){$.fn.Slide.effect[opts.effect](ContentBox, targetLi, index, slideWH, opts);},200);
				
			},function(){
				if(autoPlay){
					clearInterval(autoPlay);
				}
				autoPlay = setInterval(doPlay, opts.timer);
			});
    	});
	};
	$.fn.Slide.deflunt={
		effect : "scroolY",
		autoPlay:true,
		speed : "normal",
		timer : 1000,
		defIndex : 0,
		claNav:"JQ-slide-nav",
		claCon:"JQ-slide-content",
		steps:1
	};
	$.fn.Slide.effectLoop={
		scroolLeft:function(contentObj,navObj,i,slideW,opts,callback){
			contentObj.animate({"left":-i*opts.steps*slideW},opts.speed,callback);
			if (navObj) {
				navObj.eq(i).addClass("on").siblings().removeClass("on");
			}
		},
		
		scroolRight:function(contentObj,navObj,i,slideW,opts,callback){
			contentObj.stop().animate({"left":0},opts.speed,callback);
			
		}
	}
	$.fn.Slide.effect={
		fade:function(contentObj,navObj,i,slideW,opts){
			contentObj.children().eq(i).stop().animate({opacity:1},opts.speed).css({"z-index": "1"}).siblings().animate({opacity: 0},opts.speed).css({"z-index":"0"});
			navObj.eq(i).addClass("on").siblings().removeClass("on");
		},
		scroolTxt:function(contentObj,undefined,i,slideH,opts){
			//alert(i*opts.steps*slideH);
			contentObj.animate({"margin-top":-opts.steps*slideH},opts.speed,function(){
                for( var j=0;j<opts.steps;j++){
                	contentObj.find("li:first").appendTo(contentObj);
                }
                contentObj.css({"margin-top":"0"});
            });
		},
		scroolX:function(contentObj,navObj,i,slideW,opts,callback){
			contentObj.stop().animate({"left":-i*opts.steps*slideW},opts.speed,callback);
			if (navObj) {
				navObj.eq(i).addClass("on").siblings().removeClass("on");
			}
		},
		scroolY:function(contentObj,navObj,i,slideH,opts){
			contentObj.stop().animate({"top":-i*opts.steps*slideH},opts.speed);
			if (navObj) {
				navObj.eq(i).addClass("on").siblings().removeClass("on");
			}
		}
	};
})(jQuery);

function bindSlider(){

	/* 用按钮控制图片左右滚动 */
    $("#portlet_KMS_shortcut_item1 .hotPic .JQ-slide").Slide({
        effect: "scroolLoop",
        autoPlay: false,
        speed: "normal",
        timer: 3000,
        steps: 1
    });

    /* 用按钮控制图片左右滚动 */
    $("#portlet_KMS_shortcut_item2 .hotPic .JQ-slide").Slide({
        effect: "scroolLoop",
        autoPlay: false,
        speed: "normal",
        timer: 3000,
        steps: 1
    });

    /* 用按钮控制图片左右滚动 */
    $("#portlet_KMS_shortcut_item3 .hotPic .JQ-slide").Slide({
        effect: "scroolLoop",
        autoPlay: false,
        speed: "normal",
        timer: 3000,
        steps: 1
    });
}

//快捷菜单的切换
function changeItem(name, cursel, n) {
    var className = "KMS_shortcut_row";
    var item1 = document.getElementById(name + "1");
    var item2 = document.getElementById(name + "2");
    var item3 = document.getElementById(name + "3");
    switch (cursel) {
        case 1:
            {
                item1.className = name + "1 KMS_cellbg_" + "current";
                item2.className = name + "2 KMS_cellbg_" + "currentB";
                item3.className = name + "3 KMS_cellbg_" + "normal";
                break;
            }
        case 2:
            {
                item1.className = name + "1 KMS_cellbg_" + "normal";
                item2.className = name + "2 KMS_cellbg_" + "current";
                item3.className = name + "3 KMS_cellbg_" + "currentB";
                break;
            }
        case 3:
            {
                item1.className = name + "1 KMS_cellbg_" + "normal";
                item2.className = name + "2 KMS_cellbg_" + "normal";
                item3.className = name + "3 KMS_cellbg_" + "current";
                break;
            }
    }
    for (var i = 1; i <= n; i++) {
        var item = document.getElementById(name + i);
        var con = document.getElementById("portlet_KMS_shortcut_item" + i);
        con.style.display = i == cursel ? "block" : "none";
    }
}
</script>