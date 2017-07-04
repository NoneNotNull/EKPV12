var datas = data.datas;
var columns = data.columns;
var hiddenColumns = [];
var showTableTitle = render.vars.showTableTitle;
{$
	<table width="100%" class="lui_dataview_listtable_table">
$}
	if(!datas || ! columns)
		return;
	if(showTableTitle == "true"){
{$
		<thead>
$}
		for (var i = 0; i < columns.length; i ++) {
			var col = columns[i];
			if(col.title==null || $.trim(col.title) == ""){
				hiddenColumns.push(i);
				continue;
			}
			{$<th style='{%col.headerStyle%}' class='{%col.headerClass%}'>{%col.title%}</th>$}
		}
{$		
		</thead>
$}	
	} else {
		for (var i = 0; i < columns.length; i ++) {
			var col = columns[i];
			if(col.title==null || $.trim(col.title) == ""){
				hiddenColumns.push(i);
				continue;
			}
		}
	}
{$
		<tbody>
$} 
		for (var i = 0; i < datas.length; i ++) {
			var row = datas[i];
			var href = '';
			var target = '_blank';
			for(var k = 0; k < row.length; k ++){
				if(row[k]['col']=='href')
					href = env.fn.formatUrl(row[k]['value']) ;
				if(row[k]['col']=='target')
					target = row[k]['value'];
			}	
			{$<tr>$}
            var firstTd = true;
			for (var j = 0; j < row.length; j ++) {
				if($.inArray(j,hiddenColumns) > -1 || row[j]['col']=='href'|| row[j]['col']=='target'){
					continue;
				}
				var cell = row[j];
                if(firstTd){
                    {$<td style='{%cell.style%}' class='lui_dataview_listtable_firstTd {%cell.styleClass%}' >{%cell.value%}</td>$}
                    firstTd = false;
                }
                else{
				    {$<td style='{%cell.style%}' class='{%cell.styleClass%}'>{%cell.value%}</td>$}
                }
			}
			{$</tr>$}
		}
{$		</tbody>
	</table>
$}