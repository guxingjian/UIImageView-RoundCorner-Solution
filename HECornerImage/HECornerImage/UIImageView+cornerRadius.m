//
//  test.m
//  tableViewTest
//
//  Created by Kevin on 16/7/6.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "UIImageView+cornerRadius.h"
#import "HECornerImageMaker.h"
#import "HECornerImageCacher.h"

#import <objc/runtime.h>

const char* imageCacheKey = "imageCacheKey";

@implementation UIImageView(cornerRadius)

- (void)setImage:(UIImage *)image cR:(CGFloat)fRadius cacheKey:(NSString *)key
{
    [self setImage:image cR:fRadius cacheKey:key contentMode:UIViewContentModeScaleToFill];
}

- (void)setImage:(UIImage *)image cR:(CGFloat)fRadius cacheKey:(NSString *)key contentMode:(UIViewContentMode)contentMode
{
    if(0 == fRadius)
    {
        self.contentMode = contentMode;
        self.image = image;
        return ;
    }
    
    if(key.length > 0)
    {
        objc_setAssociatedObject(image, imageCacheKey, key, OBJC_ASSOCIATION_RETAIN);
    }
    
    HECornerImageMaker* maker = [HECornerImageMaker imageMaker];
    [maker makeCornerImageWithImage:image cR:fRadius viewSize:self.bounds.size contentMode:contentMode completely:^(UIImage *cornerkImage) {
        self.image = cornerkImage;
    }];

}

- (void)setImageName:(NSString *)name withCR:(CGFloat)fRadius
{
    [self setImageName:name withCR:fRadius contentMode:UIViewContentModeScaleToFill];
}

- (void)setImageName:(NSString *)name withCR:(CGFloat)fRadius contentMode:(UIViewContentMode)contentMode
{
    if(0 == name.length)
        return ;
    
    UIImage* cacheOrigImage = [[HECornerImageCacher maskImageCacher] originalImage:name cR:fRadius andSize:self.bounds.size contentMode:contentMode];
    if(cacheOrigImage)
    {
        self.image = cacheOrigImage;
        return ;
    }
    
    UIImage* image = [UIImage imageNamed:name];
    if(!image)
        return ;
    
    [self setImage:image cR:fRadius cacheKey:name contentMode:contentMode];
}

@end
