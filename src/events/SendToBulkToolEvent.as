package events{
	
	import flash.events.Event;
	
	public class SendToBulkToolEvent  extends Event{
		
		public static const sendtobulkTool:String = "SENDTOBULKTOOL";
		
		public var sendtobulktoolString:String;
		// Properties
		public var arg:*;
		// Constructor
		public function SendToBulkToolEvent (type:String, bubbles:Boolean=false, cancelable:Boolean=false,sendtobulktoolString:String="")
		{
			super(type, bubbles, cancelable);
			this.sendtobulktoolString = sendtobulktoolString;

		}
		override public function clone():Event{
			return new SendToBulkToolEvent (this.type,this.bubbles,this.cancelable,this.sendtobulktoolString);
		}
	}
}