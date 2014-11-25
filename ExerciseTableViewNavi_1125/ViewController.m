//
//  ViewController.m
//  ExerciseTableViewNavi_1125
//
//  Created by Cyrilshanway on 2014/11/25.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    //新增datasource
    NSArray *dataSource;
    NSArray *detailDataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //datasource init
    self.title = @"測試";
    
    dataSource = [NSArray arrayWithObjects:@"Message1", @"Message2", @"Message3", @"Message4", @"Message5", @"Message6", @"Message7", @"Message8", nil];
    detailDataSource = [NSArray arrayWithObjects:@"Abstract1", @"Abstract2", @"Abstract3", @"Abstract4", @"Abstract5", @"Abstract6", @"Abstract7", @"Abstract8", nil];
    
    NSLog(@"DataSource: %@", dataSource);
    NSLog(@"Detail DataSource: %@", detailDataSource);
    
    
    UIBarButtonItem *preButton = [[UIBarButtonItem alloc] initWithTitle:@"上一頁" style:(UIBarButtonItemStylePlain) target:self action:@selector(back:)];
    
    [preButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:12], NSFontAttributeName, nil] forState:(UIControlStateNormal)];//value/key
    
    //設定完成，裝上navigation controller
    self.navigationItem.leftBarButtonItem = preButton;
}

-(void)back:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"前一頁" delegate:self cancelButtonTitle:@"確認" otherButtonTitles: nil];
    [alert show];
}

- (IBAction)complete:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"完成" delegate:self cancelButtonTitle:@"關閉" otherButtonTitles: nil];
    [alert show];
    
    [self getRemoteURL];
}

- (void)getRemoteURL
{
    // Prepare the HTTP Client
    AFHTTPClient *httpClient =
    [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.187.98.65/"]];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"api/v1/AlphaCampTest.php"
                                                      parameters:nil];
    
    // Set the opration
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    // Set the callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tmp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // Test Log
        NSLog(@"Response: %@", tmp);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    
    // Start the opration
    [operation start];
}


#pragma mark - UITableView Delegate
//分類
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//欄位高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
//要顯示幾個欄位
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *requestIdentifier = @"HelloCell";
    static NSString *requestIdentifier2 = @"HelloCell2";
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
        case 0:{
            cell = [tableView dequeueReusableCellWithIdentifier:requestIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:requestIdentifier];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.detailTextLabel.textColor =
                [UIColor colorWithRed:241.0f/255.0f green:244.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
                cell.backgroundColor = [UIColor clearColor];
                
                cell.textLabel.font  = [UIFont fontWithName: @"AvenirNextCondensed-Bold" size: 14.0];
                
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
                
                cell.selectionStyle =UITableViewCellSelectionStyleGray;
            }
        }
            break;
            
        case 1: {
            cell = [tableView dequeueReusableCellWithIdentifier:requestIdentifier2];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:requestIdentifier2];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.detailTextLabel.textColor =
                [UIColor colorWithRed:241.0f/255.0f green:244.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
                cell.backgroundColor = [UIColor clearColor];
                
                cell.textLabel.font  = [UIFont fontWithName: @"AvenirNextCondensed-Bold" size: 14.0];
                
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
                
                cell.selectionStyle =UITableViewCellSelectionStyleGray;
            }
        }
            break;
    }
    
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:requestIdentifier];
    
    cell.textLabel.text = dataSource[indexPath.row];
    cell.detailTextLabel.text = detailDataSource[indexPath.row];
    
    NSString *title;
    switch (indexPath.section) {
        case 0:
            title = @"Download";
            break;
        case 1:
            title = @"Upload";
            break;
            
        default:
            break;
    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(230, 10, 80, 40)];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName: @"AvenirNextCondensed-Bold" size: 12.0];
    [button setBackgroundColor:[UIColor clearColor]];
    button.tag = indexPath.row;
    
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    
    [button.layer setCornerRadius:10.0f];
    [button.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [button.layer setBorderWidth:2.0f];
    
    //    if (indexPath.row == 0) {
    //        cell.textLabel.text = @"Message";
    //        cell.detailTextLabel.text = @"Abstract";
    //    }
    //    else {
    //        cell.textLabel.text = @"iOS";
    //        cell.detailTextLabel.text = @"iOS Abstract";
    //    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You pressed: %ld %ld", indexPath.section, indexPath.row);
}

- (void)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"You pressed the button %ld", button.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
