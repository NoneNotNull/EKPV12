package com.landray.kmss.spi.interfaces;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.spi.query.CriteriaQuery;
import com.landray.kmss.sys.authentication.filter.FilterContext;
import com.landray.kmss.sys.authentication.filter.IAuthenticationFilter;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.config.design.SysCfgFilter;
import com.landray.kmss.sys.config.design.filter.SysCfgFilterUtil;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.UserUtil;

public abstract class AbstractQueryBuilder implements QueryBuilder {
	private static final Log logger = LogFactory
			.getLog(AbstractQueryBuilder.class);

	public static void loadAuthInfo(CriteriaQuery query) throws Exception {
		if (UserUtil.getKMSSUser().isAdmin()) {
			if (logger.isDebugEnabled())
				logger.debug("当前用户为系统管理员，不作数据权限过滤");
			return;
		} else {
			// 寻找域模型配置
			SysDictModel model = SysDataDict.getInstance().getModel(
					query.getModelName());
			if (model == null || model.getFilters() == null) {
				if (logger.isDebugEnabled())
					logger.debug(query.getModelName() + "的过滤未配置，不作数据权限过滤");
				return;
			}

			// 获取读者过滤信息
			List<SysCfgFilter> filters = model.getFilters().get(
					SysAuthConstant.AUTH_CHECK_READER);
			if (filters != null) {
				runFilter(filters, query, UserUtil.getKMSSUser());
			}
		}
	}

	// 计算权限Filter
	private static void runFilter(List<SysCfgFilter> filters, CriteriaQuery query,
			KMSSUser user) throws Exception {
		String modelName = query.getModelName();
		String modelTable = ModelUtil.getModelTableName(modelName);
		String expression;
		String filterName;
		FilterContext ctx = null;
		IAuthenticationFilter filterBean;
		for (int i = 0; i < filters.size(); i++) {
			expression = (filters.get(i)).getExpression();
			ctx = new FilterContext(modelName, modelTable, SysCfgFilterUtil
					.getParameterMap(expression), user);
			ctx.setCriteriaQuery(query);
			filterName = SysCfgFilterUtil.getFilterName(expression);
			if(filterName.equals("authFieldInnerJoinFilter")){
				filterName = "authFieldKmsFilter";
			}
			filterBean = (IAuthenticationFilter) SpringBeanUtil
					.getBean(filterName);
			int result = filterBean.getAuthHQLInfo(ctx);
			if (logger.isDebugEnabled()) {
				String logInfo = "执行过滤器：" + expression + "，返回：";
				switch (result) {
				case FilterContext.RETRUN_CANCELFILTER:
					logInfo += "RETRUN_CANCELFILTER";
					break;
				case FilterContext.RETURN_VALUE:
					logInfo += "RETURN_VALUE";
					break;
				case FilterContext.RETURN_IGNOREME:
					logInfo += "RETURN_IGNOREME";
					break;
				}
				logger.debug(logInfo);
			}
			if (result == FilterContext.RETRUN_CANCELFILTER) {
				// 取消数据过滤动作
				return;
			} else if (result == FilterContext.RETURN_VALUE) {
				// 返回值存储在ctx中
			}
		}
	}

	public QueryWrapper buildQuery(CriteriaQuery query) throws Exception {
		loadAuthInfo(query);
		return buildBusinessQuery(query);
	}

	public abstract QueryWrapper buildBusinessQuery(CriteriaQuery query)
			throws Exception;
}
