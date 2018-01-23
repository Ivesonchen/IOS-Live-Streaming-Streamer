
#import "ViewController.h"
#import "SGSimpleSession.h"
#import "SGAudioConfig.h"
#import "SGVideoConfig.h"

//#define RTMP_URL  @"rtmp://169.254.12.83/rtmplive/movie"

@interface ViewController ()<SGSimpleSessionDelegate>

@property (nonatomic,strong) SGSimpleSession *session;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property(nonatomic,retain) UITextField * textField;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationItem.title = @"未连接";
    
    CGRect rect = CGRectMake(0, 64, 375, 40);
    UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    
    textField.placeholder = @"请输入推流地址";
    textField.borderStyle = UITextBorderStyleLine;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    textField.delegate = self;
    
    self.session = [SGSimpleSession defultSession];
    self.session.videoConfig = [SGVideoConfig defaultConfig];
    self.session.audioConfig = [SGAudioConfig defaultConfig];
    

    self.session.delegate = self;
    
    self.session.preview.frame = self.view.bounds;
    
    [self.view insertSubview:self.session.preview atIndex:0];
    [self.view addSubview:textField];
}

- (IBAction)didClicked:(UIBarButtonItem *)sender {
    switch (self.session.state) {
        case SGSimpleSessionStateConnecting:
        case SGSimpleSessionStateConnected:
        {
            [self.session endSession];
        }
            break;
            
        default:
        {
            [self.session startSession];
        
        }
            break;
    }
}

- (void)simpleSession:(SGSimpleSession *)simpleSession statusDidChanged:(SGSimpleSessionState)status{

    switch (status) {
        case SGSimpleSessionStateConnecting:
        {
            self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
            self.navigationItem.title = @"连接中...";
        }
            break;
        case SGSimpleSessionStateConnected:
        {
            self.navigationController.navigationBar.barTintColor = [UIColor greenColor];
            self.navigationItem.title = @"已连接";
            self.rightItem.title = @"结束";
        }
            break;
        default:
        {
            self.navigationController.navigationBar.barTintColor = [UIColor redColor];
            self.navigationItem.title = @"未连接";
            self.rightItem.title = @"开始";
        }
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textfield text %@",textField.text);
    self.session.url = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
