package events{
	
	import flash.events.Event;
	
	public class GoEvent  extends Event{
		

		public static const popupGo:String = "POPUPGO";

		
		public var govalues:String;
		public var poptrid:String;
		// Properties
		public var arg:*;
		// Constructor
		public function GoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,govalues:String="",poptrid:String="")
		{
			super(type, bubbles, cancelable);
			this.govalues = govalues;
			this.poptrid = poptrid;
		}
		override public function clone():Event{
			return new GoEvent (this.type,this.bubbles,this.cancelable,this.govalues,this.poptrid);
		}
	}
}