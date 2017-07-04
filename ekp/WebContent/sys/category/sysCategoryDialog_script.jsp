<script type="text/javascript">
function cate_selectedOrgTree(mulSelect, idField, nameField, splitStr,notNull){
	if(mulSelect==null) mulSelect = false;
	if(idField==null) idField = 'fdParentId';
	if(nameField==null) nameField = 'fdParentName';
	Dialog_Tree(mulSelect, idField, nameField, splitStr, 'sysCategoryOrgTreeTreeService&authType=01&categoryId=!{value}', '<bean:message key="dialog.orgtree.title" bundle="sys-category"/>', null, null, '${param.fdId}', null, notNull, '<bean:message key="dialog.org.title" bundle="sys-category"/>');
}
</script>	