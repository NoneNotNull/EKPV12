<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@page import="com.landray.kmss.sys.config.design.SysCfgHomePage"%>
<%@page import="java.util.*"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="com.landray.kmss.sys.config.design.SysConfigs"%>
<%@ include file="/resource/jsp/common.jsp" %>
<%@ include file="/resource/jsp/tree_top.jsp" %>

<%@page import="com.landray.kmss.util.comparator.ChinesePinyinComparator"%><c:set var="typeMessageKey" value="config.${param.type}"/>
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"${lfn:message(typeMessageKey)}",
		document.getElementById("treeDiv")
	);
	var node, selectedNode;
	node = LKSTree.treeRoot;
	<% 
		String module = request.getParameter("module");
		if(StringUtil.isNotNull(module)){
			if(module.startsWith("/")){
				module = module.substring(1);
			}
			if(module.endsWith("/")){
				module = module.substring(0,module.length()-1);
			}
		}
		String type = request.getParameter("type");
		Map configs = new HashMap();
		for(Iterator iterator = SysConfigs.getInstance().getHomePages().values().iterator(); iterator.hasNext();){
			SysCfgHomePage hp = (SysCfgHomePage) iterator.next();
			if(StringUtil.isNull(hp.getConfig()) || !type.equals(hp.getType())){
				continue;
			}
			String moduleName = hp.getMessageKey();
			if(StringUtil.isNotNull(moduleName)){
				moduleName = ResourceUtil.getString(moduleName);
			}
			if(StringUtil.isNull(moduleName)){
				continue;
			}
			if(!UserUtil.checkAuthentication(hp.getConfig(), "GET")){
				continue;
			}
			
			StringBuffer jscode = new StringBuffer();
			if(module.equals(hp.getUrlPrefix())){
				jscode.append("selectedNode = ");
			}
			jscode.append("node.AppendURLChild('").append(moduleName).append("','")
					.append(request.getContextPath()).append(hp.getConfig()).append("','moduleManager');\r\n");
			configs.put(jscode.toString(), moduleName);
		}
		List list = new ArrayList(configs.entrySet());
		Collections.sort(list, new Comparator(){
			public int compare(Object o1, Object o2){
				return ChinesePinyinComparator.compare(((Map.Entry)o1).getValue().toString(), ((Map.Entry)o2).getValue().toString());
			}
		});
		for(Object e : list){
			out.write(((Map.Entry)e).getKey().toString());
		}
	%>
	function setTitle(title){
		try{
			top.document.title = title;
		}catch(e){}
	}
	LKSTree.OnNodePostClick = function(node){
		setTitle(Tree_GetNodePath(node, " - "));
	}
	setTitle(LKSTree.treeRoot.text);
	LKSTree.Show();
	if(selectedNode!=null){
		Com_AddEventListener(window,"load",function(){
			LKSTree.ClickNode(selectedNode);
			parent.Frame_MoveBy(parent.document.getElementsByName("moduleCtrl")[0].contentWindow,-1);
		});
	}
//============================请修改上面的代码============================
}
</script>
<%@ include file="/resource/jsp/tree_down.jsp" %>