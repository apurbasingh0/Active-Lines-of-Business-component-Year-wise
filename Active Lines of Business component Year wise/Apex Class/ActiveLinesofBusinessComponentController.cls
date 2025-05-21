/**
* @description       : used in "ActiveLinesofBusinessComponent" LWC to Display all product and highlight product which current account related opportunity it stage is closewon contains product
* @authorName        : Savita Jamdarkhani
* @group             : Appstrail
* @last modified on  : 09-01-2025
* @last modified by  : Apurba Singh
**/
public with sharing class ActiveLinesofBusinessComponentController 
{  
/**
* @description     : get all BU From Closed Won Opportunity record related to accoutid (recordId) and return to BUsWrapper 
* @pass parameter  : Pass Account  rec id 'recordId'
* @returnparam    : return list of product records to 'BUsWrapper' wrapper
**/  
    @AuraEnabled
    public static List <BUsWrapper> getOppBUs(Id recordId, Integer seYear){
        System.debug('Get Opp BUs'+recordId);
        Date startDate = Date.newInstance(seYear, 4, 1);
        Date endDate = Date.newInstance(seYear + 1, 3, 31);
        System.debug('startDate:::'+startDate);
        System.debug('endDate:::'+endDate);
        Decimal WCT=0,CMS=0,IAQ=0,WD=0,WH=0,Lighting=0,SWG=0;
        List <BUsWrapper> BUsWrapperList=new List<BUsWrapper>();
        Map <String,Decimal> BUAmountMap= new Map<String,Decimal>();
        Map<String, Date> BUDateMap = new Map<String, Date>(); 
        List<Opportunity> oppList = [SELECT Id,CloseDate,CMS_Invoice_Value__c,EV_Invoice_Value__c,IAQ_Invoice_Value__c,Lighting_Invoice_Value__c,SWG_Invoice_Value__c,Total_Invoice_Value__c,Water_Heater_Invoice_Value__c,WCT_Invoice_Value__c,WD_Invoice_Value__c,CreatedDate
                                     FROM Opportunity 
                                     WHERE AccountId =: recordId 
                                     AND StageName IN ('Closed Won','Completed')
                                    ];
        //added by apurba singh 
        // describtion: as we need to give business extracted as financial year wise and it showed with invoice date
        Set<Id> oppoId = new Set<Id>();
        for(Opportunity opp : oppList){
            oppoId.add(opp.Id);
            System.debug('oppoId::'+oppoId);
        }
        List<Quote> quoteList = [SELECT Id,Name, Quote_Type__c FROM Quote WHERE OpportunityId =: oppoId and Quote_Type__c = 'SPA' ];             
        System.debug('quoteList:::'+quoteList);
        Set<Id> quoteId = new Set<Id>();
        for(Quote quo : quoteList){
            quoteId.add(quo.Id);
            System.debug('quoteId::'+quoteId);
        }
        List<PLSI_Invoice__c> invoiceList = [SELECT Id,Name, PLSI_Quotation_Name__c, Taxable_Value__c, Division__c, CreatedDate, PLSI_Invoice_Date__c FROM PLSI_Invoice__c WHERE PLSI_Quotation_Name__c =: quoteId AND PLSI_Invoice_Date__c >= :startDate
        AND PLSI_Invoice_Date__c <= :endDate ];             
        System.debug('invoiceList:::'+invoiceList);               
        try{
            for(PLSI_Invoice__c inv : invoiceList){
                
                if(inv.Division__c == 'WIRES CABLES AND TAPES'){
                    WCT+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                else if(inv.Division__c == 'CABLE MANAGEMENT SYSTEM'){
                    CMS+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                else if(inv.Division__c == 'WIRING DEVICE'){
                    WD+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                else if(inv.Division__c == 'SWITCH GEAR'){
                    SWG+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                else if(inv.Division__c == 'WATER HEATER'){
                    WH+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                else if(inv.Division__c == 'LIGHTING'){
                    Lighting+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                else if(inv.Division__c == 'IAQ'){
                    IAQ+=(inv.Taxable_Value__c==null? 0:inv.Taxable_Value__c);
                }
                //WCT+=(inv.PLSI_Quotation_Name__r.Opportunity.WCT_Invoice_Value__c==null? 0:inv.PLSI_Quotation_Name__r.Opportunity.WCT_Invoice_Value__c);
                // CMS+=(inv.PLSI_Quotation_Name__r.Opportunity.CMS_Invoice_Value__c==null? 0:inv.PLSI_Quotation_Name__r.Opportunity.CMS_Invoice_Value__c);
                // WD+=(inv.PLSI_Quotation_Name__r.Opportunity.WD_Invoice_Value__c==null? 0:inv.PLSI_Quotation_Name__r.Opportunity.WD_Invoice_Value__c);
                // SWG+=(inv.PLSI_Quotation_Name__r.Opportunity.SWG_Invoice_Value__c==null? 0:inv.PLSI_Quotation_Name__r.Opportunity.SWG_Invoice_Value__c);
                // WH+=(inv.PLSI_Quotation_Name__r.Opportunity.Water_Heater_Invoice_Value__c==null? 0:inv.PLSI_Quotation_Name__r.Opportunity.Water_Heater_Invoice_Value__c);
                // Lighting+=(inv.PLSI_Quotation_Name__r.Opportunity.Lighting_Invoice_Value__c==null? 0:inv.PLSI_Quotation_Name__r.Opportunity.Lighting_Invoice_Value__c);
                // IAQ+=(inv.PLSI_Quotation_Name__r.Opportunity.IAQ_Invoice_Value__c==null? 0:+inv.PLSI_Quotation_Name__r.Opportunity.IAQ_Invoice_Value__c);
                
                Date invoiceDate = inv.PLSI_Invoice_Date__c;
                if (!BUDateMap.containsKey('WCT')) BUDateMap.put('WCT', invoiceDate);
                if (!BUDateMap.containsKey('CMS')) BUDateMap.put('CMS', invoiceDate);
                if (!BUDateMap.containsKey('IAQ')) BUDateMap.put('IAQ', invoiceDate);
                if (!BUDateMap.containsKey('WD')) BUDateMap.put('WD', invoiceDate);
                if (!BUDateMap.containsKey('SWG')) BUDateMap.put('SWG', invoiceDate);
                if (!BUDateMap.containsKey('WH')) BUDateMap.put('WH', invoiceDate);
                if (!BUDateMap.containsKey('Lighting')) BUDateMap.put('Lighting', invoiceDate);
            } 
            System.debug('WCT: ' + WCT + ', CMS: ' + CMS + ', WD: ' + WD + ', SWG: ' + SWG + ', WH: ' + WH + ', Lighting: ' + Lighting + ', IAQ: ' + IAQ);
            BUAmountMap.put('WCT',WCT);
            BUAmountMap.put('IAQ',IAQ);
            BUAmountMap.put('CMS',CMS);
            BUAmountMap.put('SWG',SWG);
            BUAmountMap.put('WH',WH);
            BUAmountMap.put('Lighting',Lighting);
            BUAmountMap.put('IAQ',IAQ);
            BUAmountMap.put('WD',WD);
            System.debug('BUAmountMap'+BUAmountMap);
            for(String key:BUAmountMap.keySet()){
                BUsWrapper makeBUsWrapper= new BUsWrapper();
                makeBUsWrapper.BUName=key;
                makeBUsWrapper.BUAmount=BUAmountMap.get(key);
                makeBUsWrapper.InvoiceDateW = BUDateMap.get(key);
                System.debug('makeBUsWrapper:::'+makeBUsWrapper);
                BUsWrapperList.add(makeBUsWrapper);
            }
            System.debug('BUAmountMap: ' + BUAmountMap);
            System.debug('BUDateMap: ' + BUDateMap);
            System.debug('BUsWrapperList:::'+BUsWrapperList);
            return BUsWrapperList;  
        }  
        catch(Exception e){
            System.debug('Error Message:::'+ e.getMessage());
        }
        return BUsWrapperList;      
    }
    
    public class BUsWrapper{
        @AuraEnabled public String BUName;
        @AuraEnabled public Decimal BUAmount ;
        @AuraEnabled public Date InvoiceDateW ;   
    }  
}