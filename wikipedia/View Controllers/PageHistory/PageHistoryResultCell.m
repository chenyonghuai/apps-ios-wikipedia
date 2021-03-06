//  Created by Monte Hurd on 11/19/13.
//  Copyright (c) 2013 Wikimedia Foundation. Provided under MIT-style license; please copy and modify!

#import "PageHistoryResultCell.h"
#import "NSObject+ConstraintsScale.h"
#import "PageHistoryLabel.h"
#import "Defines.h"
#import "NSString+Extras.h"
#import "UIFont+WMFStyle.h"

@interface PageHistoryResultCell ()

@property (weak, nonatomic) IBOutlet PageHistoryLabel* summaryLabel;
@property (weak, nonatomic) IBOutlet PageHistoryLabel* nameLabel;
@property (weak, nonatomic) IBOutlet PageHistoryLabel* timeLabel;
@property (weak, nonatomic) IBOutlet PageHistoryLabel* deltaLabel;
@property (weak, nonatomic) IBOutlet PageHistoryLabel* iconLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* separatorHeightConstraint;

@end

@implementation PageHistoryResultCell

+ (NSDateFormatter*)dateFormatter {
    static NSDateFormatter* _formatter = nil;

    if (!_formatter) {
        // See: https://www.mediawiki.org/wiki/Manual:WfTimestamp
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [_formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        _formatter.dateStyle         = NSDateFormatterNoStyle;
        _formatter.timeStyle         = NSDateFormatterShortStyle;
        _formatter.formatterBehavior = NSDateFormatterBehavior10_4;
    }

    return _formatter;
}

- (void)setName:(NSString*)name
           time:(NSString*)time
          delta:(NSNumber*)delta
           icon:(NSString*)icon
        summary:(NSString*)summary
      separator:(BOOL)separator {
    self.nameLabel.text = name;

    self.timeLabel.text = [[[self class] dateFormatter] stringForObjectValue:[time getDateFromIso8601DateString]];

    self.deltaLabel.text =
        [NSString stringWithFormat:@"%@%@", (delta.integerValue > 0) ? @"+" : @"", delta.stringValue];

    if (delta.integerValue == 0) {
        self.deltaLabel.textColor = WMF_COLOR_BLUE;
    } else if (delta.integerValue > 0) {
        self.deltaLabel.textColor = WMF_COLOR_GREEN;
    } else {
        self.deltaLabel.textColor = WMF_COLOR_RED;
    }

    NSDictionary* iconAttributes =
        @{
        NSFontAttributeName: [UIFont wmf_glyphFontOfSize:23.0 * MENUS_SCALE_MULTIPLIER],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.78 green:0.78 blue:0.78 alpha:1.0],
        NSBaselineOffsetAttributeName: @1
    };

    self.iconLabel.attributedText =
        [[NSAttributedString alloc] initWithString:icon
                                        attributes:iconAttributes];

    self.summaryLabel.text = [summary getStringWithoutHTML];

    self.separatorHeightConstraint.constant =
        (separator) ? (1.0f / [UIScreen mainScreen].scale) : 0.0f;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initial changes to ui elements go here.
    // See: http://stackoverflow.com/a/15591474 for details.

    [self adjustConstraintsScaleForViews:
     @[self.summaryLabel, self.nameLabel, self.timeLabel, self.deltaLabel, self.iconLabel]
    ];
}

@end
