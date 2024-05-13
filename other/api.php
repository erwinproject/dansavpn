<?php
$feedback = array(
    'status' => false,
    'msg' => 'Invalid parameter'
);

set_include_path(__DIR__ . '/phpseclib');
include("Net/SSH2.php");

// ## if using Password Only ###
// $key ="YOUR_PASSWORD";


// ## if using PrivateKey & Paraphase ### 
// include("Crypt/RSA.php");
// $key = new Crypt_RSA();
// $key->setPassword('surabaya');
// $key->loadKey(file_get_contents('key.ppk'));
// $ssh = new Net_SSH2('YOUR_IP', 22);   // Domain or IP
// if (!$ssh->login('YOUR_USERNAME', $key)) exit('');

include("Crypt/RSA.php");
$key = new Crypt_RSA();
$key->setPassword('surabaya');
$key->loadKey(file_get_contents('key.ppk'));
$ssh = new Net_SSH2('148.113.141.190', 22);   // Domain or IP
if (!$ssh->login('ubuntu', $key)) exit('');


// ## if using PrivateKey ### 
// include("Crypt/RSA.php");
// $key = new Crypt_RSA();
// $key->loadKey(file_get_contents('key.ppk'));
// $ssh = new Net_SSH2('YOUR_IP', 22);   // Domain or IP
// if (!$ssh->login('YOUR_USERNAME', $key)) exit('');

$action = $_GET['action'];
switch ($action) {
    case 'add-trojan': // add trojan
        $expired = $_GET['expired'];
        if (isset($expired)) {
            $output = $ssh->exec('sudo /usr/bin/web-add-trojan ' . $expired);
            $output2 = str_replace("'unknown': I need something more specific.", "", $output);
            $feedback = json_decode($output2, true);
        }
        break;
    case 'del-trojan': // delete trojan
        $id = $_GET['id'];
        if (isset($id)) {
            $output = $ssh->exec('sudo /usr/bin/web-del-trojan ' . $id);
            $output2 = str_replace("'unknown': I need something more specific.", "", $output);
            $feedback = json_decode($output2, true);
        }
        break;
    case 'extend-trojan': // extend trojan
        $id = $_GET['id'];
        $expired = $_GET['expired'];
        if (isset($id) && isset($expired)) {
            $output = $ssh->exec('sudo /usr/bin/web-extend-trojan ' . $id . ' ' . $expired);
            $output2 = str_replace("'unknown': I need something more specific.", "", $output);
            $feedback = json_decode($output2, true);
        }
        break;
    default:
        break;
}

echo json_encode($feedback);
