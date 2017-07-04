<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div class="muiDateTimeChoices">
	<div class="muiDateTimeChoice checked">日期</div>
	<div class="muiDateTimeChoice">时间</div>
</div>
<div class="muiDateTimeArea">
	<div style="z-index:2;opacity:1;">
		<div 
			data-dojo-type="mui/datetime/DatePicker" 
			id="_date_picker" 
			data-dojo-props="value:'!{dateValue}'">
		</div>
	</div>
	<div>
		<div 
			data-dojo-type="mui/datetime/TimePicker" 
			id="_time_picker" 
			data-dojo-props="value:'!{timeValue}'">
		</div>
	</div>
</div>