
#import <UIKit/UIKit.h>

@interface HECornerImageCacher : NSObject

+ (HECornerImageCacher*)maskImageCacher;

- (UIImage*)originalImage:(NSString*)name cR:(CGFloat)cr andSize:(CGSize)size contentMode:(UIViewContentMode)mode;
- (void)storeOrigImage:(UIImage*)image name:(NSString*)name cR:(CGFloat)cr andSize:(CGSize)size contentMode:(UIViewContentMode)mode;

- (UIImage*)maskImageWithCR:(CGFloat)cr andSize:(CGSize)size;
- (void)storeMaskImageWith:(UIImage*)image cR:(CGFloat)cr andSize:(CGSize)size;

@end
