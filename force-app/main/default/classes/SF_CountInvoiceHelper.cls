/*
* ============================================
* @TestClass: SF_CreateInvoiceBatchTest.apxc
* @ApexClassName: SF_CountInvoiceHelper.apx
* @description: Class that invokes when invoice is created
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/


public class SF_CountInvoiceHelper{
    /*
    * @author: Mamuka Bigvava
    * @description: Method that counts invoices
    */
    public static void countInvoice(List<SF_Invoice__c> invoice){
        Map<Id, List<SF_Invoice__c>> oMap = new Map<Id, List<SF_Invoice__c>>();
        List<SF_Order__c> orders = new List<SF_Order__c>();
        
        for(SF_Invoice__c inv : invoice){
            if(oMap.containsKey(inv.SF_Order__c)){
                oMap.get(inv.SF_Order__c).add(inv);
            }else{
                oMap.put(inv.SF_Order__c, new List<SF_Invoice__c>{inv});
            }
        }
        
        for(Id order: oMap.keySet()){
                SF_Order__c ord = new SF_Order__c (
                    Id = order,
                    Number_of_Invoices__c = oMap.get(order).size()
                );
                orders.add(ord);
        }
        Database.update(orders);
		
    }
}