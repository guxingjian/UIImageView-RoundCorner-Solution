# UIImageView-RoundCorner-Solution
version 1.0

解决UIImageView显示圆角的问题.
圆角问题的解决方案有很多, 本方案是对自定义圆角图片的优化

使用UIImageView中的分类方法即可设置圆角

@interface UIImageView(cornerRadius)

- (void)setImageName:(NSString*)name withCR:(CGFloat)fRadius;
- (void)setImageName:(NSString*)name withCR:(CGFloat)fRadius contentMode:(UIViewContentMode)contentMode;

/*
    @pram: the key must be unique to the image, if not, the result is undefined
 **/
- (void)setImage:(UIImage *)image cR:(CGFloat)fRadius cacheKey:(NSString*)key;
- (void)setImage:(UIImage *)image cR:(CGFloat)fRadius cacheKey:(NSString*)key contentMode:(UIViewContentMode)contentMode;

@end

1. 根据UIImageView的size和圆角大小生成一张蒙版图片, 蒙版图片四角不透明, 中间透明(缓存蒙版图片)
2. 使用蒙版图片和原始图片合成新图片, 利用混合模式, 切掉原始图片的四角(缓存新图片)
3. 显示新生成的图片

全程在主线程处理, 防止图片延迟加载造成的闪动现象

经测试, 显示帧率在50以上, CPU使用率在30%左右


