//
//  ThirdCertViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-10-16.
//
//

#import "ThirdCertViewController.h"

#import "SinaWeibo.h"
#import "OpenApi.h"
#import "QQWeiboAuthorizeView.h"
#import "AppDelegate.h"
@interface ThirdCertViewController ()

@end

@implementation ThirdCertViewController
@synthesize sinaweibo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sinaweibo = [[SinaWeibo alloc] initWithAppKey:kSinaAppKey appSecret:kSinaAppSecret appRedirectURI:kSinaAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        
        if (_OpenOauth == nil) {
            _OpenOauth = [[OpenSdkOauth alloc] initAppKey:[OpenSdkBase getAppKey] appSecret:[OpenSdkBase getAppSecret]];
        }
    }
    return self;
}
- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    
	self.title = NSLocalizedString(@"ThirdPartCertification", @"ThirdPartCertification");
    
	return self;
}
- (void)tencentSendWeibo {
    
    UIImage *image = [UIImage imageNamed:@"icon"];
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingFormat:@"tmp.png"];
    NSLog(@"filename is %@", filePath);
    
    [UIImageJPEGRepresentation(image, 0) writeToFile:filePath atomically:YES];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"imageData size in picker:%d", [imageData length]);
    
    
    if (_OpenApi == nil) {
        _OpenApi = [[OpenApi alloc] initForApi:_OpenOauth.appKey appSecret:_OpenOauth.appSecret accessToken:_OpenOauth.accessToken accessSecret:_OpenOauth.accessSecret openid:_OpenOauth.openid oauthType:_OpenOauth.oauthType];
    }

    //Todo：请填写调用t/add_pic发表带图片微博接口所需的参数值，具体请参考http://wiki.open.t.qq.com/index.php/API文档
    NSString *weiboContent = @"测试发布";  //Todo：微博内容
    //发表带图片微博
    [_OpenApi publishWeiboWithImage:filePath weiboContent:weiboContent jing:@"" wei:@"" format:@"xml" clientip:@"CLIENTIP" syncflag:@"1"];
    
    
}
#pragma mark - Tencent Methods
- (void)tencentLoginWithMicroblogAccount {

    QQWeiboAuthorizeView *authorizeView = [[QQWeiboAuthorizeView alloc] init];
    authorizeView.delegate = self;
    authorizeView.OpenSdkOauth =_OpenOauth;
    [authorizeView show];
    [authorizeView release];
}
#pragma mark -QQWeiboAuthorizeViewDelegate 

/*
 * 登录成功后调用，获取OpenSdkOauth各成员变量的值
 */
- (void) oauthDidSuccess:(NSString *)accessToken accessSecret:(NSString *)accessSecret openid:(NSString *)openid openkey:(NSString *)openkey expireIn:(NSString *)expireIn{
    NSLog(@"登录成功后调用，获取OpenSdkOauth各成员变量的值==accessToken=%@",accessToken);
    [self.tableView reloadData];
}

/*
 * 授权失败调用，可能由于网络原因或参数值设置原因等
 */
- (void) oauthDidFail:(uint16_t)oauthType success:(BOOL)success netNotWork:(BOOL)netNotWork{
    NSLog(@"授权失败调用，可能由于网络原因或参数值设置原因等");
}
/*
 * webView方式，拒绝授权时调用
 */
- (void) refuseOauth:(NSURL *)url{
    NSLog(@"webView方式，拒绝授权时调用");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"DetailTextCell";
			cell.textLabel.text = NSLocalizedString(@"sina", @"sina");
            if ([sinaweibo isAuthValid]) {
                cell.detailTextLabel.text = @"已登陆";
            }else{
                cell.detailTextLabel.text = @"未授权";
            }
			//cell.imageView.image = [UIImage imageNamed:@"Sounds"];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            if ([sinaweibo isAuthValid]) {
                [sinaweibo requestWithURL:@"statuses/upload.json"
                                   params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"demotest", @"status",
                                           [UIImage imageNamed:@"icon"], @"pic", nil]
                               httpMethod:@"POST"
                                 delegate:self];
            }else{
                [sinaweibo logIn];
            }
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			cell.textLabel.text = NSLocalizedString(@"qq", @"qq");
            if ([OpenSdkOauth isLoggedIn]) {
                cell.detailTextLabel.text = @"已登陆";
            }else{
                cell.detailTextLabel.text = @"未授权";
            }
            
			//cell.imageView.image = [UIImage imageNamed:@"Brightness"];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            //测试拍照
            if ([OpenSdkOauth isLoggedIn]) {
                [self tencentSendWeibo];
            }
            else {
                [self tencentLoginWithMicroblogAccount];
            }

            
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
			cell.textLabel.text = NSLocalizedString(@"Wallpaper", @"Wallpaper");
            cell.detailTextLabel.text = @"未授权";
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
//            [sinaweibo requestWithURL:@"users/show.json"
//                               params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
//                           httpMethod:@"GET"
//                             delegate:self];
		
            AppDelegate* delgate = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [delgate RespImageContent];
        }];
	}];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
 //   NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [self storeAuthData];
    
    [self.tableView reloadData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");

}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
}
#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response{
     NSLog(@"Post status didReceiveResponse : %@", response);
}
- (void)request:(SinaWeiboRequest *)request didReceiveRawData:(NSData *)data{
     NSLog(@"Post status didReceiveRawData : %@", data);
}
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        NSLog(@"Post image status failed with error : %@", error);
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
       
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
    
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
    }
}


- (void)shareText:(NSString *)text andImage:(UIImage *)image;
{
    // post image status
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               @"demotest", @"status",
                               [UIImage imageNamed:@"icon"], @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}


@end
