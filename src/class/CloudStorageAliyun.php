<?php
require_once ROOT_DIR . '/nonfree/class/AliyunOss.phar';

use OSS\OssClient;

/**
 * 阿里云OSS云存储
 * 
 * 实现阿里云OSS云存储的文件上传、下载、服务器端签名
 */
class CloudStorageAliyun extends CloudStorageBase {
    private $ossClient;

    public function __construct() {
        $this->ossClient = new OssClient(CLOUD_STORAGE_AK, CLOUD_STORAGE_SK, CLOUD_STORAGE_ENDPOINT);
    }

    public function exists($key) {
        return $this->ossClient->doesObjectExist(CLOUD_STORAGE_BUCKET, $key);
    }

    public function copy($fromKey, $toKey) {
        $this->ossClient->copyObject(CLOUD_STORAGE_BUCKET, $fromKey, CLOUD_STORAGE_BUCKET, $toKey);
    }

    public function upload($localFile, $remoteFile, $allowOverwrite = false, $fileName = null) {
        if (!$allowOverwrite && $this->exists($remoteFile)) {
            return;
        }

        $options = [
            OssClient::OSS_HEADERS => [],
        ];
        $headers = &$options[OssClient::OSS_HEADERS];

        $fileName = rawurlencode(str::basename(trim((string)$fileName)));
        if ($fileName !== '' && !self::noAttrname($fileName)) {
            $headers[OssClient::OSS_CONTENT_DISPOSTION] = "attachment; filename=\"$fileName\"; filename*=utf-8''$fileName";
        }

        $this->ossClient->uploadFile(CLOUD_STORAGE_BUCKET, $remoteFile, $localFile, $options);
    }

    private static function gmt_iso8601($time) {
        return str_replace('+00:00', '.000Z', gmdate('c', $time));
    }

    public function getUploadForm($key, $fileName, $fileSize, $fileMd5 = null) {
        if ($this->ossClient->doesObjectExist(CLOUD_STORAGE_BUCKET, $key)) {
            return [
                'fileExists' => true,
            ];
        }

        // 上传条件
        $conditions = [];

        // 指定文件大小
        $fileSize = (int)$fileSize;
        $conditions[] = ['content-length-range', $fileSize, $fileSize];

        // 指定key
        $conditions[] = ['eq', '$key', $key];

        // 指定文件md5
        if ($fileMd5 !== null) {
            $fileMd5 = base64_encode(hex2bin(trim($fileMd5)));
            $conditions[] = ['eq', '$Content-MD5', $fileMd5];
        }

        // 超时时间：1小时
        $expire = 3600;
        $end = time() + $expire;
        $expiration = self::gmt_iso8601($end);

        // 上传策略
        $policy = base64_encode(json_encode([
            'expiration' => $expiration,
            'conditions' => $conditions
        ]));

        // 签名
        $signature = base64_encode(hash_hmac('sha1', $policy, CLOUD_STORAGE_SK, true));

        // 上传表单模板
        $data = [
            'fileExists' => false,
            'requestUrl' => CLOUD_STORAGE_CLIENT_ENDPOINT,
            'method' => 'POST',
            'enctype' => 'multipart/form-data',
            'formData' => [
                'OSSAccessKeyId' => CLOUD_STORAGE_AK,
                'policy' => $policy,
                'signature' => $signature,
                'key' => $key,
            ],
            'fileFieldName' => 'file',
        ];

        $fileName = rawurlencode(str::basename(trim($fileName)));
        if ($fileName !== '' && !self::noAttrname($fileName)) {
            $data['formData']['Content-Disposition'] = "attachment; filename=\"$fileName\"; filename*=utf-8''$fileName";
        }

        if ($fileMd5 !== null) {
            $data['formData']['Content-MD5'] = $fileMd5;
        }

        return $data;
    }
}
