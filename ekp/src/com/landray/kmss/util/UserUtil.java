package com.landray.kmss.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.acegisecurity.context.SecurityContext;
import org.acegisecurity.context.SecurityContextHolder;

import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.constant.SysOrgConstant;
import com.landray.kmss.sys.authentication.background.BackgroundTempUserHolder;
import com.landray.kmss.sys.authentication.intercept.IAuthenticationValidateCore;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.organization.interfaces.ISysOrgCoreService;
import com.landray.kmss.sys.organization.interfaces.ISysOrgElement;
import com.landray.kmss.sys.organization.model.SysOrgPerson;

public abstract class UserUtil {

	private static ISysOrgCoreService sysOrgCoreService = null;

	private static IAuthenticationValidateCore authenticationValidateCore = null;

	private static KMSSUser anonymousUser;

	/**
	 * 校验当前用户是否具有某个指定资源的权限
	 * 
	 * @param url
	 * @param mothod
	 * @return true有权限
	 */
	public static boolean checkAuthentication(String url, String mothod) {
		return getAuthenticationValidateCore().checkAuthentication(url, mothod);
	}

	/**
	 * 判断当前用户是否属于某个ID
	 * 
	 * @param id
	 *            id，可以为个人、岗位、部门、机构、常用群组的ID
	 * @return
	 */
	public static boolean checkUserId(String id) {
		return getKMSSUser().getUserAuthInfo().getAuthOrgIds().contains(id);
	}

	/**
	 * 判断当前用户是否属于id列表中的一个
	 * 
	 * @param ids
	 *            id列表，可以为个人、岗位、部门、机构、常用群组的ID
	 * @return
	 */
	public static boolean checkUserIds(List<String> ids) {
		return ArrayUtil.isListIntersect(ids, getKMSSUser().getUserAuthInfo()
				.getAuthOrgIds());
	}

	/**
	 * 判断当前用户是否属于某个组织架构
	 * 
	 * @param element
	 * @return
	 */
	public static boolean checkUserModel(ISysOrgElement element) {
		return getKMSSUser().getUserAuthInfo().getAuthOrgIds().contains(
				element.getFdId());
	}

	/**
	 * 判断当前用户是否属于组织架构列表中的一个
	 * 
	 * @param elements
	 * @return
	 */
	public static boolean checkUserModels(List<?> elements) {
		List<String> ids = new ArrayList<String>();
		for (int i = 0; i < elements.size(); i++) {
			ids.add(((ISysOrgElement) elements.get(i)).getFdId());
		}
		return ArrayUtil.isListIntersect(ids, getKMSSUser().getUserAuthInfo()
				.getAuthOrgIds());
	}

	/**
	 * 判断当前用户是否具有某个角色
	 * 
	 * @param role
	 * @return
	 */
	public static boolean checkRole(String role) {
		KMSSUser user = getKMSSUser();
		if (user.isAdmin())
			return true;
		return user.getUserAuthInfo().getAuthRoleAliases().contains(role);
	}

	public static boolean checkRoles(List<String> roles) {
		KMSSUser user = getKMSSUser();
		if (user.isAdmin())
			return true;
		return ArrayUtil.isListIntersect(roles, user.getUserAuthInfo()
				.getAuthRoleAliases());
	}

	/**
	 * 判断当前用户是否可以使用某个角色操作目标场所的数据
	 * 
	 * @param role
	 *            角色
	 * @param areaId
	 *            目标场所的层级ID
	 * @param type
	 *            场所的可用性类型。ISysAuthConstant.TYPE_VISIBLE_BRANCH
	 *            表示用户可以使用同一分支上所有上下级场所的数据 ；ISysAuthConstant.TYPE_VISIBLE_CHILD
	 *            表示用户仅可使用本场所和下级场所的数据。
	 * @return
	 * @throws Exception
	 */
	public static boolean checkAreaRole(String role, String areaHierarchyId,
			SysAuthConstant.AreaIsolation type) throws Exception {
		boolean isAvailable = getKMSSUser().getUserAuthInfo()
				.getAuthRoleAliases().contains(role);

		if (isAvailable) {
			isAvailable = SysAuthAreaUtils.isAvailableArea(areaHierarchyId,
					type);
		}

		return isAvailable;
	}

	public static boolean checkAreaRole(String role, IBaseModel model,
			SysAuthConstant.AreaIsolation type) throws Exception {
		boolean isAvailable = getKMSSUser().getUserAuthInfo()
				.getAuthRoleAliases().contains(role);

		if (isAvailable) {
			isAvailable = SysAuthAreaUtils.isAvailableModel(model, type);
		}

		return isAvailable;
	}

	/**
	 * 在程序中使用，获取当前登录员工
	 * 
	 * @return
	 */
	public static KMSSUser getKMSSUser() {
		KMSSUser rtnVal = BackgroundTempUserHolder.get();
		if (rtnVal == null) {
			try {
				rtnVal = (KMSSUser) SecurityContextHolder.getContext()
						.getAuthentication().getPrincipal();
			} catch (Exception e) {
			}
		}
		if (rtnVal == null)
			return anonymousUser;
		return rtnVal;
	}

	/**
	 * 在页面中使用，获取当前登录KMSS用户
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static KMSSUser getKMSSUser(HttpServletRequest request) {
		KMSSUser rtnVal = BackgroundTempUserHolder.get();
		if (rtnVal == null) {
			try {
				Object context = request.getSession().getAttribute(
						"ACEGI_SECURITY_CONTEXT");
				if (context != null && context instanceof SecurityContext)
					rtnVal = (KMSSUser) ((SecurityContext) context)
							.getAuthentication().getPrincipal();
			} catch (Exception e) {
			}
		}
		if (rtnVal == null)
			return anonymousUser;
		return rtnVal;
	}

	/**
	 * 在程序中使用，获取当前登录用户
	 * 
	 * @return
	 */
	public static SysOrgPerson getUser() {
		return getUser(getKMSSUser());
	}

	/**
	 * 在页面中使用，获取当前登录用户
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static SysOrgPerson getUser(HttpServletRequest request) {
		return getUser(getKMSSUser(request));
	}

	/**
	 * 获取用户对象
	 * 
	 * @param user
	 * @return
	 */
	public static SysOrgPerson getUser(KMSSUser user) {
		try {
			return (SysOrgPerson) getSysOrgCoreService().findByPrimaryKey(
					user.getUserId(), SysOrgPerson.class, false);
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
	}

	/**
	 * 在页面中使用，获取当前用户名，屏蔽了匿名的错误
	 * 
	 * @param request
	 * @return
	 */
	public static String getUserName(HttpServletRequest request) {
		return getKMSSUser(request).getUserName();
	}

	public static void setAnonymousUser(KMSSUser anonymousUser) {
		UserUtil.anonymousUser = anonymousUser;
	}

	public static KMSSUser getAnonymousUser() {
		return anonymousUser;
	}

	/**
	 * 获取所有者用户
	 * 
	 * @return
	 */
	public static SysOrgPerson getEveryoneUser() {
		try {
			return (SysOrgPerson) getSysOrgCoreService().findByPrimaryKey(
					SysOrgConstant.ORG_PERSON_EVERYONE_ID, SysOrgPerson.class,
					false);
		} catch (Exception e) {
			throw new KmssRuntimeException(e);
		}
	}

	private static ISysOrgCoreService getSysOrgCoreService() {
		if (sysOrgCoreService == null)
			sysOrgCoreService = (ISysOrgCoreService) SpringBeanUtil
					.getBean("sysOrgCoreService");
		return sysOrgCoreService;
	}

	private static IAuthenticationValidateCore getAuthenticationValidateCore() {
		if (authenticationValidateCore == null)
			authenticationValidateCore = (IAuthenticationValidateCore) SpringBeanUtil
					.getBean("authenticationValidateCore");
		return authenticationValidateCore;
	}
}
