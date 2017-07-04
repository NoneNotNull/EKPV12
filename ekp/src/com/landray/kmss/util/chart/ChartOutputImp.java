package com.landray.kmss.util.chart;

import java.awt.Font;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.CategoryItemLabelGenerator;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.labels.StandardPieSectionLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.Plot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.BarRenderer3D;
import org.jfree.chart.renderer.category.CategoryItemRenderer;
import org.jfree.chart.renderer.category.LineAndShapeRenderer;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;

public class ChartOutputImp implements ChartOutput {
	private Log logger = LogFactory.getLog(getClass());
	
	private Font chartTitleFont;
	private Font chartLabelFont;
	private Font axisTitleFont;
	private Font axisLabelFont;
	
	private void init(ChartConfig config) {
		/* 确定图表标题字体 */
		if (config.getChartTitleFont() != null)
			chartTitleFont = config.getChartTitleFont();
		else
			chartTitleFont = CHART_TITLE_FONT;
		/* 确定图表标签字体 */
		if (config.getChartLabelFont() != null)
			chartLabelFont = config.getChartLabelFont();
		else
			chartLabelFont = CHART_LABEL_FONT;
		/* 确定坐标轴标题字体 */
		if (config.getAxisTitleFont() != null)
			axisTitleFont = config.getAxisTitleFont();
		else
			axisTitleFont = AXIS_TITLE_FONT;
		/* 确定坐标轴标签字体 */
		if (config.getAxisLabelFont() != null)
			axisLabelFont = config.getAxisLabelFont();
		else
			axisLabelFont = AXIS_LABEL_FONT;
	}
	
	public void output(OutputStream stream, List dataList, ChartConfig config)
			throws IOException {
		init(config);
		JFreeChart chart = null;
		switch (config.getChartType()) {
		case TYPE_LINE:
		case TYPE_BAR:
			chart = generateLineAndBarChart(stream, dataList, config);
			break;
		case TYPE_PIE:
			chart = generatePieChart(stream, dataList, config);
			break;
		case TYPE_AREA:
			chart = generateAreaChart(stream, dataList, config);
			break;
		}
		ChartUtilities.writeChartAsJPEG(stream, 1, chart, config.getWidth(), config
				.getHigh(), null);
	}
	
	public void output(HttpServletResponse response, List dataList, ChartConfig config)
			throws IOException {
		output(response.getOutputStream(), dataList, config);
	}

	/** 生成曲线图和柱状图需要的数据集 */
	private CategoryDataset buildCategoryDataset(List dataList) {
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		for (Iterator iter = dataList.iterator(); iter.hasNext();) {
			Object obj = iter.next();
			if (obj instanceof ChartItem) {
				ChartItem item = (ChartItem) obj;
				dataset.addValue(item.getValue(), item.getRowKey(), item.getColumnKey());
			} else
				throw new IllegalArgumentException("dataList中每个元素必须都是ChartItem类型。");
		}
		return dataset;
	}

	/** 生成饼图需要的数据集 */
	private PieDataset buildPieDataset(List dataList) {
		DefaultPieDataset dataset = new DefaultPieDataset();
		for (Iterator iter = dataList.iterator(); iter.hasNext();) {
			Object obj = iter.next();
			if (obj instanceof ChartItem) {
				ChartItem item = (ChartItem) obj;
				dataset.setValue(item.getColumnKey(), item.getValue());
			} else
				throw new IllegalArgumentException("dataList中每个元素必须都是ChartItem类型。");
		}
		return dataset;
	}

	/** 生成曲线图和柱状图 */
	private JFreeChart generateLineAndBarChart(OutputStream stream, List dataList,
			ChartConfig config) throws IOException {
		CategoryDataset dataset = buildCategoryDataset(dataList); // 构造数据集
		logger.debug("chartTitle=" + config.getChartTitle());
		logger.debug("rowTitle=" + config.getRowTitle());
		logger.debug("columnTitle=" + config.getColumnTitle());
		CategoryItemRenderer renderer = generateRender(dataset, config); // 构造图表对象
		ValueAxis valueAxis = new NumberAxis(config.getColumnTitle()); // 构造纵坐标
		CategoryAxis categoryAxis = new CategoryAxis(config.getRowTitle()); // 构造横坐标
		valueAxis.setLabelFont(axisTitleFont);
		valueAxis.setTickLabelFont(axisLabelFont);
		valueAxis.setUpperMargin(0.15); //设置最高的一个柱与图片顶端的距离
		categoryAxis.setLabelFont(axisTitleFont);
		categoryAxis.setTickLabelFont(axisLabelFont);
		
		/* 横轴上的Lable 45度倾斜 */
		if (config.isCategoryLabelIncline())
			categoryAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
		
		Plot plot = new CategoryPlot(dataset, categoryAxis, valueAxis, renderer);
		JFreeChart chart = new JFreeChart(config.getChartTitle(), chartTitleFont, plot, config
				.isCreateLegend());
		return chart;
	}

	/** 生成饼图 */
	private JFreeChart generatePieChart(OutputStream stream, List dataList, ChartConfig config)
			throws IOException {
		PieDataset dataset = buildPieDataset(dataList); // 构造数据集
		JFreeChart chart = ChartFactory.createPieChart3D(config.getChartTitle(), dataset,
				config.isCreateLegend(), true, false); // 构造图表对象
		TextTitle title = new TextTitle(config.getChartTitle(), chartTitleFont);
		chart.setTitle(title);
		PiePlot plot = (PiePlot) chart.getPlot();
		plot.setLabelFont(chartLabelFont);
		plot.setLabelGenerator(new StandardPieSectionLabelGenerator("{1} ({2})"));
		return chart;
	}
	
	/** 生成面积图 */
	private JFreeChart generateAreaChart(OutputStream stream, List dataList, ChartConfig config)
			throws IOException {
		CategoryDataset dataset = buildCategoryDataset(dataList); // 构造数据集
		ValueAxis valueAxis = new NumberAxis(config.getColumnTitle()); // 构造纵坐标
		CategoryAxis categoryAxis = new CategoryAxis(config.getRowTitle()); // 构造横坐标
		valueAxis.setLabelFont(axisTitleFont);
		valueAxis.setTickLabelFont(axisLabelFont);
		categoryAxis.setLabelFont(axisTitleFont);
		categoryAxis.setTickLabelFont(axisLabelFont);
		categoryAxis.setLowerMargin(0.0); // 左边空白
		categoryAxis.setUpperMargin(0.0); // 右边空白
		categoryAxis.setCategoryMargin(0); // 各值之间的空白
		/* 横轴上的Lable 45度倾斜 */
		if (config.isCategoryLabelIncline())
			categoryAxis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
		 /* create a chart  */
        final JFreeChart chart = ChartFactory.createAreaChart(
            config.getChartTitle(), config.getRowTitle(), config.getColumnTitle(),
            dataset,                  // data
            PlotOrientation.VERTICAL, // orientation
            true,                     // include legend
            false,                     // tooltips
            false                     // urls
        );
        final CategoryPlot plot = chart.getCategoryPlot();
        plot.setForegroundAlpha(0.5f); // 透明度
        plot.setDomainAxis(categoryAxis);
        plot.setRangeAxis(valueAxis);
        plot.setDomainGridlinesVisible(true);
        plot.setRangeGridlinesVisible(true);
        return chart;
	}

	private CategoryItemRenderer generateRender(CategoryDataset dataset, ChartConfig config) {
		CategoryItemRenderer categoryItemRenderer = null;
		switch (config.getChartType()) {
		case TYPE_LINE:
			LineAndShapeRenderer renderer = new LineAndShapeRenderer();
			renderer.setShapesFilled(false);
			categoryItemRenderer = renderer;
			break;
		case TYPE_BAR:
			BarRenderer3D renderer2 = new BarRenderer3D();
			renderer2.setItemMargin(0.1);
			categoryItemRenderer = renderer2;
			break;
		}
		if (categoryItemRenderer != null) {
			CategoryItemLabelGenerator ategoryItemLabelGenerator = new StandardCategoryItemLabelGenerator();
//			ategoryItemLabelGenerator.generateColumnLabel(dataset, 0);
			categoryItemRenderer.setItemLabelGenerator(ategoryItemLabelGenerator);
			categoryItemRenderer.setItemLabelsVisible(true);
			categoryItemRenderer.setItemLabelFont(chartLabelFont);
//			categoryItemRenderer.setItemLabelPaint(Color.BLUE);
		}
		return categoryItemRenderer;
	}
}
