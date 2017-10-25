<!-- TOC -->

- [ASP.NET基础](#aspnet基础)
    - [状态管理](#状态管理)
        - [数据缓存](#数据缓存)
            - [Session](#session)
            - [Application](#application)
            - [Cache](#cache)
            - [Cookie](#cookie)
        - [数据传递问题](#数据传递问题)
            - [Request](#request)
            - [Response](#response)
    - [ASP.NET静态网页实现简单登录跳转](#aspnet静态网页实现简单登录跳转)
    - [Ajax](#ajax)
        - [同步异步](#同步异步)
        - [通过js请求](#通过js请求)
    - [JSON](#json)
    - [疑难杂症](#疑难杂症)
        - [CompositionFailedException](#compositionfailedexception)

<!-- /TOC -->
# ASP.NET基础
## 状态管理
在开发互联网程序时，不可避免的几个问题需要解决：
1. 程序数据有些是某个用户独享，而有些是所有用户共享，这块如何设计？
2. 用户在浏览器中输入的数据如何传递给服务器，在服务器中又该如何存储管理？

所谓“状态管理”，是指使用ASP.NET中的ViewState、Cookie、Session和Application等对象实现页面数据缓存和传递的技术。

在ASP.NET中，状态管理会被划分为两大类：
![](..\assets\ASP.NET\状态管理.png)

可以说状态管理对象依附在内置对象而工作的。下面是这些内置对象的常见属性和方法：

```cs
Context
	.Cache["key"]
	.Session["key"]
	.Request
		.Cookies["key"]			//获取客户端的cookie值
		.QueryString["key"]		//收集 http get请求传递的数据
		.Form["key"]			//收集 http post 请求传递的数据
	.Server
		.Transfer(string url)	//终止当前页，执行一个新页
		.UrlEncode(string str)	//对字符串进行URL编码
		.UrlDecode(string str)	//对字符串进行URL解码并返回结果
	.Response
		.Cookies["key"]			//设置发送给客户端的Cookie值
		.Redirect(string url)	//重定向到另一个URL
		.Write(string str)		//将数据以超文本格式发送到浏览器上
```

其中：
1. Request：HTTP请求对象，用于收集从客户端传递而来的信息。
2. Response：HTTP响应对象，用于收集服务器端的信息，并发送到浏览器。
3. Context：当前上下文对象，封装了与当前页关联的信息。

### 数据缓存

方法 | 信息量大小 | 作用域和保存时间 | 应用范围 | 保存位置
---|-------|----------|------|-----
Application | 任意大小 | 整个应用程序的生命周期 | 整个应用程序/所有用户 | 服务器端
Cache | 任意大小 | 可以根据需要设定 | 整个应用程序/所有用户 | 服务器端
Session | 小量,简单的数据 | 用户活动时间+一段延迟时间(一般为20分钟) | 单个用户 | 服务器端
Cookie | 小量,简单的数据 | 可以根据需要设定 | 单个用户 | 客户端
隐藏域 | 小量,简单的数据 | 一个Web页面的生命期 | 单个用户 | 客户端
查询字符串 | 小量,简单的数据 | 直到下次页面跳转请求 | 单个用户 | 客户端

可以在全局应用程序类(Global.asax)中进行数据缓存的模拟。

#### Session

要想在.ashx中引用 session 必须 using System.Web.SessionState ，继承IReadOnlySessionState/IRequiresSessionState

IReadOnlySessionState,为只读的session 不可以修改

IRequiresSessionState ，可以修改。

单用户数据独享时使用，属于会话级别对象；允许通过将对象存储在 Web 服务器的内存中在整个用户会话过程中保持任何对象；每个用户的Session对象是通过SessionID来识别的，该SessionID默认是由客户端的Cookie来存储并传输的。

Session可以保存任何类型的值，包括类的实例：`Session["UserName"] = " jack ";`
```cs
//存放信息
Session["key"]="value";
//读取数据
string UserName = Session["key"].ToString();

// Outside of Web Forms page class, use HttpContext.Current.
HttpContext context = HttpContext.Current;
context.Session["FirstName"] = firstName;
firstName = (string)(context.Session["FirstName"]);
```

#### Application
多用户数据共享时使用，属于应用程序级别对象；用它保存的数据会在一个应用内多个用户信息共享，并在服务器运行期间持久保存该数据。服务器一关闭，Application对象就自动消失。允许共享 ASP.NET 应用程序内多个会话和请求之间的全局信息。

在服务器内存中存储数量较少又独立于用户请求的数据：`Application[“key"] = value ;`

```cs
Application.Lock();//同步,避免同时写入

Application["CurrentGuests"] =(int)Application["CurrentGuests"]+ 1;//总在线用户数
Application["AllGuests"] =(int)Application["AllGuests"]+ 1;//访问网站的总用户数

Application.UnLock();//同步结束
```

#### Cache
Cache对象用于在HTTP请求间保存页面或数据。该对象的使用可以极大地提高整个应用程序的效率。常用于将频繁访问的大量服务器资源存储在内存中，当用户发出相同的请求后服务器不再次处理而是将Cache中保存的信息返回给用户，节省了服务器处理请求的时间。其生存期依赖于该应用程序的生存期。当重新启动应用程序时，将重新创建其Cache对象的实例。使用Cache对象保存信息的代码如下。

```cs
//存放信息
context.Cache["nameID"]="0001";
//存放信息
context.Cache.Insert("nameID","0001");
//读取信息
string NameID = context.Cache["nameID"].ToString();
```

#### Cookie
Cookie 提供了一种在 Web 应用程序中存储用户特定信息的方法。例如，当用户访问您的站点时，您可以使用 Cookie 存储用户首选项或其他信息。当该用户再次访问您的网站时，应用程序便可以检索以前存储的信息。

```cs
/*
cookie的设置
*/
context.Response.Cookies["CurUser"]["name"] = name;
context.Response.Cookies["CurUser"]["pwd"] = pwd;
//设置过期时间为1小时
context.Response.Cookies["CurUser"].Expires = DateTime.Now.AddHours(1);

HttpCookie hcookie = new HttpCookie("CurAdmin");
hcookie["uid"] = name;
hcookie["pass"] = pwd;
//30s后过期
hcookie.Expires = DateTime.Now.AddSeconds(30);
context.Response.Cookies.Add(hcookie);

/*
cookie的读取
*/
if (context.Request.Cookies["CurUser"] != null)
{
	string userSettings;
	if (context.Request.Cookies["CurUser"]["name"] != null)
	{
		userSettings = context.Request.Cookies["CurUser"]["name"];
	}
}

/*
不能直接删除用户计算机中的 Cookie。但是，可以通过将 Cookie 的到期日期设置为过去的日期，让用户的浏览器来删除 Cookie。
当用户下一次向设置该 Cookie 的域或路径内的页发出请求时，浏览器将确定该 Cookie 已到期并将其移除。
*/
if (context.Request.Cookies["CurUser"] != null)
{
    HttpCookie myCookie = new HttpCookie("CurUser");
    myCookie.Expires = DateTime.Now.AddDays(-1d);
    context.Response.Cookies.Add(myCookie);
}

```
```js
//js读取cookie
document.cookie;
```

### 数据传递问题
#### Request
请求对象，用来从客户端取得信息，包括浏览器种类、用户输入表单的数据、Cookies中的数据等信息。

当客户端发出请求执行asp.net程序时，CLR会将客户端的请求信息包含在Request对象中。
可以通过Request.<Collection>方式来使用该对象，其中Collection包括四种集合：
1. QueryString：收集请求url地址中"?"号后面的数据
2. Form：收集post方法传递的数据
3. Cookies：获取客户端的Cookie值
4. ServerVariables：获得环境变量值

#### Response
响应对象，用于将服务器端的信息发送到浏览器，包括：
1. 将服务器端的数据用超文本的格式发送到浏览器上：Response.Write(“js脚本或html脚本”);
2. 重定向浏览器到另一个URL：Response.Redirect(“url”, true);
3. 设置Cookie的值：Response.Cookies.Add(cookie);

## ASP.NET静态网页实现简单登录跳转
新建Web应用程序，如下图：
![](..\assets\asp.net\HtmlLoginDemo1.png)

选择Empty空模板，如下图：
![](..\assets\asp.net\HtmlLoginDemo2.png)

添加Login.html文件并设为起始页，如下图：

![](..\assets\asp.net\HtmlLoginDemo1.gif)

Login.html内容如下：
```html
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>登录</title>
    <meta charset="utf-8" />
</head>
<body>
    <h1>欢迎使用xxxx</h1>
    <form>
        <table>
            <tr>
                <td><label for="txtName">用户名：</label></td>
                <td><input type="text" id="txtName" name="name"/></td>
            </tr>
            <tr>
                <td><label for="txtPwd">密码：</label></td>
                <td><input type="password" id="txtPwd" name="pwd"/></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" />
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
```

以上，即可以通过开始执行(ctrl+f5)通过浏览器查看该页面。

实现后台的验证功能，通过一般处理程序，接收form表单的提交。新建一般处理程序(HomeHandler.ashx)，结构如下：
```cs
/// <summary>
/// HomeHandler 的摘要说明
/// </summary>
public class HomeHandler : IHttpHandler
{
	/// <summary>
	/// 处理http请求
	/// </summary>
	/// <param name="context"></param>
	public void ProcessRequest(HttpContext context)
	{
		context.Response.ContentType = "text/plain";
		context.Response.Write("Hello World");
	}

	/// <summary>
	/// 获取一个值，该值指示其他请求是否可以使用 IHttpHandler 实例。
	/// 如果 IHttpHandler 实例可再次使用，则为 true；否则为 false。 
	/// 默认为false即可
	/// </summary>
	public bool IsReusable
	{
		get
		{
			return false;
		}
	}
}
```

修改上述Login.html中form的action为对应的处理程序，如下：
```html
<form id="form1" action="/HomeHandler.ashx" method="post">
```

修改HomeHandler.ashx一般处理程序的ProcessRequest方法，内容如下：
```cs
/// <summary>
/// 处理http请求
/// </summary>
/// <param name="context"></param>
public void ProcessRequest(HttpContext context)
{
	context.Response.ContentType = "text/html";

	//Request["xxx"]中的xxx对应表单中元素的name属性，而不是id属性！
	string name = context.Request["name"];
	string pwd = context.Request["pwd"];

	if (name == "admin" && pwd == "1")
	{
		context.Response.Write("<script>alert('登录成功！');</script>");
	}
	else
	{
		context.Response.Write("<script>alert('不存在该用户！');</script>");
	}
}
```

通过表单提交，即可进行再后台进行验证登录是否成功。以上，就是一个简单的登录demo。

拓展，可以添加另外一个页面Index.html，实现验证成功后跳转到另一个静态页面，在验证成功后添加如下跳转代码：
```cs
context.Server.Transfer("Index.html");
```

这种方式的弊端是表单提交即发生跳转，无论验证成功与否。这个问题后面会讲到。。。

## Ajax
### 同步异步
同步：发送方发出请求后，等接收方发回响应后，才会发送下一个请求。

异步：发送方发出请求后，不等接收方发回响应，直接发送下一个请求。

### 通过js请求

原生js的ajax请求流程：

```js
1）创建XMLHttpRequest对象
        var req = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");

2）发送AJAX请求
	GET请求：
	req.open('GET', './Handlers/AjaxHandler.ashx?username=zhangsan&sex=boy', true);
	req.send(null);
	POST请求：
	req.open('POST', './Handlers/AjaxHandler.ashx', true);
	req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	req.send('username=zhangsan&sex=boy');

3）接收AJAX响应
	req.onreadystatechange = function () {
		if (req.readyState == 4 && req.status == 200) {
			alert('响应消息的正文内容：' + req.responseText);
		}
	};
	其中，readyState可以取如下值：
			0 (未初始化，XMLHttpRequest对象已经创建，但尚未初始化，还没有调用open方法)
			1 (已经调用send方法，正在发送HTTP请求) 
			2 (send方法调用结束，已经接收到全部HTTP响应消息) 
			3 (正在解析响应内容，但状态和响应头还不可用) 
			4 (完成)
```


原生js封装ajax流程：
```js
//调用示例
myAjax({
	url: '../Handler/HomeHandler.ashx/Add',
	type: 'POST',
	data: {
		name: name,
		pwd: pwd
	},
	success: function (data) {
		if (data == 'true') {
			alert('注册成功');
		} else {
			alert('未注册成功');
		}
	},
	error: function (err) {
		alert('请求发生异常');
		console.error(err);
	}
});

/*
参数说明：
option = {
	url:'',//请求的地址
	type:'POST',//请求类型 POST或GET
	data:{},//传输的数据
	success:function(data){},//成功响应后的回调函数
	error:function(err){},//失败后的回调函数
}
*/
function myAjax(option) {
	//1、创建XMLHttpRequest对象
	var req = window.XMLHttpRequest ? new XMLHttpRequest() : new ActiveXObject("Microsoft.XMLHTTP");

	//默认为GET方式
	option.type = option.type || "GET";

	//2、发送AJAX请求
	if (option.type == "GET") {
		req.open('GET', option.url, true);
		req.send(null);
	} else {
		req.open('POST', option.url, true);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(formatParams(option.data));
	}

	//3、接收AJAX响应
	/*
	其中，readyState可以取如下值：
	0 (未初始化，XMLHttpRequest对象已经创建，但尚未初始化，还没有调用open方法)
	1 (已经调用send方法，正在发送HTTP请求)
	2 (send方法调用结束，已经接收到全部HTTP响应消息)
	3 (正在解析响应内容，但状态和响应头还不可用)
	4 (完成)
	*/
	req.onreadystatechange = function () {
		if (req.readyState == 4 && req.status == 200) {
			option.success(req.response);
		} else if (req.readyState == 4) {
			option.error(req.response);
		}
	}
}
		
//格式化参数
function formatParams(data) {
	var arr = [];
	for (var name in data) {
		arr.push(encodeURIComponent(name) + "=" + encodeURIComponent(data[name]));
	}
	arr.push(("v=" + Math.random()).replace(".", ""));
	return arr.join("&");
}
```

## JSON
JSON(JavaScript Object Notation)是一种轻量级的数据交换格式，易于人阅读和编写，同时也易于机器解析和生成。它可以构建以下两种结构：
1. “名称/值”对的集合
2. 值的有序列表（数组）

JSON在大多数的情况下作为AJAX的数据交换格式而不是XML。因为JSON有一些明显的优点：
1. 语法更简单，数据传输量更少
2. Javascript解码JSON数据容易并且效率高

在JavaScript中提供了JSON对象，帮助我们将js对象转换为json字符串或者是将json字符串转换为js对象。
```js
//将js对象转换为字符串
JSON.stringify({name:'jack',age:12});// '{"name":"jack","age":12}'

//将js数组转换为字符串
JSON.stringify(['jack','lucy','smith']);// '["jack","lucy","smith"]'

//将复杂对象转换为字符串 -> '{"region":"芜湖市","citys":["镜湖区","弋江区","鸠江区","三山区"]}'
JSON.stringify({region:'芜湖市',citys:['镜湖区','弋江区','鸠江区','三山区']});

//将字符串转换为对象
JSON.parse('{"id":123,"userid":"coder1"}');// {id: 123, userid: "coder1"}
```

## 疑难杂症
### CompositionFailedException

![](..\assets\asp.net\Microsoft.VisualStudio.Composition.CompositionFailedException.png)

参考 
[Javascript and css intellisense not working](https://connect.microsoft.com/VisualStudio/feedback/details/1288784/javascript-and-css-intellisense-not-working)

由 Microsoft 在 2015/5/14 於 14:17 公佈
Giacomo,

Would you please try the following:

1. Exit Visual Studio
2. Delete the following folder 

%LOCALAPPDATA%\Microsoft\VisualStudio\14.0\ComponentModelCache

That folder is hidden by default, so you may need to change Windows Explorer settings in order to see it (you can follow steps similar to http://windows.microsoft.com/en-us/windows/show-hidden-files#show-hidden-files=windows-7).

3. Re-start Visual Studio and see if the issue is resolved. 

I would appreciate if you would let us know if that resolved your issue.

Thanks,
Alex Gavrilov
由 Microsoft 在 2015/4/29 於 8:04 公佈
Thank you for your feedback, we are currently reviewing the issue you have submitted. If you require immediate assistance with this issue, please contact product support at http://support.microsoft.com/ph/1117.