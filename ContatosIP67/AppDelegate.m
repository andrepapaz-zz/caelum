//
//  AppDelegate.m
//  ContatosIP67
//
//  Created by ios2736 on 12/05/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ListagemContatosController.h"
#import "Contato.h"

@interface AppDelegate () {
    NSMutableArray *contatos;
}
- (void) gravandoNoPlist;
@end

@implementation AppDelegate

@synthesize navigationController = _navigationController;

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Contato *caelumSP = [[Contato alloc] init];
    [caelumSP setNome:@"Caelum Unidade SP"];
    [caelumSP setEmail:@"contato@caelum.com.br"];
    [caelumSP setEndereco:@"Rua Vergueiro, 9393"];
    [caelumSP setTelefone:@"(11) 5775-0909"];
    [caelumSP setSite:@"caelum.com.br"];
    
    NSLog(@"Contato: %@ - %@", [caelumSP nome], [caelumSP email]);
    
    Contato *caelumBSB = [[Contato alloc] init];
    caelumBSB.nome = @"Caelum Unidade BSB";
    caelumBSB.email = @"contatobsb@caelum.com.br";
    caelumBSB.endereco = @"rua bsb, 8989";
    caelumBSB.telefone = @"(19) 98989-8989";
    caelumBSB.site = @"www.caelumbsb.com.br";
    
    NSLog(@"Contato: %@ - %@", caelumBSB.nome, caelumBSB.email);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self carregaDoPlist];
    
    ListagemContatosController *listagemContatos = [[ListagemContatosController alloc] initWithNibName:@"ListagemContatosController" bundle:nil];
    
    listagemContatos.contatos = contatos;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:listagemContatos];
    self.window.rootViewController = self.navigationController;
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [self gravandoNoPlist];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [self gravandoNoPlist];
}

- (void) carregaDoPlist
{
    NSMutableDictionary *arrayDeContatos;
    NSString *caminho;
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0];
    NSString *arquivo = [NSString stringWithFormat:@"%@/contatos.plist", documentsDir];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:arquivo]) {
        caminho = arquivo;
    } else {
        caminho = [[NSBundle mainBundle] pathForResource:@"contatos" ofType:@"plist"];
        
    }
    
    arrayDeContatos = [[NSMutableDictionary alloc] initWithContentsOfFile:caminho];

    contatos = [[NSMutableArray alloc] init];
    
    NSInteger total = arrayDeContatos.count;
    
    for (NSString *key in arrayDeContatos) {
        Contato *c = [[Contato alloc] init];
        
        NSDictionary *d = [arrayDeContatos objectForKey:key];

        [c setNome: [d objectForKey:@"nome"]];
        [c setEndereco: [d objectForKey:@"endereco"]];
        [c setEmail: [d objectForKey:@"email"]];
        [c setTelefone: [d objectForKey:@"telefone"]];
        [c setSite: [d objectForKey:@"site"]];
        [c setTwitter: [d objectForKey:@"twitter"]];
        
        NSData *data = [d valueForKey:@"imagem"];
        UIImage *img = [UIImage imageWithData:data];
        [c setImagem: img];
        
        [contatos addObject:c];
    }
}

- (void)gravandoNoPlist
{
    NSMutableDictionary *listaDeContatos = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < contatos.count; i++) {
        Contato *contato = [contatos objectAtIndex:i];
        NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
        
        [d setValue:[contato nome] forKey:@"nome"];
        [d setValue:[contato email] forKey:@"email"];
        [d setValue:[contato telefone] forKey:@"telefone"];
        [d setValue:[contato endereco] forKey:@"endereco"];
        [d setValue:[contato site] forKey:@"site"];
        
        UIImage *imagem = [contato imagem];
        NSData *data = UIImageJPEGRepresentation(imagem, 1.0);
        [d setValue:data forKey:@"imagem"];
        
        [listaDeContatos setValue:d forKey:[NSString stringWithFormat:@"%i", i]];
        
    }
    
    NSString *caminho = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES) objectAtIndex:0];
    NSString *arquivo = [NSString stringWithFormat:@"%@/contatos.plist", caminho];
    [listaDeContatos writeToFile:arquivo atomically:YES];
}
@end
