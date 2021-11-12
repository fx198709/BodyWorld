#import "BaseObject.h"

@interface Plan : BaseObject

@property (nonatomic , assign) NSInteger              duration;
@property (nonatomic , copy) NSString              * stage;

- (BOOL)isEqualToPlan:(Plan *)plan;

@end
