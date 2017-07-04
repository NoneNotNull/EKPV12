package com.landray.kmss.sys.news.util;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.imageio.ImageIO;

/**
 * <pre>
 * 2008-12-11
 * 图片压缩
 * </pre>
 * 
 * @author 傅游翔
 */
public class ImageUitlsBean {

	private int outputWidth = 250; // 默认输出图片宽

	private int outputHeight = 250; // 默认输出图片高

	private boolean proportion = true; // 是否等比缩放标记(默认为等比缩放)

	public void setOutputWidth(int outputWidth) {
		this.outputWidth = outputWidth;
	}

	public void setOutputHeight(int outputHeight) {
		this.outputHeight = outputHeight;
	}

	public void setWidthAndHeight(int width, int height) {
		this.outputWidth = width;
		this.outputHeight = height;
	}

	public boolean isProportion() {
		return proportion;
	}

	public void setProportion(boolean proportion) {
		this.proportion = proportion;
	}

	private static ImageUitlsBean instance = new ImageUitlsBean();

	public ImageUitlsBean() {
	}

	public static ImageUitlsBean getInstance() {
		return instance;
	}
	
	public ByteArrayInputStream compressImage(InputStream src) throws IOException {
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		compressImage(src, out);
		return new ByteArrayInputStream(out.toByteArray());
	}
	
	public void compressImage(InputStream src, OutputStream out) throws IOException {
		compressImage(src, out, outputWidth, outputHeight, proportion);
	}
	
	public void compressImage(InputStream src, OutputStream out, 
			int w, int h, boolean p) throws IOException {
		Image img = ImageIO.read(src);
    	int newWidth;
        int newHeight;
        
        if (p == true) {
        	// 为等比缩放计算输出的图片宽度及高度
            double rate1 = ((double) img.getWidth(null)) / (double) w + 0.1;
            double rate2 = ((double) img.getHeight(null)) / (double) h + 0.1;
            // 根据缩放比率大的进行缩放控制
            double rate = rate1 > rate2 ? rate1 : rate2;
            newWidth = (int) (((double) img.getWidth(null)) / rate);
            newHeight = (int) (((double) img.getHeight(null)) / rate);
        }
        else {
            newWidth = w; // 输出的图片宽度
            newHeight = h; // 输出的图片高度
        }
        
        BufferedImage tag = new BufferedImage((int) newWidth,   
                (int) newHeight, BufferedImage.TYPE_INT_RGB);
        
        /*  
         * Image.SCALE_SMOOTH 的缩略算法 生成缩略图片的平滑度的 优先级比速度高 生成的图片质量比较好 但速度慢  
         */   
        tag.getGraphics().drawImage(
        		img.getScaledInstance(newWidth, newHeight, Image.SCALE_SMOOTH), 
        		0, 0, null);
        
        ImageIO.write(tag, "jpeg", out);
	}

}
