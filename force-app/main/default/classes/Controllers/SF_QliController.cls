public with sharing class SF_QliController {
   

    @AuraEnabled(cacheable=true)
    public static List<String> getQuoteLineItemFieldNames(){
        List<String> labels = SF_QliService.getInstance().getQuoteLineItemFieldNames();
        return labels;
    }

    @AuraEnabled(cacheable=true)// add cache
    public static SF_QliWrapper getQli(Id quoteId){
      SF_QliWrapper qliInfo= SF_QliService.getInstance().getQLIs(quoteId);
      return qliInfo;
    }

    @AuraEnabled
    public static List<SF_Quote_Line_Item__c> getQliOptions(Id qliId){
      List<SF_Quote_Line_Item__c> qlis = SF_QliService.getInstance().getOptions(qliId);
      return qlis;
    }
}
