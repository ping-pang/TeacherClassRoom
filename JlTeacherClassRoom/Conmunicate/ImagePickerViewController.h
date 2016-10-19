//
//  ImagePickerViewController.h
//  Reader
//
//  Created by zhangtao on 15/12/6.
//  Copyright © 2015年 zt.td. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol getPhotoDelegate <NSObject>

-(void)OnGetPhoto:(UIImage *)img;

@end

@interface ImagePickerViewController : UIImagePickerController<UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)UIImage *imgae;

@property(nonatomic,assign)id<getPhotoDelegate>photoDelegate;
-(void)takePhone:(id)target;
-(void)localPhone:(id)target;


//////
-(UIImage *)getImg:(UIImage *)img;




@end
