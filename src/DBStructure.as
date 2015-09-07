package{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;

	public class DBStructure extends Object{
		static public const createTablesSQL:XMLList = <>
			<statement><![CDATA[
				CREATE TABLE `urls` (
					`id` INT PRIMARY KEY AUTOINCREMENT,
					`value` TEXT NOT NULL
				);
			]]></statement>
			<statement><![CDATA[
				CREATE TABLE `sessions` (
					`id` INT PRIMARY KEY AUTOINCREMENT,
					`url_id` INT NOT NULL,
					`start_date` INT NOT NULL 
				);
			]]></statement>
			<statement><![CDATA[
				CREATE TABLE `states` (
					`id` INT PRIMARY KEY AUTOINCREMENT,
					`url_id` INT NOT NULL,
					`session_id` INT NOT NULL,
					`value` INT DEFAULT 0,
					`min_time` INT NOT NULL,
					`average_time` INT NOT NULL,
					`max_time` INT NOT NULL,
					`start_date` INT NOT NULL,
					`end_date` INT NOT NULL 
				);
			]]></statement>
			<statement><![CDATA[
				CREATE INDEX `sessions_url_id` ON `sessions` (`url_id`);
			]]></statement>
			<statement><![CDATA[
				CREATE INDEX `states_url_id` ON `states` (`url_id`);
			]]></statement>
			<statement><![CDATA[
				CREATE INDEX `states_session_id` ON `states` (`session_id`);
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `states_url_id_insert` BEFORE INSERT ON `states`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						`id`
						FROM
						`urls`
						WHERE
						`id` = NEW.`url_id`
					)IS NULL THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: states_url_id_insert'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `states_url_id_update` BEFORE UPDATE OF `url_id` ON `states`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						`id`
						FROM
						`urls`
						WHERE
						`id` = NEW.`url_id`
					)IS NULL THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: states_url_id_update'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `states_url_id_delete` BEFORE DELETE ON `urls`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						COUNT(`url_id`)
						FROM
						`states`
						WHERE
						`url_id` = OLD.`id`
					)> 0 THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: states_url_id_delete'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `states_session_id_insert` BEFORE INSERT ON `states`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						`id`
						FROM
						`sessions`
						WHERE
						`id` = NEW.`session_id`
					)IS NULL THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: states_session_id_insert'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `states_session_id_update` BEFORE UPDATE OF `session_id` ON `states`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						`id`
						FROM
						`sessions`
						WHERE
						`id` = NEW.`session_id`
					)IS NULL THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: states_session_id_update'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `states_session_id_delete` BEFORE DELETE ON `sessions`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						COUNT(`session_id`)
						FROM
						`states`
						WHERE
						`session_id` = OLD.`id`
					)> 0 THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: states_session_id_delete'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `sessions_url_id_insert` BEFORE INSERT ON `sessions`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						`id`
						FROM
						`urls`
						WHERE
						`id` = NEW.`url_id`
					)IS NULL THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: sessions_url_id_insert'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `sessions_url_id_update` BEFORE UPDATE OF `url_id` ON `sessions`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						`id`
						FROM
						`urls`
						WHERE
						`id` = NEW.`url_id`
					)IS NULL THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: sessions_url_id_update'
					)
					END;
				END;
			]]></statement>
			<statement><![CDATA[
				CREATE TRIGGER `sessions_url_id_delete` BEFORE DELETE ON `urls`
					BEGIN
					SELECT
					CASE
					WHEN(
						SELECT
						COUNT(`url_id`)
						FROM
						`sessions`
						WHERE
						`url_id` = OLD.`id`
					)> 0 THEN
					RAISE(
						ABORT,
						'Foreign Key Violation: sessions_url_id_delete'
					)
					END;
				END;
]]></statement>
		<statement><![CDATA[]]></statement>
		<statement><![CDATA[]]></statement>
	</>;
		static public function install(connection:SQLConnection):void{
			const statement:SQLStatement = new SQLStatement();
			for each(var sql:String in createTablesSQL){
				if(!sql) continue;
				statement.sqlConnection = connection;
				statement.text = String(sql);
				statement.execute();
			}
		}
		static public function createURL(connection:SQLConnection, url:String):URLInfo{
			const statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "INSERT INTO `urls`(`value`)VALUES(?);";
			statement.parameters[0] = url;
			statement.execute();
			const result:SQLResult = statement.getResult();
			return URLInfo.createByURL(result.lastInsertRowID, url);
		}
		static public function createSession(connection:SQLConnection, urlId:uint, date:Date=null):uint{
			if(!date) date = new Date();
			const statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "INSERT INTO `sessions`(`url_id`, `start_date`)VALUES(?, ?);";
			statement.parameters[0] = urlId;
			statement.parameters[1] = uint(date.time/1000);
			statement.execute();
			const result:SQLResult = statement.getResult();
			return result.lastInsertRowID;
		}
		static public function createState(connection:SQLConnection, urlId:uint, sessionId:uint, value:int, startDate:Date=null, minTime:uint=0, averageTime:uint=0, maxTime:uint=0, endDate:Date=null):uint{
			if(!startDate) startDate = new Date();
			if(!endDate) endDate = startDate;
			const statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "INSERT INTO `states`(`url_id`, `session_id`, `value`, `min_time`, `average_time`, `max_time`, `start_date`, `end_date`)VALUES(?, ?, ?, ?, ?, ?, ?, ?);";
			statement.parameters[0] = urlId;
			statement.parameters[1] = sessionId;
			statement.parameters[2] = value;
			statement.parameters[3] = minTime;
			statement.parameters[4] = averageTime;
			statement.parameters[5] = maxTime;
			statement.parameters[6] = uint(startDate.time/1000);
			statement.parameters[7] = uint(endDate.time/1000);
			statement.execute();
			const result:SQLResult = statement.getResult();
			return result.lastInsertRowID;
		}
		static public function updateState(connection:SQLConnection, id:uint, minTime:uint, averageTime:uint, maxTime:uint, endDate:Date=null):void{
			if(!endDate) endDate = new Date();
			const statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "UPDATE `states` SET `min_time`=?, `average_time`=?, `max_time`=?, `end_date`=? WHERE `id`=?;";
			statement.parameters[0] = minTime;
			statement.parameters[1] = averageTime;
			statement.parameters[2] = maxTime;
			statement.parameters[3] = uint(endDate.time/1000);
			statement.parameters[4] = id;
			statement.execute();
		}
		static public function generateURLLogXML(connection:SQLConnection, urlId:uint):XML{
			var xml:XML = <root/>;
			const statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = connection;
			statement.text = "SELECT `id`, `start_date` FROM `sessions` WHERE `url_id`=? ORDER BY `start_date` DESC;";
			statement.parameters[0] = urlId;
			statement.execute();
			var sessions:Array = statement.getResult().data;
			for each(var session:Object in sessions){
				var sessionXML:XML = <session label={"Session started at "+DateUtil.format(new Date(session.start_date*1000), true)}/>;
				statement.text = "SELECT `value`, `min_time`, `average_time`, `max_time`, `end_date`, `start_date`, `end_date` FROM `states` WHERE `session_id`=? ORDER BY `end_date` DESC;";
				statement.parameters[0] = session.id;
				statement.execute();
				var states:Array = statement.getResult().data;
				for each(var state:Object in states){
					var label:String;
					switch(state.value){
						case WebPageState.UNKNOWN:
						default:
							label = "Unknown";
							break;
						case WebPageState.NETWORK_OFFLINE:
							label = "Offline";
							break;
						case WebPageState.WEBPAGE_REACHABLE:
							label = "Available";
							break;
						case WebPageState.WEBPAGE_UNREACHABLE:
							label = "Unavailable";
							break;
					}
					var stateXML:XML = <state label={label+" from "+DateUtil.format(new Date(state.start_date*1000), true)+" to "+DateUtil.format(new Date(state.end_date*1000), true)+" (min:"+state.min_time+"ms, avg:"+state.average_time+"ms, max:"+state.max_time+"ms)"} type={state.value} startDate={state.start_date} endDate={state.end_date} minTime={state.min_time} averageTime={state.average_time} maxTime={state.max_time}/>;
					sessionXML.* += stateXML;
				}
				xml.* += sessionXML;
			}
			return xml;
		}
		static public function clear(connection:SQLConnection, urlId:uint, exceptions:Array=null/*array of sessionId*/):void{
			const statement:SQLStatement = new SQLStatement();
			var sessions:String = exceptions && exceptions.length ? "\""+exceptions.join("\", \"")+"\"" : null;
			statement.sqlConnection = connection;
			statement.text = "DELETE FROM `states` WHERE `url_id`=? AND `id`";
			if(sessions) statement.text += " AND `session_id` NOT IN("+sessions+")";
			statement.text += ";";
			statement.parameters[0] = urlId;
			statement.execute();
			statement.text = "DELETE FROM `sessions` WHERE `url_id`=?";
			if(sessions) statement.text += " AND `id` NOT IN("+sessions+")";
			statement.text += ";";
			statement.parameters[0] = urlId;
			statement.execute();
		}
	}
}