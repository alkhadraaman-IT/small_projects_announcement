<?php

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie', 'storage/*'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['*'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,

];

/*
return [
  'paths' => ['api/*', 'storage/*', 'sanctum/csrf-cookie'],
'allowed_origins' => ['*'], // أو حطي رابط Flutter Web http://localhost:53119
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
'supports_credentials' => true,
];
*/
/*
return [
    'paths' => ['api/*', 'storage/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['*'], // اسمحي مبدئياً للجميع (أبسط حل)

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,
];
   
*/