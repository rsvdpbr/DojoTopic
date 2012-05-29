<?php

class User {

	private $DBClass = null;

	private $userDir = '../data/usr/'; /* ユーザ情報を格納するディレクトリ */
	private $msgDir = 'messages/';	   /* メッセージを格納するディレクトリ */
	private $bmDir = 'bookmark/';	   /* ブックマークを格納するディレクトリ */
	
	private $userLog = '.logs';		   /* ログファイル */
	private $userInfo = 'info';		   /* 基本情報ファイル */
	private $userEnv = 'env';		   /* 環境情報ファイル */

	function __construct(){
		$this->DBClass = new DatabaseAccess();
	}

	// ユーザ情報を登録する
	// 引数は、user,password,roleのjson形式
	function addUser($data){
		// エラーチェック
		if(strpos($data, '@') !== false || strpos($data, '=') !== false){
			return 'invalid-error';
		}
		// ユーザ情報を作成する
		$json = new Services_JSON;
		$data = $json->decode($data);
		$string = '';
		foreach($data as $key => $value){
			$string .= $key.'='.$value."\n";
		}
		$string .= 'datetime='.date('Y-m-d H:i:s');
		// ユーザ情報を保存する
		$dir = $this->userDir.$data->user.'/';
		if(file_exists($dir)){
			return 'double-error';
		}
		if(mkdir($dir) && $fp = fopen($dir.$this->userInfo, 'w+')){
			flock($fp, LOCK_EX);
			fputs($fp, $string);
			flock($fp, LOCK_UN);
			fclose($fp);
		}
		// 環境情報を保存する
		if($fp = fopen($dir.$this->userEnv, 'w+')){
			flock($fp, LOCK_EX);
			fputs($fp, serialize($_SERVER));
			flock($fp, LOCK_UN);
			fclose($fp);
		}
		// 必要なフォルダを作成する
		mkdir($dir.$this->msgDir);
		mkdir($dir.$this->bmDir);
		// データを返す
		return $this->getUserData($data->user.'@'.$data->password);
	}

	// ユーザ情報を取得する
	// 引数は、「ユーザ名@パスワード」
	function getUserData($user){
		list($user, $passwd) = explode('@', $user);
		// ユーザファイルを開く
		$dir = $this->userDir.$user.'/'.$this->userInfo;
		if(file_exists($dir) && $fp = fopen($dir, 'r')){
			$data = array();
			while(!feof($fp)){
				$tmp = explode('=', fgets($fp));
				$data[$tmp[0]] = str_replace(array("\r\n","\n","\r"), '', $tmp[1]);
			}
			fclose($fp);
		}else{
			return 'user-error';
		}
		// パスワードを照合する
		if($passwd !== $data['password']){
			return 'pass-error';
		}
		return $data;
	}
	
}

?>