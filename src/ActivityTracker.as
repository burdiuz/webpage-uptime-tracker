package{
	import flash.utils.Dictionary;

	public class ActivityTracker extends Object{
		static public const urls:ActivityTracker = new ActivityTracker(URLInfo);
		static public const states:ActivityTracker = new ActivityTracker(WebPageState);
		private var _type:Class;
		private const _activities:Dictionary = new Dictionary(true);
		public function ActivityTracker(typeFilter:Class=null):void{
			super();
			_type = typeFilter;
		}
		public function get type():Class{
			return this._type;
		}
		public function addActivity(data:*):void{
			if(this._type) data = data as this._type;
			if(data) _activities[data] = true;
		}
		public function removeActivity(data:*):void{
			delete _activities[data];
		}
		public function isActive(data:*):Boolean{
			return data in this._activities;
		}
		public function isCompatibleType(info:*):Boolean{
			return info is this._type;
		}
		public function getList():Array{
			const list:Array = [];
			for (var item:* in this._activities) list.push(item);
			return list;
		}
		public function getBy(parameter:String, value:*):Array{
			const list:Array = [];
			for (var item:* in this._activities){
				if(parameter in item && item[parameter] == value){
					list.push(item);
				}
			}
			return list;
		}
	}
}