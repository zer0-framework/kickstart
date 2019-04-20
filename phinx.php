<?php
define('ZERO_ROOT', __DIR__);
require 'vendor/zer0-framework/core/src/bootstrap.php';
/**
 * @var $broker \Zer0\Brokers\PDO
 */
$broker = $app->broker('PDO');
$config = $broker->getConfig();
$defaultDatabase = null;

$environments = [
    'default_migration_table' => $config->migrations['default_migration_table'] ?? 'phinxlog',
];

foreach ($config->sectionsList() as $pdoName) {
    $pdoConfig = $config->{$pdoName};
    $environments[$pdoName] = [
        'name'      => $pdoConfig->dbname,
        'connection' => $broker->get($pdoName),
    ];
    if ($pdoConfig->migrations['default'] ?? false) {
        $defaultDatabase = $pdoName;
    }
}
if ($defaultDatabase !== null) {
    $environments['default_database'] = $defaultDatabase;
}

return [
    'paths' => [
        'migrations' => 'migrations'
    ],
    'environments' => $environments,
];
