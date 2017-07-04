部署步骤说明：
1、修改配置文件：config.properties
2、修改/resource/js/domain.js，将“registHotspot();”的注释去除
3、修改/sys/portal/sys_portal_page/page.jsp，加入代码：
	<%@ include file="/dbcenter/behavior/hotspot/portal.jsp" %>