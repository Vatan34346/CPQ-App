// Interface that should be implemented by class that work with different quote data
//@author:paata gvichia
//@email:paatagvichia@gmail.com
//05/25/2022
public interface SF_IQuoteService {
   SF_Quote__c createQuote(Id opportunityId);
   SF_Quote__c cloneQuote(Id quoteId,Boolean qliIsNeeded);
   void acceptQuote(Id quoteId);
}