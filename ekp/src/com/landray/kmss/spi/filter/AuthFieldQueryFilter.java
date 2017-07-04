package com.landray.kmss.spi.filter;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.spi.query.ArrayQuery;
import com.landray.kmss.spi.query.CriteriaQuery;
import com.landray.kmss.spi.query.SearchType;
import com.landray.kmss.sys.authentication.filter.AuthFieldInnerJoinFilter;
import com.landray.kmss.sys.authentication.filter.FilterContext;
import com.landray.kmss.sys.authentication.filter.IAuthenticationFilter;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.UserUtil;

public class AuthFieldQueryFilter extends AuthFieldInnerJoinFilter implements
		IAuthenticationFilter {

	public int getAuthHQLInfo(FilterContext ctx) throws Exception {
		return super.getAuthHQLInfo(ctx);
	}

	protected int getAuthHQLInfo(FilterContext ctx, String field)
			throws Exception {
		CriteriaQuery criteriaQuery = ctx.getCriteriaQuery();
		int index = field.lastIndexOf('.');
		String type = null;
		String firstProperty = null;
		boolean isPerson = false;
		if (index > -1) {
			firstProperty = field.substring(0, index);
			type = ModelUtil.getPropertyType(ctx.getModelName(), firstProperty);
			isPerson = type.startsWith(SysOrgPerson.class.getName());
		} else {
			firstProperty = field;
			type = ModelUtil.getPropertyType(ctx.getModelName(), field);
			isPerson = type.startsWith(SysOrgPerson.class.getName());
		}
		if (isPerson) {
			criteriaQuery.andQuery(new ArrayQuery(firstProperty, SearchType.EQ,
					ctx.getUser().getPerson().getFdId()));
		} else {
			List<String> authOrgIds = new ArrayList<String>();
			authOrgIds.add(UserUtil.getEveryoneUser().getFdId()); // 所有者
			authOrgIds.addAll(ctx.getUser().getUserAuthInfo().getAuthOrgIds());
			criteriaQuery.andQuery(new ArrayQuery(firstProperty, SearchType.IN,
					authOrgIds.toArray(new String[0])));
		}

		// 执行HQLinfo逻辑
		return super.getAuthHQLInfo(ctx, field);
	}
}