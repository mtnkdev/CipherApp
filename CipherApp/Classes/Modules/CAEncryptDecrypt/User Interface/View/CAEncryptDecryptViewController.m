//
//  CAEncryptDecryptViewController.m
//  CipherApp
//
//  Created by Jesús Emilio Fernández de Frutos on 28/12/2016.
//  Copyright © 2016 Jesús Emilio Fernández de Frutos. All rights reserved.
//

#import "CAEncryptDecryptViewController.h"
#import "NSString+RSA.h"
#import "NSString+AES.h"

NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";

@interface CAEncryptDecryptViewController ()
@property (weak, nonatomic) IBOutlet UIView *aesView;
@property (weak, nonatomic) IBOutlet UIView *rsaView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *aesViewCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rsaViewCenterConstraint;
@property (weak, nonatomic) IBOutlet UITextField *aesKeyTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *aesTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *plainTextField;
@property (weak, nonatomic) IBOutlet UITextView *publicKeyTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *algorithmTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextView *privateKeyTextView;
@end

@implementation CAEncryptDecryptViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.rsaViewCenterConstraint.constant = [UIScreen mainScreen].bounds.size.width;

    self.privateKeyTextView.text = privkey;
    self.publicKeyTextView.text = pubkey;
    
}

#pragma mark - Actions
- (IBAction)encryptionTypeChanged:(id)sender {
    
    switch (((UISegmentedControl*)sender).selectedSegmentIndex) {
        case 0:
            [self showAESView];
            break;
        case 1:
            [self showRSAView];
        default:
            break;
    }
}
- (IBAction)encryptDecrypt:(id)sender {
    switch (self.algorithmTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.eventHandler encryptText:self.plainTextField.text withAESAlgorithm:self.aesTypeSegmentedControl.selectedSegmentIndex andKey:self.aesKeyTextField.text];
            break;
        case 1:
            [self.eventHandler encryptText:self.plainTextField.text withRSAAlgorithmAndKey:self.publicKeyTextView.text];
            break;
    }
    
}

#pragma mark - Private methods
-(void) showAESView
{
    self.aesViewCenterConstraint.constant = 0;
    self.rsaViewCenterConstraint.constant = -[UIScreen mainScreen].bounds.size.width;
    self.view.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        self.rsaViewCenterConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    }];
    
}

-(void) showRSAView
{
    self.rsaViewCenterConstraint.constant = 0;
    self.aesViewCenterConstraint.constant = -[UIScreen mainScreen].bounds.size.width;
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        self.aesViewCenterConstraint.constant = [UIScreen mainScreen].bounds.size.width;
    }];
}

#pragma mark - Public Methods (CAEncryptDecryptViewInterface)
-(void) setEncryptedString:(NSString*)encryptedString
{
    self.encryptedTextView.text = encryptedString;
    
    switch (self.algorithmTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.eventHandler decryptText:self.encryptedTextView.text withAESAlgorithm:self.aesTypeSegmentedControl.selectedSegmentIndex andKey:self.aesKeyTextField.text];
            break;
        case 1:
            [self.eventHandler decryptText:self.encryptedTextView.text withRSAAlgorithmAndKey:self.privateKeyTextView.text];
        default:
            break;
    }
}


-(void) setDecryptedString:(NSString*)plainTextString
{
    self.decryptedTextView.text = plainTextString;
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end
