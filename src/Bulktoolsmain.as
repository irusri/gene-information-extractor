import com.adobe.serialization.json.JSON;

import events.AlertEvent;

import events.GoEvent;
import events.SendToBulkToolEvent;
import events.ShowInBulkToolEvent;

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.Dictionary;

import itemrenderer.popGO;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import utils.DataGridUtils;

private var modelConfig:Object;
private var exprDatachartfinal:Object= new Object();
[Bindable]
private var startArray:ArrayCollection=new ArrayCollection();

[Bindable]
public var overlapstartArray:ArrayCollection=new ArrayCollection();
private var overlapexprDatachartfinal:Object= new Object();

[Bindable]
private var functionalannotationdgBoolean:Boolean=false;
[Bindable]
private var fastaproteindgBoolean:Boolean=false;
[Bindable]
private var fastatranscriptdgBoolean:Boolean=false;

[Bindable]
private var functBoxBoolean:Boolean=true;
[Bindable]
private var overlapBoolean:Boolean=false;
[Bindable]
private var seqpchkBoolean:Boolean=false;

[Bindable]
private var overlapSecondHeader:String="v1.0";
[Bindable]
private var tboolean:Boolean=false;
[Bindable]
private var tvisible:Boolean=false;


private function reportClick(event:MouseEvent):void	{
	var URL:String = "http://130.239.72.85/popgenie2/annotations?field_transcript_id_value=POPTR_0001s13540.1,+POPTR_0011s04270.1,+POPTR_0012s15090.1,+POPTR_0003s10870.1,+POPTR_0004s19390.1,+POPTR_0016s05190.1,+POPTR_0008s17900.1,+POPTR_0183s00230.1,+POPTR_0003s01280.1,+POPTR_0007s06470.1,+POPTR_0019s11610.1,+POPTR_0002s04100.1,+POPTR_0014s13490.1,+POPTR_0008s16160.1,+POPTR_0011s05230.1,+POPTR_0015s08150.1,+POPTR_0013s04890.1,+POPTR_0002s25490.1,+POPTR_0004s02730.1,+POPTR_0001s01230.1,+POPTR_0015s14790.1,+POPTR_0010s02790.1,+POPTR_0005s21440.1,+POPTR_0017s13030.1&op=Extract";
	var urlRequest:URLRequest = new URLRequest(URL);
	urlRequest.method = "POST";
	navigateToURL(urlRequest);
	//navigateToURL((new URLRequest(URL), "_blank");
}
/**
 * creationCompete HTTP service call
 */
private function bulktool_init() : void {
	serve_getConfigData.send();
	this.addEventListener(ShowInBulkToolEvent.showinbulktool,customeventfunction);
	this.addEventListener(GoEvent.popupGo,popupGOFunction);
	//this.addEventListener(AlertEvent.alertShow,alertShowFunct);
	//var tt:*=this.overlapdg.headerRenderer.newInstance();
this.addEventListener(SendToBulkToolEvent.sendtobulkTool,sendtoBulkToolFunction);
}

private function sendtoBulkToolFunction(e:SendToBulkToolEvent):void{
	//Alert.show(e.checkboxstring);
	var selectedRows:Array = new Array();
	var totalrecords:int = overlapstartArray.length;//countResult.lastResult as int;
	
	/*if (e.checkboxstring == "yes")
	{*/
	if(this.overlapdg.selectedIndices.length==0){
		for( var rows:int = 0; rows < totalrecords; rows++){
			selectedRows[rows]=rows
		}
		
		this.overlapdg.selectedIndices = selectedRows;
	}
		overlapdg.copyDataHandlersbutton();

}




private function alertShowFunct(e:AlertEvent):void{

}

private function customeventfunction(e:ShowInBulkToolEvent):void{
	var zerostateavalue:String =new String();
	zerostateavalue=e.showinbulktoolString;
	//Alert.show(zerostateavalue);
	functBoxBoolean=true;
	inputTranscripttxt.text=zerostateavalue;
	overlapBoolean=false;
	bulktoolsradio.selectedValue=null;
	submitTranscript_clickHandler();

}
/**
 * creationCompete HTTP service Result
 */
private function handle_config_files(event:ResultEvent):void {
	modelConfig = (JSON.decode(String(event.result)));
	loadPolFile(modelConfig.settings.policy_file);
	
}
/**
 * PopupGO 
 */
private function popupGOFunction(e:GoEvent):void{
	var win:popGO = PopUpManager.createPopUp(this.parent, popGO, true) as popGO;
	win.goValue=e.govalues;
	win.poptrid=e.poptrid;
	PopUpManager.centerPopUp(win);
	var govalue:String =new String();
	govalue=e.govalues;
	//Alert.show(govalue,e.poptrid+".1 GO values");
}
/**
 * Main Submit button click event
 */
private function submitTranscript_clickHandler():void{
	
	startArray=new ArrayCollection();
	overlapstartArray=new ArrayCollection();
	
	var str:String =inputTranscripttxt.text;
	/*if(overlapBoolean==true){
		str =overlapttxt.text
	}else{
		str =inputTranscripttxt.text
	}*/
	
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	for(var h:int=0;h<a.length;h++){
		serve_getTranscriptData.url =modelConfig.settings.url+"?primaryGene="+a[h];
		serve_getTranscriptData.send();
	}
}
/**
 * Overlap Submit button click event
 */
private function overlap_clickHandler():void{
	overlapstartArray=new ArrayCollection();
	var str:String =overlapttxt.text;
/*	if(overlapBoolean==true){
		str =overlapttxt.text
	}else{
		str =inputTranscripttxt.text
	}*/
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	for(var h:int=0;h<a.length;h++){
		if(overlapCombo.selectedIndex==0){
			serve_getOverlapData.url =modelConfig.settings.overlapurl+"?v10id="+a[h];
			serve_getOverlapData.send();	
		}else if(overlapCombo.selectedIndex==1){
			serve_getOverlapData.url =modelConfig.settings.overlapurl+"?v11id="+a[h];
			serve_getOverlapData.send();
		}else if(overlapCombo.selectedIndex==2){
			serve_getOverlapData.url =modelConfig.settings.overlapurl+"?v20id="+a[h];
			serve_getOverlapData.send();
		}else if(overlapCombo.selectedIndex==3){
			serve_getOverlapData.url =modelConfig.settings.overlapurl+"?pu="+a[h];
			serve_getOverlapData.send();
		}else if(overlapCombo.selectedIndex==4){
			serve_getOverlapData.url =modelConfig.settings.overlapurl+"?atg="+a[h];
			serve_getOverlapData.send();
		}else{
			serve_getOverlapData.url =modelConfig.settings.overlapurl+"?v22atg="+a[h];
			serve_getOverlapData.send();
		}
		
	}
	
	//overlapstartArray.filterFunction = removedDuplicates;
	overlapstartArray=getUniqueValues(overlapstartArray);
	//overlapstartArray.refresh();
	overlapdg.dataProvider=overlapstartArray;
}
/**
 * Overlap combo box change Event
 */
private function headerChange():void{
	if(overlapCombo.selectedIndex==0){
		overlapSecondHeader="v1.0";
		tlabel.text="v2.2";
		tvisible=false;
	}else if(overlapCombo.selectedIndex==1){
		overlapSecondHeader="v1.1";
		tlabel.text="v2.2";
		tvisible=false;
	}else if(overlapCombo.selectedIndex==2){
		overlapSecondHeader="v2.0";
		tlabel.text="v2.2";
		tvisible=false;
	}else if(overlapCombo.selectedIndex==3){
		overlapSecondHeader="PU";
		tlabel.text="v2.2";
		tvisible=false;	
	}else if(overlapCombo.selectedIndex==4){
		overlapSecondHeader="ATG";
		tlabel.text="v2.2";
		tvisible=true;
	}else{
		overlapSecondHeader="ATG";
		tlabel.text="ATG";
		tvisible=true;
	}
	overlapdg.dataProvider=null;
//	submitbulk.visible=false;
}

/**
 * Overlap submitted data results and draw gene start lines
 */
private function overlapDataResult(event:ResultEvent):Boolean {
	var exprData:Object = JSON.decode(String(event.result));
	for(var i:int=0;i<exprData.length;i++) {
		overlapexprDatachartfinal = exprData[i];
		if(overlapCombo.selectedIndex==0){
			overlapstartArray.addItem({id:overlapexprDatachartfinal.v22,v10:overlapexprDatachartfinal.v10});
		}else if(overlapCombo.selectedIndex==1){
			overlapstartArray.addItem({id:overlapexprDatachartfinal.v22,v10:overlapexprDatachartfinal.v11});
		}else if(overlapCombo.selectedIndex==2){
			overlapstartArray.addItem({id:overlapexprDatachartfinal.v22,v10:overlapexprDatachartfinal.v20});
		}else if(overlapCombo.selectedIndex==3){
			overlapstartArray.addItem({id:overlapexprDatachartfinal.v22,v10:overlapexprDatachartfinal.pu});
		}else if(overlapCombo.selectedIndex==4){
			overlapstartArray.addItem({id:overlapexprDatachartfinal.v22,v10:overlapexprDatachartfinal.atg});
		}else{
			overlapstartArray.addItem({id:overlapexprDatachartfinal.v22,v10:overlapexprDatachartfinal.atg});
		}
	}
	
	
	
	return true;
}

/**
 * submitted data results and draw gene start lines
 */
private function transcriptDataResult(event:ResultEvent):Boolean {
	var exprData:Object = JSON.decode(String(event.result));
	exprDatachartfinal = exprData;
	var i:int;
	startArray.addItem({id:exprDatachartfinal.id,peptideSeq:exprDatachartfinal.peptideSeq,chromosome: exprDatachartfinal.Cromosome,transcriptstart:Math.round(parseInt(exprDatachartfinal.transcriptstart)),strand:exprDatachartfinal.strand,transcriptstop:Math.round(parseInt(exprDatachartfinal.transcriptstop)),transcriptSeq:exprDatachartfinal.transcriptSeq,GO:exprDatachartfinal.GO,PeptideName:exprDatachartfinal.PeptideName,pac:exprDatachartfinal.PAC,cdsSeq:exprDatachartfinal.cdsSeq,atg:exprDatachartfinal.atg,description:exprDatachartfinal.description,
		synonyms:exprDatachartfinal.synonyms,ko:exprDatachartfinal.ko,ec:exprDatachartfinal.ec,panther:exprDatachartfinal.panther,pfam:exprDatachartfinal.pfam,kog:exprDatachartfinal.kog});
	functionalannotationdg.dataProvider=startArray;
	fastaproteindg.dataProvider=startArray;
	fastatranscriptdg.dataProvider=startArray;

	return true;
}
/**
 * export grid data as CSV
 */
private function handleExportClick():void
{
	if(functionalannotationdgBoolean==true){
		DataGridUtils.loadDataGridInExcel(functionalannotationdg);	
	}else if(fastaproteindgBoolean==true){
		DataGridUtils.loadDataGridInExcel(fastaproteindg);
	}else if (fastatranscriptdgBoolean==true){
		DataGridUtils.loadDataGridInExcel(fastatranscriptdg);
	}else if(overlapBoolean==true){
		DataGridUtils.loadDataGridInExcel(overlapdg);	
	}else {
		Alert.show("Please select an option!","Select option");
	}
}





/**
 * Retrieves the crossdomain file for the web-service policy file.
 */
private function loadPolFile(url:String):void {
	Security.loadPolicyFile(url);
}

/**
 * Handle failed HTTPService component requests.
 */
private function transcriptDataResultFault(event:FaultEvent):Boolean {
	return true;
}



/**
 * Add columns to Functional Annotation Data Grid
 */

private function addRemoveColumns(evt:Event):void{
	var ac:ArrayCollection = new ArrayCollection(functionalannotationdg.columns);
	if(evt.currentTarget.selected==false ){
		for each(var col1:AdvancedDataGridColumn in ac){
			if(col1.headerText == evt.currentTarget.label){
				ac.removeItemAt(ac.getItemIndex(col1));
				functionalannotationdg.columns = ac.toArray();
			}
		}
	}else if(evt.currentTarget.selected==true){
		var dgc:AdvancedDataGridColumn = new AdvancedDataGridColumn();
		dgc.headerText = evt.currentTarget.label;
		dgc.dataField = evt.currentTarget.id;
		dgc.wordWrap=true;
		
		if(dgc.dataField=="description"){
			
		dgc.width = 150;
		}
		ac.addItem(dgc);
		functionalannotationdg.columns = ac.toArray();			
	}
	
}

/**
 * Set False to every boolean varibles
 */

private function falseall():void{
	functionalannotationdgBoolean=false;
	fastatranscriptdgBoolean=false;
	fastaproteindgBoolean=false;

	overlapBoolean=false;
	//seqpchkBoolean=false;
}


//filter main id
private function filter():void {
	if(overlapBoolean==true){
		overlapstartArray.filterFunction = filterMyArrayCollection;
		overlapstartArray.refresh();		
	}else{
		startArray.filterFunction = filterMyArrayCollection;
		startArray.refresh();}
}
//filter overlap
private function overlapfilter():void {
	overlapstartArray.filterFunction = filterMyArrayCollectionoverlapsecoundcolumn;
	overlapstartArray.refresh();		
	
}


private function filterMyArrayCollection(item:Object):Boolean {
	var searchString:String = txt.text.toLowerCase();
	var itemName:String = (item.id as String).toLowerCase();
	return itemName.indexOf(searchString) > -1;
}

private function filterMyArrayCollectionoverlapsecoundcolumn(item:Object):Boolean {
	var searchString:String = overlaptxt.text.toLowerCase();
	var itemName:String = (item.v10 as String).toLowerCase();
	return itemName.indexOf(searchString) > -1;
}

private function clearMyTextInput():void {
	txt.text = "";
	
}

private function overlapresetMyTextInput():void {
	if (overlaptxt.text.length==0)
		overlaptxt.text = "Filter by "+overlapSecondHeader+" Id..";
}
private function resetMyTextInput():void {
	if (txt.text.length==0)
		txt.text = "Filter by Transcript Id..";
}


//takes an AC and the filters out all duplicate entries
private function getUniqueValues (collection : ArrayCollection) : ArrayCollection {
	var length : Number = collection.length;
	var dic : Dictionary = new Dictionary();
	
	//this should be whatever type of object you have inside your AC
	var value : Object;
	for(var i : Number = 0; i < length; i++){
		value = collection.getItemAt(i);
		dic[value] = value;
	}
	
	//this bit goes through the dictionary and puts data into a new AC
	var unique:ArrayCollection = new ArrayCollection();
	for(var prop :String in dic){
		unique.addItem(dic[prop]);
	}
	return unique;
}

private function translateClick():void{
if(tboolean==false){
	overlapCombo.selectedIndex=5;
	//overlapCombo.enabled=false;
	tlabel.text="ATG";
	tboolean=true;
}else{
	overlapCombo.selectedIndex=4;
	overlapCombo.enabled=true;
	tlabel.text="v2.2";
	tboolean=false;
}	
}
