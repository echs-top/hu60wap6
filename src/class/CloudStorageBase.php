<?php
/**
 * 云存储服务的基类
 * 
 * 新增的云存储服务应该继承该类
 */
abstract class CloudStorageBase {
    /**
     * 判断文件是否存在
     */
    abstract public function exists($key);

    /**
     * 拷贝云存储中的文件到另一位置
     */
    abstract public function copy($fromKey, $toKey);

    /**
     * 上传文件到云存储
     * 
     * @param $localFile 本地文件路径
     * @param $remoteFile 远程文件路径
     * @param $allowOverwrite 如果远程文件已存在，是否允许覆盖。默认不允许。
     * 
     * @return null 上传成功没有返回值
     * @throws Exception 上传失败抛出异常
     */
    abstract public function upload($localFile, $remoteFile, $allowOverwrite = false, $fileName = null);

    /**
     * 获取客户端文件直传表单模板
     * 
     * @param $key 上传到的路径
     * @param $fileName 待上传文件的原始文件名
     * @param $fileSize 待上传的文件大小
     * @param $fileMd5 待上传文件的MD5值，可为null。
     * 
     * @return array 带有上传表单模板的数组，经过JSON编码后发给客户端
     * @throws Exception 出错时抛出异常
     */
    abstract public function getUploadForm($key, $fileName, $fileSize, $fileMd5 = null);

    public function uploadLocalFile($filePath, $fileName, $allowOverwrite = false) {
        $fileSize = filesize($filePath);
        $fileMd5 = md5_file($filePath);
        $key = self::getFileKey($fileName, $fileSize, $fileMd5);

        // 上传文件，成功没有返回值，失败抛出异常
        $this->upload($filePath, $key, $allowOverwrite, $fileName);

        $url = self::getFileUrl($key, $fileName);
        return [
            'url' => $url,
            'name' => str::basename($fileName),
            'size' => str::filesize($fileSize),
            'content' => self::getFileUbb($url, $fileName, $fileSize),
        ];
    }

    public function getFileUploadForm($fileName, $fileSize, $fileMd5 = null) {
        $key = self::getFileKey($fileName, $fileSize, $fileMd5);
        $data = $this->getUploadForm($key, $fileName, $fileSize, $fileMd5);

        $data['downloadUrl'] = self::getFileUrl($key, $fileName);
        $data['contentUbb'] = self::getFileUbb($data['downloadUrl'], $fileName, $fileSize);

        return $data;
    }

    public static function getFileUrl($key, $fileName) {
        $url = 'http://'.CLOUD_STORAGE_DOWNLOAD_HOST.'/'.$key;
        $fileName = rawurlencode(str::basename(trim($fileName)));
        if ($fileName !== '' && !self::noAttrname($fileName)) {
            $url .= '?attname='.$fileName;
        }
        return $url;
    }

    public static function getFileKey($fileName, $fileSize, $fileMd5 = null) {
        $fileSize = (int)$fileSize;
        if ($fileSize > CLOUD_STORAGE_MAX_FILESIZE) {
            throw new Exception("文件太大，文件大小不能超过 ".str::filesize(CLOUD_STORAGE_MAX_FILESIZE), 413);
        }

        $fileName = trim($fileName);
        if (preg_match('/\.[a-zA-Z0-9_-]{1,10}\s*$/s', $fileName, $ext)) {
            $ext = strtolower($ext[0]);
        } else {
            $ext = '.dat';
        }
        $type = substr($ext, 1);

        if ($fileMd5 !== null) {
            $fileMd5 = trim(strtolower($fileMd5));
            if (!preg_match('/^[0-9a-f]{32}$/s', $fileMd5)) {
                throw new Exception("文件MD5格式不正确，MD5必须为32个十六进制字符（0-9 a-f）");
            }

            $key = 'file/hash/' . $type . '/' . $fileMd5 . $fileSize . $ext;
        } else {
            $uuid = str::guidv4();
            $key = 'file/uuid/' . $type . '/' . $uuid . $fileSize . $ext;
        }

        return $key;
    }

    public static function noAttrname($fileName) {
        // 不要给图片添加 attrname 参数，以防查看大图变成下载
        if (preg_match('/\.(jpe?g|png|gif|bmp|webp|hei[cf])$/is', trim($fileName))) {
            return true;
        }
        return false;
    }

    public static function getFileUbb($url, $fileName, $fileSize) {
        $fileName = str::basename(trim($fileName));
        $fileSize = str::filesize($fileSize);
        $type = self::getFileType($fileName);

        if (empty($fileName)) {
            $fileName = "附件.dat";
        }

        switch ($type) {
            case 'image':
                return "《图片：" . $url . '，' . $fileName . '》';
            case 'video':
                return "《视频流：" . $url . '》';
            case 'audio':
                return "《音频流：" . $url . '》';
            default:
                return "《链接：" . $url . '，' . $fileName . '（' . $fileSize . '）》';
        }
    }

    public static function getFileType($key) {
        if (preg_match('/\.(jpe?g|png|gif|bmp|webp|hei[cf])$/is', $key)) {
            return 'image';
        }
        if (preg_match('/\.(mp4|m3u8|m4v|ts|mov|flv)$/is', $key)) {
            return 'video';
        }
        if (preg_match('/\.(mp3|wma|m4a|ogg)$/is', $key)) {
            return 'audio';
        }
        return 'others';
    }

    public static function getBlockTemplate($key) {
        global $CLOUD_STORAGE_BLOCK_TEMPLATE;
        return $CLOUD_STORAGE_BLOCK_TEMPLATE[self::getFileType($key)];
    }
}
