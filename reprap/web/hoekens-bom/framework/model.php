<?
/**
* @TODO: give me a description
*/
class Model
{
	/**
	 * @b Private.  The name of the database table its linked to.
	 * @private
	 */
	public $tableName;

	/**
	 * @b public.  Boolean if we use object caching or not. you should understand the object caching system before you use this.
	 */
	public $useObjectCaching = false;
	
	/**
	* how long we cache the object data in seconds. defaults to a bit over a month (3 million seconds)
	*/
	public static $objectCacheLife = 3000000;

	/**
	 * The id that references the table.
	 */
	private $internalId = 0;

	/**
	 * @b Private. Array of fields that are dirty.
	 */
	private $dirtyFields = array();

	/**
	 * @b Protected. Internal data array
	 */
	private $data = array();
	
	/**
	 * Creates a new BaseObject.
	 *
	 * @param $data if $data is an integer id, in which case it will load the data from the database.
	 * If $data is an array, it will load the data from the array to the equivalent properties of the object.
	 *
	 * @param $tableName the name of the table to reference.
	 */
	public function __construct($data, $tableName)
	{
		//set our table name...
		$this->tableName = $tableName;

		//check our fields.
		$this->checkTable();

		//omg noob... dont forget to load!
		$this->load($data);
	}

	/**
	 * This function translates the object to a string.
	 * @return the string value for the funtction
	**/
	public function __toString()
	{
		return $this->getName();
	}

	/**
	 * This function is for getting at the various data internal to the object
	 * @param $name is the name of the field
	 * @return the value from the data array or the id
	 */
	public function get($name)
	{
		return $this->data[$name];
	}

	/**
	 * Function to set data values for the object
	 * @param $name is the name of the field
	 * @param $value is the stored value
	 */
	public function set($name, $value)
	{
		$this->data[$name] = $value;
	}

	/**
	 * This function handles loading the data into the object.
	 *
	 * @todo this will change in v2.2 to load the data from cache or look it up from the db.
	 *
	 * @param $data either an id of an object or an array of data that
	 * represents that object.
	 */
	public function load($data)
	{
		//did we get an array of data to set?
		if (is_array($data))
			$this->hydrate($data);
		//nope, maybe its an id for the database...
		else if ($data)
			$this->loadData($data, $deep);
	}

	/**
	* load our objects data.
	*
	* @depreciated this will be changed around in v2.2
	* @todo remove and put comments / tags into load.  also make a loadfromdb function
	*/
	protected function loadData($id)
	{
		$id = (int)$id;
		
		if ($id > 0)
		{
			//set our id first.
			$this->internalId = $id;
			
			//try our cache.. if it works, then we're good.
			if (!$this->loadCacheData())
			{
				$this->lookupData();

				if ($this->useObjectCaching)
					$this->setCache();
			}
		}
	}

	/**
	* get our data from the db.
	*
	* @todo update this whole data loading process to be much smoother
	*/
	protected function lookupData()
	{
		//nope, load it normally.
		$data = $this->getData(true);
		if (count($data) && is_array($data))
			foreach ($data AS $key => $val)
				if ($key != 'id')
					$this->set($key, $val);
	}

	/**
	* load data from cache
	*/
	protected function loadCacheData()
	{
		//is it enabled?
		if ($this->useObjectCaching)
		{
			//get our cache data... is it there?
			$data = $this->getCache();
			if ($data)
			{
				//load it, and we're good.
				$this->hydrate($data);
				return true;
			}
		}

		return false;
	}

	/**
	 * This function handles saving the object.
	 *
	 * @return true on success, false on failure.
	 */
	public function save()
	{
		//we should do any cleanup if possible
		if ($this->isDirty())
			$this->clean();
	
		//save it to wherever
		$data = $this->saveData();

		//bust our cache.
		if ($this->useObjectCaching)
			$this->deleteCache();
		
		return $data;
	}

	/**
	 * This function handles any validation/cleaning of our data.
	 */
	public function clean()
	{
		foreach ($this->dirtyFields AS $field)
			$this->cleanField($field);
	}

	/**
	* Clean a field's data.  called from clean()
	*
	* @param $field the name of the field to clean.
	*/
	public function cleanField($field)
	{
		//by default... we dont clean anything
	}

	/**
	* Tells us if the object is dirty or not.  Used to determine if we clean and/or if we need to save.
	*/
	public function isDirty()
	{
		return (bool)count($this->dirtyFields);
	}

	/**
	 * This function handles deleting our object.
	 * 
	 * @return ture on success, false on failure.
	 */
	public function delete()
	{
		//delete our cache.
		if ($this->useObjectCaching)
			$this->deleteCache();
		
		return $this->deleteDb();
	}

	/**
	 * This function gets an associative array of the object's members most
	 * commonly this will be from a db, but you never know.
	 *
	 * @return an associative array of the objects data.
	 */
	protected function getData($useDb = true)
	{
		if ($useDb)
			return $this->getDbData();
		else
		{
			$data = $this->data;
			$data['id'] = $this->id;

			return $data;
		}
	}

	/**
	 * This function sets all the data for the object.
	 *
	 * @param $data an associative array of data.  The keys must match up with
	 * the object properties.
	 * @param $ignore the fields to ignore and not set
	 */
	//equivalent object members to that (if they exist)
	public function setData($data, $ignore = null)
	{
		//make sure we have an array here =)
		if (is_array($data))
		{
			if (!is_array($ignore))
				$ignore = array($ignore);

			//okay loop thur our data...
			foreach ($data AS $key => $val)
			{
				//if we ignore it... continue
				if (in_array($key, $ignore))
					continue;

				//make sure this key exists for us....
				if ($key === 'id')
					$this->internalId = (int)$val;
				else if ($this->hasField($key))
					$this->data[$key] = $val;
			}
			
			return true;
		}
		else
			return false;

	}

	/**
	 * This function handles saving the data to wherever.
	 *
	 * @return true on success, false on failure
	 */
	protected function saveData()
	{
		return $this->saveDb();
	}

	/**
	 * This function gets all the member information from a database.
	 *
	 * @return an associative array of data or false on failure.
	 */
	private function getDbData()
	{
		//make sure we have an id....
		if ($this->id)
		{
			$result = dbFetchAssoc(dbQuery("
				SELECT *
				FROM $this->tableName
				WHERE id = '$this->id'
			"));

			if (is_array($result))
				return $result;
		}
		
		return false;
	}

	/**
	 * This function saves the object back to the database.  It is a bit
	 * trickier.  It will smartly insert or update depending on if there is an
	 * id or not.  It also only saves the properties of the object that are
	 * named the same as the table fields, all automatically.
	 */
	private function saveDb()
	{
		//format our sql statements w/ the valid fields
		$fields = array();
		$columns = $this->getDbFields();
		
		//loop thru all our dirty fields.
		foreach ($this->dirtyFields AS $key)
		{
			//get our value.
			if ($columns[$key] && isset($this->data[$key]) && $key != 'id')
			{
				$val = $this->data[$key];

				//slashes replacement..
				$val = str_replace("\\\\", "\\", $val);
				$val = str_replace("\'", "'", $val);
				$val = str_replace("\\\"", "\"", $val);

				//add it if we have it...
				$fields[] = "`$key` = '" . addslashes($val) . "'";
			}
		}
		
		//update if we have an id....
		if (count($fields))
		{
			//now make our array
			$sqlFields = implode(",\n", $fields) . "\n";
			
			//update it?
			if ($this->id)
			{
				$sql  = "UPDATE $this->tableName SET\n";
				$sql .= $sqlFields;
				$sql .= "WHERE id = '$this->id'\n";
				$sql .= "LIMIT 1";

				dbExecute($sql);
			}
			//otherwise insert it...
			else
			{
				$sql  = "INSERT INTO $this->tableName SET\n";
				$sql .= $sqlFields;

				$this->id = dbExecute($sql, true);
			}
		}
	}

	/**
	 * This function deletes the object from the database.
	 *
	 * @return true on success, false on failure
	 */
	private function deleteDb()
	{
		//do we have an id?
		if ($this->id)
		{
			dbExecute("
				DELETE FROM $this->tableName
				WHERE id = '$this->id'
			");

			return true;
		}
		return false;
	}

	/**
	* @TODO: re-implement this.
	* load some 'dirty' data... that is data that is potentially not the same
	* data and should thusly be saved eventually.
	*
	* @param $data a keyed array of data.
	*/
	public function loadDirtyData($data)
	{
	}

	/**
	* this function creates our key to use with caching.  no need to override
	*
	* @return a key used with CacheBot to cache the object.
	*/
	public function getCacheKey($id = null)
	{
		if ($id === null)
			$id = $this->id;

		return "BaseJumper:object:" . get_class($this) . ":" . $id;
	}

	/**
	* this is the funciton that gets the data we need saved to cache.  by
	* default it saves our data, and will save the comments or tags objects if
	* needed. its recommended to extend this to add data that you'd like cached
	* by the object
	*
	* @return an array of data to cache
	*/
	protected function getDataToCache($deep = true)
	{
		$data = array();
	
		//obviously we want our data.
		$data['id'] = $this->id;
		$data['data'] = $this->data;

		return $data;
	}

	/**
	* this function sets the data in the object from the data we retrieved from
	* the cache.  it takes the data from the array and puts it in the object.
	* you'll want to override this one if you added custome data in
	* getDataToCache() and load it into the object.
	*
	* @param $data the data we got from teh cache
	*/
	public function hydrate($data)
	{
		if (is_array($data))
		{
			//get our id back
			$this->id = $data['id'];

			//obviously we want to load our data.
			$this->data = $data['data'];
		}
	}

	/**
	* this function gets our data from the cache. no need to override
	*/
	public function getCache()
	{
		return CacheBot::get($this->getCacheKey(), self::$objectCacheLife);
	}

	/**
	* this function saves our data to the cache. no need to override
	*/
	public function setCache()
	{
		return CacheBot::set($this->getCacheKey(), $this->getDataToCache(), self::$objectCacheLife);
	}

	/**
	* this funciton deletes our data from teh cache. no need to override
	*/
	public function deleteCache()
	{
		return CacheBot::delete($this->getCacheKey());
	}
}
?>