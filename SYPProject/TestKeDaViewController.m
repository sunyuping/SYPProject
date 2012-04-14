//
//  TestKeDaViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestKeDaViewController.h"


@implementation TestKeDaViewController

-(void)dealloc{
    [super dealloc];
    [_iFlySynthesizerControl release];
    [testtextview release];
    [_iFlyRecognizeControl release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

-(void)getchild:(UIView*)parentview{
    NSLog(@"this--info===%@",parentview);
    NSArray *tmparr = [parentview subviews];
    NSLog(@"this--childnumber===%d",[tmparr count]);
    if (tmparr != nil && [tmparr count] > 0) {
        for (UIView* aview in tmparr){
            [self getchild:aview];
        }
    }
}

-(void)viewlistinfo:(UIView*)rootview{
    NSLog(@"rootview--info===%@",rootview);
    [self getchild:rootview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    testtextview = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300, 200)];
    testtextview.text=@"程序在运行时会先检测当前文件夹有没有需要的dll文件，";
    //如果没有就会按照PATH环境变量逐一搜索（windows文件夹就是其中之一）。通常我们运行程序时，都要求exe和dll在同一文件夹下，但是VS在调试时，并不一定是在程序所在文件夹运行程序，这与工程配置有关。以VS的默认配置为例，新建一个工程test，会产生一个test文件夹，其下有Debug和另一个test文件夹，在下面的这个test文件夹中还有一个Debug。在下面的这个test文件夹中一般保存源码，同时VS调试时也会在这个文件夹进行。在下面的这个Debug文件夹中一般保存编译生成的中间件和链接之后的可执行程序。上面的Debug文件夹通常保存链接之后产生的可执行程序。通常我们自己运行程序时，要进入Debug文件夹，这时要求对应的dll文件在同一个文件夹中；但是VS调试时，是在下面的test文件夹中运行，这时就要求对应的dll文件在下面的test文件夹中。
    [self.view addSubview:testtextview];
    
    UIButton *changebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [changebutton setTitle:@"开始转换" forState:UIControlStateNormal];
    changebutton.frame = CGRectMake(20, 220, 280, 40);
    [changebutton addTarget:self action:@selector(getMp3) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:changebutton];
    
    UIButton *recodbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [recodbutton setTitle:@"开始语音" forState:UIControlStateNormal];
    recodbutton.frame = CGRectMake(20, 270, 280, 40);
    [recodbutton addTarget:self action:@selector(seartRecod) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:recodbutton];
    
    
    
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
    
    // 识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc]initWithOrigin:CGPointMake(20, 70) theInitParam:initParam];
	[self.view addSubview:_iFlyRecognizeControl];
    [_iFlyRecognizeControl setSampleRate:16000];
    [_iFlyRecognizeControl setEngine:@"sms" theEngineParam:nil theGrammarID:nil];
	_iFlyRecognizeControl.delegate = self;
    
	// 合成控件
    _iFlySynthesizerControl = [[IFlySynthesizerControl alloc] initWithOrigin:CGPointMake(20, 70) theInitParam:initParam];
    
    
    //_iFlySynthesizerControl = [[IFlySynthesizerControl alloc]initWithFrame:CGRectMake(10, 110, 200, 100) theInitParam:initParam ];
	_iFlySynthesizerControl.delegate = self;
    [_iFlySynthesizerControl setSampleRate:16000];
    
	[self.view addSubview:_iFlySynthesizerControl];
	[initParam release];
	//_synthesizerSetupController = [[UISynthesizerSetupController alloc] initWithSynthesizer:_iFlySynthesizerControl];
    
    [_iFlySynthesizerControl setVoiceName:@"henry"];
    
    NSLog(@"_iFlyRecognizeControl====info==%@",_iFlyRecognizeControl);
    NSLog(@"_iFlySynthesizerControl====info==%@",_iFlySynthesizerControl);
    
    UIButton *test001 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [test001 setTitle:@"开始546音" forState:UIControlStateNormal];
    test001.frame = CGRectMake(0, 0, 80, 40);
   // [test001 addTarget:self action:@selector(seartRecod) forControlEvents:UIControlEventTouchDown];
    [_iFlyRecognizeControl addSubview:test001];
    

}
-(void)seartRecod{
	NSLog(@"UIkeywordController onButtonKeyword:%@",_keywordID);
	
	//[_iFlyRecognizeControl setEngine:@"keyword" theEngineParam:nil theGrammarID:_keywordID];
	
	if([_iFlyRecognizeControl start])
	{
		_type = IsrKeyword;
        [self viewlistinfo:self.view];
	}

}
-(void)getMp3{
    [_iFlySynthesizerControl setText:testtextview.text theParams:nil];
    [_iFlySynthesizerControl setShowUI:YES];
	if([_iFlySynthesizerControl start]){
        NSLog(@"正在播放。。。。");
        [self viewlistinfo:self.view];
        
        
        
        
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[testtextview resignFirstResponder];
}

- (void)onSynthesizerEnd:(IFlySynthesizerControl *)iFlySynthesizerControl theError:(SpeechError) error{
    NSLog(@"合成结束。。error==%d。错误码描述=%@",error,[iFlySynthesizerControl getErrorDescription:error]);
    
    
}
//	识别结束回调
- (void)onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(SpeechError) error
{
	NSLog(@"识别结束回调finish.....");
	//[self onButtonKeyword];
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
	
}
//语音
- (void)onRecognizeResult:(NSArray *)array
{
	[self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:[array objectAtIndex:0] waitUntilDone:YES];
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	NSLog(@"- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl thParam:(id)params");
	if(_type == IsrKeyword)
	{
        NSMutableString *sentence = [[[NSMutableString alloc] init] autorelease];
        
        for (int i = 0; i < [resultArray count]; i++)
        {
            [sentence appendFormat:@"%@	置信度:%@\n",[[resultArray objectAtIndex:i] objectForKey:@"NAME"],
             [[resultArray objectAtIndex:i] objectForKey:@"SCORE"]];
        }
        [self performSelectorOnMainThread:@selector(onUpdateTextView:) withObject:sentence waitUntilDone:YES];
        
        NSLog(@"keyword result : %@", sentence);
	}
	else 
	{
		
		[_keywordID release];
		_keywordID = [[resultArray objectAtIndex:0] retain];
		NSLog(@"UIkeywordController onResult:%@",_keywordID);
	}
}
-(void)onUpdateTextView:(NSString *)text{
    NSString *oldtex = testtextview.text;
    testtextview.text = [NSString stringWithFormat:@"%@%@",oldtex,text];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
