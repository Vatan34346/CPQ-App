/*
* ============================================
* @TestClass: SF_QuoteTriggerHelperTest.apxc
* @ApexClassName: SF_CreateQuoteLineItem.apxt
* @description: Trigger that invokes when Quote line item is created
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

trigger SF_CreateQuoteLineItem on SF_Quote_Line_Item__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        QuoteTriggerHelper.settingQLIValues(Trigger.new);
    }
}