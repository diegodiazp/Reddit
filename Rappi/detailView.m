//
//  detailView.m
//  Rappi
//
//  Created by Diego Diaz Pinilla on 6/03/17.
//  Copyright © 2017 Diego Diaz. All rights reserved.
//

#import "detailView.h"

@interface detailView ()

@end

@implementation detailView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_activityLoading startAnimating];
    
    NSString *urlHeader = [_dictReddit objectForKey:@"header_img"];
    if (![urlHeader isEqual: [NSNull null]]) {
        UIImage *headerImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlHeader]]];
        [_viewHeader setBackgroundColor:[UIColor colorWithPatternImage:headerImage]];
    }
    
    NSString *urlIcon = [_dictReddit objectForKey:@"icon_img"];
    if (![urlIcon isEqual: [NSNull null]]) {
        UIImage *iconImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlIcon]]];
        _iconImg.image = iconImage;
    }
    
    _displayTxt.text =[_dictReddit objectForKey:@"display_name"];
    
    NSString *stringHTML = [_dictReddit objectForKey:@"description_html"];
    stringHTML = [self textToHtml:stringHTML];
    
    _descriptionHTML.delegate = self;
    [_descriptionHTML loadHTMLString:stringHTML baseURL:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopHideLoading
{
    [_activityLoading stopAnimating];
    _viewLoading.hidden = YES;
}

#pragma mark - UIWebViewDelegate

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopHideLoading];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Lo sentimos" message:@"La Página no pudo ser cargada correctamente" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *aceptar = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                  [self.navigationController popViewControllerAnimated:YES];
                                  
                              }];
    [alert addAction:aceptar];
    [self presentViewController:alert animated:YES completion:nil];
    
    NSLog(@"Error de carga");
}

- (NSString*)textToHtml:(NSString*)htmlString {
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    return htmlString;
}


@end
