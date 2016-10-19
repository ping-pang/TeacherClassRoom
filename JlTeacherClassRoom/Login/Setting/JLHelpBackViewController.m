//
//  JLHelpBackViewController.m
//  JLClassroom
//
//  Created by JingLun on 15/6/30.
//  Copyright (c) 2015年 Mac Os. All rights reserved.
//

#import "JLHelpBackViewController.h"
#import "JLHelpTableViewCell.h"
#import "JLHelpDetilViewController.h"
//#import "FileManager.h"

@interface JLHelpBackViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * table;

@end
static NSString *const SUCCESS = @"success";
static NSString *const ERROR = @"error";
@implementation JLHelpBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationViewWithLeftImg:nil title:@"帮助信息" rightImg:nil];
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height-64) style:UITableViewStylePlain];
    _table.delegate=self;
    _table.dataSource=self;
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-----
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataList.count;
    return self.dataList.count -1 ;//暂时隐藏一条
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellidtenfier=@"jlhelpCellid";
    JLHelpTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellidtenfier];
    if (cell==nil) {
        cell=[[JLHelpTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidtenfier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSString * title =self.dataList[indexPath.row][@"qaTitle"];
    [cell cellWithTitle:title];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * qaidc=self.dataList[indexPath.row][@"qaId"];
    [[MBProgressController sharedInstance] showTipsLoadingWithText:@"正在加载..." AndDelay:1.5];
    [self displeayHelpDitile:qaidc];
}
-(void)displeayHelpDitile:(NSString*)qadid{
//       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
       NSString *base = [NSString stringWithFormat:@"userId=%@&S=%@&businessSysId=%@",[[UserModel sharedUser]uid],[[UserModel sharedUser]my_cookie],@"2"];
    
                NSString * url=[[NSString stringWithFormat:@"%@getQaInfo&%@&qaId=%@",JL_HTTP_URL111,base,qadid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
           NSLog(@"url %@",url);
                HTTPManage * manage=[HTTPManage shareInstance];
           
           [manage afgetRequestWithUrl:url withPariermet:nil success:^(id responseObject) {
//               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               if ([responseObject[@"success"] isEqualToString:@"true"]) {
                   JLHelpDetilViewController *detailVC = [[JLHelpDetilViewController alloc] init];
                   detailVC.info = [NSString stringWithFormat:@"%@", responseObject[@"qaQuestion"]];
               detailVC.contentDic = responseObject[@"data"][0];
                   NSLog(@"test data is:: %@",responseObject[@"qaQuestion"]);
                 
                
                   NSLog(@"%@~%@",[detailVC.contentDic objectForKey:@"qaQuestion"],responseObject[@"qaAnswei"]);
                   [self.navigationController pushViewController:detailVC animated:YES];
                   
               
               }
           } fail:^{
               JLHelpDetilViewController *detailVC = [[JLHelpDetilViewController alloc] init];
               
           
               [detailVC addNavigationViewWithLeftImg:@"" title:@"帮助详情" rightImg:@""];
               [self.navigationController pushViewController:detailVC animated:YES];

           }];
    
    
           
           
//                [manage afget:url withPariermet :nil success:^(id responseObject) {
//                    id jsonObj = [NSJSONSerialization JSONObjectWithData:responseObject options:
//                                  NSJSONReadingMutableLeaves error:nil];
//                    if ([jsonObj isKindOfClass:[NSDictionary class]]) {
//                        NSDictionary *resDic = [NSDictionary dictionaryWithDictionary:jsonObj];
//                        if ([resDic[@"success"] isEqualToString:@"true"]) {
//                            if (resDic[@"data"] != [NSNull null] && [resDic[@"data"] count] !=0)
//                            {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    JLHelpDetilViewController    *detailVC = [[JLHelpDetilViewController alloc] init];
//    
//                                    detailVC.contentDic = [NSMutableDictionary dictionaryWithDictionary:resDic[@"data"][0]];
//                                    [detailVC addNavigationViewWithLeftImg:@"" title:@"帮助详情" rightImg:@""];
//                                    NSLog(@"%@",[detailVC.contentDic objectForKey:@"qaAnswer"]);
//                                    [self.navigationController pushViewController:detailVC animated:YES];
//                                });
//                            }
//                        }
//                    }
//                } fail:^{
//                   
//                }];
//       });
}
@end
