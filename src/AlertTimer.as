package 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.containers.Box;
	import mx.containers.HBox;
	import mx.containers.TitleWindow;
	import mx.controls.Button;
	import mx.controls.Text;
	import mx.managers.PopUpManager;
	
	/**
	 * Alert timer displays an alert like pop up
	 * which closes itself after XX seconds and also
	 * displays a countdown.
	 */    
	public class AlertTimer
	{
		private var myWin:Box;
		private var myTimer:Timer;
		// Main message to display in Alert
		public var alertText:String;
		// Title for the Alert
		public var alertTitle:String;
		// Duration to display Alert before closing
		public var duration:Number = 1;
		// Set alert to modal or not
		public var alertModal:Boolean;
		// Parent DisplayObject to display alert over
		public var alertParent:DisplayObject;    
		// Property to change background color of the alert
		public var backgroundColor:String="#DC143C";
		// Property to change the color of the alert
		public var color:String="#FFFFFF";
		// Text to use for button control
		public var buttonText:String = 'OK';
		// Variable to hold the original width of the alert
		private var alertWidth:Number;
		// Text to use for counter        
		public var counterText:String = "This window will close in";
		// Counter Display Object
		private var counterDisplay:Text;
		
		public function AlertTimer()
		{}
		/**
		 * Function builds and displays the alert.
		 */
		public function show( parent:DisplayObject, text:String, modal:Boolean=true ):void
		{    
			alertText = text;
			//alertTitle = title;
			alertModal = modal;
			alertParent = parent;
			this.createAlert();            
			this.createTimer();            
		}  
		/**
		 * Private function for setting Alert properties and Poping Alert
		 */
		private function createAlert():void
		{
			//myWin.x=300;
			
			myWin = Box(PopUpManager.createPopUp(alertParent, Box, alertModal));
			//myWin = Box(PopUpManager.createPopUp(alertParent, Box, alertModal));
		//	myWin.title = alertTitle;
		
			if ( this.color ) myWin.setStyle('color',this.color);
			if ( this.backgroundColor ) myWin.setStyle('backgroundColor',this.backgroundColor);
			myWin.setStyle('cornerRadius',5);
			
			this.createChildren();
			PopUpManager.centerPopUp(myWin);
		//	PopUpManager.addPopUp(this.
		//	if ( ! alertWidth ){
			//	alertWidth = myWin.width;
			//}
			//myWin.width=200;
		}
		/**
		 * Function for building children for the alert
		 */        
		private function createChildren():void
		{
			var myText:Text = new Text();
			myText.setStyle('fontSize',14);
			myText.setStyle('fontWeight','bold');
			myText.text = alertText;
			
			counterDisplay = new Text();
			var secondText:String = ( duration > 1 ) ? 'seconds' : 'second';
			//counterDisplay.text = counterText ;//+ " " + duration + " " + secondText;
			
			var buttonBox:HBox = new HBox();
			//buttonBox.percentWidth = 100;
			buttonBox.setStyle('horizontalAlign','center');
			buttonBox.setStyle('backgroundAlpha',0.0);
			
			var myButton:Button = new Button();
			myButton.label = this.buttonText;                
			myButton.addEventListener(MouseEvent.CLICK, clickEvent);
			
			//buttonBox.addChild(myButton);            
			myWin.addChild(myText); 
		//	myWin.addChild(counterDisplay);
		//	myWin.addChild(buttonBox);    
		}
		/**
		 * Function which handling button click event
		 */        
		private function clickEvent(event:Event):void
		{
			PopUpManager.removePopUp(myWin);
		}
		/**
		 * Function for creating the timer for closing alert and handling countdown
		 */
		private function createTimer():void
		{
			myTimer = new Timer(1000,duration);
			myTimer.addEventListener(TimerEvent.TIMER, timerTickHandler);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler);
			myTimer.start();            
		}
		/**
		 * Function to handle TIMER event
		 * Updates counterText
		 */        
		private function timerTickHandler(event:Event):void
		{
			//myWin.width = alertWidth;
			var secondsLeft:Number = (duration - myTimer.currentCount);
			var secondText:String = ( secondsLeft > 1 ) ? 'seconds' : 'second';            
			//counterDisplay.text = counterText+" "+secondsLeft.toString()+" "+secondText;
		}
		/**
		 * Function for closing Alert when timer completes.
		 */    
		private function timerCompleteHandler(event:Event):void
		{
			PopUpManager.removePopUp(myWin);
		}
	}
}