package{
	import flash.data.SQLConnection;
	import flash.events.EventDispatcher;

	[Bindable]
	public class WebPageState extends EventDispatcher{
		static public const UNKNOWN:int = 0;
		static public const NETWORK_OFFLINE:int = 1;
		static public const WEBPAGE_UNREACHABLE:int = 2;
		static public const WEBPAGE_REACHABLE:int = 4;
		private var _urlId:uint;
		private var _sessionId:uint;
		private var _id:uint;
		private var _value:int;
		private var _minTime:uint;
		private var _averageTime:uint;
		private var _maxTime:uint;
		private var _startDate:Date;
		private var _endDate:Date;
		public function WebPageState(urlId:int, sessionId:int, id:uint, value:int, startDate:Date, minTime:uint, averageTime:uint, maxTime:uint, endDate:Date):void{
			super();
			_urlId = urlId;
			_sessionId = sessionId;
			_id = id;
			_value = value;
			_minTime = minTime;
			_averageTime = averageTime;
			_maxTime = maxTime;
			_startDate  = startDate;
			_endDate = endDate;
		}
		public function get urlId():uint{
			return this._urlId;
		}
		public function get sessionId():uint{
			return this._sessionId;
		}
		public function get id():uint{
			return this._id;
		}
		public function get value():int{
			return this._value;
		}
		public function get minTime():uint{
			return this._minTime;
		}
		public function set minTime(value:uint):void{
			this._minTime = value;
		}
		public function get averageTime():uint{
			return this._averageTime;
		}
		public function set averageTime(value:uint):void{
			this._averageTime = value;
		}
		public function get maxTime():uint{
			return this._maxTime;
		}
		public function set maxTime(value:uint):void{
			this._maxTime = value;
		}
		public function get startDate():Date{
			return this._startDate;
		}
		public function get endDate():Date{
			return this._endDate;
		}
		public function set endDate(value:Date):void{
			if(!value) value = new Date();
			this._endDate = value;
		}
		override public function toString():String{
			var string:String;
			switch(this._value){
				case WebPageState.UNKNOWN:
					string = "unknown";
					break;
				case WebPageState.NETWORK_OFFLINE:
					string = "offline";
					break;
				case WebPageState.WEBPAGE_UNREACHABLE:
					string = "unavailable";
					break;
				case WebPageState.WEBPAGE_REACHABLE:
					string = "available";
					break;
			}
			return string;
		}
		static public function create(connection:SQLConnection, urlId:int, sessionId:int, value:int, startDate:Date, minTime:uint=0, averageTime:uint=0, maxTime:uint=0, endDate:Date=null):WebPageState{
			if(!startDate) startDate = new Date();
			if(!endDate) endDate = startDate;
			const id:int = DBStructure.createState(connection, urlId, sessionId, value, startDate, minTime, averageTime, maxTime, endDate);
			return new WebPageState(urlId, sessionId, id, value, startDate, minTime, averageTime, maxTime, endDate);
		}
	}
}