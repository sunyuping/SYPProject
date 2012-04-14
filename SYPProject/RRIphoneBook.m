//
//  RRIphoneBook.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRIphoneBook.h"
#import "AddressBook/AddressBook.h"
@implementation RRIphoneBook
- (RRIphoneBook*)init{
    if (self == [super init]) {
        [self getallInfo];
        _allphonenumber = [NSMutableArray alloc];
    } 
    return self;
}
-(void)dealloc{
    [super dealloc];
    [_allphonenumber release];
}
- (void) getallInfo{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        NSMutableArray *ionepersion = [NSMutableArray arrayWithCapacity:24];
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        NSMutableString *name = [[NSMutableString alloc] init];
        //读取firstname
        NSString *personName = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(personName != nil){
            [name appendString:personName];
        }
        //textView.text = [textView.text stringByAppendingFormat:@"\n姓名：%@\n",personName];
        //读取middlename
        NSString *middlename = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        if(middlename != nil){
            
        }
        //textView.text = [textView.text stringByAppendingFormat:@"%@\n",middlename];
        //读取lastname
        NSString *lastname = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(lastname != nil){
             [name appendString:lastname];
        }
        //textView.text = [textView.text stringByAppendingFormat:@"%@\n",lastname];

        //读取prefix前缀
        NSString *prefix = (NSString*)ABRecordCopyValue(person, kABPersonPrefixProperty);
        if(prefix != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",prefix];
        //读取suffix后缀
        NSString *suffix = (NSString*)ABRecordCopyValue(person, kABPersonSuffixProperty);
        if(suffix != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",suffix];
        //读取nickname呢称
        NSString *nickname = (NSString*)ABRecordCopyValue(person, kABPersonNicknameProperty);
        if(nickname != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",nickname];
        //读取firstname拼音音标
        NSString *firstnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
        if(firstnamePhonetic != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",firstnamePhonetic];
        //读取lastname拼音音标
        NSString *lastnamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        if(lastnamePhonetic != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",lastnamePhonetic];
        //读取middlename拼音音标
        NSString *middlenamePhonetic = (NSString*)ABRecordCopyValue(person, kABPersonMiddleNamePhoneticProperty);
        if(middlenamePhonetic != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",middlenamePhonetic];
        //读取organization公司
        NSString *organization = (NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
        if(organization != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",organization];
        //读取jobtitle工作
        NSString *jobtitle = (NSString*)ABRecordCopyValue(person, kABPersonJobTitleProperty);
        if(jobtitle != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",jobtitle];
        //读取department部门
        NSString *department = (NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
        if(department != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",department];
        //读取birthday生日
        NSDate *birthday = (NSDate*)ABRecordCopyValue(person, kABPersonBirthdayProperty);
        if(birthday != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",birthday];
        //读取note备忘录
        NSString *note = (NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
        if(note != nil)
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",note];
        //第一次添加该条记录的时间
        NSString *firstknow = (NSString*)ABRecordCopyValue(person, kABPersonCreationDateProperty);
        NSLog(@"第一次添加该条记录的时间%@\n",firstknow);
        //最后一次修改該条记录的时间
        NSString *lastknow = (NSString*)ABRecordCopyValue(person, kABPersonModificationDateProperty);
        NSLog(@"最后一次修改該条记录的时间%@\n",lastknow);
        
        //获取email多值
        ABMultiValueRef email = ABRecordCopyValue(person, kABPersonEmailProperty);
        int emailcount = ABMultiValueGetCount(email);    
        for (int x = 0; x < emailcount; x++)
        {
            //获取email Label
            NSString* emailLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(email, x));
            //获取email值
            NSString* emailContent = (NSString*)ABMultiValueCopyValueAtIndex(email, x);
            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",emailLabel,emailContent];
        }
        //读取地址多值
        ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        int count = ABMultiValueGetCount(address);    
        
        for(int j = 0; j < count; j++)
        {
            //获取地址Label
            NSString* addressLabel = (NSString*)ABMultiValueCopyLabelAtIndex(address, j);
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",addressLabel];
            //获取該label下的地址6属性
            NSDictionary* personaddress =(NSDictionary*) ABMultiValueCopyValueAtIndex(address, j);        
            NSString* country = [personaddress valueForKey:(NSString *)kABPersonAddressCountryKey];
            if(country != nil)
                textView.text = [textView.text stringByAppendingFormat:@"国家：%@\n",country];
            NSString* city = [personaddress valueForKey:(NSString *)kABPersonAddressCityKey];
            if(city != nil)
                textView.text = [textView.text stringByAppendingFormat:@"城市：%@\n",city];
            NSString* state = [personaddress valueForKey:(NSString *)kABPersonAddressStateKey];
            if(state != nil)
                textView.text = [textView.text stringByAppendingFormat:@"省：%@\n",state];
            NSString* street = [personaddress valueForKey:(NSString *)kABPersonAddressStreetKey];
            if(street != nil)
                textView.text = [textView.text stringByAppendingFormat:@"街道：%@\n",street];
            NSString* zip = [personaddress valueForKey:(NSString *)kABPersonAddressZIPKey];
            if(zip != nil)
                textView.text = [textView.text stringByAppendingFormat:@"邮编：%@\n",zip];    
            NSString* coutntrycode = [personaddress valueForKey:(NSString *)kABPersonAddressCountryCodeKey];
            if(coutntrycode != nil)
                textView.text = [textView.text stringByAppendingFormat:@"国家编号：%@\n",coutntrycode];    
        }
        
        //获取dates多值
        ABMultiValueRef dates = ABRecordCopyValue(person, kABPersonDateProperty);
        int datescount = ABMultiValueGetCount(dates);    
        for (int y = 0; y < datescount; y++)
        {
            //获取dates Label
            NSString* datesLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(dates, y));
            //获取dates值
            NSString* datesContent = (NSString*)ABMultiValueCopyValueAtIndex(dates, y);
            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",datesLabel,datesContent];
        }
        //获取kind值
        CFNumberRef recordType = ABRecordCopyValue(person, kABPersonKindProperty);
        if (recordType == kABPersonKindOrganization) {
            // it's a company
            NSLog(@"it's a company\n");
        } else {
            // it's a person, resource, or room
            NSLog(@"it's a person, resource, or room\n");
        }
        
        
        //获取IM多值
        ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
        for (int l = 1; l < ABMultiValueGetCount(instantMessage); l++)
        {
            //获取IM Label
            NSString* instantMessageLabel = (NSString*)ABMultiValueCopyLabelAtIndex(instantMessage, l);
            textView.text = [textView.text stringByAppendingFormat:@"%@\n",instantMessageLabel];
            //获取該label下的2属性
            NSDictionary* instantMessageContent =(NSDictionary*) ABMultiValueCopyValueAtIndex(instantMessage, l);        
            NSString* username = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageUsernameKey];
            if(username != nil)
                textView.text = [textView.text stringByAppendingFormat:@"username：%@\n",username];
            
            NSString* service = [instantMessageContent valueForKey:(NSString *)kABPersonInstantMessageServiceKey];
            if(service != nil)
                textView.text = [textView.text stringByAppendingFormat:@"service：%@\n",service];            
        }
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phone, k));
            //获取該Label下的电话值
            NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",personPhoneLabel,personPhone];
        }
        
        //获取URL多值
        ABMultiValueRef url = ABRecordCopyValue(person, kABPersonURLProperty);
        for (int m = 0; m < ABMultiValueGetCount(url); m++)
        {
            //获取电话Label
            NSString * urlLabel = (NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(url, m));
            //获取該Label下的电话值
            NSString * urlContent = (NSString*)ABMultiValueCopyValueAtIndex(url,m);
            
            textView.text = [textView.text stringByAppendingFormat:@"%@:%@\n",urlLabel,urlContent];
        }
        
        //读取照片
        NSData *image = (NSData*)ABPersonCopyImageData(person);
        
        
        UIImageView *myImage = [[UIImageView alloc] initWithFrame:CGRectMake(200, 0, 50, 50)];
        [myImage setImage:[UIImage imageWithData:image]];
        myImage.opaque = YES;
        [textView addSubview:myImage];
    }
    CFRelease(results);
    CFRelease(addressBook);
    
}
@end
