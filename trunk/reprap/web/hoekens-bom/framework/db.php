<?

function db()
{
	return Database::getSocket();
}

class Database
{
	private static $socket = null;

	private function __construct() {}
	
	public static function getSocket()
	{
		if (self::$socket === null)
			self::$socket = new DatabaseSocket(RR_DB_USER, RR_DB_PASS, RR_DB_HOST, RR_DB_PORT);
			
		return self::$socket;
	}
}

class DatabaseSocket
{
	private $link;
	
	public function __construct($user, $pass = null, $host = 'localhost')
	{
		$this->link = mysql_connect($host, $user, $pass);
	}
	
	public function error()
	{
		return mysql_error($this->link);
	}
	
	public function query($sql)
	{
		return mysql_query($sql, $this->link);
	}
	
	public function getArray($sql)
	{
		$rs = $this->query($sql);
		while ($row = mysql_fetch_assoc($rs))
			$data[] = $row;
			
		return $data;
	}
	
	public function getRow($sql)
	{
		$rs = $this->query($sql);
		return mysql_fetch_assoc($rs);
	}
	
	public function getValue($sql)
	{
		$row = $this->getRow($sql);
		return $row[0];
	}
	
	public function getLink()
	{
		return $this->link;
	}
	
	public function selectDb($database)
	{
		mysql_select_db($database, $this->link);
	}
}

?>