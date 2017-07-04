<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$
<li style="cursor: pointer;">
	<a href="javascript:void(0);" onclick="clickLabel(this,'myEvent');">
		<div class="label_div_on lui_calendar_color_event"></div>
			${ lfn:message('km-calendar:kmCalendar.nav.title') }
	</a>
</li>
$}
for(var i=0;i<data.length;i++){
	{$
	<li style="cursor: pointer;">
		<a href="javascript:void(0);"  onclick="clickLabel(this,'{%data[i].fdId%}');" >
			<div style="background-color: {%data[i].fdColor%};" class="label_div_on"></div>
			{%data[i].fdName%}
		</a>
	</li>
	$}
}
{$
<li style="cursor: pointer;">
  	<a href="javascript:void(0);"  onclick="clickLabel(this,'myNote');">
  		<div  class="label_div_on lui_calendar_color_note"></div>
  		${ lfn:message('km-calendar:module.km.calendar.tree.my.note') }
  	</a>
 </li>
 $}