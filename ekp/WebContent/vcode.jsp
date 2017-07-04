
<%@page import="java.io.OutputStream"%><%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="java.awt.Color"%>
<%@ page import="java.awt.Font"%>
<%@ page import="java.awt.Graphics"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="java.util.Random"%>
<%
    response.reset();
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", -1);

	BufferedImage img = new BufferedImage(68, 22,
			BufferedImage.TYPE_INT_RGB);
	// 得到该图片的绘图对象

	Graphics g = img.getGraphics();
	Random r = new Random();
	Color c = new Color(200, 150, 255);
	g.setColor(c);
	// 填充整个图片的颜色
	g.fillRect(0, 0, 68, 22);
	// 向图片中输出数字和字母
	StringBuffer sb = new StringBuffer();
	char[] ch = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789".toCharArray();
	int index, len = ch.length;
	for (int i = 0; i < 4; i++) {
		index = r.nextInt(len);
		g.setColor(new Color(r.nextInt(88), r.nextInt(188), r
				.nextInt(255)));
		g.setFont(new Font("Arial", Font.BOLD | Font.ITALIC, 22));// 输出的
		g.drawString("" + ch[index], (i * 15) + 3, 18);// 写什么数字，在图片
		sb.append(ch[index]);
	}
	request.getSession().setAttribute("VALIDATION_CODE", sb.toString());
 
	OutputStream outStream = response.getOutputStream();
	ImageIO.write(img, "JPG", outStream);
	out.clear();  
	out=pageContext.pushBody();  
%>