<?php

class FindData {

	private $DBClass = null;

	private $cacheDir = './cache/';
	private $tables = array(
		'access_logs',
		'change_logs',
		'members',
		'notifications',
		'otps',
		//'pre_commits',
		'sheets',
		'sheet_memos',
		'sheet_types',
		'sheet_type_files',
		'stm_configs',
		'stm_values',
		'users',
	);
	
	function __construct(){
		$this->DBClass = new DatabaseAccess();
		$this->updateCache();
		print_r($this->getDataByTableName('sheet_types'));
	}
		
	function updateCache(){
		foreach($this->tables as $i){
			// get data
			$query = "SELECT * FROM `{$i}`";
			$data = $this->DBClass->executeQuery($query);
			$temp = array();
			foreach($data as $j){
				$temp[$j['id']] = $j;
			}
			$data = base64_encode(serialize($temp));
			// save
			$fp = fopen($this->cacheDir.$i, 'w+');
			flock($fp, LOCK_EX);
			fputs($fp, $data);
			flock($fp, LOCK_UN);
			fclose($fp);
		}
	}

	function getDataByTableName($table){
		// load data
		$fp = fopen($this->cacheDir.$table, 'r');
		$data = fgets($fp);
		fclose($fp);
		// decode
		$data = unserialize(base64_decode($data));
		return $data;
	}

	function getAllData(){
		$data = array();
		foreach($this->tables as $i){
			$data[$i] = $this->getDataByTableName($i);
		}
		return $data;
	}

}

?>
