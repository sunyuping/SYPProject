//
//  TestTableViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-10-31.
//
//

#import "TestTableViewController.h"

#import "SCLocationManager.h"


@interface TestTableViewController ()

@end

@implementation TestTableViewController
@synthesize tableview=_tableview;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"测试tableview";
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,320, 400) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        [tmp setBackgroundColor:[UIColor redColor]];
        _tableview.tableHeaderView = tmp;
        _tableview.sectionHeaderHeight = 40;
        [tmp release];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:self.tableview];

    SCLocationManager *locmanger = [[SCLocationManager alloc] init];
    [locmanger setKeepOpening:YES];
    [locmanger startUpdateLocation];
//    CLLocationManager *locManager = [[CLLocationManager alloc] init];
//
//    self.locationManager.delegate = self;
//    //if([CLLocationManager locationServicesEnabled]){
//    [self.locationManager startUpdatingLocation];
//    //}
//    [self.locationManager stopUpdatingHeading];
//    self.locationManager.distanceFilter = 0.0f;
//    self.locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *tmp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    [tmp setBackgroundColor:[UIColor blueColor]];
    return  [tmp autorelease];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 60;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID=@"testtableviewCell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
	if(cell==nil)
		cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID]autorelease];
	NSString *text=[NSString stringWithFormat:@"test===%d",indexPath.row];
	cell.textLabel.text=[text stringByDeletingPathExtension];
	UIImage *mailImage=[UIImage imageNamed:@"icon.png"];
	UIButton *mailButton=[[UIButton alloc]initWithFrame:CGRectMake(0,0,32,32)];
	[mailButton setImage:mailImage forState:UIControlStateNormal];
	mailButton.tag=indexPath.row;
	//[mailButton addTarget:self action:@selector(mailButtonTouched:)forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView=mailButton;
	return cell;

}
@end
