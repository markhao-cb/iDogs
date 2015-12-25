

#import <UIKit/UIKit.h>
@class ZBFlowView;

@protocol ZBFlowViewDelegate <NSObject>

- (void)pressedAtFlowView:(ZBFlowView *)flowView;

@end

@interface ZBFlowView : UIView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, assign) id <ZBFlowViewDelegate> flowViewDelegate;

@end
