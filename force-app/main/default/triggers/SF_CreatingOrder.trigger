/*
* ============================================
* @TestClass: none
* @ApexClassName: SF_CreatingOrder.apxt
* @description: Trigger that invokes when Quote is accepted
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

trigger SF_CreatingOrder on SF_Quote__c (after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        List<Id> quoteIds = new List<Id>();
        for(SF_Quote__c quote : Trigger.new){
            
            SF_Quote__c quoteStatus = Trigger.oldMap.get(quote.Id);
            if(quoteStatus.Status__c != 'Accepted' && quote.Status__c == 'Accepted'){
                quoteIds.add(quote.Id);
            }
        }
        if(!quoteIds.isEmpty()){
			SF_CreatingOrderHelper.createOrder(quoteIds);
		}
    }
}