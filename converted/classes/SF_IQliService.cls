public interface SF_IQliService {
    SF_QliWrapper getQLIs(Id quoteId);
    List<SF_Quote_Line_Item__c> getOptions(Id qliId);
    List<String> getQuoteLineItemFieldNames();
}
