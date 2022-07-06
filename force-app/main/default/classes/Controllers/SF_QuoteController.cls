/*
* ============================================
* @apexClassName: SF_QuoteController.cls
* @description: class containing the logic for creating and deleting quote;
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @testClass: SF_QuoteControllerTest.cls	
* @dateCreated: 05/25/2022
* ============================================
*/
public with sharing class SF_QuoteController {
     /*
     * @author: paata gvichia
     * @param: opportunityID - id of opportunity.QUote should be asigned to it
     * @description: calles method from QuoteService.cls class that creates quote
     */
   @AuraEnabled
   public static SF_Quote__c createQuote(Id opportunityId){
      SF_Quote__c quote= SF_QuoteService.getInstance().createQuote(opportunityId);
      return quote;
   }

    /*
     * @author: paata gvichia
     * @description: calles method from QuoteService.cls that accepts  quote 
     * @param: quoteId - id of quote that should be accepted
     */
    @AuraEnabled
    public static void acceptQuote(Id quoteId){
      SF_QuoteService.getInstance().acceptQuote(quoteId);
    }

    /*
     * @author: paata gvichia
     * @description: calles method from QuoteService.cls that clones  quote 
     * @param: quoteId - id of quote that should be cloned. cloneQLI - clone QLI if user whants
     */
    @AuraEnabled
    public static SF_Quote__c cloneQuote(Id quoteId,Boolean cloneQLI){
      SF_Quote__c clonedQuote= SF_QuoteService.getInstance().cloneQuote(quoteId,cloneQLI);
      return clonedQuote;
     }
}