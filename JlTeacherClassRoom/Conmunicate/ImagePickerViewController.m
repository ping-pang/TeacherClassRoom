//
//  ImagePickerViewController.m
//  Reader
//
//  Created by zhangtao on 15/12/6.
//  Copyright © 2015年 zt.td. All rights reserved.
//

#import "ImagePickerViewController.h"

@interface ImagePickerViewController ()<UINavigationControllerDelegate>

@end

@implementation ImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)takePhone:(id)target{
    self.photoDelegate = target;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
}

-(void)localPhone:(id)target{
    self.photoDelegate = target;
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //选择的图片类型
    NSLog(@"~~~~~~");
    if ([type isEqualToString:@"public.image"]) {
        //先把图片的类型换成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        _imgae = image;
      
        if (self.photoDelegate && [self.photoDelegate respondsToSelector:@selector(OnGetPhoto:)]) {
            [self.photoDelegate OnGetPhoto:image];

        }
        
        
        //关闭相册界面
         [picker dismissViewControllerAnimated:YES completion:nil];


}
}

-(UIImage *)getImg:(UIImage *)img{
    UIImage *image = img;
    return image;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
