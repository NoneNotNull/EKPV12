<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

var width ;
if (!window.innerWidth)
	width =  $(window).width();
else
	width =  window.innerWidth;
width = width-80;
width += "px";
var hasAdd = false;
<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add" requestMethod="GET">
	hasAdd = true;
</kmss:auth>
for(var i=0;i<data.length;i++){
{$
	<section class="lui-expert-grid $} if(i==0){ {$ current $} } {$" style="width:{% width %}">
		<header>
			<ul>
				<li class="img">
					<a href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&getCount=true&fdExpertId={% data[i]['fdId'] %}">
						<img src="{% data[i]['imgUrl'] %}" width="100%" height="100%" />
					</a>
				</li>
				<li class="info">
					<a href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&getCount=true&fdExpertId={% data[i]['fdId'] %}">
						<span class="name">{% data[i]['fdName'] %}</span>
					</a>
					<span class="textEllipsis">
						{% data[i]['fdDeptName'] %}
					</span>
					<ul class="lui-expert-connect clearfloat">
$}
					if(data[i]['fdEmail']){
						{$ <li class="lui-icon-s lui-mail-icon" onclick="person_opt('mailto:','{% data[i]['fdEmail'] %}','mailto')"></li> $}
					}
					if(data[i]['fdMobileNo']){
						{$ <li class="lui-icon-s lui-phone-icon" onclick="person_opt('tel:','{% data[i]['fdMobileNo'] %}','phone')"></li> $}
					}
{$ 						<!--  <li class="lui-kk-icon"></li> -->
					</ul>
				</li>
			</ul>
			
			<ul class="clearfloat lui-grid-b count">
				<li>
					<em class="lui-icon-s-s lui-knowledge-icon">知识<span>{% data[i]['fdDocCount'] %}</span></em>
				</li>
				<li>
					<em class="lui-icon-s-s lui-bookmark-icon">收藏<span>{% data[i]['fdBookMarkCount'] %}</span></em>
				</li>
				<li>
					<em class="lui-icon-s-s lui-follow-icon" style="color:#979797">关注<span></span></em>
				</li>
			</ul>
		</header>
		<article class="lui-content">
			<ul class="lui-expert-info">
				<li>
					<span>手机</span>
					<span>{% data[i]['fdMobileNo'] %}</span>
				</li>
				<li>
					<span>电话</span>
					<span>{% data[i]['fdWorkPhone'] %}</span>
				</li>
				<li>
					<span>邮箱</span>
					<span>{% data[i]['fdEmail'] %}</span>
				</li>
				<li>
					<span>岗位</span>
					<span>{% data[i]['fdPostNames'] %}</span>
				</li>
			</ul>
		</article>
		
		<footer class="lui-footer" style="position:absolute">
			<ul>
				<li>
$}
					if(data[i]['askTo'] == "true" && hasAdd==true) {
{$					   <a data-lui-role="button" 
						  class="lui-property-icon-view" 
						  onclick="add_ask('{%data[i]['fdId']%}')">
							向TA提问
					   </a>
$}
					}
{$
				</li>
			</ul>
		</footer>
	</section>
$}
}
