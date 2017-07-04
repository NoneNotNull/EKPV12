<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<ul class="clearfloat lui-grid-d" id="btnBar" style="display: none">
	<li>
		<a id="column_button" data-lui-role="button">
			<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-column-icon',
							toggleClass : 'lui-column-icon-on',
							onclick : "btnSelected('column')",
							group : 'group1',
							selected : true
						}
			</script>		
		</a>
	</li>
	<li>
		<a id="rowtable_button" data-lui-role="button">
			<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-rowtable-icon',
							toggleClass : 'lui-rowtable-icon-on',
							onclick : "btnSelected('rowtable')",
							group : 'group1'
						}
					</script>
		</a>
	</li>
	<li>
		<a id="grid_button" data-lui-role="button">
			<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-grid-icon',
							toggleClass : 'lui-grid-icon-on',
							onclick : "btnSelected('grid')",
							group : 'group1'
						}
					</script>
		</a>
	</li>
	<li>
		<a data-lui-role="button" id="other_button">
			<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-other-icon',
							onclick : "category_click()"
						}
			</script>
		</a>
	</li>
	<li>
		<a data-lui-role="button" id="personal_button">
			<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-person-icon',
							onclick : "personal_click()"
						}
			</script>
		</a>
	</li>
</ul>

<script>
	Pda.Topic.on('head_btnClick',function(){
		$('#btnBar').hide();
	});

	Pda.Topic.on('slide',function(evt){
		var list = evt.obj;
		Pda.Element(list.id+'_button').emitGroup("groupon");
		changeCurrentBtn(list.id);
		Pda.Topic.emit("head_btnClick");
		
	});

	function btnSelected(type){
		Pda.Element('listview').selected(type);
		changeCurrentBtn(type);
		Pda.Topic.emit('head_btnClick');
	}
</script>
