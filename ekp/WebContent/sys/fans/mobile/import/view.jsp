 <%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<span 
   	  data-dojo-type="dojox/mobile/Button"
   	  data-dojo-mixins="sys/fans/mobile/FansButtonMixin" 
   	  data-dojo-props="fdMemberNum:'${param.fdMemberNum}',
   	  muiIcon:'${param.muiIcon}',
   	  attentModelName:'${param.attentModelName}',
   	  fansModelName:'${param.fansModelName}',
   	  fdId:'${param.fdModelId}',
   	  type:'${param.type }'">
</span> 