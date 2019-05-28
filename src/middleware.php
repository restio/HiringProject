<?php

use Slim\App;
use Slim\Http\Request;
use Slim\Http\Response;

return function (App $app) {
    $container = $app->getContainer();
    
    $csrf = new \Slim\Csrf\Guard;
    $failureCallable = function (Request $request, Response $response, $next) use ($container) {
        $error = 'Authentication Failed.';
        return $container->view->render($response, 'login.html', compact('request', 'error'));
    };
    $csrf->setFailureCallable($failureCallable);
    
    $app->add($csrf);
    
    $container['csrf'] = function ($c) use ($csrf) {
        return $csrf;
    };
};
