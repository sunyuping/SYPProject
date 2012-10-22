//
//  NSMutableURLRequest+UploadFile.m
//  SunAuto
//
//  Created by mini2 on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableURLRequest+FormData.h"

@implementation NSMutableURLRequest (FormData)
- (void)setFormDataWithTextField:(NSDictionary *)textField withFileField:(NSDictionary *)fileField
{
    NSString *boundary=@"75kdeale0a93jakaie22";
    NSMutableData *postData=[[NSMutableData alloc] init];
    [self setHTTPMethod:@"POST"];
    [self setValue:[NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    if(textField)
    {
        for(NSString *name in textField.allKeys)
        {
            NSString *value=[textField objectForKey:name];
            [postData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",boundary,name,value] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    if(fileField)
    {
        for(NSString *name in fileField.allKeys)
        {
            NSData *value=[fileField objectForKey:name];
            [postData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\nContent-Type: application/octet-stream\r\n\r\n",boundary,name,name] dataUsingEncoding:NSUTF8StringEncoding]];
            [postData appendData:value];
            [postData appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
             
        }
    }
    
    [postData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self setValue:[NSString stringWithFormat:@"%d",postData.length] forHTTPHeaderField:@"Content-Length"];
    [self setHTTPBody:postData];
    [postData release];
}
@end
