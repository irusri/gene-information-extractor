package events{
	
	import flash.events.Event;
	
	public class ShowInBulkToolEvent  extends Event{
		
		public static const showinbulktool:String = "SHOWINBULKTOOL";
		
		public var showinbulktoolString:String;

		// Properties
		public var arg:*;
		// Constructor
		public function ShowInBulkToolEvent (type:String, bubbles:Boolean=false, cancelable:Boolean=false,showinbulktoolString:String="")
		{
			super(type, bubbles, cancelable);
			this.showinbulktoolString = showinbulktoolString;
		}
		override public function clone():Event{
			return new ShowInBulkToolEvent (this.type,this.bubbles,this.cancelable,this.showinbulktoolString);
		}
	}
}