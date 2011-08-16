package  {
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.errors.IllegalOperationError;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.controls.dataGridClasses.DataGridListData;
	import mx.controls.listClasses.ListData;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	public class FlexToExcel {
		public function FlexToExcel() {
			throw new IllegalOperationError  ("Class  static. You can't instance this");
		}
		
		static public function exportDataGrid (dt:AdvancedDataGrid, filename:String="arcadio.xls", listData:DataGridListData=null):void {
			var head:Array = new Array();
			for each (var item:AdvancedDataGridColumn in dt.columns) {
				head.push(item.headerText);
			}
			
			var data:Array = new Array();
			
			for each (var obj:Object in dt.dataProvider) {
				var arr:Array=new Array();
				for each (var hd:AdvancedDataGridColumn in dt.columns) {
					if (hd.itemRenderer != null) {
						var classFactory:ClassFactory=hd.itemRenderer as ClassFactory;
						var itemRenderer:Object = classFactory.newInstance();
						var listData:DataGridListData = new DataGridListData(hd.editorDataField,hd.dataField,arr.length+1,"id",dt,1);
						itemRenderer.listData = listData;
						if (itemRenderer.hasOwnProperty(hd.editorDataField)) {
							itemRenderer[hd.editorDataField] = obj[hd.dataField];
							itemRenderer.data = obj; // must be last apply for complex itemRenderer
							arr.push(itemRenderer[hd.editorDataField]);
						} else {
							arr.push(itemRenderer.toString());
						}
					} else if (hd.labelFunction != null) {
						arr.push(hd.labelFunction(obj,null));
					} else {
						arr.push(obj[hd.dataField]);
					}
				}
				data.push(arr);
			}
			export(head,data,filename);
		}
		
		static private function export(head:Array, data:Array,filename:String):void {
			// Create sheet
			var cols:int = head.length;
			var rows:int = data.length+1;
			var sheet:Sheet = new Sheet();
			sheet.resize(rows,cols);
			
			// Header
			var row:int=0;
			var col:int=0;
			for each (var item:String in head) {
				sheet.setCell(row,col,item);
				col++;
			}
			
			// Data
			row=1;
			col=0;
			for each (var dataRow:Array in data) {
				for each (var dataCol:String in dataRow) {
					sheet.setCell(row,col,dataCol);
					col++;
				}
				col=0;
				row++;
			}
			
			// Add sheet
			var xls:ExcelFile = new ExcelFile();
			xls.sheets.addItem(sheet);
			var bytes:ByteArray = xls.saveToByteArray();
			// Generate file
			var fr:FileReference = new FileReference();
			fr.save(bytes, filename);
		}
	}
}