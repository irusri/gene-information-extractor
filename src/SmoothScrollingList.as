package 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.List;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDetail;
	
	/** 
	 *  List that uses smooth scrolling
	 */
	public class SmoothScrollingList extends AdvancedDataGrid
	{
		
		public function SmoothScrollingList()
		{
			super();
			offscreenExtraRowsOrColumns = 2;
		}
		
		override protected function configureScrollBars():void
		{
			super.configureScrollBars();
			if (verticalScrollBar)
				verticalScrollBar.lineScrollSize = .125;  // should be inverse power of 2
		}
		
		private var fudge:Number;
		
		override public function get verticalScrollPosition():Number
		{
			if (!isNaN(fudge))
			{
				var vsp:Number = super.verticalScrollPosition + fudge;
				fudge = NaN;
				return vsp;
			}
			return Math.floor(super.verticalScrollPosition);
		}
		
		override protected function scrollHandler(event:Event):void
		{
			// going backward is trickier.  When you cross from, for instance 2.1 to 1.9, you need to convince
			// the superclass that it is going from 2 to 1 so the delta is -1 and not -.2.
			// we do this by adding a fudge factor to the first return from verticalScrollPosition
			// which is used by the superclass logic.
			var last:Number = super.verticalScrollPosition;
			var vsp:Number = verticalScrollBar.scrollPosition;
			if (vsp < last)
			{
				if (last != Math.floor(last) || vsp != Math.floor(vsp))
				{
					if (Math.floor(vsp) < Math.floor(last))
					{
						fudge = Math.floor(last) - Math.floor(verticalScrollBar.scrollPosition);
						trace(last.toFixed(2), vsp.toFixed(2), fudge);
					}
				}
			}
			
			super.scrollHandler(event);
			var pos:Number = super.verticalScrollPosition;
			// if we get a THUMB_TRACK, then we need to calculate the position
			// because it gets rounded to an int by the ScrollThumb code, and 
			// we want fractional values.
			if (event is ScrollEvent)
			{
				var se:ScrollEvent = ScrollEvent(event);
				if (se.detail == ScrollEventDetail.THUMB_TRACK)
				{
					if (verticalScrollBar.numChildren == 4)
					{
						var downArrow:DisplayObject = verticalScrollBar.getChildAt(3);
						var thumb:DisplayObject = verticalScrollBar.getChildAt(2);
						pos = (thumb.y - downArrow.height) / (downArrow.y - thumb.height - downArrow.height) * maxVerticalScrollPosition;
						// round to nearest lineScrollSize;
						pos /= verticalScrollBar.lineScrollSize;
						pos = Math.round(pos);
						pos *= verticalScrollBar.lineScrollSize;
						//trace("faked", pos);
					}
				}
			}
			var fraction:Number = pos - verticalScrollPosition;
			fraction *= rowHeight;
			//trace("was", listContent.y.toFixed(2));
			listContent.move(listContent.x, viewMetrics.top + listContent.topOffset - fraction);
			//trace("now", listContent.y.toFixed(2), fraction.toFixed(2), listItems[0][0].data.lastName);
		}
		
	}
	
}