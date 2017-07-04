<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script id="portlet_tmpl" type="text/template">
				{$ 
				<div class="box1 m_t10">
							<h2 class="h2_1">{%parameters.kms.title%}</h2>
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
<script id="portlet_item_tmpl" type="text/template">
				for(i=0;i<data.rows.length;i++){
					{$ 
						<div>ss</div>
					$}
				}
</script>
