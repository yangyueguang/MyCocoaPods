
#import <UIKit/UIKit.h>
@interface UIImage (expanded)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)fixOrientation;
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;
- (UIImage *) imageWithWaterText:(NSString*)text inRect:(CGRect)rect;
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;
-(UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage*)resizeImageWithNewSize:(CGSize)newSize;
+(UIImage *)imageName:(NSString *)name;
// 根据图片名返回一张能够自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)name;
//根据图片名返回一张能够自由拉伸的图片
+ (UIImage *)resizableImageWithName:(NSString *)imageName;
/// 获取屏幕截图
+ (UIImage *)scott_screenShot;
// blur  模糊程度 (0~1)
+ (UIImage *)scott_blurImage:(UIImage *)image blur:(CGFloat)blur;
- (UIImage *)imageWithAlpha:(CGFloat)alpha;
///图片灰色
- (UIImage *)grayImage;
- (UIImage *)subImageAtRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageScaledToWidth:(CGFloat)value;
- (UIImage *)imageScaledToHeight:(CGFloat)value;
- (UIImage *)imageScaledToSizeEx:(CGSize)size;
- (UIImage *)imageWithShadowColor:(UIColor *)color offset:(CGSize)offset blur:(CGFloat)blur;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)gaussianBlur;
- (CGFloat)resizableHeightWithFixedwidth:(CGFloat)width;
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;
-(UIImage*)getGrayImage:(UIImage*)sourceImage;
+ (UIImage *) getLaunchImage;
+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)scalingToSize:(CGSize)size;
//加载最原始的图片,没有经过渲染
+(instancetype)imageWithRenderingOriginalName:(NSString *)imageName;
//加载全屏的图片
+(UIImage *)fullScreenImage:(NSString *)imageName;
//可以自由拉伸的图片
+ (UIImage *)resizedImage:(NSString *)imageName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;
//  可以自由拉伸不会变形的图片
+ (instancetype)imageWithStretchableName:(NSString *)imageName;
+ (instancetype)resizableWithImageName:(NSString *)imageName;
- (CGRect) getRectWithSize:(CGSize) size;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h;
@end
