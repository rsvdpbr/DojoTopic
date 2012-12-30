<?php

class DatabaseAccess {

	private $config;
	private $connect;
	private $log;
	private $timeSum;

	function DatabaseAccess(){
		$this->log = array();
		$this->timeSum = 0;
		$this->config = array(
			'url'		=> 'localhost',
			'user'		=> 'username',
			'pass'		=> 'password',
			'dbName'	=> 'topic',
			'encord'	=> 'utf8',
		);
	}

	// ログ取得
	function getLog(){
		$temp = array_merge(array("合計クエリ実行時間（秒）：　".$this->timeSum), $this->log);
		return $temp;
	}

	// タイム関連
	function getTimeSum(){
		return $this->timeSum;
	}
	function initTimeSum(){
		$this->timeSum = 0;
	}

	// クエリ発行
	function executeQuery($query){
		global $DEV;
		$this->log[] = $query;
		$query = str_replace(array("\r\n", "\n", "\r", "	"), ' ', $query);
		$this->__connectMySQL();
		mysql_query("SET NAMES {$this->config['encord']}") or die('Could not set charset');
		$timeStart = $this->microtime_float();
		$ret = mysql_query($query) or die('Could not execute query :'."\n".$query);
		$timeEnd = $this->microtime_float();
		$time = $timeEnd - $timeStart;
		$this->log[] = "上記クエリの実行時間（秒）： ".$time;
		$this->timeSum += $time;
		if(count($ret) > 0 && strpos($query, 'SELECT') !== false){
			$result = array();
			while($item = mysql_fetch_array($ret, MYSQL_ASSOC)){
				$result[] = $item;
			}
			mysql_close($this->connect);
			return $result;
		}
		mysql_close($this->connect);
		return null;
	}

	// PRIVATE: 処理時間計測用
	static function microtime_float(){
		list($usec, $sec) = explode(" ", microtime());
		return ((float)$usec + (float)$sec);
	}

	// PRIVATE: データベース接続
	private function __connectMySQL(){
		$this->connect = mysql_connect(
			$this->config['url'],
			$this->config['user'],
			$this->config['pass']
		) or die('Could not connect database');
		mysql_select_db($this->config['dbName'], $this->connect) or die('Could not connect database');
	}

}

?>