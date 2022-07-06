/*
* ============================================
* @TestClass: SF_CreateInvoiceBatchTest.apxc
* @ApexClassName: SF_CountInvoice.apxt
* @description: Trigger class that invokes when invoice is created
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/


trigger SF_CountInvoice on SF_Invoice__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        SF_CountInvoiceHelper.countInvoice(Trigger.New);
    }
}