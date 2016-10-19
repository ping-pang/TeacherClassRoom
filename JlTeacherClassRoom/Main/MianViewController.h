//
//  MianViewController.h
//  JlTeacherClassRoom
//
//  Created by app on 15/12/2.
//  Copyright © 2015年 app. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MianViewController : JLBaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuxi_top_cons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuxi_w_cons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yuxi_h_cons;

@property (weak, nonatomic) IBOutlet UILabel *yuxilabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dati_top_cons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dati_w_cons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dati_h_cons;

@property (weak, nonatomic) IBOutlet UILabel *datilabel;
@end
