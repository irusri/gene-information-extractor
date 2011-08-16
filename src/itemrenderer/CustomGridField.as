package itemrenderer {
	
	import mx.controls.Label;
	import mx.controls.dataGridClasses.*;
	
	public class CustomGridField extends Label {
		
		override public function set data(value:Object):void
		{
			if(value != null)
			{
				super.data = value;
				if(value[DataGridListData(listData).dataField] == "Out of range") {
					setStyle("color", 0xFF0000);
					setStyle("fontWeight",'bold');
				}
				else {
					setStyle("color", 0x000000);
					setStyle("fontWeight",'normal');
				}
			}
		}
	}
	
}