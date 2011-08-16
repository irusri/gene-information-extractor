package
{ 
	import com.as3xls.xls.ExcelFile; 
	import com.as3xls.xls.Sheet; 
	
	import flash.errors.IllegalOperationError; 
	import flash.net.FileReference; 
	import flash.utils.ByteArray; 
	
	import mx.collections.ArrayCollection; 
	import mx.collections.ICollectionView; 
	import mx.collections.IViewCursor; 
	import mx.collections.XMLListCollection; 
	import mx.controls.DataGrid; 
	
	/** 
	 * 
	 * Author: Andrés Lozada Mosto 
	 * Version: 0.1 
	 * Fecha release: 10/03/2009 
	 * Contacto: alfathenus@gmail.com 
	 *   
	 * Clase que maneja la exportacion de elementos 
	 * a Excel. 
	 *  
	 * Se utiliza el proyecto http://code.google.com/p/as3xls/  
	 * para la generacion de Excel. 
	 *  
	 * Se necesita la version 10 de Flash player para realizar el correcto 
	 * guardado del archivo sin pasar por backend. 
	 *  
	 * @example 
	 * <code> 
	 * private var flat:ArrayCollection = new ArrayCollection([ 
	 *                              {nombre:"Andrés", apellido:"Sanchez"}, 
	 *                              {nombre:"Mónica", apellido:"Sanchez"}, 
	 *                              {nombre:"Agustina", apellido:"Sanchez"}, 
	 *                              {nombre:"Pablo", apellido:"Sanchez"}, 
	 *                              {nombre:"Magalí", apellido:"Sanchez"} 
	 *                              ]); 
	 * ExcelExporterUtil.dataGridExporter(this.dg, "prueba_excel.xls"); 
	 * </code> 
	 *  
	 * Lista de funciones 
	 * <list> 
	 *  dataGridExporter:       Exporta un datagrid a un excel de forma automatica 
	 *  export:             Exporta un listado de objetos 
	 * </list> 
	 * 
	 */ 
	
	public class ExcelExporterUtil 
	{ 
		public function ExcelExporterUtil() 
		{ 
			throw new IllegalOperationError("Class \"ExcelExporterUtil\" is static. You can't instance this"); 
		} 
		
		//----------------------------- 
		// Public function 
		//----------------------------- 
		/** 
		 *  
		 * Exporta los datos de un datagrid hacia un Excel. 
		 * Toma el dataProvider del mismo y las columnas para su exportacion 
		 *  
		 * @param dg          Referencia al datagrid 
		 * @defaultName         Nombre default con el que se va a generar el archivo excel 
		 *  
		 */ 
		static public function dataGridExporter(dg:DataGrid, defaultName:String):void 
		{ 
			if (dg == null || dg.dataProvider == null || defaultName == null || defaultName == "") 
				return; 
			
			var cols:Number = 0; 
			var colsValues:Array = []; 
			var cantCols:Number = dg.columnCount; 
			var fieldT:String; 
			var headerT:String; 
			
			// armo el listado de headers y variables para cada columna 
			for ( ; cols < cantCols; cols++) 
			{ 
				headerT = (dg.columns[cols] as Object).headerText 
				fieldT = (dg.columns[cols] as Object).dataField; 
				if ( fieldT == null || fieldT == "" || headerT == null || headerT == "") 
					continue;  
				colsValues.push({ 
					header:headerT, 
					value:fieldT 
				}); 
			} 
			
			if ( colsValues.length == 0 ) 
				return; 
			
			ExcelExporterUtil.export(dg.dataProvider, colsValues, defaultName); 
		} 
		
		/** 
		 *  
		 * Export to Excell 
		 *  
		 * @param obj          Objeto simple, XML, XMLList, Array, ArrayCollection o XMLListCollection 
		 *                   que se quiere exportar a excel 
		 * @colsValues         Listado de objetos que indican cual es el nombre de la columna 
		 *                   y que propiedad del objeto se utiliza para sacar los datos de la columna 
		 *                   {header:"nombre del header", value:"propiedad del objeto que contiene el valor"} 
		 * @param defaultName   Nombre default con el que se genera el excel 
		 *  
		 */ 
		static public function export(obj:Object, colsValues:Array, defautlName:String):void 
		{ 
			var _dp:ICollectionView = ExcelExporterUtil.getDataProviderCollection(obj); 
			if ( _dp == null ) 
				return; 
			
			var rows:Number = 0; 
			var cols:Number = 0; 
			var cantCols:Number = colsValues.length; 
			var sheet:Sheet = new Sheet(); 
			sheet.resize(_dp.length, colsValues.length); 
			
			for ( ; cols < cantCols; cols++) 
			{ 
				sheet.setCell(rows, cols, colsValues[cols].header); 
			} 
			
			cols = 0; 
			rows++; 
			var cursor:IViewCursor = _dp.createCursor(); 
			while ( !cursor.afterLast ) 
			{ 
				for (cols = 0 ; cols < cantCols; cols++) 
				{ 
					if ( (cursor.current as Object).hasOwnProperty(colsValues[cols].value) ) 
						sheet.setCell(rows, cols, (cursor.current as Object)[colsValues[cols].value]); 
				} 
				
				rows++; 
				cursor.moveNext(); 
			} 
			
			var xls:ExcelFile = new ExcelFile(); 
			xls.sheets.addItem(sheet); 
			var bytes:ByteArray = xls.saveToByteArray(); 
			
			var fr:FileReference = new FileReference(); 
			fr.save(bytes, defautlName); 
		} 
		
		//----------------------------- 
		// Private function 
		//----------------------------- 
		/** 
		 *  
		 * A partir de un elemento pasado se genera un ICollectionView 
		 * para su correcto recorrido 
		 *  
		 * @param obj         Objeto a convertir a ICollectionView 
		 *  
		 *  
		 * @return referencia a un ICollectionView.  
		 *  
		 */ 
		static private function getDataProviderCollection(obj:Object):ICollectionView 
		{ 
			if ( (obj is Number && isNaN(obj as Number)) || (!(obj is Number) && obj == null)) 
			{ 
				return null; 
			} 
			else if ( obj is ICollectionView ) 
			{ 
				return obj as ICollectionView; 
			} 
			else if ( obj is Array ) 
			{ 
				return new ArrayCollection(obj as Array); 
			} 
			else if ( obj is XMLList ) 
			{ 
				return new XMLListCollection(obj as XMLList); 
			} 
			else if ( obj is XML ) 
			{ 
				var col:XMLListCollection = new XMLListCollection(); 
				col.addItem(obj); 
				return col; 
			} 
			else if ( obj is Object ) 
			{ 
				return new ArrayCollection([obj]); 
			} 
			else 
			{ 
				return null; 
			} 
		} 
	} 
}