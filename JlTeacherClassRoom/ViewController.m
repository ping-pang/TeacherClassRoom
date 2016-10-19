//
//  ViewController.m
//  JlTeacherClassRoom
//
//  Created by app on 15/11/30.
//  Copyright © 2015年 app. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.backgroundColor=[UIColor redColor];
    [self.view addSubview:label];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
