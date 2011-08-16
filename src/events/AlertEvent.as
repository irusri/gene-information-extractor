package events{
	
	import flash.events.Event;
	
	public class AlertEvent  extends Event{
		
		
		public static const alertShow:String = "ALERTSHOW";
		
		
		public var alertString:String;
		//public var yavalue:int;
		//public function (customEventString:String){
		// Properties
		public var arg:*;
		// Constructor
		public function AlertEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,alertString:String="")
		{
			super(type, bubbles, cancelable);
			this.alertString = alertString;
			//this.yavalue = yavalue;
		}
		override public function clone():Event{
			return new AlertEvent (this.type,this.bubbles,this.cancelable,this.alertString);
		}
	}
}