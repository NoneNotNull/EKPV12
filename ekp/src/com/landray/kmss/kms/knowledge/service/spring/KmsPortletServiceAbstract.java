package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public abstract class KmsPortletServiceAbstract {
	
	//从数据库获取数量
	protected static final int DATA_NUM = 100;

	public JSONArray findPortlet(HttpServletRequest request)
			throws Exception {

		// 最新、最热、精华
		String type = request.getParameter("type");
		String parentId = request.getParameter("categoryId");
		String cacheKey = StringUtil.linkString(type, null, parentId);
		JSONArray jsonList;

		// 当启用了集团分级授权，则直接从数据库中查询数据，因为缓存的数据在切换场所时会导致数据不全
		if (ISysAuthConstant.IS_AREA_ENABLED) {
			jsonList = findData(request, true);
		} else {
			// 从缓存中取出所有数据
			jsonList = findDataWithOutAuth(cacheKey, request);
		}
		// 取所需要数据量
		return getDataByCache(jsonList, request);
	}

	/**
	 * 查询数据
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	protected abstract JSONArray findData(HttpServletRequest request, boolean b)
			throws Exception;

	/**
	 * 不带权限查询,优先加载缓存数据
	 * 
	 * @param cacheKey
	 * @param request
	 * @return
	 * @throws Exception
	 */
	protected abstract JSONArray findDataWithOutAuth(String cacheKey,
			HttpServletRequest request) throws Exception;

	/**
	 * 从缓存取所需要数据
	 * 
	 * @param jsonList
	 * @param request
	 * @return
	 * @throws Exception
	 */
	protected JSONArray getDataByCache(JSONArray jsonList,
			HttpServletRequest request) throws Exception {
		Boolean isPermission = this.getPermission(this.getClass());
		List authOrgIds = new ArrayList();
		// 如果是管理员或拥有模块权限则无需取登录用户相关组织架构
		if (!isPermission) {
			authOrgIds = UserUtil.getKMSSUser().getUserAuthInfo()
					.getAuthOrgIds();
		}
		int rowsize = SysConfigParameters.getRowSize();
		String s_rowsize = request.getParameter("rowsize");
		if (s_rowsize != null && s_rowsize.length() > 0) {
			rowsize = Integer.parseInt(s_rowsize);
		}
		JSONArray rtnArray = new JSONArray();
		for (int i = 0; i < jsonList.size() && rowsize > 0; i++) {
			// 如果是管理员或拥有模块权限则不进行权限过滤，直接获取rowsize的新闻记录即可
			if (!isPermission) {
				JSONObject map = (JSONObject) jsonList
						.get(i);
				Boolean authReaderFlag = (Boolean) map.get("authReaderFlag");
				// 判断权限标志位,如果不是所有可以阅读则进行权限过滤
				if (authReaderFlag == null || !authReaderFlag) {
					List<String> authPermissions = (List<String>) map
							.get("authPermissions");
					// 判断有权限的组织架构是否和该登录用户的相关组织架构有交集，如果没有交集则没有权限
					Boolean permission = ArrayUtil.isListIntersect(
							authPermissions, authOrgIds);
					if (!permission) {
						continue;
					}
				}
			}
			rtnArray.add(jsonList.get(i));
			rowsize--;
		}
		return rtnArray;
	}

	/**
	 * 获取当前登录用户是否拥有模块权限或为管理员
	 * 
	 * @return
	 */
	public Boolean getPermission(Class Oclass) throws Exception {
		Boolean isPermission = false;
		isPermission = UserUtil.getKMSSUser().isAdmin();
		List<String> authRoleAliases = new ArrayList<String>();
		List<String> moduleRoles = new ArrayList<String>();
		// 如果不是管理员则获取当前登录用户的角色列表以及模块角色信息
		if (!isPermission) {
			authRoleAliases = UserUtil.getKMSSUser().getUserAuthInfo()
					.getAuthRoleAliases();
			moduleRoles = getModuleRoles(Oclass);
		}
		for (int i = 0; i < moduleRoles.size(); i++) {
			// 拥有模块其中的一个权限则为true
			if (authRoleAliases.contains(moduleRoles.get(i))) {
				isPermission = true;
				break;
			}
		}
		return isPermission;
	}

	/**
	 * 获取该模块角色信息
	 * 
	 * @return
	 * @throws Exception
	 */
	private List<String> getModuleRoles(Class Oclass) throws Exception {
		List<String> roleList = new ArrayList<String>();
		List roles = ModelUtil.getModelRoles(Oclass.getName());
		for (int i = 0; i < roles.size(); i++) {
			roleList.add((String) roles.get(i));
		}
		return roleList;
	}

	/**
	 * 将可阅读者和可编辑者转换为id列表
	 * 
	 * @param list
	 * @return
	 */
	public List<String> lists2Ids(List list) {
		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < list.size(); i++) {
			BaseModel m = (BaseModel) list.get(i);
			ids.add(m.getFdId());
		}
		return ids;
	}
}
