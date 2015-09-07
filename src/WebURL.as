package {
	public class WebURL extends Object{
		static public const PROTOCOL:String = "protocol";
		static public const AUTHENTICATION:String = "authentication";
		static public const DOMAIN:String = "domain";
		static public const PORT:String = "port";
		static public const PATH:String = "path";
		static public const QUERY:String = "query";
		static public const HASH:String = "hash";
		static private const _composer:WebURL = new WebURL();
		public var protocol:String = "";
		public var username:String = "";
		public var password:String = "";
		public var domain:String = "";
		public var port:String = "";
		public var path:String = "";
		public var query:String = "";
		public var hash:String = "";
		public function WebURL():void{
			super();
		}
		public function get root():String{
			var string:String = "";
			if(this.protocol) string += this.protocol+"://";
			if(this.username) string += this.username+":"+(this.password ? this.password : "")+"@";
			if(this.domain) string += this.domain;
			if(this.port) string += ":"+this.port;
			return string;
		}
		public function get local():String{
			var string:String = this.path ? (string && this.path.charAt()!="/" ? "/" : "")+this.path : "";
			if(this.query) string += this.query.charAt()=="?" ? this.query : "?"+this.query;
			if(this.hash) string += this.hash.charAt()=="#" ? this.hash : "#"+this.hash;
			return string;
		}
		public function compose(...parts:Array):String{
			return this.composeBy(parts);
		}
		public function composeBy(parts:*):String{
			var string:String = "";
			for each(var part:String in parts) parts[part] = part; 
			if(PROTOCOL in parts && this.protocol) string += this.protocol+"://";
			if(AUTHENTICATION in parts && this.username) string += this.username+":"+(this.password ? this.password : "")+"@";
			if(DOMAIN in parts && this.domain) string += this.domain;
			if(PORT in parts && this.port) string += ":"+this.port;
			if(PATH in parts && this.path) string += this.path ? (string && this.path.charAt()!="/" ? "/" : "")+this.path : "";
			if(QUERY in parts && this.query) string += this.query.charAt()=="?" ? this.query : "?"+this.query;
			if(HASH in parts && this.hash) string += this.hash.charAt()=="#" ? this.hash : "#"+this.hash;
			return string;
		}
		public function toString():String{
			const root:String = this.root;
			const local:String = this.local;
			return (root && "\\/?#".indexOf(local.charAt())<0) ? root+"/"+local : root+local;
		}
		public function parse(string:String):void{
			var parts:Array;
			var index:int = 0;
			if(string.indexOf("://")>0){// url with protocol has domain and rooted path
				parts = string.match(/^(([\w\+\-\.]+)\:\/\/)?(([^\:]+)\:([^@]+)@)?([^\:;\/\?#]+)?(\:\d+)?(\/[^\?#]*)?(\?[^#]*)?(#.*)?$/i);
				if(!parts) return;
				this.protocol = parts[2] ? parts[2] : "";
				this.username = parts[4] ? parts[4] : "";
				this.password = parts[5] ? parts[5] : "";
				this.domain = parts[6] ? parts[6] : "";
				this.port = parts[7] ? parts[7].substr(1) : "";
				index = 7;
			}else{// url started from free path: [\.\/]*.+
				parts = string.match(/^([^\?#]*)?(\?[^#]*)?(#.*)?$/i); 
				if(!parts) return;
				this.protocol = "";
				this.username = "";
				this.password = "";
				this.domain = "";
				this.port = "";
			}
			this.path = parts[++index] ? parts[index] : "";
			this.query = parts[++index] ? parts[index].substr(1) : "";
			this.hash = parts[++index] ? parts[index].substr(1) : "";
		}
		static public function parse(string:String):WebURL{
			const url:WebURL = new WebURL();
			url.parse(string);
			return url;
		}
		static public function compose(url:String, ...parts:Array):String{
			return WebURL.composeBy(url, parts);
		}
		static public function composeBy(url:String, parts:*):String{
			_composer.parse(url);
			return _composer.composeBy(parts);
		}
	}
}