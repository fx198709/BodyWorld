//
//  SelectCountryCell.h
//  FFitWorld

//
//  Created by xiejc on 2021/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectCountryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backSelectbtn;
@property (nonatomic, copy) AnyBtnBlock selectedCourntyBlock;

- (IBAction)backSelectedBtnClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
