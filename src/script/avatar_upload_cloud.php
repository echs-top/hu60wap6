<?php
if ('cli' != php_sapi_name()) {
    die('run in shell: php avatar_upload_cloud.php');
}

include '../config.inc.php';
$ENABLE_CC_BLOCKING = false;

$cloudStorage = CloudStorage::getInstance();

$files = glob(AVATAR_DIR.'/*.jpg');

foreach ($files as $f) {
	$uid = explode('.', basename($f))[0];
	$u = new user();
	if (!$u->uid($uid)) {
		continue;
	}
	$u->virtualLogin();

	$path = CLOUD_STORAGE_AVATAR_PATH . $u->uid.".jpg";
    try {
    	$cloudStorage->upload($f, $path, true);
		$url = CloudStorage::getUrl($path, true);
        $u->setinfo("avatar.url", $url);
    } catch (Exception $ex) {
        $url = $ex->getMessage();
    }

	echo "uid $uid -> $url\n";
}

