测试地址：http://test.o2lx.com:9090

Get参数形式:要进行URL编码，再进行GET提交 例子:


---
接口格式遵循：

 {  
    "err_code" : "200",  
    "msg" : "true",  
    "data" : { }  
} 

需要增加data一层的接口有：  
9. 添加评论  
10. 收藏活动  
11. 点击搜藏，查看用户收藏的活动  
12.取消收藏  
13. 修改昵称、性别、绑定手机的接口  
14.登录  
15.注册用户  
17 验证短信验证码  
17. 增加反馈  
18 添加活动到购物车  
19  获取购物车的信息  
20 修改购物车的商品  
21 删除购物车商品  
23 清空购物车  
25 新增联系人  
26 删除联系人  
27 设置默认联系人  
28 编辑联系人  
29 显示订单列表  
修改部分：
1.增加adultPrice 等3个Price 
2.外面data后面增加一层 orders。
3。增加Data

30 取消订单和支付 
35 上传用户头像  
36 退出登陆  

---

---
二. 接口修改，经过测试，文档和接口有修改的地方如下：     
6.在点赞数最多的活动中按类型搜索      
6.1文档增加 "accurateTag":””,程序返回结果原来就是正确的。   
7. 点击活动进入详情页     
7.1 更正文档错误	           	actiDesc:"",
           	actiId:”” 到actiDay 到外面，原程序返回无误。   
8. 加载评论    
8.1 "userImage" : “", 统一修改为："userImg":""   

---

---

	1. 加载首页活动  
/trip/ws/rest_acti/indexActi?paramjson={longitude="",latitude="",startPage:"",pageSize:"",userId:""}
	
---

GET

####输入参数
|参数 |name|value	|
|----|----|------|
|经度|longitude|经度|
|纬度|latitude|纬度|
|起始页|startPage|
|分页大小|pageSize|
|用户ID|userId|可选，如果登陆了，则有userId
####返回参数

|参数 |name|value	|
|----|----|------|
|目的地|destination|
|目的地ID|destiId|
|目的地名称|destiName|
|目的地活动数量|actiNum|
|目的地图片链接|destiImg|
|活动|acti|
|活动Id|actiId|
|活动标题|actiTitle|
|体力强度|physicalStrength|
|活动类型|actiType|
|活动距离|tripDistance|
|活动天数|days|
|评论数量|discussNum|
|原价|origPrice|
|特价|speciaNum|
|点赞数|praiseNum|
|活动图片|actiImage|
|活动时间标签|accurateTag|
####JSON

	{
		"err_code":"200",
		"msg":"true"
		"data":
			{
				destination :  
				[
					{
						destiId:"", 
						destiName:""  
						actiNum:"",  
						destiImg:"", 

					}
					...
				],
				acti:
				[
					{
						actiId:"", 
						actiImage:["",""],
						actiTitle:"",
						actiType:"",
						days:"",
						descName:"",
						discussNum:"",
						distance:"",
						hasPraise:"",
						origPrice:"",
						physicalStrength:"",
						praiseNum:"",
						specialPrice:"",
						tripDistance:"",
						accurateTag:""
					}
					...
				]
			}
	}

___

	2.点赞

/trip/ws/rest_user/addPraise?paramjson={"actiId":"","userId":""}

---
GET

####输入参数
|参数 |name|value	|
|----|----|------|
|活动ID|actiId|
|用户ID|userId|可选，如果登陆了，则有userId

####返回参数

|参数|name|
|---|----|
|点赞数|praiseNum|

	{
		"err_code" : "200",
		"msg" : "true",
		"data" :
		{
			"praiseNum":"6"			
		}
	}

---

	3. 输入框搜索
/trip/ws/rest_acti/searchActi?paramjson={"keyWord":"","userId":"",latitude:"",longtitude:"","startPage":"","pageSize":""}
	
---
GET

####输入参数
|参数 |name|value	|
|----|----|------|
|关键词|keyWord|
|纬度|latitude|
|经度|longtitude|
|起始页|startPage|
|分页大小|pageSize|
|用户ID|userId|可选，如果登陆了，则有userId

####返回参数

|参数 |name|value	|
|----|----|------|
|目的地城市|destination|
|目的地ID|destiId|
|目的地名称|destiName|
|目的地活动数量|actiNum|
|目的地图片链接|destiImg|
|活动|acti|
|活动时间标签|accurateTag|多个时间用;分隔
|活动Id|actiId|
|活动图片|actiImage|
|活动标题|actiTitle|
|体力强度|physicalStrength|
|活动类型|actiType|
|活动距离|tripDistance|
|活动天数|days|
|活动目的名称|descName|
|评论数量|discussNum|
|是否被点过赞|hasPraise|
|原价|origPrice|
|特价|speciaNum|
|点赞数|praiseNum|
|活动时间标签|accurateTag|

####JSON

	{
		"err_code":"200",
		"msg":""
		"data":
			{
				"destination" :  
				[
					{
						"destiId":"",
						"destiName":"",
						"actiNum":"",  
						"destiImg":""
					}
				],
				"acti":
				[
					{
						"actiId":"", 
						"actiImage":["",""],
						"actiTitle":"",
						"actiType":"",
						"days":"",
						"descName":"",
						"discussNum":"",
						"distance":"",
						"hasPraise":"",
						"origPrice":"",
						"physicalStrength":"",
						"praiseNum":"",
						"specialPrice":"",
						"tripDistance":""，
						"accurateTag":""
					}
				]
			}
	}


___

	4.获取活动类型和国家用于搜索

/trip/ws/rest_acti/getCountryAndType?paramjson=
{"longitude":"","latitude":""}

---
GET
####输入参数
|参数|name|
|---|---|
|经度|longitude|
|纬度|latitude|


####返回参数
|参数 |name|value	|
|----|----|------|
|活动类型ID| typeId |
|活动图片|typeImg |
|活动名称| typeName |
|国家ID| countryId |
|国家图片| countryImg |
|国家名称| countryName |

#### JSON
	{
    "err_code": "200",
    "msg": "true",
    "data": 
    	{
    		type:
    		[
    			{
    			typeId:"",
    			typeImg:"",
    			typeName:""
    			}
    			...
    		],
    		country:
    		[
    			{
    			countryId:"",
    			countryImg:"",
    			countryName:""
    			}
    			...
    		]	
       }
     }
---

	5.根据国家ID搜索活动

/trip/ws/rest_acti/findActiByCountryId?paramjson={"countryId":"","longitude":"","latitude":"",
"userId":"","startPage":"","pageSize":""}

---
GET
####输入参数
|参数|name|说明|
|---|---|---|
|国家ID|countryId|
|经度|longitude|
|纬度|latitude|
|用户ID|userId|可选，如果登陆了，则有userId
|起始页|startPage|
|分页大小|pageSize|

####返回参数
|参数 |name|value	|
|----|----|------|
|活动|acti|
|活动时间标示|accurateTag|多个用;标示
|活动Id|actiId|
|活动标题|actiTitle|
|体力强度|physicalStrength|
|活动类型|actiType|
|活动距离|tripDistance|
|活动天数|days|
|评论数量|discussNum|
|原价|origPrice|
|特价|specialPrice|
|点赞数|praiseNum|
|活动图片|actiImage|
#### JSON
	{
    "err_code": "200",
    "msg": "true",
    "data": 
    {
        "acti": 
        [
            {
            		"accurateTag":"",
                "actiId": "001",
                "actiImage":[],
                "actiTitle":"",
                "actiType":"",
                "days":"",
                "descName":"",
                "discussNum":"",
                "distance":"",
                "hasPraise":"",
                "physicalStrength":"",
                "praiseNum":"",
                "specialPrice":"",
                "origPrice":""
                "tripDistance":""
            }
            ...
        ]
     }
  	}
---

	6.在点赞数最多的活动中按类型搜索

/trip/ws/rest_acti/findActiByTypePosition?paramjson={"actiType":"","longitude":"","latitude":"","userId":"","startPage":"","pageSize":""}

---
GET
####输入参数
|参数|name|说明|
|---|---|---|
|活动类型|actiType|
|经度|longitude|
|纬度|latitude|
|用户ID|userId|可选，如果登陆了，则有userId
|起始页|startPage|
|分页大小|pageSize|

####返回参数
|参数 |name|value	|
|----|----|------|
|活动|acti|
|活动标签| accurateTag |  
|活动Id|actiId|
|活动标题|actiTitle|
|体力强度|physicalStrength|
|活动类型|actiType|
|活动距离|tripDistance|
|活动天数|days|
|评论数量|discussNum|
|原价|origPrice|
|特价|speciaNum|
|点赞数|praiseNum|
|活动图片|actiImage|
#### JSON
	{
    "err_code": "200",
    "msg": "",
    "data": 
    {
        "acti": 
        [
            {
                "accurateTag":"",
                "actiId": "001",
                "actiImage": [],
                "actiTitle":"",
                "actiType":"",
                "days":"",
                "descName":"",
                "discussNum":"",
                "distance":"",
                "hasPraise":"",
                "physicalStrength":"",
                "praiseNum":"",
                "specialPrice":"",
                "tripDistance":""
            }
        ]
    }

___

	7. 点击活动进入详情页

/trip/ws/rest_acti/getActiInfo?
paramjson={"actiId":"4e04faf8-f6eb-424e-a6cc-181a6d98b268","userId":"e79b8efd-c834-4058-a9cf-377c92c2f381"}

---

####输入参数

|参数|name|
|---|----|
|活动Id|actiId|
|用户ID|userId|可选，如果登陆了，则有userId


####返回参数
|参数|name|说明|
|---|-----|-----|
|活动信息|actiInfo|
|活动时间标示|accurateTag|多个以;分隔
|活动日程信息|actiDay|
|活动描述|actiDesc|
|活动Id|actiId|
|活动图片|actiImg|
|活动等级|actiLevel|1-10个等级|
|活动评论数|dissNum|
|活动价格|actiPrice|
|活动标题|actiTitle|
|活动类型|actiType|
|费用说明|costNotes|
|国家|country|
|活动天数|days|
|活动评论|discuss|
|活动价格|actiPrice|
|活动标题|actiTitle|
|评论内容|dissContent|
|评论日期|dissDate|
|评论等级|level|
|评论用户昵称|nickName|
|用户ID|userId|
|用户图片|userImg|
|用户账户名称|userName|
|活动评论数|disNum|
|活动距离|distance|
|体力强度|physicalStrength|
|装备|equips|
|活动是否被收藏过|isfavorite|
|活动标签|label|多个标签用;分隔
|活动点赞用户|praUser|
|用户ID|userId|
|用户图片|userImg|
|用户账户|userName|
|用户提问|problems|
|用户提问活动名称|actiName|
|用户提问活动价格|actiPrice|
|用户昵称|nickName|
|用户提问问题Id|proId|
|用户提问内容|problemContent|
|用户提问日期时间|problemDate|
|用户提问是否被回复|status|
|用户头像|useImage|
|用户账户名称|userName|
|客服回复|reply|
|客服回复内容|replyContent|
|客服回复日期|replyDate|
|温馨提示|prompt|
|退款说明|refundNotes|
|景点地图信息|scenic|
|行程天数编号|dayNo|
|行程天数标题|dayTitle|
|行程经度|longitude|
|行程纬度|latitude|
|活动出发时间|startTime|
|活动价格日历|priceTime|
|价格日期|dateNo|
|价格|prices|
|库存|stock|
|集合地点|assemblyPoint|
|集合地点名称|pointName|
|集合地点经度|longitude|
|集合地点纬度|latitude|

####JSON

	{
	    "err_code" : "200",
	    "msg" : "true",
	    "data" :
	        {
	            "actiInfo" :
	            {
		            	"accurateTag":"",
		            	actiDay:
		            	[
			            	{
			            		days:"",
		            			secnicName:""	,
			            		secnicDesc:"",
			            		secnicImg:["",""]
			            	}
		            		...
		            	],	
		            	actiDesc:"",
		            	actiId:""
		            	scenic:
		            	[
		            		{
		            			dayNo:"",
		            			dayTitle:"",
		            			latitude:"",
		            			longitude:""	
		            		}
		            		...
		            	],
		            	actiDesc:"",
		            	actiId:"",
		            	actiImg:[],
		            	actiLevel:"",
		            	actiNum:"",
		            	actiPrice:"",
		            	actiTitle:"",
		            	actiType:"",
		            	costNotes:"",
		            	country:"",
		            	days:"",
		            	discuss:
		            	[
		            		{
		            			actiPrice:"",
		            			actiTitle:"",
		            			dissContent:"",
		            			dissDate:"",
		            			level:"",
		            			userId:"",
		            			userName:""
		            			userImg:""
	            			}
	            			...
		            	],
		            	dissNum:"",
		            	distance:"",
		            	equips:"",
		            	isfavoirte:"",
		            	label:"",
		            	physicalStrength:"",
		            	praUser:
		            	[
		            		{
			            		userId:"",
			            		userImg:"",
			            		userName:""
		            		}
		            		...
		            	],
		            	problems:
		            	[
		            		{
	            			actiNum:"",
	            			actiPrice:"",
	            			proId:"",
	            			problemContent:"",
	            			problemDate:"",
	            			reply:
	            			[
	            				{
	            					replyContent:"",
	            					replyDate:""
	            				}
	            			],
	            			status:"",
	            			userImage:"",
	            			userName:""
	            
	            			}
		            	],
		            	prompt:"",
		            	refundNotes:"",
		            	scenic:
		            	[
		            		{
			            		dayNo:"",
			            		dayTitle:"",
			            		latitude:"",
			            		longitude:""
		            		}
		            		...
		            	],
		            	startTime:"",
		          },
		         priceTime:
		         [
		         		{
		         			dayNo:"2015-02-03",
		         			prices:"3255",
		         			stock:""
		         		}
		         		...
		         ],
		         assemblyPoint: 
		         {
		         		pointName:"集合地点",
		         		pointLong:"223.438432",
		         		pointLati:"124.233332",	
		         }
		     	   
	            	
	         }
	         

---

	8. 加载评论

/trip/ws/rest_acti/getDiscusses?paramjson={"actiId":"","startPage":"","pageSize":""}

---

####输入参数

|参数|name|说明|
|---|---|---|
|活动ID|actiId|
|页数|startPage|
|每页数量|pageSize|

####返回参数
|参数|name|说明|
|---|----|----|
|用户ID|userId|
|用户昵称|nickName|
|用户账户|userName|
|用户头像|userImage|
|评论内容|dissContent|
|评论日期|dissDate|
|评价等级|level|
|活动价格|actiPrice|
|活动标题|actiTitle|


####JSON
	{
    "err_code" : "200",
    "msg" : "true",
    "data" : 
    {
    	discuss:
    	[
        {
            "userId" : "001",
            “userName” : "QHdf8",
            "userImg" : "",
            "disContent" : "",
            "dissDate" : "",
            "level":"",
            "actiPrice":"",
            "actiTitle":"",
            "nickName":""  
        }
        ...
       ]
      }

---

	9. 添加评论

/trip/ws/rest_acti/addDiscuss?paramjson={"userId":"","actiId":"","context":"","level":""}

---

####参数

|参数|name|说明|
|---|---|-----|
|登录用户Id|userId|
|活动ID|actiId|
|评论内容|context|
|评价等级|level|整数(1-10)


####返回参数
|参数|name|说明|
|---|---|----|
|标志|flag|

####JSON 

	{
		"err_code" : "200",
    	"msg" : "添加成功",
    	"data":
    	 {
    	   “flag” : "true"
    	 }
	}
	
---

	10. 收藏活动

/trip/ws/rest_acti/addfavoriteActi?paramjson={"userId":"","actiId":""}

---

GET
####参数
|参数|name|
|---|-----|
|用户ID|userId|
|活动ID|actiId|

####返回参数

|参数|name|
|---|----|
|标志|flag|


####JSON

	{
		"err_code" : "200",
		"msg" : "收藏成功",
		"data": 
		 {
		   "flag" : "true" 
		 }
	}


___

	11. 点击搜藏，查看用户收藏的活动   

/trip/ws/rest_user/getFavouritesByUser?paramjson={"userId":"","startPage":"1","pageSize":"4"}

___
 
 
 GET
####输入参数

|参数|name| 
|---|---|
|用户ID|userId|
|页数|startPage|
|数量|pageSize|
 
####返回参数

|参数|name|说明|
|---|---|-----|
|活动ID|actiId|
|活动标题|actiTitle|
|国家|country|
|类型|type|
|价格|price|
|图片地址|url|
|活动类型|actiType|与参数type重复,取actiType|
|旅行距离|tripDistance|与参数distance重复，取tripDistance即可
|点赞数量|praiseNum|
|是否被收藏过|hasPraise|
|评论数量|discussNum|
|活动天数|days|
|活动图片链接|url|
####JSON
	{
    "err_code" : "200",
    "msg" : "",
    "data": 
    	{
			    "favourites" :
			    [
			        {
			            "actiId" : "0323",
			            "actiTitle": "普吉岛奇幻乐园",
			            “actiType”:"",
			            "country":"",
			            "days":"",
			            "discussNum":"",
			            "hasPraise":"",
			            "physicalStrength":"",
			            "praiseNum":"",
			            "price":"",
			            "tripDistance":"",
			            "country" : "美国",
			            "distance":""
			            "price" : "2890",
			            "type" : "户外探险",
			            "url" : []
			        }
			        ...
			      ]
		}
	}

---

	12.取消收藏

 /trip/ws/rest_user/cancelFavourite?paramjson={"userId":"","actiId":""}

___

 GET
####输入参数

|参数|name|说明| 
|---|---|----|
|用户ID|userId|
|活动ID|actiId|多个活动用","分隔,如:"2324345,3233222"



####返回参数

|参数|name|
|---|-----|
|收藏标志|flag|
	
	{
		"err_code" :" 200" ,
		"msg" :"取消收藏成功" ,
		"data":
		{
			"flag" :"true"
		}
	}
	
___

	13. 修改昵称、性别、绑定手机的接口
	
/trip/ws/rest_register_user/updateUser?paramjson={"userId":"","nickName":"","sex":"",
"phone":""}

---

####参数

|参数|name|说明|
|---|----|----|
|用户ID|userId|
|昵称|nickName|
|性别|sex|0,未选择 1，男 2，女|
|电话|phone|

####返回参数

|参数|name|
|---|----|
|flag|true|

	{
		"err_code" :" 200/404" ,
		"msg" :"success/fail" ,
		"data":
		{
			"flag" :"true/false"
		}
	}



---

	14.登录 (OK)

/trip/ws/rest_login/login?paramjson={"account":"","password":""}
 
---

GET
####输入参数

|参数 |name|value	|
|----|----|------|
|用户名	|account|Otrip
|密码	|password|12345|

####返回参数
|参数 |name|value	|
|----|----|------|
|用户名| account|001|
|用户email|email|“otrip”|
|用户Id|loginUserId|
|用户密码|password|
|用户电话|phone|
|会话ID|session_id_key
|登录ID|wsLogLoginId
|注册时间|registerDate
|昵称|nick_name
|图片|image
|性别|sex
|订单数|orderNum


####JSON代码
	{
		"err_code" :" 200" ,
		"msg" :"" ,
		"data": 
		{ 
		  "user":
				{
					account:"",
					email:"",
					loginUserId:"",
					password:"",
					phone:"",
					session_id_key:"",
					wsLogLoginId:"",
					registerDate:"2015-07-09",
					nick_name:"",
					image:"",
					orderNum:""
				}
		}
	}

___

	15.注册用户

/trip/ws/rest_register_user/register?paramjson={"account":"",passWord:"",verifyCode:""}

---

GET

####输入参数
|参数 |name|value	|
|----|----|------|
|用户名|account|15202342124|
|密码|passWord|1234|
|手机验证码|verifyCode|

####返回参数
|参数 |name|value	|
|----|----|------|
|登录ID|session_id_key|
|电话|phone|
|登录用户ID|userId|
|邮箱|email|
|账号|account|
|注册时间|registerDate|
|昵称|nick_name|
|图片|image|
|性别|sex|

#####返回状态码说明
|状态码|说明|
|-----|----|
|200|注册成功|
|300|验证码或手机号错误|
|301|验证码超时|
|303|没有获取过验证码|
|304|用户已存在|
|305|用户或密码为空|
|306|未知错误|

####JSON
	{
		"err_code" :" 200" ,
		"msg" :"true" ,
		"data": 
		{
			"user":
			{
				userId:"",
				account:"",
				session_id_key:"",
				phone:"",
				email:"",
				registerDate:"2015-07-09",
				nick_name:"",
				image:"",
				sex:""
			}
		}
	}
	
___
	
		16 获取手机验证码
/trip/ws/rest_login/getVerifyCode?paramjson={"mobile":""}

___

####参数

|参数|name|
|----|----|
|手机号码|mobile|


####返回参数
|参数|name|说明|
|----|----|----|
|验证码失效时间|timeLimit|单位:分钟|


	{
	    "err_code" : "200",
	    "msg" : "true",
	    "data" :
		    {
		    	"timeLimit":"5"
		    }     
	}
	

---

17 验证短信验证码
		/trip/ws/rest_login/checkVerifyCode?paramjson={"mobile":"18321965871","code":"08279"}
		
---

#### 参数

|参数|name|
|---|-----|
|手机号|mobile|
|验证码|code|


##### 返回参数

|参数|name|
|----|----|
|标志|flag|

|返回代码|说明|
|---|----|
|200|成功|
|300|验证码不正确|
|301|验证码超时|
|303|验证码不存在|


	{
	    "err_code" : "200",
	    "msg" : "success",
	    "data" :
	    {
	      "flag" :"true" 
	    }     
	}


---

	17. 增加反馈

/trip/ws/rest_user/addFeedBack?paramjson={userId:"",content:"",mobile:""}

___


####输入参数
|参数 |name|value	|
|----|----|------|
|用户名Id|userId||
|内容|content|
|手机号|mobile|



####返回参数

|参数|name|
|---|----|
|flag|true/false|


	{
	    "err_code" : "200",
	    "msg" : "success",
	    "data" : 
		    {
		    	"flag" :"true"    
		    }  
	}
 
 
___

	18 添加活动到购物车
/trip/ws/rest_shopping/addToShoppingCart

___

####参数
POST

|名称|name|
|----|----|
|用户ID|userId|
|活动ID|actiId|
|成年人数|adultNumber|
|青年人数|youthNumber|
|儿童人数|childrenNumber|
|预定时成年人价格|adultPrice|
|预定时青年价格|youthPrice|
|预定时儿童价格|childrenPrice|
|预定日期|date|
|预定时间|time|
|支付金额|totalPay|

	{
		userId:"32443432",
		actiId:"wewqr2323",
		adultNumber:"2",
		youthNumber:"3",
		childrenNumber:"4",
		adultPrice:"4242",
		youthPrice:"1242",
		childrenPrice:"2324",
		date:"2015-04-03",
		time:"18:00"
		totalPay:"2352"
	}
####响应

	{
    "err_code" : "200",
    "msg" : "add success",
    "data" :
     {
         "flag" :"true" 
     }         
	}

___

	19  获取购物车的信息
/trip/ws/rest_shopping/getShoppingCart?paramjson={"userId":"","startPage":"","pageSize":""}
	
___

####参数
	
|参数|name|
|----|----|
|userId|用户ID|
|起始页|startPage|
|分页大小|pageSize|默认50个|
	
####响应参数
	|参数|name|
	|----|----|
	|商品Id|id|
	|活动Id|actiId|
	|活动标题|title|
	|活动图片|url|
	|出行日期|startDate|
	|出行时间|startTime|
	|出行成人数|adultNum|
	|出行青年数|youthNum|
	|出行儿童数|childrenNum|
	|青年单价|youthPrice|
	|儿童单价|childrenPrice|
	|成人单价|adultPrice|
	
	{
		"err_code":"200",
		"msg":"true",
		"data":
		{ 
			goods:
			[
				{
					id:"",
					childrenPrice:"",
					adultNum:"",
					youthPrice:"",
					childrenNum:"",
					adultPrice:"",
					startTime:"",
					title:"",
					actiId:"",
					startDate:"",
					url:"",
					youthNum:""
				}
				...
			]
		}
	}

___

	20 修改购物车的商品
/trip/ws/rest_shopping/editShoppingItem

___

####参数	

POST

|参数|name|说明|
|----|-----|-----|
|商品ID|goodsId|
|用户ID|userId|
|活动ID|actiId|
|出行日期|date|2015-10-09|
|出行时间|time|
|成人数量|adultNum|
|青年数量|youthNum|
|儿童数量|childrenNum|

####返回参数

|参数|name|
|----|----|
|标志|flag(true/false)|

	{
	    "err_code" : "200",
	    "msg" : "",
	    "data" :
	    {
	    	"flag" :"true" 
	    }  
	}

___	

	21 删除购物车商品
/trip/ws/rest_shopping/delShoppingItem?paramjson={"userId":"","goodsId":""}

___

|参数|name|说明
|---|-----|----|
|用户Id|userId|
|商品ID|goodsId|多个goodsId用,分隔的字符串如“3235435,3232323”|


####返回参数
|参数|name|
|----|----|
|标志|flag(true/false)|

	{
	    "err_code" : "200",
	    "msg" : "delete success",
	    "data" :
	    {
		    "flag" :"true"
	    }
	}

___

	22 结算购物车信息
	
/trip/ws/rest_shopping/chargeShoppingCart?paramjson={"userId":"","goodsId":""}

___

####参数
	
|参数|name|说明|
|----|----|-----|
|用户ID|userId|
|商品Id|goodsId|多个goodsId用,分隔的字符串如“3235435,3232323”
	
#####响应参数
#####返回待确认订单
	
|参数|name|说明|
|---|-----|----|
|订单子项数量|itemNum|
|订单ID|orderId|
|订单子项|orderItems|
|单个订单子项出行日期|date|
|子项图片|itemImage|
|子项标题|itemTitle|
|子项总价|itemTotal|
|订单子项Id|orderItemId|
|单个订单子项出行时间|time|
|单个子项出行青年数|youthNum|
|单个子项出行成年数|adultNum|
|单个子项出行儿童数|childrenNum|
|单个子项青年价格|youthPrice|
|单个子项成年价格|adultPrice|
|单个子项儿童价格|childrenPrice|
|总订单编号|orderNo|
|订单状态|state|0.订单取消 1.订单未支付 2.订单已支付，等待确认单 3.订单已支付，可以生成确认单
|所有订单总价|totalPay|

	{
		"err_code":"200",
		"msg":"",
		"data":
		{
			orderInfo:
			{
				itemNum:"",
				orderId:"",
				orderItems:
				[
					{
						adultNum:"",
						adultPrice:"",
						childrenNum:"",
						childrenPrice:"",
						date:"",
						itemImage:"",
						itemTitle:"",
						itemTotal:"",
						orderItemId:"",
						time:"",
						youthNum:"",
						youthPrice:""
					}
					...
				],
				orderNo:"",
				state:"",
				totalPay:""
			},
			payWay:
			[
				{
					payCode:"",
					fs_name:""
				}
				...
			]
		}
	}

___

	23 清空购物车
	
/trip/ws/rest_shopping/clearShoppingItem?paramjson={"userId":""}

___

####参数
|参数|name|
|----|-----|
|用户Id|userId|

####返回参数
|参数|name|
|----|----|
|标志|flag(true/false)|

	{
	    "err_code" : "200",
	    "msg" : "clear success",
	    "data" : 
	    {
	     	"flag" :"true"
	    }
	}



	
————

	24 获取联系人列表
 /trip/ws/rest_shopping/getContactList?paramjson={"userId":""}

—————

|参数|name|
|---|----|
|用户Id|userId|


####返回参数

|参数|name|说明|
|----|-----|
|联系人id|id|
|姓|firstName|
|名|lastName|
|拼音|py|
|手机|mobile|
|微信|weChat|
|邮箱|email|
|性别|sex|1表示男 0 表示女
|默认选择|default|true表示默认联系人

	{
		"err_code":"200",
		"msg":"success",
		"data":
		{
			contact:
				[
					{
					id:"",
					firstName:"",
					lastName:"",
					py:"",
					mobile:"",
					weChat:"",
					email:"",
					default:"",
					sex:""
					}
					...
				]	
		}
	}

___

	25 新增联系人
 /trip/ws/rest_shopping/addContactItem

___

####参数

POST 

|参数|name|说明|
|---|----|----|
|用户Id|userId|
|姓|firstName|
|名|lastName|
|拼音|pym|
|手机|mobile|
|微信|weChat|
|邮箱|email|
|性别|sex|1 男 0 女|

####返回参数

|参数|name|
|---|----|
|成功标志|flag|
 
	{
		"err_code":"200",
		"msg":"success",
		"data":
			{
				"flag":"true"
			}
	}

___

	26 删除联系人
/trip/ws/rest_shopping/delContactItem?paramjson={"userId":"","contactId":""}

___

####参数
参数|name|
|---|----|
|用户Id|userId|
|联系人ID|contactId|

####返回参数

|参数|name|
|---|----|
|成功标志|flag|
 
	{
		"err_code":"200",
		"msg":"del success",
		"data": 
			{
				"flag":"true"
			}
	}

___

	27 设置默认联系人
/trip/ws/rest_shopping/setDefaultContact?paramjson={"userId":"","contactId":""}

___

|参数|name|
|----|----|
|用户ID|userId|
|联系人id|contactId|

####返回参数

|参数|name|
|---|----|
|成功标志|flag|
 
	{
		"err_code":"200",
		"msg":"success",
		"data":
			{
				"flag":"true"
			}
	}

___

	28 编辑联系人
/trip/ws/rest_shopping/editContactItem

___

####参数

POST 

|参数|name|
|---|----|
|用户Id|userId|
|联系人Id|contactId|
|姓|firstName|
|名|lastName|
|拼音|pym|
|手机|mobile|
|微信|weChat|
|邮箱|email|
|性别|sex|

####返回参数

|参数|name|
|---|----|
|成功标志|flag|
 
	{
		"err_code":"200",
		"msg":"success",
		"data":
			{
				"flag":"true"
			}
	}

___

	29 显示订单列表
/trip/ws/rest_order/getOrderByUser?paramjson={"userId":"","status":"","startPage":"","pageSize":""}
 
___

|参数|name|说明|
|----|----|----|
|用户ID|userId|
|订单类型|status|"all"全部，"unpay"未付款,"confirm"已确定,
|页码数|startPage|
|页面条数|pageSize|

####返回参数

|参数|name|说明|
|---|----|-----|
|订单ID|orderId|
|订单号|orderNo|
|订单状态|orderState|1表示未付款，0表示取消，2表示已付款，没有确认单，3表示已付款，有确认单
|订单单价|price|
|订单总价|orderTotal|
|成人出行人数|adultNum|
|青年出行人数|youthNum|
|儿童出行人数|childrenNum|
|成人出行价格|adultPrice|  
|青年出行价格|youthPrice|  
|儿童出行价格|childrenPrice|  
|活动Id|actiId|
|活动标题|actiTitle|
|出行日期|date|
|出行时间|time|
|活动图片|actiImage|
|订单状态|state||

	{
		"err_code":"200",
		"msg":"",
		"data":
		{
			"orders" :[
				{
					orderId:"",
					orderNo:"",
					orderState:"",
					totalPrice:"",
					orderItems:
					[
						{
							orderItemId:""
							itemTitle:"",
							itemPrice:"",
							itemTotal:"",
							adultNum:"",
							youthNum:"",
							childrenNum:"",
							adultPrice:"",
							youthPrice:"",
							childrenPrice"",
							date:"",
							time:"",
							itemImage:""
						}
						...
					]	
				}			
				...
			]
		}
	}


___

	30 取消订单和支付
/trip/ws/rest_order/cancelOrder?paramjson={"userId":"","orderId":""}

___

####输入参数

|参数|name|
|----|----|
|用户id|userId|
|订单Id|orderId|

####返回参数

|参数|name|
|----|----|
|flag|true|

	{
		"err_code":"200",
		"msg":"success",
		"data":
		{
			"flag":"true"
		}
	}



___

	31 对未付款订单进行支付
/trip/ws/rest_shopping/chargeOrder?paramjson={"userId":"","orderId":"'}
 
___

|参数|name|
|----|-----|
|用户Id|userId|
|订单Id|orderId|

####返回参数

|参数|name|
|----|----|
|

	{
		"err_code":"200",
		"msg":"",
		"data":
		{
				orderId:"",
				orderNo:"",
				orderState:"".
				contactInfo:
				{
					contactId:"",
					contactName:"",
					mobile:"",
					weChat:"",
					email:""
				}
				orderItems:
				[
					{
						orderItemId:""
						itemTitle:"",
						itemPrice:"",
						itemTotal:"",
						adultNum:"",
						youthNum:"",
						childrenNum:"",
						date:"",
						time:"",
						itemImage:""
					}
					...
				],
				totalPay:"",
				itemNum:"",
				payWay:
				[	
				   {
						way:"weChatPay",
						default:"1"
					}，				
					{
						way:"alipay",
						default:"0"
					}

				]
		}
	}
		
	
___
	
	32 单个活动立即预定提交订单
/trip/ws/rest_order/postOrder

___

#####输入参数

POST

|参数|name|
|---|-----|
|用户Id|userId|
|活动ID|actiId|
|成人价格|adultPrice|
|青年价格|youthPrice|
|儿童价格|childrenPrice|
|成人出行人数|adultNum|
|青年出行人数|youthNum|
|儿童出行人数|childrenNum|
|出行日期|startDate|
|出行时间|time|
|支付总金额|total|

#####返回参数

|参数|name|
|----|----|
|订单ID|orderId|
|订单编号|orderNo|
|账户昵称|nickName|
|联系人名字|realName|
|联系人电子邮件|email|
|联系人电话号码|tel|
|活动标题|actiName|
|出发日期|date|
|出发时间|time|
|出行人数|number|
|活动单价|price|
|总金额|total|

	
	{
		"err_code":"200",
		"msg":"",
		"flag":"true",
		"data":
		{
			orderId:"24342323"
			orderItems:
			[
				{
					orderItemId:""
					itemTitle:"",
					itemPrice:"",
					itemTotal:"",
					adultNum:"",
					youthNum:"",
					childrenNum:"",
					date:"",
					time:"",
					itemImage:""
				}
				...
			],
			totalPay:"5333"，
			itemNum：“2”
		}
	}


___

	33 支付 ,服务器发送支付请求
/trip/ws/rest_order/getCharge
向客户端发送支付凭据

___

POST

|参数|name|说明|
|----|----|
|订单ID|orderId|
|联系人Id|contactId|
|使用的第三方渠道|channel|"weChat":"01",alipay:"02"|
|客户端Ip|clientIp|
|货币代码|currency|默认为cny
|确认支付|flag|

######返回Charge对象
第三方支付的charge对象,参考ping++ charge对象说明
|参数|name|
|---|----|



___
	
	34 确认单
/trip/ws/rest_order/getConfirmSheet?paramjson={"userId":"","orderId":"","itemId":""}

___

####参数

|参数|name|
|---|-----|
|用户ID|userId|
|订单ID|orderId|
|订单ItemID|itemId|

####返回参数

|参数|name|
|----|----|
|确认号|confirmNo|
|姓名|name|
|拼音|py|
|总人数|totalNumber|
|活动名称|actiTitle|
|活动名称英文|actiEngTitle|
|活动日期|date|
|活动时间|time|
|接送信息|pickUpInfo|
|提示说明|desc|
|确认单二位码图片|image
|联系信息|tel|

	{
		"err_code":"200",
		"msg":"",
		"data":
		{
			confirmNo:"",
			name:"",
			py:"",
			totalNumber:"",
			actiTitle:"",
			actiEngTitle:"",
			date:"",
			time:"",
			pickUpInfo:"",
			desc:"",
			image:"",
			tel:""
		}
	}
		
	
	#35 上传用户头像

urL :
trip/ws/rest_user/uploadPortrait

--
POST
####参数
|参数 |name|value	|
|----|----|------|
|用户Id|userId||
|文件流名|uploadedFile|

####JSON
{
		"err_code":"200",
		"msg":"success",
		"data":
		{
			"flag":"true"
		}
}

___

	#36 退出登陆

/trip/ws/rest_login/logout?paramjson={"account":""}
 
---

GET
####输入参数

|参数 |name|value	|
|----|----|------|
|用户名	|account|Otrip

####返回参数
|参数 |name|value	|
|----|----|------|
| flag | true/false | 退出成功或者失败|



####JSON代码
	{
		"err_code" :" 200" ,
		"msg" :"" ,
		"data":
		{
			"flag":"true"
		}
	}





