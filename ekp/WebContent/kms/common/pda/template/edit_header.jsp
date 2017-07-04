<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<header class="lui-header">
	<ul class="clearfloat" id="toolbar">
		<li style="float: left; padding-left: 10px;">
			<a data-lui-role="button"> 
				<script type="text/config">
					{
						currentClass : 'lui-icon-s lui-back-icon',
						onclick : "history.go(-1)"
					}
				</script>
			</a>
		</li>
		<li class="lui-docSubject" style="right: 140px"><h2 class="textEllipsis"></h2></li>
		<li style="float: right; padding-right: 15px;">
			<a data-lui-role="button"> 
				<script type="text/config">
					{
						currentClass : 'lui-icon-s lui-ok-icon lui-ok-icon-on',
						onclick : "save()"
					}
				</script>
			</a>
		</li>
	</ul>
</header>

<script>
	Pda.Topic.on('changeTitle',function(evt){
		if(evt&&evt.title){
			var title = evt.title;
			$('.lui-docSubject h2').text(title);
		}
			
	});
</script>