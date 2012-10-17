//
//  ThirdCertViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-10-16.
//
//

#import "ThirdCertViewController.h"

#import "SinaWeibo.h"

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
    }
    return self;
}
- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    
	self.title = NSLocalizedString(@"ThirdPartCertification", @"ThirdPartCertification");
    
	return self;
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
            cell.detailTextLabel.text = @"未授权";
			//cell.imageView.image = [UIImage imageNamed:@"Sounds"];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            [sinaweibo logIn];
//            YPAlertView *alertview = [YPAlertView alertViewWith:@"sina....."
//                                                        message:@"ddasdadasdasda\nadas\ndasd\n"
//                                                       delegate:nil
//                                                   cancelButton:YES];
//            [alertview show];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"qq", @"qq");
			//cell.imageView.image = [UIImage imageNamed:@"Brightness"];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            //测试拍照
            
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"Wallpaper", @"Wallpaper");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            [sinaweibo requestWithURL:@"users/show.json"
                               params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                           httpMethod:@"GET"
                             delegate:self];
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
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [self storeAuthData];
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



@end
