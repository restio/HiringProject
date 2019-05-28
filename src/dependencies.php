<?php

use Slim\App;

return function (App $app) {
    $container = $app->getContainer();

    // twig
    $container['view'] = function ($c) {
        $settings = $c->get('settings')['twig'];
        $view = new \Slim\Views\Twig($settings['template_path'], [
            'cache' => $settings['cache_path'],
            'auto_reload' => $settings['auto_reload']
        ]);
        
        // Instantiate and add Slim specific extension
        $router = $c->get('router');
        $uri = \Slim\Http\Uri::createFromEnvironment(new \Slim\Http\Environment($_SERVER));
        $view->addExtension(new \Slim\Views\TwigExtension($router, $uri));

        return $view;
    };
    
    // monolog
    $container['logger'] = function ($c) {
        $settings = $c->get('settings')['logger'];
        $logger = new \Monolog\Logger($settings['name']);
        $logger->pushProcessor(new \Monolog\Processor\UidProcessor());
        $logger->pushHandler(new \Monolog\Handler\StreamHandler($settings['path'], $settings['level']));
        return $logger;
    };
};
