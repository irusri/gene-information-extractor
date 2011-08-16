package 
{

	import events.ShowInBulkToolEvent;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.EventPriority;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;

	public class IBDataGrid extends AdvancedDataGrid
	{
		[Bindable] public var enableCopy : Boolean = true;
		// for creating conext menu item for coping functionality				
		private var copyContextItem:ContextMenuItem;	
		private var copyContextItems:ContextMenuItem;	
		// for storing the header text at only once.
		private var headerString : String = '';
		
		private var dataToCopy:String = '';
		
		
		
		public function IBDataGrid()
		{
			super();		
		}
			
		// I am creating a copy context item and its handler in creation complete of DATAGRID if and only if enableCopy is true.
	    override protected function createChildren():void{
			super.createChildren();
			 var flag:Boolean = false
				if(enableCopy){
								contextMenu = new ContextMenu();
								createContextMenu();
							    addEventListener(ListEvent.ITEM_CLICK,
				                         										itemClickHandler,
				                         										false, EventPriority.DEFAULT_HANDLER);
				                 flag = true;
   					}			
		}
	    
		private function createContextMenu():void{
			copyContextItems = new ContextMenuItem("send to bulk tools");
		      copyContextItem = new ContextMenuItem("copy row/s");
	          copyContextItem.enabled = false;
			  copyContextItems.enabled = false;
			  copyContextItems.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,copyDataHandlers);	
			  copyContextItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,copyDataHandler);		
			  contextMenu.customItems.push(copyContextItem);
			  contextMenu.customItems.push(copyContextItems);
			  // comment the following line if you want default items in context menu.
			  contextMenu.hideBuiltInItems();
		}
		
		private function copyDataHandler(event:Event):void{
			dataToCopy = '';
			if(selectedItems != null){
				 dataToCopy = getSelectedRowsData();
			//	 dataToCopy = ((headerString == '') ? getHeaderData() : headerString)+"\n" + dataToCopy;
				 dataToCopy
				 copyContextItem.enabled = true;
				 System.setClipboard(dataToCopy);
			}  			
		}
		private function copyDataHandlers(event:Event):void{
			dataToCopy = '';
			if(selectedItems != null){
				dataToCopy = getSelectedRowsDatasend();
			//	dataToCopy = ((headerString == '') ? getHeaderData() : headerString)+"\n" + dataToCopy;				
				copyContextItems.enabled = true;
				dispatchEvent(new ShowInBulkToolEvent(ShowInBulkToolEvent.showinbulktool,true,false,dataToCopy))

				//System.setClipboard(dataToCopy);
			}  			
		}
		
		private function handleAlertClose(event:CloseEvent):void{
			trace("handling .. the event");
			if(event.detail == 1)
			{		
			  	 
			}
			 
		}
		private function getHeaderData():String{		 
			   headerString = '';		
					for(var j:int = 0; j< columnCount; j++){
						if((columns[j] as AdvancedDataGridColumn).visible)
							headerString += (columns[j] as AdvancedDataGridColumn).headerText +"\n";
					}
		 		return headerString;	 	
		}	
		
		private function getSelectedRowsData():String{
			var rowsData : String = '';
			for(var i:int =0;i<selectedItems.length;i++) {
				for(var j:int = 0; j< columnCount; j++){
					if((columns[j] as AdvancedDataGridColumn).visible)
						rowsData += selectedItems[i][(columns[j] as AdvancedDataGridColumn).dataField] +"\t";
				}
				rowsData+= "\n";							 
			}
			return rowsData;
		}
		
		private function getSelectedRowsDatasend():String{
			var rowsData : String = '';
			//trace(this.collection.length);
			for(var i:int =0;i<selectedItems.length;i++) {
				for(var j:int = 0; j< 1; j++){
					if((columns[j] as AdvancedDataGridColumn).visible)
						rowsData += selectedItems[i][(columns[0] as AdvancedDataGridColumn).dataField].toString()+".1";
					   if(i<selectedItems.length-1){
						   rowsData+= "\n" ;
					   }
				}
			//	rowsData+= "\n";							 
			}
			return rowsData;
		}
		private function getSelectedRowsDatasend1():String{
			var rowsData : String = '';
			//trace(this.collection.length);
			for(var i:int =0;i<selectedItems.length;i++) {
				for(var j:int = 0; j< 1; j++){
					if((columns[j] as AdvancedDataGridColumn).visible)
						rowsData += selectedItems[i][(columns[1] as AdvancedDataGridColumn).dataField].toString()+".1";
					if(i<selectedItems.length-1){
						rowsData+= "\n" ;
					}
				}
				//	rowsData+= "\n";							 
			}
			return rowsData;
		}
	    
		
		public function copyDataHandlersbutton():void{
			if(this.collection.length!=0){
			dataToCopy = '';
			if(selectedItems != null){
				dataToCopy = getSelectedRowsDatasendbutton();
				//	dataToCopy = ((headerString == '') ? getHeaderData() : headerString)+"\n" + dataToCopy;				
				//copyContextItems.enabled = true;
				dispatchEvent(new ShowInBulkToolEvent(ShowInBulkToolEvent.showinbulktool,true,false,dataToCopy))
				
				//System.setClipboard(dataToCopy);
			}  }			
		}
		
		public function copyDataHandlersbutton1():void{
			if(this.collection.length!=0){
				dataToCopy = '';
				if(selectedItems != null){
					dataToCopy = getSelectedRowsDatasendbutton1();
					//	dataToCopy = ((headerString == '') ? getHeaderData() : headerString)+"\n" + dataToCopy;				
					//copyContextItems.enabled = true;
					dispatchEvent(new ShowInBulkToolEvent(ShowInBulkToolEvent.showinbulktool,true,false,dataToCopy))
					
					//System.setClipboard(dataToCopy);
				}  }			
		}
		
		private function getSelectedRowsDatasendbutton():String{
			var rowsData : String = '';
			//trace(this.collection.length);
			if(this.collection.length!=0){
			for(var i:int =0;i<this.collection.length;i++) {
				for(var j:int = 0; j< 1; j++){
					if((columns[j] as AdvancedDataGridColumn).visible)
						rowsData += this.collection[i][(columns[0] as AdvancedDataGridColumn).dataField].toString()+".1";
					if(i<this.collection.length-1){
						rowsData+= "\n" ;
					}
				}
				//	rowsData+= "\n";							 
			}}
			rowsData = rowsData.replace( /\s+.1/gi, ".1");
			rowsData = rowsData.replace( /No_Value.1/gi, "");
			rowsData = rowsData.replace( /No_Value.1\n/gi, "");
			rowsData = rowsData.replace(/\s+/g, '\n');
			return rowsData;
		}
		
		private function getSelectedRowsDatasendbutton1():String{
			var rowsData : String = '';
			//trace(this.collection.length);
			if(this.collection.length!=0){
				for(var i:int =0;i<this.collection.length;i++) {
					for(var j:int = 0; j< 1; j++){
						if((columns[j] as AdvancedDataGridColumn).visible)
							rowsData += this.collection[i][(columns[1] as AdvancedDataGridColumn).dataField].toString()+".1";
						if(i<this.collection.length-1){
							rowsData+= "\n" ;
						}
					}
					//	rowsData+= "\n";							 
				}}
			rowsData = rowsData.replace( /\s+.1/gi, ".1");
			rowsData = rowsData.replace( /No_Value.1/gi, "");
			rowsData = rowsData.replace( /No_Value.1\n/gi, "");
			rowsData = rowsData.replace(/\s+/g, '\n');
			return rowsData;
		}
		
	    private function itemClickHandler(event:ListEvent):void
	    {
	    	copyContextItem.enabled = true;
			copyContextItems.enabled = true;
	    }		
	}
}