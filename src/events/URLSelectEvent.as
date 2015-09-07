package events{
	import flash.events.Event;
	
	public class URLSelectEvent extends Event{
		static public const SELECT:String = "select";
		private var _item:URLInfo;
		public function URLSelectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, item:URLInfo=null):void{
			super(type, bubbles, cancelable);
			_item = item;
		}
		public function get item():URLInfo{
			return this._item;
		}
		override public function clone():Event{
			return new URLSelectEvent(this.type, this.bubbles, this.cancelable, this._item);
		}
	}
}