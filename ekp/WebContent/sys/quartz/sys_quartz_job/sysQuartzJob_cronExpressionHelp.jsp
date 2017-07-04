<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<p>
一个Cron-表达式是一个由六至七个字段组成由空格分隔的字符串，其中6个字段是必须的而一个是可选的，如下：  <br>
 
 <table cellspacing="8" class="tb_noborder">
 <tr>
 <th align="left">字段名</th>
 <th align="left">&nbsp;</th>
 <th align="left">允许的值</th>
 <th align="left">&nbsp;</th>
 <th align="left">允许的特殊字符</th>
 </tr>
 <tr>
 <td align="left"><code>秒</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>0-59</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>分</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>0-59</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>小时</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>0-23</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>日</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>1-31</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * ? / L W C</code></td>
 </tr>
 <tr>
 <td align="left"><code>月</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>1-12 or JAN-DEC</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>周</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>1-7 or SUN-SAT</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * ? / L C #</code></td>
 </tr>
 <tr>
 <td align="left"><code>年 (可选字段)</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>empty, 1970-2099</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 </table>
 </p>
 
 <p>
'*' 字符可以用于所有字段，在“分”字段中设为"*"表示"每一分钟"的含义。 
 </p>
 
 <p>
'?' 字符可以用在“日”和“周几”字段. 它用来指定 '不明确的值'. 这在你需要指定这两个字段中的某一个值而不是另外一个的时候会被用到。
在后面的例子中可以看到其含义。 
 </p>
 
 <p>
'-' 字符被用来指定一个值的范围，比如在“小时”字段中设为"10-12"表示"10点到12点". 
 </p>
 
 <p>
',' 字符被用来指定数个值。如：“MON,WED,FRI”在星期域里表示”星期一、星期三、星期五”. 
 </p>
 
 <p>
'/' 字符用来指定一个值的的增加幅度. 比如在“秒”字段中设置为"0/15"表示"第0, 15, 30, 和 45秒"。而 "5/15"则表示"第5, 20, 35, 和 50". 
在'/'前加"*"字符相当于指定从0秒开始. 每个字段都有一系列可以开始或结束的数值。对于“秒”和“分”字段来说，其数值范围为0到59，对于“小时”
字段来说其为0到23, 对于“日”字段来说为0到31, 而对于“月”字段来说为1到12。"/"字段仅仅只是帮助你在允许的数值范围内从开始"第n"的值。 
因此 对于“月”字段来说"7/6"只是表示7月被开启而不是“每六个月”, 请注意其中微妙的差别。 
 </p>
 
 <p>
 'L'字符可用在“日”和“周几”这两个字段。它是"last"的缩写, 但是在这两个字段中有不同的含义。例如,“日”字段中的"L"表示"一个月中的最后一天
 " —— 对于一月就是31号对于二月来说就是28号（非闰年）。而在“周几”字段中, 它简单的表示"7" or "SAT"，但是如果在“周几”字段中使用时跟在
 某个数字之后, 它表示"该月最后一个星期×" —— 比如"6L"表示"该月最后一个周五"。当使用'L'选项时,指定确定的列表或者范围非常重要，否则你会
 被结果搞糊涂的。 
 </p>
 
 <p>
'W' 可用于“日”字段。用来指定历给定日期最近的工作日(周一到周五) 。比如你将“日”字段设为"15W"，意为: "离该月15号最近的工作日"。因此如果
15号为周六，触发器会在14号即周五调用。如果15号为周日, 触发器会在16号也就是周一触发。如果15号为周二,那么当天就会触发。然而如果你将“日”
字段设为"1W", 而一号又是周六, 触发器会于下周一也就是当月的3号触发,因为它不会越过当月的值的范围边界。'W'字符只能用于“日”字段的值为单独
的一天而不是一系列值的时候。   
 </p>
 
 <p>
 'L'和'W'可以组合用于“日”字段表示为'LW'，意为"该月最后一个工作日"。 
 </p>
 
 <p>
'#' 字符可用于“周几”字段。该字符表示“该月第几个周×”，比如"6#3"表示该月第三个周五( 6表示周五而"#3"该月第三个)。再比如: "2#1" = 表示该
月第一个周一而 "4#5" = 该月第五个周三。注意如果你指定"#5"该月没有第五个“周×”，该月是不会触发的。
 </p>
 
 <p>
'C' 字符可用于“日”和“周几”字段，它是"calendar"的缩写。 它表示为基于相关的日历所计算出的值（如果有的话）。如果没有关联的日历, 那它等同于
包含全部日历。“日”字段值为"5C"表示"日历中的第一天或者5号以后"，“周几”字段值为"1C"则表示"日历中的第一天或者周日以后"。 
 </p>
 
 <p>
对于“月份”字段和“周几”字段来说合法的字符都不是大小写敏感的。 
 </p>
 
 <p>
 下面是一些完整的例子:  <br><table cellspacing="8" class="tb_noborder">
 <tr>
 <th align="left">表达式</th>
 <th align="left">&nbsp;</th>
 <th align="left">含义</th>
 </tr>
 <tr>
 <td align="left"><code>"0 0 12 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天中午十二点触发</code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * *"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天早上10：15触发 </code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天早上10：15触发 </code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 * * ? *"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天早上10：15触发 </code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 * * ? 2005"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>2005年的每天早上10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 * 14 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天从下午2点开始到2点59分每分钟一次触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 0/5 14 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天从下午2点开始到2：55分结束每5分钟一次触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 0/5 14,18 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天的下午2点至2：55和6点至6点55分两个时间段内每5分钟一次触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 0-5 14 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每天14:00至14:05每分钟一次触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 10,44 14 ? 3 WED"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>三月的每周三的14：10和14：44触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * MON-FRI"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每个周一、周二、周三、周四、周五的10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 15 * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每月15号的10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 L * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每月的最后一天的10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6L"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每月最后一个周五的10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6L"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每月最后一个周五的10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6L 2002-2005"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>2002年至2005年的每月最后一个周五的10：15触发 </code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6#3"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>每月的第三个周五的10：15触发 </code>
 </td>
 </tr>
 </table>
 </p>
<br> 
 <p>
 A "Cron-Expression" is a string comprised of 6 or 7 fields separated by
 white space. The 6 mandatory and 1 optional fields are as follows: <br>
 
 <table cellspacing="8" class="tb_noborder">
 <tr>
 <th align="left">Field Name</th>
 <th align="left">&nbsp;</th>
 <th align="left">Allowed Values</th>
 <th align="left">&nbsp;</th>
 <th align="left">Allowed Special Characters</th>
 </tr>
 <tr>
 <td align="left"><code>Seconds</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>0-59</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>Minutes</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>0-59</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>Hours</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>0-23</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>Day-of-month</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>1-31</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * ? / L W C</code></td>
 </tr>
 <tr>
 <td align="left"><code>Month</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>1-12 or JAN-DEC</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 <tr>
 <td align="left"><code>Day-of-Week</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>1-7 or SUN-SAT</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * ? / L C #</code></td>
 </tr>
 <tr>
 <td align="left"><code>Year (Optional)</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>empty, 1970-2099</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>, - * /</code></td>
 </tr>
 </table>
 </p>
 
 <p>
 The '*' character is used to specify all values. For example, "*" in the
 minute field means "every minute".
 </p>
 
 <p>
 The '?' character is allowed for the day-of-month and day-of-week fields. It
 is used to specify 'no specific value'. This is useful when you need to
 specify something in one of the two fileds, but not the other. See the
 examples below for clarification.
 </p>
 
 <p>
 The '-' character is used to specify ranges For example "10-12" in the hour
 field means "the hours 10, 11 and 12".
 </p>
 
 <p>
 The ',' character is used to specify additional values. For example
 "MON,WED,FRI" in the day-of-week field means "the days Monday, Wednesday,
 and Friday".
 </p>
 
 <p>
 The '/' character is used to specify increments. For example "0/15" in the
 seconds field means "the seconds 0, 15, 30, and 45". And "5/15" in the
 seconds field means "the seconds 5, 20, 35, and 50". You can also specify
 '/' after the '*' character - in this case '*' is equivalent to having '0'
 before the '/'.
 </p>
 
 <p>
 The 'L' character is allowed for the day-of-month and day-of-week fields.
 This character is short-hand for "last", but it has different meaning in
 each of the two fields. For example, the value "L" in the day-of-month field
 means "the last day of the month" - day 31 for January, day 28 for February
 on non-leap years. If used in the day-of-week field by itself, it simply
 means "7" or "SAT". But if used in the day-of-week field after another
 value, it means "the last xxx day of the month" - for example "6L" means
 "the last friday of the month". When using the 'L' option, it is important
 not to specify lists, or ranges of values, as you'll get confusing results.
 </p>
 
 <p>
 The 'W' character is allowed for the day-of-month field.  This character 
 is used to specify the weekday (Monday-Friday) nearest the given day.  As an 
 example, if you were to specify "15W" as the value for the day-of-month 
 field, the meaning is: "the nearest weekday to the 15th of the month".  So
 if the 15th is a Saturday, the trigger will fire on Friday the 14th.  If the
 15th is a Sunday, the trigger will fire on Monday the 16th.  If the 15th is
 a Tuesday, then it will fire on Tuesday the 15th.  However if you specify
 "1W" as the value for day-of-month, and the 1st is a Saturday, the trigger
 will fire on Monday the 3rd, as it will not 'jump' over the boundary of a 
 month's days.  The 'W' character can only be specified when the day-of-month 
 is a single day, not a range or list of days.  
 </p>
 
 <p>
 The 'L' and 'W' characters can also be combined for the day-of-month 
 expression to yield 'LW', which translates to "last weekday of the month".
 </p>
 
 <p>
 The '#' character is allowed for the day-of-week field. This character is
 used to specify "the nth" XXX day of the month. For example, the value of
 "6#3" in the day-of-week field means the third Friday of the month (day 6 =
 Friday and "#3" = the 3rd one in the month). Other examples: "2#1" = the
 first Monday of the month and "4#5" = the fifth Wednesday of the month. Note
 that if you specify "#5" and there is not 5 of the given day-of-week in the
 month, then no firing will occur that month.
 </p>
 
 <p>
 The 'C' character is allowed for the day-of-month and day-of-week fields.
 This character is short-hand for "calendar". This means values are
 calculated against the associated calendar, if any. If no calendar is
 associated, then it is equivalent to having an all-inclusive calendar. A
 value of "5C" in the day-of-month field means "the first day included by the
 calendar on or after the 5th". A value of "1C" in the day-of-week field
 means "the first day included by the calendar on or after sunday".
 </p>
 
 <p>
 The legal characters and the names of months and days of the week are not
 case sensitive.
 </p>
 
 <p>
 Here are some full examples: <br><table cellspacing="8" class="tb_noborder">
 <tr>
 <th align="left">Expression</th>
 <th align="left">&nbsp;</th>
 <th align="left">Meaning</th>
 </tr>
 <tr>
 <td align="left"><code>"0 0 12 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 12pm (noon) every day</code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * *"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am every day</code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am every day</code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 * * ? *"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am every day</code></td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 * * ? 2005"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am every day during the year 2005</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 * 14 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire every minute starting at 2pm and ending at 2:59pm, every day</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 0/5 14 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire every 5 minutes starting at 2pm and ending at 2:55pm, every day</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 0/5 14,18 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire every 5 minutes starting at 2pm and ending at 2:55pm, AND fire every 5 minutes starting at 6pm and ending at 6:55pm, every day</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 0-5 14 * * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire every minute starting at 2pm and ending at 2:05pm, every day</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 10,44 14 ? 3 WED"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 2:10pm and at 2:44pm every Wednesday in the month of March.</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * MON-FRI"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am every Monday, Tuesday, Wednesday, Thursday and Friday</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 15 * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am on the 15th day of every month</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 L * ?"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am on the last day of every month</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6L"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am on the last Friday of every month</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6L"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am on the last Friday of every month</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6L 2002-2005"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am on every last friday of every month during the years 2002, 2003, 2004 and 2005</code>
 </td>
 </tr>
 <tr>
 <td align="left"><code>"0 15 10 ? * 6#3"</code></td>
 <td align="left">&nbsp;</th>
 <td align="left"><code>Fire at 10:15am on the third Friday of every month</code>
 </td>
 </tr>
 </table>
 </p>
 
 <p>
 Pay attention to the effects of '?' and '*' in the day-of-week and
 day-of-month fields!
 </p>
 
 <p>
 <b>NOTES:</b>
 <ul>
 <li>Support for the features described for the 'C' character is not
 complete.</li>
 <li>Support for specifying both a day-of-week and a day-of-month value is
 not complete (you'll need to use the '?' character in on of these fields).
 </li>
 <li>Be careful when setting fire times between mid-night and 1:00 AM -
 "daylight savings" can cause a skip or a repeat depending on whether the
 time moves back or jumps forward.</li>
 </ul>
 </p>