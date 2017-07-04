<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
var hasAdd = false;
<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add" requestMethod="GET">
	hasAdd = true;
</kmss:auth>
{$
	<ul class="lui-expert-rowtable">
$}
for(var i=0;i<data.length;i++){
{$
		<li>
			<article class="lui-expert-article">
				<a href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&getCount=true&fdExpertId={% data[i]['fdId'] %}">
					<img src="{% data[i]['imgUrl'] %}" width="100%" height="100%"/>
				</a>
				<ul >
					<li class="clearfloat">
						<span class="name" onclick="window.open('${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&getCount=true&fdExpertId={% data[i]['fdId'] %}','_self')">{% data[i]['fdName'] %}</span>
$}
					if(data[i]['fdEmail']||data[i]['fdMobileNo']){
{$
						<ul class="lui-expert-connect clearfloat">
$}
						if(data[i]['fdEmail']){
{$							
							<li class="lui-icon-s lui-mail-icon-on" onclick="person_opt('mailto:','{% data[i]['fdEmail'] %}','mailto')"></li>
$}
						}
						if(data[i]['fdMobileNo']){
{$
							<li class="lui-icon-s lui-phone-icon-on" onclick="person_opt('tel:','{% data[i]['fdMobileNo'] %}','phone')"></li>
$}						
						}
{$				
							<!-- <li class="lui-icon-s-s lui-kk-icon-on"></li> -->
						</ul>
$}
					}
						if(data[i]['askTo'] == "true" &&  hasAdd == true){
{$						
							<span class="ask" onclick="add_ask('{%data[i]['fdId']%}')">向TA提问</span>
$}
						}
{$
					</li>
					<li >
						<p class="background textEllipsis">{% data[i]['fdBackground'] %}</p>
					</li>
					<li >
						<span class="dept textEllipsis">
							部门：{% data[i]['fdDeptName'] %}
						</span>
					</li>
				</ul>
			</article>
		</li>
$}
}
{$
	</ul>
$}