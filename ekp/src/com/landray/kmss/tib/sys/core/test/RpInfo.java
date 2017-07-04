package com.landray.kmss.tib.sys.core.test;

public class RpInfo {
	//被替换的源
		String rp_src;
//		替换的文字
		String rp_tar;
		
		public RpInfo(String rp_src, String rp_tar) {
			this.rp_src = rp_src;
			this.rp_tar = rp_tar;
		}
		public String getRp_src() {
			return rp_src;
		}
		public void setRp_src(String rp_src) {
			this.rp_src = rp_src;
		}
		public String getRp_tar() {
			return rp_tar;
		}
		public void setRp_tar(String rp_tar) {
			this.rp_tar = rp_tar;
		}
		
}
