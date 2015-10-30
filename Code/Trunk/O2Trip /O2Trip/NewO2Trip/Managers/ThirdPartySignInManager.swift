//
//  ThirdPartySignInManager.swift
//  O2Trip
//
//  Created by Q on 15/10/29.
//  Copyright © 2015年 lst. All rights reserved.
//

import UIKit

@objc enum ThirdPartyType: Int {
    case Weibo = 0
    case Wechat
    case QQ
}

@objc protocol ThirdPartySignInManagerDelegate {
    optional func didFinishAuthorized(manager: ThirdPartySignInManager, type: ThirdPartyType, success: Bool)
    optional func didSignIn(manager: ThirdPartySignInManager, type: ThirdPartyType, success: Bool)
}

class ThirdPartySignInManager: NSObject, WeiboSDKDelegate, WBHttpRequestDelegate, TencentSessionDelegate, WXApiDelegate {
    
    static let thirdPartySignInManager = ThirdPartySignInManager()
    
    let qqAppID = "1104859569"
    let qqAppKey = "Q64UL3KImgbc5wUQ"
    let weixinAppID = "wxfc5b7d0ff882adcb"
    let weixinAppKey = "4a53268e81a76ca6e9b96136314ce29f"
    let weiboAppID = "2996070161"
    let weiboAppKey = "94b043a8068b8f8929f10330443640a4"
    
    let weixinAPIUrl = "https://api.weixin.qq.com/sns/"
    let thirdPartyUserInfo = ThirdPartyInfo()
    
    var tencentOAuth: TencentOAuth? = nil
    var isDoingSignIn = false
    var wbToken = ""
    var wxToken = ""
    
    weak var delegate: ThirdPartySignInManagerDelegate? = nil
    
    class func defaultManager() -> ThirdPartySignInManager {
        return thirdPartySignInManager
    }
    
    class func isQQInstalled() -> Bool {
        return TencentOAuth.iphoneQQInstalled()
    }
    
    class func isWechatInstalled() -> Bool {
        return WXApi.isWXAppInstalled()
    }
    
    override init() {
        super.init()
        
        tencentOAuth = TencentOAuth(appId: qqAppID, andDelegate: self)
        WeiboSDK.registerApp(weiboAppID)
    }
    
    func handleOpenUrl(url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func signInWeibo() {
        let request = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "http://www.sina.com"
        request.scope = "all"
        request.userInfo = ["SSO_From": "SignInViewController"]
        WeiboSDK.sendRequest(request)
    }
    
    func signInQQ() {
        let params = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_ALBUM, kOPEN_PERMISSION_ADD_IDOL, kOPEN_PERMISSION_ADD_ONE_BLOG, kOPEN_PERMISSION_ADD_PIC_T,
            kOPEN_PERMISSION_ADD_SHARE,
            kOPEN_PERMISSION_ADD_TOPIC,
            kOPEN_PERMISSION_CHECK_PAGE_FANS,
            kOPEN_PERMISSION_DEL_IDOL,
            kOPEN_PERMISSION_DEL_T,
            kOPEN_PERMISSION_GET_FANSLIST,
            kOPEN_PERMISSION_GET_IDOLLIST,
            kOPEN_PERMISSION_GET_INFO,
            kOPEN_PERMISSION_GET_OTHER_INFO,
            kOPEN_PERMISSION_GET_REPOST_LIST,
            kOPEN_PERMISSION_LIST_ALBUM,
            kOPEN_PERMISSION_UPLOAD_PIC,
            kOPEN_PERMISSION_GET_VIP_INFO,
            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
            kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
            kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO]
        
        tencentOAuth?.authorize(params)
    }
    
    func signInWechat() {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        WXApi.sendReq(req)
    }
    
    // MARK: - Private
    
    private func getWeiboUserInfo() {
        WBHttpRequest(URL: "https://api.weibo.com/2/users/show.json", httpMethod: "GET", params: ["access_token": wbToken, "uid": thirdPartyUserInfo.userID], delegate: self, withTag: "getUserInfo")
    }
    
    private func getWeixinUserInfo(code: String) {
        self.weixinRequest("oauth2/access_token", params: ["appid": weixinAppID, "secret": weixinAppKey, "code": code, "grant_type": "authorization_code"], httpMethod: nil) { (response) -> Void in
            guard let data = response?.dataUsingEncoding(NSUTF8StringEncoding) else {
                return
            }
            
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
                self.thirdPartyUserInfo.userID = dict["openid"]!
                self.wxToken = dict["access_token"]!;
                
                self.weixinRequest("userinfo", params: ["access_token": self.wxToken, "openid": self.thirdPartyUserInfo.userID], httpMethod: "GET", finished: { (response) -> Void in
                    guard let data = response?.dataUsingEncoding(NSUTF8StringEncoding) else {
                        return
                    }
                    
                    do {
                        let respDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
                        
                        self.thirdPartyUserInfo.nickName = respDict["nickname"];
                        self.thirdPartyUserInfo.gender = Int(respDict["sex"]!) == 1 ? "male" : "female";
                        self.thirdPartyUserInfo.location = respDict["city"];
                        self.thirdPartyUserInfo.photoUrl = respDict["headimgurl"];
                        
                        self.delegate?.didFinishAuthorized?(self, type: ThirdPartyType.Wechat, success: true)
                    }
                    catch {}
                })
            }
            catch {}
        }
    }
    
    private func serializeParams(params: Dictionary<String, String>) -> String {
        let parts = NSMutableArray()
        
        for key in params.keys {
            let value = params[key]
            parts.addObject("\(key)=\(value)")
        }
        
        return parts.componentsJoinedByString("&")
    }
    
    private func weixinRequest(method: String, params: Dictionary<String, String>, httpMethod: String?, finished: (String?) -> Void) {
        var urlString = "\(weixinAPIUrl)\(method)"
        urlString += self.serializeParams(params)
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        if (httpMethod != nil) {
            request.HTTPMethod = httpMethod!
        }
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if data?.length > 0 {
                finished(NSString(data: data!, encoding: NSUTF8StringEncoding) as? String)
            }
            else {
                finished(error?.description)
            }
        }
    }
    
    // MARK: - Weibo
    
    func didReceiveWeiboRequest(request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(response: WBBaseResponse!) {
        if response is WBSendMessageToWeiboResponse {
            let title = "发送结果"
            let message = "响应状态: \(response.statusCode)\n响应UserInfo数据: \(response.userInfo)\n原请求UserInfo数据: \(response.requestUserInfo)"
            let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "确定")
            alert.show()
        }
        else if (response is WBAuthorizeResponse) {
            let aResponse = response as! WBAuthorizeResponse;
            if aResponse.accessToken != nil && aResponse.userID != nil {
                wbToken = aResponse.accessToken
                thirdPartyUserInfo.userID = aResponse.userID
                self.getWeiboUserInfo()
            }
            else {
                delegate?.didFinishAuthorized?(self, type: ThirdPartyType.Weibo, success: false)
            }
        }
    }
    
    func request(request: WBHttpRequest!, didFinishLoadingWithResult result: String!) {
        do {
            let dict = try NSJSONSerialization.JSONObjectWithData(result.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
            thirdPartyUserInfo.nickName = dict["screen_name"]
            thirdPartyUserInfo.photoUrl = dict["profile_image_url"]
            thirdPartyUserInfo.location = dict["location"]
            thirdPartyUserInfo.gender = dict["gender"] == "m" ? "male" : "female"
            
            delegate?.didFinishAuthorized?(self, type: ThirdPartyType.Weibo, success: true)
        }
        catch {}
    }
    
    func request(request: WBHttpRequest!, didFailWithError error: NSError!) {
        
    }
    
    // MARK: - QQ
    
    func tencentDidLogin() {
        
        var success = false
        if tencentOAuth?.openId != nil {
            thirdPartyUserInfo.userID = tencentOAuth!.openId
            tencentOAuth?.getUserInfo()
            success = true
        }
        
        delegate?.didSignIn?(self, type: ThirdPartyType.QQ, success: success)
    }
    
    func tencentDidNotLogin(cancelled: Bool) {
        delegate?.didSignIn?(self, type: ThirdPartyType.QQ, success: false)
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func getUserInfoResponse(response: APIResponse!) {
        let dict = response.jsonResponse as! Dictionary<String, AnyObject>
        
        if dict["ret"] as! Int == 0 {
            thirdPartyUserInfo.nickName = dict["nickname"] as? String
            thirdPartyUserInfo.photoUrl = dict["figureurl_qq_1"] as? String
            thirdPartyUserInfo.location = dict["city"] as? String
            thirdPartyUserInfo.gender = dict["gender"] as! String == "男" ? "male" : "female"
            
            delegate?.didFinishAuthorized?(self, type: ThirdPartyType.QQ, success: true)
        }
    }
    
    // MARK: - Wechat
    
    func onResp(resp: BaseResp!) {
        if resp is SendAuthResp {
            let aResp = resp as! SendAuthResp
            self.getWeixinUserInfo(aResp.code)
        }
    }
    
    func onReq(req: BaseReq!) {
        
    }
    
}

class ThirdPartyInfo: NSObject {
    var userID: String = ""
    var photoUrl: String? = nil
    var nickName: String? = nil
    var gender: String? = nil
    var location: String? = nil
}
