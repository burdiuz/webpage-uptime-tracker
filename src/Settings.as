/**
 * Created with IntelliJ IDEA.
 * User: Oleg Galabura
 * Date: 28.01.13
 * Time: 13:35
 * To change this template use File | Settings | File Templates.
 */
package {
	import flash.filesystem.File;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	[Bindable]
	public class Settings {
		static public const FILE_NAME:String = "settings.amf";
		static public const instance:Settings = new Settings();
		private var _timeout:int = 5;
		public var restoreWindowOnStateChange:Boolean = true;
		public function Settings():void{
			super();
			if(instance) throw new Error("Settings class cannot be instantiated, use static property \"instance\" instead.");
			readInternal(this);
		}
		public function get timeout():int{
			return _timeout;
		}
		public function set timeout(value:int):void{
			this._timeout = Math.max(1, value);
		}
		static public function read():void{
			readInternal(Settings.instance);
		}
		static private function readInternal(target:Settings):void{
			var file:File = File.applicationStorageDirectory.resolvePath(FILE_NAME);
			if(!file.exists || file.isDirectory) return;
			const bytes:ByteArray = FileUtils.read(file);
			bytes.position = 0;
			var object:Object = bytes.readObject();
			for(var property:String in object){
				if(property in target) target[property] = object[property];
			}
		}
		static public function write():void{
			var file:File = File.applicationStorageDirectory.resolvePath(FILE_NAME);
			if(file.exists) file.deleteFile();
			const bytes:ByteArray = new ByteArray();
			bytes.writeObject(instance);
			FileUtils.write(bytes, file);
		}
	}
}
