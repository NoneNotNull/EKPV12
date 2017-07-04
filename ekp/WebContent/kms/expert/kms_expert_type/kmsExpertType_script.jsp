<script type="text/javascript">
function openExpertWindow(){
	dialog_Expert_Tree(null, 'fdParentId', 'fdParentName', ',', 'kmsExpertTypeTreeService&expertTypeId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-expert"/>', null, null, '${kmsExpertTypeForm.fdId}', null, null, '<bean:message key="dialog.title" bundle="kms-expert"/>');
}

function dialog_Expert_Tree(mulSelect, idField, nameField, splitStr, treeBean, treeTitle, treeAutoSelChilde, action, exceptValue, isMulField, notNull, winTitle){
	var dialog = new KMSSDialog(mulSelect, false);
	var node = dialog.CreateTree(treeTitle);
	node.AppendBeanData(treeBean, null, null, null, exceptValue);
	dialog.tree.isAutoSelectChildren = treeAutoSelChilde;
	dialog.winTitle = winTitle==null?treeTitle:winTitle;
	dialog.BindingField(idField, nameField, splitStr);
	dialog.SetAfterShow(action);
	dialog.Show();
}
</script>
