/*
* ============================================
* @apexClassName: SF_QuoteTriggerHelper.cls
* @description: helper for SF_QuuoteTrigger.trigger;
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @dateCreated: 06/06/2022
* ============================================
*/
public  class SF_QuoteTriggerHelper {
    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: inserts or update quote and deletes quote.
    public static void processQuoteTrigger(List<SF_Quote__c> newQuotes,List<SF_Quote__c> oldQuotes,String trigerEvent){  
        switch on trigerEvent{
            when 'InsertEvent'{
              List<SF_Quote__c> changedQuotes=processUpsertWithExistingPrimaryQuote(newQuotes);
              update changedQuotes;
            }
            when 'UpdateEvent'{
              List<SF_Quote__c> changedQuotes= processUpsertWithExistingNoNPrimaryQuotes(newQuotes,oldQuotes);
              if(changedQuotes.size()>0){
                update changedQuotes;
              }
            }
            when 'DeleteEvent'{
              deleteQuote(oldQuotes);
            }
        }
    }

   //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: deletes quote.
    private static void deleteQuote(List<SF_Quote__c> oldQuotes){
        for(SF_Quote__c item : oldQuotes) {
            if(item.Primary__c == true) {
                item.addError(system.label.SF_Delete_Quote_Error);
            }
        }
    }

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description:insert primary and uncheck Other Primary and cheks new one, or if quote is first makes it primary
    private static List<SF_Quote__c> processUpsertWithExistingPrimaryQuote(List<SF_Quote__c> quotes){
    
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, List<SF_Quote__c>> mappedQuotes = new Map<Id, List<SF_Quote__c>>();
        List<SF_Quote__c> changedQuotes = new List<SF_Quote__c>();
    
        for(SF_Quote__c item : quotes) {
            opportunityIds.add(item.Opportunity__c);
            if(!mappedQuotes.containsKey(item.Opportunity__c)) {
                mappedQuotes.put(item.Opportunity__c, new List<SF_Quote__c>());
            }
            mappedQuotes.get(item.Opportunity__c).add(item);
        }

        List<SF_Quote__c> primaryQuotes = [SELECT Id, Opportunity__c, Primary__c FROM SF_Quote__c WHERE Opportunity__c IN :opportunityIds AND Primary__c = true];
        if(primaryQuotes.size() > 0) {
            for(SF_Quote__c item : primaryQuotes) {
                if(opportunityIds.contains(item.Opportunity__c)) {
                    for(SF_Quote__c mappedQuoteItem : mappedQuotes.get(item.Opportunity__c)) {
                        if(mappedQuoteItem.Primary__c == true) {
                            item.Primary__c = false;
                            changedQuotes.add(item);
                        }
                    }
                }
            }
        } else {
            for(SF_Quote__c item : quotes){
                item.Primary__c=true;
            }
        }  
        return changedQuotes;      
    }

   //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: check non primary as primary and uncheck old primary, primary could not be unchecked. .
    private static List<SF_Quote__c> processUpsertWithExistingNoNPrimaryQuotes(List<SF_Quote__c> quotes,List<SF_Quote__c> old){
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, List<SF_Quote__c>> mappedQuotes = new Map<Id, List<SF_Quote__c>>();
        List<SF_Quote__c> changedQuotes = new List<SF_Quote__c>();
        
        for(SF_Quote__c item : quotes) {
            opportunityIds.add(item.Opportunity__c);
            if(!mappedQuotes.containsKey(item.Opportunity__c)) {
                mappedQuotes.put(item.Opportunity__c, new List<SF_Quote__c>());
            }
            mappedQuotes.get(item.Opportunity__c).add(item);
        }
       
        List<SF_Quote__c> primaryQuotes = [SELECT Id, Opportunity__c, Primary__c FROM SF_Quote__c WHERE Opportunity__c IN :opportunityIds AND Primary__c = true];
        
        for(SF_Quote__c item : quotes) {
            if(item.Primary__c == true) {
                for(SF_Quote__c primaryQuoteItem : primaryQuotes) {
                    if(primaryQuoteItem.Id != item.Id && primaryQuoteItem.Primary__c == true) {
                        primaryQuoteItem.Primary__c = false;
                        changedQuotes.add(primaryQuoteItem);
                    }
                }
            } else if(item.Primary__c == false) {
                for(SF_Quote__c oldQuote : old) {
                    if(oldQuote.Id == item.Id && oldQuote.Primary__c == true) {
                        item.addError(system.label.SF_Uncheck_Primary_Quote_Error);
                    }
                }
            }
        }
        return changedQuotes;
    }
}