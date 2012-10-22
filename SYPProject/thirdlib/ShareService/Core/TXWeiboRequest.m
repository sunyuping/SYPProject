//
//  TXWeiboRequest.m
//  ShareDemo
//
//  Created by tmy on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TXWeiboRequest.h"

@implementation TXWeiboRequest


- (void)prepareForShare
{
    signature = [signatureProvider signClearText:[self _signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
												  [consumer.secret URLEncodedString],
                                                  [token.secret URLEncodedString]]];
    
    NSString *oauthQueryString = [NSString stringWithFormat:@"?oauth_consumer_key=%@&oauth_signature_method=%@&oauth_signature=%@&oauth_timestamp=%@&oauth_nonce=%@&oauth_version=1.0", 
                                  [consumer.key URLEncodedString],
                                  [[signatureProvider name] URLEncodedString],
                                  [signature URLEncodedString],
                                  timestamp,
                                  nonce
                                  ];
    if (![token.key isEqualToString:@""])
        oauthQueryString=[NSString stringWithFormat:@"%@&oauth_token=%@",oauthQueryString,token.key];
    
    NSMutableArray *bodyParams=[[[NSMutableArray alloc] init] autorelease];
    for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
    {
        [bodyParams  addObject:[NSString stringWithFormat:@"%@=%@",
                                [parameterName URLEncodedString],
                                [[extraOAuthParameters objectForKey:parameterName] URLEncodedString]]];
    }
    
    NSString *postBody=[bodyParams componentsJoinedByString:@"&"];   
    NSString *url=[NSString stringWithFormat:@"%@%@",self.URL.description,oauthQueryString];
    [self setURL:[NSURL URLWithString:url]];
    [self setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    

}


- (void)prepareForShareUsingFormData
{
    signature = [signatureProvider signClearText:[self _signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
												  [consumer.secret URLEncodedString],
                                                  [token.secret URLEncodedString]]];
    
    NSString *oauthQueryString = [NSString stringWithFormat:@"?oauth_consumer_key=%@&oauth_signature_method=%@&oauth_signature=%@&oauth_timestamp=%@&oauth_nonce=%@&oauth_version=1.0", 
                                  [consumer.key URLEncodedString],
                                  [[signatureProvider name] URLEncodedString],
                                  [signature URLEncodedString],
                                  timestamp,
                                  nonce
                                  ];
    if (![token.key isEqualToString:@""])
        oauthQueryString=[NSString stringWithFormat:@"%@&oauth_token=%@",oauthQueryString,token.key];
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@",self.URL.description,oauthQueryString];
    [self setURL:[NSURL URLWithString:url]];
}

- (void)prepareForOAuth
{
    signature = [signatureProvider signClearText:[self _signatureBaseString]
                                      withSecret:[NSString stringWithFormat:@"%@&%@",
												  [consumer.secret URLEncodedString],
                                                  [token.secret URLEncodedString]]];
    
    NSString *oauthQueryString = [NSString stringWithFormat:@"?oauth_consumer_key=%@&oauth_signature_method=%@&oauth_signature=%@&oauth_timestamp=%@&oauth_nonce=%@&oauth_version=1.0", 
                                  [consumer.key URLEncodedString],
                                  [[signatureProvider name] URLEncodedString],
                                  [signature URLEncodedString],
                                  timestamp,
                                  nonce
                                  ];
    if (![token.key isEqualToString:@""])
        oauthQueryString=[NSString stringWithFormat:@"%@&oauth_token=%@",oauthQueryString,token.key];
    
    NSMutableString *extraParameters = [NSMutableString string];
    for(NSString *parameterName in [[extraOAuthParameters allKeys] sortedArrayUsingSelector:@selector(compare:)])
	{
		[extraParameters appendFormat:@"&%@=%@",
		 [parameterName URLEncodedString],
		 [[extraOAuthParameters objectForKey:parameterName] URLEncodedString]];
	}
    
    oauthQueryString=[NSString stringWithFormat:@"%@%@",oauthQueryString,extraParameters];
    
    NSString *url=[NSString stringWithFormat:@"%@%@",self.URL.description,oauthQueryString];
    [self setURL:[NSURL URLWithString:url]];
}


@end
