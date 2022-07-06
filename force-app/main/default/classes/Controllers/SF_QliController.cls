public with sharing class SF_QliController {
   
    @AuraEnabled(cacheable=true)
    public static SF_QliWrapper getQli(Id quoteId){
      return SF_QliService.getInstance().getQLIs(quoteId);
    }

    @AuraEnabled
    public static void updateQuantity(Id qliId,Double quantity){
      SF_QliService.getInstance().updateQuantity(qliId, quantity);
    }
}