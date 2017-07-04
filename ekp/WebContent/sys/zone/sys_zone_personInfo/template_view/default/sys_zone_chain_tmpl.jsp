<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
if(data && data.length > 0 ) {
	{$<ul class="lui_zone_relation_chain" id="con_teamTab_1">$}
	for(var i = 0 ; i < data.length ; i++ ) {
		if(i != 0) {
			{$ <li class="lui_zone_relation_chainup">
					<i></i>
				</li>
			$}
		}
		{$
			<li>
				<i class="dotted"></i>
				<div class="lui_zone_relation_chain_img">
					<a target="_blank" 
						href="{%env.fn.formatUrl(data[i].homePagePath)%}">
						<img
							src="{%env.fn.formatUrl(data[i].homeImgPath)%}" />
					</a>
				</div>
				<h4>
					<a target="_blank" class="com_author"
						href="{%env.fn.formatUrl(data[i].homePagePath)%}">
						{%data[i].leaderName%}
					</a>
				</h4>
				<p>
					{%data[i].postName%}
                    <br />
				</p>
			</li>
		$}
	}
	{$</ul>$}
}else {
{$	<div></div>$}
}