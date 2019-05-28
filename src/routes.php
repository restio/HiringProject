<?php

use Slim\App;
use Slim\Http\Request;
use Slim\Http\Response;

return function (App $app) {
    $container = $app->getContainer();

    $app->get('/', function (Request $request, Response $response, array $args) {
        return $this->view->render($response, 'home.html', compact('request'));
    })->setName('home');
    
    $app->get('/login', function (Request $request, Response $response, array $args) {
        return $this->view->render($response, 'login.html', compact('request'));
    })->setName('login');
    
    $app->post('/login', function (Request $request, Response $response, array $args) {
    });
};
