//
//  NSMutableURLRequest+UploadFile.h
//  SunAuto
//
//  Created by mini2 on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (FormData)

- (void)setFormDataWithTextField:(NSDictionary *)textField withFileField:(NSDictionary *)fileField;

@end
