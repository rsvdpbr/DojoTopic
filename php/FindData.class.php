<?php

class FindData {

	private $DBClass = null;

	private $cacheDir = '../data/cache/';
	private $cacheLog = '.logs';
	private $cacheDatetime = '.datetimes';
	private $tables = array(
		//'access_logs',
		//'change_logs',
		'members',
		'notifications',
		//'otps',
		//'pre_commits',
		'sheets',
		//'sheet_memos',
		'sheet_types',
		//'sheet_type_files',
		'stm_configs',
		'stm_values',
		//'users',
	);
	private $time = 10800;
	
	function __construct(){
		$this->DBClass = new DatabaseAccess();
	}
	
	function checkUpdateAll(){
		$ret = array();
		foreach($this->tables as $i){
			if($this->checkUpdate($i)){
				$ret[] = $i;
			}
		}
		return $ret;
	}
	function checkUpdate($table){
		$last = $this->getDatetimeByTableName($table);
		$last = $last ? strtotime($last) : $last;
		if(($last + $this->time) < time()){
			return $this->updateCache($table);
		}
		return false;
	}
	
	function updateCacheAll(){
		$ret = array();
		foreach($this->tables as $i){
			if($this->updateCache($i)){
				$ret[] = $i;
			}
		}
		return $ret;
	}
	function updateCache($table){
		// get data
		$query = "SELECT * FROM `{$table}`";
		$data = $this->DBClass->executeQuery($query);
		// format data
		$temp = array();
		foreach($data as $i){
			$temp[$i['id']] = $i;
		}
		$json = new Services_JSON;
		$data = $json->encode($temp);
		// save
		if($fp = fopen($this->cacheDir.$table, 'w+')){
			flock($fp, LOCK_EX);
			fputs($fp, $data);
			flock($fp, LOCK_UN);
			fclose($fp);
			$this->writeDatetime($table);
			$this->writeLog('success to update cache : '.$table);
			return true;
		}else{
			$this->writeLog('failure to update cache : '.$table);
			return false;
		}
	}

	function getDatetimeByTableName($table){
		$data = $this->readDatetime();
		if(isset($data[$table])){
			return $data[$table];
		}
		return 0;
	}
	function readDatetime(){
		$data = array();
		if($fp = fopen($this->cacheDir.$this->cacheDatetime, 'r')){
			flock($fp, LOCK_EX);
			while(!feof($fp)){
				$temp = fgets($fp);
				if(!empty($temp)){
					$temp = explode('@', $temp);
					$data[$temp[0]] = str_replace("\n", '', $temp[1]);
				}
			}
			flock($fp, LOCK_UN);
			fclose($fp);
		}
		return $data;
	}
	function writeDatetime($table){
		// get data
		$data = $this->readDatetime();
		print_r($data);
		$data[$table] = date('Y-m-d H:i:s');
		// save data
		if($fp = fopen($this->cacheDir.$this->cacheDatetime, 'w+')){
			flock($fp, LOCK_EX);
			foreach($data as $key => $val){
				$str = $key.'@'.$val."\n";
				fputs($fp, $str);
			}
			flock($fp, LOCK_UN);
			fclose($fp);
		}
	}
	function writeLog($string){
		if($fp = fopen($this->cacheDir.$this->cacheLog, 'a+')){
			$data = date('Y-m-d H:i:s').' . '.$string."\n";
			flock($fp, LOCK_EX);
			fputs($fp, $data);
			flock($fp, LOCK_UN);
			fclose($fp);
			return true;
		}
		return false;
	}

}

?>
