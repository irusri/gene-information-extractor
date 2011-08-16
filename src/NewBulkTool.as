

import com.adobe.serialization.json.JSON;

import events.GoEvent;
import events.ShowInBulkToolEvent;

import itemrenderer.GenebankItemrenderer;
import itemrenderer.Gorenderer;
import itemrenderer.cds;
import itemrenderer.descriptionRenderer;
import itemrenderer.downstream;
import itemrenderer.pantherItemrenderer;
import itemrenderer.peptide;
import itemrenderer.pfamitemrenderer;
import itemrenderer.popGO;
import itemrenderer.pubesthit;
import itemrenderer.puoverlap;
import itemrenderer.pyGOrender;
import itemrenderer.transcript;
import itemrenderer.upstream;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.AdvancedDataGrid;
import mx.controls.Alert;
import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
import mx.core.ClassFactory;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import utils.DataGridUtils;

private var modelConfig:Object;
private var exprDatachartfinal:Object= new Object();
private var populusObject:Object= new Object();
[Bindable]
private var populusArray:ArrayCollection=new ArrayCollection();
private var puObject:Object= new Object();
private var atgObject:Object= new Object();
private var gbObject:Object= new Object();
[Bindable]
private var puArray:ArrayCollection=new ArrayCollection();
[Bindable]
private var putmp:AdvancedDataGrid=new AdvancedDataGrid();
[Bindable]
private var atgArray:ArrayCollection=new ArrayCollection();
[Bindable]
private var puArrayExport:ArrayCollection=new ArrayCollection();
[Bindable]
private var gbArray:ArrayCollection=new ArrayCollection();
[Bindable]
private var puExportdg:AdvancedDataGrid=new AdvancedDataGrid();
[Bindable]
private var atgArrayExport:ArrayCollection=new ArrayCollection();
[Bindable]
private var startArray:ArrayCollection=new ArrayCollection();
[Bindable]
private var startArraySeq:ArrayCollection=new ArrayCollection();
[Bindable]
private var functionalannotationdgBoolean:Boolean=false;
[Bindable]
private var controlboxBoolean:Boolean=true;
[Bindable]
private var subcontrolboxBoolean:Boolean=true;
[Bindable]
public var collapseBoolean:Boolean;
[Bindable]
private var searchText:String="";
[Bindable]
private var typeText:String="";

/**
 * creationCompete HTTP service call
 */
private function bulktool_init() : void {
	serve_getConfigData.send();
	this.addEventListener(ShowInBulkToolEvent.showinbulktool,showinbulktoolFunction);
	
	searchText = FlexGlobals.topLevelApplication.parameters.agi;
	typeText = FlexGlobals.topLevelApplication.parameters.type;
}

/**
 * when ShowInBulkToolEvent fired this method will call and redirect to the annotation
 */
private function showinbulktoolFunction(e:ShowInBulkToolEvent):void{
	var zerostateavalue:String =new String();
	zerostateavalue=e.showinbulktoolString;
	inputTranscripttxt.text=zerostateavalue;
	geneinfoChk.selected=true;
	submitTranscript_clickHandler();
	
}
/**
 * creationCompete HTTP service Result
 */
private function handle_config_files(event:ResultEvent):void {
	modelConfig = (JSON.decode(String(event.result)));
	loadPolFile(modelConfig.settings.policy_file);
	if(searchText!="" && typeText=="functional"){
		inputTranscripttxt.text=searchText;
		submitTranscript_clickHandler();
		functionalannotationdg.visible=true;
		geneinfoChk.selected=true;
	}
	if(searchText!="" && typeText=="populus"){
		overlapttxt.text=searchText;
		conversionCombo.selectedIndex=0;
		idconversionsubmitClick();
		populusdg.visible=true;
		conversionChk.selected=true;
	}
	
	if(searchText!="" && typeText=="atg"){
		overlapttxt.text=searchText;
		conversionCombo.selectedIndex=1;
		idconversionsubmitClick();
		atgdg.visible=true;
		conversionChk.selected=true;
	}
	if(searchText!="" && typeText=="pu"){
		overlapttxt.text=searchText;
		conversionCombo.selectedIndex=2;
		idconversionsubmitClick();
		pudg.visible=true;
		conversionChk.selected=true;
	}
	
}
/**
 * Main Submit button click event
 */
private function submitTranscript_clickHandler():void{
	
	startArray=new ArrayCollection();
	var str:String =inputTranscripttxt.text;
	//str=str.replace(/\s+.1/gi, " ");
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	for(var h:int=0;h<a.length;h++){
		serve_getTranscriptData.url =modelConfig.settings.url+"?primaryGene="+a[h];
		serve_getTranscriptData.send();
	}
}
/**
 * submitted data results and draw gene start lines
 */
private function transcriptDataResult(event:ResultEvent):Boolean {
	var exprData:Object = JSON.decode(String(event.result));
	exprDatachartfinal = exprData;
	startArray.addItem({id:exprDatachartfinal.id,peptideSeq:exprDatachartfinal.peptideSeq,chromosome: exprDatachartfinal.Cromosome,transcriptstart:Math.round(parseInt(exprDatachartfinal.transcriptstart)),strand:exprDatachartfinal.strand,transcriptstop:Math.round(parseInt(exprDatachartfinal.transcriptstop)),datasignalresultSequence:exprDatachartfinal.datasignalresultSequence,transcriptSeq:exprDatachartfinal.transcriptSeq,GO:exprDatachartfinal.GO,PeptideName:exprDatachartfinal.PeptideName,pac:exprDatachartfinal.PAC,cdsSeq:exprDatachartfinal.cdsSeq,atg:exprDatachartfinal.atg,description:exprDatachartfinal.description,
		synonyms:exprDatachartfinal.synonyms,ko:exprDatachartfinal.ko,ec:exprDatachartfinal.ec,panther:exprDatachartfinal.panther,pfam:exprDatachartfinal.pfam,kog:exprDatachartfinal.kog,upSeq:exprDatachartfinal.peptideSeq,downSeq:exprDatachartfinal.peptideSeq,pu:exprDatachartfinal.pu,pyGO:exprDatachartfinal.pyGO});
	functionalannotationdg.dataProvider=startArray;
	
	//if(sequencedg.dataProvider==null){
	sequencedg.dataProvider=startArray;
	//}
	return true;
}
/**
 * Add columns to Functional Annotation Data Grid
 */
public function addRemoveColumns(evt:Event):void{
	if(geneinfoChk.selected){
		var ac:ArrayCollection = new ArrayCollection(functionalannotationdg.columns);
		var factory:ClassFactory ;
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
			dgc.width=100;	
			dgc.wordWrap=true;
			if(dgc.dataField=="pu"){
				factory = new ClassFactory(pubesthit);
				dgc.itemRenderer = factory;
				dgc.headerText = "PU";
				dgc.dataField = "pu";
				dgc.width=100;	
				
			}
			if(dgc.dataField=="description"){
				factory = new ClassFactory(descriptionRenderer);
				dgc.itemRenderer = factory;
				dgc.headerText = "Description";
				dgc.dataField = "description";
				dgc.width = 150;
			}
			
			if(dgc.dataField=="pfam"){
				factory = new ClassFactory(pfamitemrenderer);
				dgc.itemRenderer = factory;
				dgc.headerText = "PFAM";
				dgc.dataField = "pfam";
				dgc.width=100;	
			}		
			if(dgc.dataField=="panther"){
				factory = new ClassFactory(pantherItemrenderer);
				dgc.itemRenderer = factory;
				dgc.headerText = "PANTHER";
				dgc.dataField = "panther";
				dgc.width=100;	
			}	
			
			ac.addItem(dgc);
			functionalannotationdg.columns = ac.toArray();			
		}
	}else if(conversionChk.selected && populusdg.visible==true){
		var acpopulus:ArrayCollection = new ArrayCollection(populusdg.columns);
		var factorypopulus:ClassFactory ;
		if(evt.currentTarget.selected==false ){
			for each(var col1populus:AdvancedDataGridColumn in acpopulus){
				if(col1populus.headerText == evt.currentTarget.label){
					acpopulus.removeItemAt(acpopulus.getItemIndex(col1populus));
					populusdg.columns = acpopulus.toArray();
				}
			}
		}else if(evt.currentTarget.selected==true){
			var dgcpopulus:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			dgcpopulus.headerText = evt.currentTarget.label;
			dgcpopulus.dataField = evt.currentTarget.id;
			dgcpopulus.width=100;	
			dgcpopulus.wordWrap=true;
			if(dgcpopulus.dataField=="pu"){
				factory = new ClassFactory(pubesthit);
				dgcpopulus.itemRenderer = factory;
				dgcpopulus.headerText = "PU";
				dgcpopulus.dataField = "pu";
				dgcpopulus.width=100;			
			}
			if(dgcpopulus.dataField=="GO"){
				factory = new ClassFactory(Gorenderer);
				dgcpopulus.itemRenderer = factory;
				dgcpopulus.headerText = "AgriGO";
				dgcpopulus.dataField = "GO";
				dgcpopulus.width=100;	
			}
			if(dgcpopulus.dataField=="pyGO"){
				factory = new ClassFactory(pyGOrender);
				dgcpopulus.itemRenderer = factory;
				dgcpopulus.headerText = "Phytozome GO";
				dgcpopulus.dataField = "pyGO";
				dgcpopulus.width=100;	
			}
			
			if(dgcpopulus.dataField=="pfam"){
				factory = new ClassFactory(pfamitemrenderer);
				dgcpopulus.itemRenderer = factory;
				dgcpopulus.headerText = "PFAM";
				dgcpopulus.dataField = "pfam";
				dgcpopulus.width=100;	
			}	
			if(dgcpopulus.dataField=="panther"){
				factory = new ClassFactory(pantherItemrenderer);
				dgcpopulus.itemRenderer = factory;
				dgcpopulus.headerText = "PANTHER";
				dgcpopulus.dataField = "panther";
				dgcpopulus.width=100;	
			}
			if(dgcpopulus.dataField=="description"){
				factory = new ClassFactory(descriptionRenderer);
				dgcpopulus.itemRenderer = factory;
				dgcpopulus.headerText = "Description";
				dgcpopulus.dataField = "description";
				dgcpopulus.width = 150;
			}
			
			acpopulus.addItem(dgcpopulus);
			populusdg.columns = acpopulus.toArray();	
		}
		
	}else if(conversionChk.selected && pudg.visible==true){
		var acpu:ArrayCollection = new ArrayCollection(pudg.columns);
		var factorypu:ClassFactory ;
		if(evt.currentTarget.selected==false ){
			for each(var col1pu:AdvancedDataGridColumn in acpu){
				if(col1pu.headerText == evt.currentTarget.label){
					acpu.removeItemAt(acpu.getItemIndex(col1pu));
					pudg.columns = acpu.toArray();
				}
			}
		}else if(evt.currentTarget.selected==true){
			var dgcpu:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			dgcpu.headerText = evt.currentTarget.label;
			dgcpu.dataField = evt.currentTarget.id;
			dgcpu.width=100;
			dgcpu.wordWrap=true;
			if(dgcpu.dataField=="pu"){
				factory = new ClassFactory(pubesthit);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "PU";
				dgcpu.dataField = "pu";
				dgcpu.width=100;			
			}
			if(dgcpu.dataField=="pfam"){
				factory = new ClassFactory(pfamitemrenderer);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "PFAM";
				dgcpu.dataField = "pfam";
				dgcpu.width=100;	
			}
			if(dgcpu.dataField=="panther"){
				factory = new ClassFactory(pantherItemrenderer);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "PANTHER";
				dgcpu.dataField = "panther";
				dgcpu.width=100;	
			}
			if(dgcpu.dataField=="description"){
				factory = new ClassFactory(descriptionRenderer);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "Description";
				dgcpu.dataField = "description";
				dgcpu.width = 150;
			}
			if(dgcpu.dataField=="GO"){
				factory = new ClassFactory(Gorenderer);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "AgriGO";
				dgcpu.dataField = "GO";
				//dgcpu.editorDataField="result";
				//dgcpu.rendererIsEditor=true;
				dgcpu.width=100;	
			}
			if(dgcpu.dataField=="puoverlap"){
				factory = new ClassFactory(puoverlap);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "PU Overlap";
				dgcpu.dataField = "puoverlap";
				dgcpu.width=100;
				
			}
			
			if(dgcpu.dataField=="genebank"){
				factory = new ClassFactory(GenebankItemrenderer);
				dgcpu.itemRenderer = factory;
				dgcpu.headerText = "GeneBank";
				dgcpu.dataField = "genebank";
				dgcpu.width=100;
				
			}
			
			
			acpu.addItem(dgcpu);
			pudg.columns = acpu.toArray();	
		}
		
	}else if(conversionChk.selected && atgdg.visible==true){
		var acatg:ArrayCollection = new ArrayCollection(atgdg.columns);
		var factoryatg:ClassFactory ;
		if(evt.currentTarget.selected==false ){
			for each(var col1atg:AdvancedDataGridColumn in acatg){
				if(col1atg.headerText == evt.currentTarget.label){
					acatg.removeItemAt(acatg.getItemIndex(col1atg));
					atgdg.columns = acatg.toArray();
				}
				
				/*	if(col1atg.headerText == "Phytozome ATG"){
				acatg.removeItemAt(acatg.getItemIndex(col1atg));
				atgdg.columns = acatg.toArray();
				}*/
			}
		}else if(evt.currentTarget.selected==true){
			var dgcatg:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			dgcatg.headerText = evt.currentTarget.label;
			dgcatg.dataField = evt.currentTarget.id;
			dgcatg.wordWrap=true;
			dgcatg.width=100;	
			/*if(evt.currentTarget.label=="ATG"){
			dgcatg.headerText = "Phytozome ATG";
			//evt.currentTarget.label="Phytozome ATG";
			}*/
			
			if(dgcatg.dataField=="pu"){
				factory = new ClassFactory(pubesthit);
				dgcatg.itemRenderer = factory;
				dgcatg.headerText = "PU";
				dgcatg.dataField = "pu";
				dgcatg.width=100;			
			}
			if(dgcatg.dataField=="pfam"){
				factoryatg = new ClassFactory(pfamitemrenderer);
				dgcatg.itemRenderer = factoryatg;
				dgcatg.headerText = "PFAM";
				dgcatg.dataField = "pfam";
				dgcatg.width=100;	
			}
			if(dgcatg.dataField=="panther"){
				factoryatg = new ClassFactory(pantherItemrenderer);
				dgcatg.itemRenderer = factoryatg;
				dgcatg.headerText = "PANTHER";
				dgcatg.dataField = "panther";
				dgcatg.width=100;	
			}
			if(dgcatg.dataField=="GO"){
				factoryatg = new ClassFactory(Gorenderer);
				dgcatg.itemRenderer = factoryatg;
				dgcatg.headerText = "AgriGO";
				//	dgcatg.dataField = "GO";
				dgcatg.width=100;	
			}
			
			if(dgcatg.dataField=="pyGO"){
				factoryatg = new ClassFactory(pyGOrender);
				dgcatg.itemRenderer = factoryatg;
				dgcatg.headerText = "Phytozome GO";
				//	dgcatg.dataField = "GO";
				dgcatg.width=100;	
			}
			
			
			if(dgcatg.dataField=="description"){
				factoryatg = new ClassFactory(descriptionRenderer);
				dgcatg.itemRenderer = factoryatg;
				dgcatg.headerText = "Description";
				dgcatg.dataField = "description";
				dgcatg.width = 150;
			}
			
			acatg.addItem(dgcatg);
			atgdg.columns = acatg.toArray();	
		}
		
	}else if(conversionChk.selected && puexpanddg.visible==true){
		var acpuexpand:ArrayCollection = new ArrayCollection(puexpanddg.columns);
		var factorypuexpand:ClassFactory ;
		if(evt.currentTarget.selected==false ){
			for each(var col1puexpand:AdvancedDataGridColumn in acpuexpand){
				if(col1puexpand.headerText == evt.currentTarget.label){
					acpuexpand.removeItemAt(acpuexpand.getItemIndex(col1puexpand));
					puexpanddg.columns = acpuexpand.toArray();
				}
			}
		}else if(evt.currentTarget.selected==true){
			var dgcpuexpand:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			dgcpuexpand.headerText = evt.currentTarget.label;
			dgcpuexpand.dataField = evt.currentTarget.id;
			dgcpuexpand.width=100;
			dgcpuexpand.wordWrap=true;
			if(dgcpuexpand.dataField=="pu"){
				factory = new ClassFactory(pubesthit);
				dgcpuexpand.itemRenderer = factory;
				dgcpuexpand.headerText = "PU";
				dgcpuexpand.dataField = "pu";
				dgcpuexpand.width=100;			
			}
			if(dgcpuexpand.dataField=="GO"){
				factorypuexpand = new ClassFactory(Gorenderer);
				dgcpuexpand.itemRenderer = factorypuexpand;
				dgcpuexpand.headerText = "AgriGO";
				dgcpuexpand.dataField = "GO";
				dgcpuexpand.width=100;
				
			}
			if(dgcpuexpand.dataField=="pfam"){
				factory = new ClassFactory(pfamitemrenderer);
				dgcpuexpand.itemRenderer = factory;
				dgcpuexpand.headerText = "PFAM";
				dgcpuexpand.dataField = "pfam";
				dgcpuexpand.width=100;	
			}
			if(dgcpuexpand.dataField=="panther"){
				factory = new ClassFactory(pantherItemrenderer);
				dgcpuexpand.itemRenderer = factory;
				dgcpuexpand.headerText = "PANTHER";
				dgcpuexpand.dataField = "panther";
				dgcpuexpand.width=100;	
			}
			
			if(dgcpuexpand.dataField=="puoverlap"){
				factorypuexpand = new ClassFactory(puoverlap);
				dgcpuexpand.itemRenderer = factorypuexpand;
				dgcpuexpand.headerText = "PU Overlap";
				dgcpuexpand.dataField = "puoverlap";
				dgcpuexpand.width=100;
				
			}
			
			if(dgcpuexpand.dataField=="genebank"){
				factorypuexpand = new ClassFactory(GenebankItemrenderer);
				dgcpuexpand.itemRenderer = factorypuexpand;
				dgcpuexpand.headerText = "GeneBank";
				dgcpuexpand.dataField = "genebank";
				dgcpuexpand.width=100;
				
			}
			
			if(dgcpuexpand.dataField=="description"){
				factorypuexpand = new ClassFactory(descriptionRenderer);
				dgcpuexpand.itemRenderer = factorypuexpand;
				dgcpuexpand.headerText = "Description";
				dgcpuexpand.dataField = "description";
				dgcpuexpand.width = 150;
			}
			acpuexpand.addItem(dgcpuexpand);
			puexpanddg.columns = acpuexpand.toArray();	
		}
		
	}else if(conversionChk.selected && gbdg.visible==true){
		var acgb:ArrayCollection = new ArrayCollection(gbdg.columns);
		var factorygb:ClassFactory ;
		if(evt.currentTarget.selected==false ){
			for each(var col1gb:AdvancedDataGridColumn in acgb){
				if(col1gb.headerText == evt.currentTarget.label){
					acgb.removeItemAt(acgb.getItemIndex(col1gb));
					gbdg.columns = acgb.toArray();
				}
				
				/*	if(col1atg.headerText == "Phytozome ATG"){
				acatg.removeItemAt(acatg.getItemIndex(col1atg));
				atgdg.columns = acatg.toArray();
				}*/
			}
		}else if(evt.currentTarget.selected==true){
			var dgcgb:AdvancedDataGridColumn = new AdvancedDataGridColumn();
			dgcgb.headerText = evt.currentTarget.label;
			dgcgb.dataField = evt.currentTarget.id;
			dgcgb.wordWrap=true;
			
			/*if(evt.currentTarget.label=="ATG"){
			dgcatg.headerText = "Phytozome ATG";
			//evt.currentTarget.label="Phytozome ATG";
			}*/
			
			if(dgcgb.dataField=="pu"){
				factorygb = new ClassFactory(pubesthit);
				dgcgb.itemRenderer = factorygb;
				dgcgb.headerText = "PU";
				dgcgb.dataField = "pu";
				dgcgb.width=100;			
			}
			if(dgcgb.dataField=="GO"){
				factorygb = new ClassFactory(Gorenderer);
				dgcgb.itemRenderer = factorygb;
				dgcgb.headerText = "AgriGO";
				//	dgcatg.dataField = "GO";
				dgcgb.width=100;	
			}
			if(dgcgb.dataField=="panther"){
				factorygb = new ClassFactory(pantherItemrenderer);
				dgcgb.itemRenderer = factorygb;
				dgcgb.headerText = "PANTHER";
				dgcgb.dataField = "panther";
				dgcgb.width=100;	
			}
			if(dgcgb.dataField=="description"){
				dgcgb.width = 150;
			}
			
			acgb.addItem(dgcgb);
			gbdg.columns = acgb.toArray();	
		}
		
	}
}
/**
 * subsequence checkbox change event
 */
private function subsequenceChange():void{
	var dgc:AdvancedDataGridColumn = new AdvancedDataGridColumn();
	var ac:ArrayCollection = new ArrayCollection(sequencedg.columns);
	var factory:ClassFactory ;
	if(fastatranscriptChk.selected==true){
		//for each(var col1:AdvancedDataGridColumn in ac){
		ac.removeItemAt(1);
		dgc.headerText = "Transcript";
		dgc.dataField = 'transcriptSeq';
		dgc.wordWrap=true;
		//dgc.width=300;
		
		factory = new ClassFactory(transcript);
		//factory.properties={height:3000};
		dgc.itemRenderer = factory;
		ac.addItem(dgc);
		sequencedg.columns = ac.toArray();
		sequencedg.dataProvider=startArray;
	} 
	
	if(scaffoldsequenceChk.selected==true){
		ac.removeItemAt(1);
		dgc.headerText = "Genomic Sequence";
		dgc.dataField = "datasignalresultSequence";
		dgc.wordWrap=true;
		//dgc.width=300;
		factory = new ClassFactory(datasignalresultSequence);
		dgc.itemRenderer = factory;
		
		ac.addItem(dgc);
		sequencedg.columns = ac.toArray();	
		sequencedg.dataProvider=startArray;
	}
	
	if(fastaproteinChk.selected==true){
		ac.removeItemAt(1);
		
		dgc.wordWrap=true;
		//dgc.width=300;
		factory = new ClassFactory(peptide);
		dgc.itemRenderer = factory;
		dgc.headerText = "Protein";
		dgc.dataField = "peptideSeq";
		ac.addItem(dgc);
		sequencedg.columns = ac.toArray();	
		sequencedg.dataProvider=startArray;
	}
	
	if(fastacdsChk.selected==true){
		ac.removeItemAt(1);
		dgc.wordWrap=true;
		//dgc.width=300;
		factory = new ClassFactory(cds);
		dgc.itemRenderer = factory;
		dgc.headerText = "CDS";
		dgc.dataField = "cdsSeq";
		ac.addItem(dgc);
		sequencedg.columns = ac.toArray();		
		sequencedg.dataProvider=startArray;
	}
	if(upstreamChk.selected==true){
		ac.removeItemAt(1);
		dgc.wordWrap=true;
		//dgc.width=300;
		factory = new ClassFactory(upstream);
		dgc.itemRenderer = factory;
		dgc.headerText = "Upstream flank";
		dgc.dataField = "upSeq";
		ac.addItem(dgc);
		sequencedg.columns = ac.toArray();	
		
	}
	
	
	
	if(downstreamChk.selected==true){
		ac.removeItemAt(1);
		dgc.wordWrap=true;
		//dgc.width=300;
		factory = new ClassFactory(downstream);
		dgc.itemRenderer = factory;
		dgc.headerText = "Downstream flank";
		dgc.dataField = "downSeq";
		ac.addItem(dgc);
		sequencedg.columns = ac.toArray();		
	}

}
/**
 * export grid data as CSV
 */
private function handleExportClick():void
{
	if(functionalannotationdg.visible==true){
		DataGridUtils.loadDataGridInExcel(functionalannotationdg);	
	}else if(sequencedg.visible==true){
		if(upstreamChk.selected==true || downstreamChk.selected==true){
			startArraySeq=new ArrayCollection();
			for(var j:int=0;j<startArray.length;j++){
				startArraySeq.addItem({id:startArray[j].id,peptideSeq:startArray[j].peptideSeq,upSeq:startArray[j].upSeq.substring(0,upstreamSlider.value),downSeq:startArray[j].downSeq.substring(0,downstreamSlider.value),cdsSeq:startArray[j].cdsSeq,transcriptSeq:startArray[j].transcriptSeq})
			}
			sequencedg.dataProvider=startArraySeq;
			subsequenceChange();
		}
		DataGridUtils.loadDataGridInExcel(sequencedg);
		
	}else if(puexpanddg.visible==true){
		//if(collapseBoolean==false){
		/*puArray=new ArrayCollection();
		puArrayExport=new ArrayCollection();
		for(var k:int=0;k<puArray.length;k++){
		var a:Array=new Array(); 
		var tmpStr:String=new String();
		var str:String =puArray[k].pu;
		var pattern:RegExp = /;/gi;
		a = str.replace(pattern, " ").split(/\s+/);
		for(var h:int=0;h<a.length;h++){
		//tmpStr=a[h]+ '\n';
		puArrayExport.addItem({id:puArray[k].id,pu:a[h],id:puArray[k].id,atg:puArray[k].atg,puinput:puArray[k].puinput,orthologs:puArray[k].orthologs,coorthologs:puArray[k].coorthologs,overlap:puArray[k].overlap,besthit:puArray[k].besthit,chromosome: puArray[k].Cromosome,transcriptstart:Math.round(parseInt(puArray[k].transcriptstart)),strand:puArray[k].strand,transcriptstop:Math.round(parseInt(puArray[k].transcriptstop)),GO:puArray[k].GO,PeptideName:puArray[k].PeptideName,pac:puArray[k].PAC,atg:puArray[k].atg,description:puArray[k].description,synonyms:puArray[k].synonyms,ko:puArray[k].ko,ec:puArray[k].ec,panther:puArray[k].panther,pfam:puArray[k].pfam,kog:puArray[k].kog})
		}
		}
		puexpanddg.dataProvider=puArrayExport;*/
		//	DataGridUtils.loadDataGridInExcel(puexpanddg);
		
		puArrayExport=new ArrayCollection()
		puExportdg.dataProvider=null;
		keys=new Object();
		//puArray.filterFunction = filter;
		sortCollection(puArray);
		puArray.refresh();
		copyArrayCollection(puArray,puArrayExport);
		puexpanddg.dataProvider=puArrayExport;
		DataGridUtils.loadDataGridInExcel(puexpanddg);
		
		
		//puexpanddg.dataProvider=null;		
		//sortCollection(puArray);
		//	puArray.refresh();
		//	.dataProvider=puArray;
		//	DataGridUtils.loadDataGridInExcel(puexpanddg);
		//	FlexToExcel.exportDataGrid(pudg);
		/*}else if(collapseBoolean==true) {
		DataGridUtils.loadDataGridInExcel(pudg);
		}*/
	}else if(populusdg.visible==true){
		DataGridUtils.loadDataGridInExcel(populusdg);
		//FlexToExcel.exportDataGrid(populusdg);
	}else if(atgdg.visible==true){
		/*	atgArrayExport=new ArrayCollection();
		for(var m:int=0;m<atgArray.length;m++){
		atgArrayExport.addItem({atg:atgArray[m].atg,id:atgArray[m].id,orthologs:atgArray[m].orthologs,coorthologs:atgArray[m].coorthologs,overlap:atgArray[m].overlap,besthit:atgArray[m].besthit});
		}
		atgdg.dataProvider=atgArrayExport*/
		
		
		DataGridUtils.loadDataGridInExcel(atgdg);
	}else if(pudg.visible==true){
		collapseExport();
	}else if(gbdg.visible==true){
		DataGridUtils.loadDataGridInExcel(gbdg);
	}
}
/**
 * when upstreamslider and downstreamslider change populate new data provider for sequencedg
 */
protected function seqChk_changeHandler():void
{
	startArraySeq=new ArrayCollection();
	for(var j:int=0;j<startArray.length;j++){
		startArraySeq.addItem({id:startArray[j].id,peptideSeq:startArray[j].peptideSeq,upSeq:startArray[j].upSeq.substring(0,upstreamSlider.value),downSeq:startArray[j].downSeq.substring(0,downstreamSlider.value),cdsSeq:startArray[j].cdsSeq,transcriptSeq:startArray[j].transcriptSeq,datasignalresultSequence:startArray[j].datasignalresultSequence})
	}
	sequencedg.dataProvider=startArraySeq;
	subsequenceChange();
}
[Bindable]
private var aTempac:Array=new Array();
/**
 * This method call when we click the ID conversion submit button,call HTTP services
 */
private function idconversionsubmitClick():void{
	populusArray=new ArrayCollection();
	gbArray=new ArrayCollection();
	puArray=new ArrayCollection();
	atgArray=new ArrayCollection();
	puArrayExport=new ArrayCollection();
	var str:String =overlapttxt.text;
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	if(conversionCombo.selectedIndex==0){
		for(var h:int=0;h<a.length;h++){
			serve_idconversionData.url =modelConfig.settings.overlapurl+"?populusid="+a[h];
			serve_idconversionData.send();}
		populusdg.dataProvider=populusArray;
	}else if(conversionCombo.selectedIndex==1){
		for(var i:int=0;i<a.length;i++){
			serve_idconversionData.url =modelConfig.settings.overlapurlatg+"?atgid="+a[i];
			serve_idconversionData.send();}
		atgdg.dataProvider=atgArray;
	}else if(conversionCombo.selectedIndex==2){
		
		for(var j:int=0;j<a.length;j++){
			
			serve_idconversionData.url =modelConfig.settings.overlapurlpu+"?puid="+a[j];
			serve_idconversionData.send();}
		/*		var inputStr:String =overlapttxt.text;
		var inputpattern:RegExp = /,/gi;
		var inputa:Array = inputStr.replace(inputpattern, " ").split(/\s+/);
		for(var k:int=0;k<puArray.length;k++){
		var tmpPU:String;
		var puStr:String=puArray[k].pu;
		var pupattern:RegExp = /;/gi;
		var pua:Array = puStr.replace(pupattern, " ").split(/\s+/);
		
		
		for(var q:int=0;q<pua.length;q++){
		
		for(var w:int=0;w<inputa.length;w++){
		if(pua[q]==inputa[w]){
		tmpPU=pua[q];
		Alert.show(tmpPU.toString());
		}
		}
		}
		puArrayExport.addItem({id:puArray[k].id,puinput:puArray[k].pu,pu:puArray[k].puinput})
		
		
		}*/
		//		puArrayExport=puArray;
		
		/*	if(puArray.length==0 || puArray == null){
		
		puArray.filterFunction = null;
		
		}else{ */
		
		
		//	}
		//ac.refresh();
		//for each (var obj:Object in puArray)
		//{
		
		//}
		//	puArray.filterFunction;
		//	puArrayExport=new ArrayCollection()
		keys=new Object();
		puArray.filterFunction = filter;
		puArray.refresh();
		pudg.dataProvider=puArray;
		
		/*	var filteredArr:Array = puArray.source.filter(removedDuplicates);
		keys=new Object();
		puArray.filterFunction = filter;
		//puArray.itemUpdated(keys.id);
		puArray.refresh();
		
		puArrayExport=puArray;
		pudg.dataProvider=puArray;*/
		//puArray=new ArrayCollection();
		
		
	}else if(conversionCombo.selectedIndex==3){
		
		for(var k:int=0;k<a.length;k++){
			
			serve_idconversionData.url =modelConfig.settings.overlapurlpu+"?puid="+a[k]+"&no="+k;
			serve_idconversionData.send();
		}
		sortCollection(puArray);
		puexpanddg.dataProvider=puArray;
		trace(puArray);
	}else if(conversionCombo.selectedIndex==4){
		for(var l:int=0;l<a.length;l++){
			serve_idconversionData.url =modelConfig.settings.overlapurlgb+"?gbid="+a[l];
			serve_idconversionData.send();}
		gbdg.dataProvider=gbArray;
	}
	
	//overlapstartArray.filterFunction = removedDuplicates;
	//overlapstartArray=getUniqueValues(overlapstartArray);
	//overlapstartArray.refresh();
	
	
	//conversionaskquestions();
	
	
	
	
}

public function sortCollection(arrayCollection : ArrayCollection) : void
{
	//Create the sort field
	var dataSortField:SortField = new SortField();
	
	//name of the field of the object on which you wish to sort the Collection
	dataSortField.name = "no";
	dataSortField.caseInsensitive = true;
	dataSortField.numeric = true;
	/*
	If you wish to perform numeric sort then set:
	
	*/
	
	//create the sort object
	var dataSort:Sort = new Sort();
	dataSort.fields = [dataSortField];
	
	arrayCollection.sort = dataSort;
	//refresh the collection to sort
	arrayCollection.refresh();
	
}
public function collapseExport():void{
	puArrayExport=new ArrayCollection()
	puExportdg.dataProvider=null;
	keys=new Object();
	puArray.filterFunction = filter;
	puArray.refresh();
	copyArrayCollection(puArray,puArrayExport);
	pudg.dataProvider=puArrayExport;
	DataGridUtils.loadDataGridInExcel(pudg);
}


private function copyArrayCollection(src1:ArrayCollection,
									 src2:ArrayCollection):ArrayCollection{
	var dest:ArrayCollection = new ArrayCollection();
	if(src1 != null && src1.length > 0){
		for(var i:int = 0; i<src1.length; i++){
			src2.addItem(src1.getItemAt(i));
		}
	}
	dest = src2;
	return dest;
}



[Bindable]
private var keys:Object = new Object();
private function filter(item:Object):Boolean
{
	if (keys.hasOwnProperty(item["id"]))
		return false;
	else
		keys[item["id"]] = item["id"];
	return true;
}

/**
 * Results for ID conversion submit HTTP call
 */
private function idconversionDataResult(evt:ResultEvent):Boolean{
	var popData:Object = JSON.decode(String(evt.result));
	if(conversionCombo.selectedIndex==0){
		
		populusObject = popData;
		populusArray.addItem({v10:populusObject.v10,v11:populusObject.v11,v20: populusObject.v20,id:populusObject.v22,atg:populusObject.atg,orthologs:populusObject.orthologs,coorthologs:populusObject.coorthologs,overlap:populusObject.overlap,besthit:populusObject.besthit,chromosome: populusObject.Cromosome,transcriptstart:Math.round(parseInt(populusObject.transcriptstart)),strand:populusObject.strand,transcriptstop:Math.round(parseInt(populusObject.transcriptstop)),GO:populusObject.GO,PeptideName:populusObject.PeptideName,pac:populusObject.PAC,atg:populusObject.atg,description:populusObject.description,
			synonyms:populusObject.synonyms,ko:populusObject.ko,ec:populusObject.ec,panther:populusObject.panther,pfam:populusObject.pfam,kog:populusObject.kog,pu:populusObject.pu,pyGO:populusObject.pyGO});
		//populusdg.dataProvider=populusArray;
	}
	if(conversionCombo.selectedIndex==1){
		atgObject = popData;
		atgArray.addItem({atginput:atgObject.atginput,atg:atgObject.atg,id:atgObject.v22,orthologs:atgObject.orthologs,coorthologs:atgObject.coorthologs,overlap:atgObject.overlap,besthit:atgObject.besthit,chromosome: atgObject.Cromosome,transcriptstart:Math.round(parseInt(atgObject.transcriptstart)),strand:atgObject.strand,transcriptstop:Math.round(parseInt(atgObject.transcriptstop)),GO:atgObject.GO,PeptideName:atgObject.PeptideName,pac:atgObject.PAC,atg:atgObject.atg,description:atgObject.description,
			synonyms:atgObject.synonyms,ko:atgObject.ko,ec:atgObject.ec,panther:atgObject.panther,pfam:atgObject.pfam,kog:atgObject.kog,pu:atgObject.pu,pyGO:atgObject.pyGO});
		
	}
	
	if(conversionCombo.selectedIndex==2 ){
		puObject = popData;
		puArray.addItem({pu:puObject.pu,id:puObject.v22,atg:puObject.atg,puinput:puObject.puinput,orthologs:puObject.orthologs,coorthologs:puObject.coorthologs,overlap:puObject.overlap,besthit:puObject.besthit,chromosome: puObject.Cromosome,transcriptstart:Math.round(parseInt(puObject.transcriptstart)),strand:puObject.strand,transcriptstop:Math.round(parseInt(puObject.transcriptstop)),GO:puObject.GO,PeptideName:puObject.PeptideName,pac:puObject.PAC,atg:puObject.atg,description:puObject.description,
			synonyms:puObject.synonyms,ko:puObject.ko,ec:puObject.ec,panther:puObject.panther,pfam:puObject.pfam,kog:puObject.kog,plate:puObject.plate,puoverlap:puObject.puoverlap,genebank:puObject.genebank,gbinput:puObject.gbinput});
	}
	if( conversionCombo.selectedIndex==3){
		puObject = popData;
		puArray.addItem({no:puObject.no,puinput:puObject.puinput,id:puObject.v22,pu:puObject.pu,atg:puObject.atg,orthologs:puObject.orthologs,coorthologs:puObject.coorthologs,overlap:puObject.overlap,besthit:puObject.besthit,chromosome: puObject.Cromosome,transcriptstart:Math.round(parseInt(puObject.transcriptstart)),strand:puObject.strand,transcriptstop:Math.round(parseInt(puObject.transcriptstop)),GO:puObject.GO,PeptideName:puObject.PeptideName,pac:puObject.PAC,atg:puObject.atg,description:puObject.description,
			synonyms:puObject.synonyms,ko:puObject.ko,ec:puObject.ec,panther:puObject.panther,pfam:puObject.pfam,kog:puObject.kog,plate:puObject.plate,puoverlap:puObject.puoverlap,genebank:puObject.genebank,gbinput:puObject.gbinput})
	}
	if( conversionCombo.selectedIndex==4){
		gbObject = popData;
		gbArray.addItem({pu:gbObject.pu,id:gbObject.v22,atg:gbObject.atg,puinput:gbObject.puinput,orthologs:gbObject.orthologs,coorthologs:gbObject.coorthologs,overlap:gbObject.overlap,besthit:gbObject.besthit,chromosome: gbObject.Cromosome,transcriptstart:Math.round(parseInt(gbObject.transcriptstart)),strand:gbObject.strand,transcriptstop:Math.round(parseInt(gbObject.transcriptstop)),GO:gbObject.GO,PeptideName:gbObject.PeptideName,pac:gbObject.PAC,atg:gbObject.atg,description:gbObject.description,
			synonyms:gbObject.synonyms,ko:gbObject.ko,ec:gbObject.ec,panther:gbObject.panther,pfam:gbObject.pfam,kog:gbObject.kog,plate:gbObject.plate,puoverlap:gbObject.puoverlap,genebank:gbObject.genebank,gbinput:gbObject.gbinput});	
	}
	if( conversionCombo.selectedIndex==5){
		gbObject = popData;
		gbArray.addItem({id:gbObject.v22,pu:gbObject.pu,atg:gbObject.atg,puinput:gbObject.puinput,orthologs:gbObject.orthologs,coorthologs:gbObject.coorthologs,overlap:gbObject.overlap,besthit:gbObject.besthit,chromosome: gbObject.Cromosome,transcriptstart:Math.round(parseInt(gbObject.transcriptstart)),strand:gbObject.strand,transcriptstop:Math.round(parseInt(gbObject.transcriptstop)),GO:gbObject.GO,PeptideName:gbObject.PeptideName,pac:gbObject.PAC,atg:gbObject.atg,description:gbObject.description,
			synonyms:gbObject.synonyms,ko:gbObject.ko,ec:gbObject.ec,panther:gbObject.panther,pfam:gbObject.pfam,kog:gbObject.kog,plate:gbObject.plate,puoverlap:gbObject.puoverlap,genebank:gbObject.genebank,gbinput:gbObject.gbinput})
	}	
	
	return true;
}
/**
 * After ID conversion http call system will ask follwoing questions
 */
protected function conversionaskquestions():void{
	if(conversionCombo.selectedIndex==0){
		//	Alert.show("Do you want to annotate?","Annotate", Alert.YES | Alert.NO, this, populusannotateClickHandler);
	}else if(conversionCombo.selectedIndex==1){
		//			Alert.show("Do you want to annotate?","Annotate", Alert.YES | Alert.NO, this, atgannotateClickHandler);
	}else if(conversionCombo.selectedIndex==2) {
		Alert.show("Do you want to collapse fileds?","Collapse",Alert.YES | Alert.NO, this, pucollapseClickHandler);
	}
}
/**
 * If user wants to annotate ID conversion populus genome results following will call
 */
private function atgannotateClickHandler(event:CloseEvent):void{
	switch (event.detail){
		case Alert.YES:
			var selectedRows:Array = new Array();
			var totalrecords:int = atgArray.length;
			if(this.atgdg.selectedIndices.length==0){
				for( var rows:int = 0; rows < totalrecords; rows++){
					selectedRows[rows]=rows
				}
				
				this.atgdg.selectedIndices = selectedRows;
			}
			//		atgdg.copyDataHandlersbutton1();
			break;
		case Alert.NO:
			break;
	}
	
}
/**
 * If user wants to annotate ID conversion populus genome results following will call
 */
private function populusannotateClickHandler(event:CloseEvent):void{
	switch (event.detail){
		case Alert.YES:
			var selectedRows:Array = new Array();
			var totalrecords:int = populusArray.length;
			if(this.populusdg.selectedIndices.length==0){
				for( var rows:int = 0; rows < totalrecords; rows++){
					selectedRows[rows]=rows
				}
				
				this.populusdg.selectedIndices = selectedRows;
			}
			//	populusdg.copyDataHandlersbutton();
			break;
		case Alert.NO:
			break;
	}
	
}
/**
 * If user wants to collaps or exapnd PU values from ID conversion following will call
 */
private function pucollapseClickHandler(event:CloseEvent):void{
	var dgc:AdvancedDataGridColumn = new AdvancedDataGridColumn();
	var ac:ArrayCollection = new ArrayCollection(pudg.columns);
	var factory:ClassFactory ;
	
	
	switch (event.detail){
		case Alert.YES:
			pudg.dataProvider=puArray;
			collapseBoolean=true;
			ac.removeItemAt(0);
			dgc.wordWrap=true;
			dgc.width=this.width/2;
			dgc.headerText = "PU";
			dgc.dataField = "pu";
			factory = new ClassFactory(pubesthit);
			dgc.itemRenderer = factory;
			ac.addItemAt(dgc,0);
			pudg.columns = ac.toArray();	
			break;
		case Alert.NO:
			pudg.dataProvider=puArray;
			collapseBoolean=false;
			//pudg.dataProvider=puArray;
			ac.removeItemAt(0);
			dgc.wordWrap=true;
			dgc.width=this.width/2;
			dgc.headerText = "PU";
			dgc.dataField = "pu";
			factory = new ClassFactory(puexpand);
			dgc.itemRenderer = factory;
			
			ac.addItemAt(dgc,0);
			pudg.columns = ac.toArray();
			
			break;
	}
	//	Alert.show("Do you want to annotate?","Annotate", Alert.YES | Alert.NO, this, puannotateClickHandler);
	
}
/**
 * call when pu annotate yes
 */
private function puannotateClickHandler(event:CloseEvent):void{
	switch (event.detail){
		case Alert.YES:
			var selectedRows:Array = new Array();
			var totalrecords:int = puArray.length;
			if(this.pudg.selectedIndices.length==0){
				for( var rows:int = 0; rows < totalrecords; rows++){
					selectedRows[rows]=rows
				}
				
				this.pudg.selectedIndices = selectedRows;
			}
			//	pudg.copyDataHandlersbutton1();
			break;
		case Alert.NO:
			break;
	}
	
}
/**
 * Handle failed HTTPService component requests.
 */
private function transcriptDataResultFault(event:FaultEvent):Boolean {
	return true;
}
/**
 * Retrieves the crossdomain file for the web-service policy file.
 */
private function loadPolFile(url:String):void {
	Security.loadPolicyFile(url);
}

/**
 * Retrieves unique values from an array collection.
 */
private function getUniqueValues (collection : ArrayCollection) : ArrayCollection {
	var length : Number = collection.length;
	var dic : Dictionary = new Dictionary();
	
	//this should be whatever type of object you have inside your AC
	var value : Object//={"id"};
	for(var i : Number = 0; i < length; i++){
		value = collection.getItemAt(i);
		dic[value.id] = value.id;
	}
	
	//this bit goes through the dictionary and puts data into a new AC
	var unique:ArrayCollection = new ArrayCollection();
	for(var prop :String in dic){
		unique.addItem(dic[prop]);
	}
	return unique;
}

/*public function getUniqueValues (collection:ArrayCollection, propertyName:String):ArrayCollection {
var length:Number = collection.length;
var dict:Dictionary = new Dictionary();
//this should be whatever type of object you have inside your AC
var obj:Object;
for(var i:int = 0; i < length; i++){
obj = collection.getItemAt(i);
dict[obj[propertyName]] = obj[propertyName];
}
//this bit goes through the dictionary and puts data into a new AC
var unique:ArrayCollection = new ArrayCollection();
for(var propertyString:String in dict){
unique.addItem(dict[propertyString]);
}
return unique;
}*/

protected function conversionCombo_changeHandler():void
{
	if(conversionCombo.selectedIndex==0 ){
		overlapttxt.htmlText="POPTR_0005s08110.1\nPOPTR_0020s00420.1\nPOPTR_0008s02470.1\nPOPTR_0004s15090.1\nPOPTR_0006s01090.1\nPOPTR_0006s17670.1\nPOPTR_0010s19220.1\nPOPTR_0010s08310.1\nPOPTR_0001s18120.1";
	}else if(conversionCombo.selectedIndex==1 ){
		overlapttxt.htmlText="At2g37830\nAt4g11430\nAt1g55480\nAt4g34670\nAt2g20890\nAt3g19860\nAt5g56680\nAt2g25670\nAt1g54350\nAt2g03870";
	}else if(conversionCombo.selectedIndex==2 ){
		overlapttxt.htmlText="PU11500\nPU11596\nPU11692\nPU11608\nPU11704\nPU00106\nPU00181\nPU00346\nPU00392\nPU01712";
	}else if(conversionCombo.selectedIndex==3 ){
		overlapttxt.htmlText="PU11500\nPU11596\nPU11692\nPU11608\nPU11704\nPU00106\nPU00181\nPU00346\nPU00392\nPU01712"
	}else if(conversionCombo.selectedIndex==4 ){
		overlapttxt.htmlText="AI161703\nAI161706\nAI161709\nAI161712";
	}
	
}


private function getDistinctPropertyValues2(collection:ArrayCollection, propertyName:String):ArrayCollection {
	//prepare result array
	var distinctValuesCollection:ArrayCollection = new ArrayCollection();
	
	//prepare a temp working array
	var tempPropertyArray:Array = [];
	
	//loop over all the objects in the collection
	for each (var object:Object in collection) {
		//get the property value from the object
		var propertyValue:Object = object[propertyName];
		
		//write the value as a property
		tempPropertyArray[propertyValue] = true;
	}
	
	//loop over all the properties in the tempPropertyArray
	for (var propertyName:String in tempPropertyArray) {
		//add the propertyName (which is actually a distinct property value)
		//to the distinct values collection
		distinctValuesCollection.addItem(propertyName);
	}
	
	//return the collection of distinct values
	return distinctValuesCollection;
}

/*private function test():void{

}*/


/////Label Functions
private function myLabelFuncs(item:Object,column:AdvancedDataGridColumn):String
{
	var str:String =new String();
	str=item[column.dataField];
	//if(item[column.dataField].toString()!=null){
	if(str!=""){
		var pattern:RegExp = /;/gi;
		str=str.replace(pattern, "\n");
		/*var a:Array = str.replace(pattern, " ").split(/\s+/);
		for(var h:int=0;h<a.length;h++){
		str+=a[h]+'\n';
		}*/
		
	}
	
	return str;
	/*}else{
	return "No";
	}*/
}
