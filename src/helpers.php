<?php

use Slim\App;

return function (App $app) {
    $container = $app->getContainer();
    
    $function = new Twig_SimpleFunction('csrf', function ($request) use ($container) {
        
        $csrfNameKey = $container->csrf->getTokenNameKey();
        $csrfValueKey = $container->csrf->getTokenValueKey();
        $csrfName = $request->getAttribute($csrfNameKey);
        $csrfValue = $request->getAttribute($csrfValueKey);
        return '<input type="hidden" name="'.$csrfNameKey.'" value="'.$csrfName.'">'.
            '<input type="hidden" name="'.$csrfValueKey.'" value="'.$csrfValue.'">';
    });
    
    $container->get('view')->getEnvironment()->addFunction($function);

};
