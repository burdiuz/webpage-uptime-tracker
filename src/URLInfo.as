package{
	[Bindable]
	public class URLInfo{
		public var id:uint;
		public var value:String;
		private var _label:String;
		public function URLInfo():void{
			super();
		}
		public function hasLabel():Boolean{
			return this._label is String;
		}
		public function get label():String{
			return this._label ? this._label : this.value;
		}
		static public function create(source:Object):URLInfo{
			const info:URLInfo = new URLInfo();
			info.id = source.id;
			info.value = source.value;
			if(source.label) info._label = source.label;
			return info;
		}
		static public function createByURL(id:int, url:String):URLInfo{
			const info:URLInfo = new URLInfo();
			info.id = id;
			info.value = url;
			return info;
		}
		static public function createList(data:*):Array{
			const list:Array = [];
			for each(var item:Object in data){
				list.push(create(item));
			}
			return list;
		}
	}
}