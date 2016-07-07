//
//  test.h
//  tableViewTest
//
//  Created by Kevin on 16/7/6.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(cornerRadius)

- (void)setImageName:(NSString*)name withCR:(CGFloat)fRadius;
- (void)setImageName:(NSString*)name withCR:(CGFloat)fRadius contentMode:(UIViewContentMode)contentMode;

/*
    @pram: the key must be unique to the image, if not, the result will
    be not what you want!
 **/
- (void)setImage:(UIImage *)image cR:(CGFloat)fRadius cacheKey:(NSString*)key;
- (void)setImage:(UIImage *)image cR:(CGFloat)fRadius cacheKey:(NSString*)key contentMode:(UIViewContentMode)contentMode;

@end
