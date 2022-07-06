/*
* ============================================
* @TestClass: SF_PostInvoiceBatchTest.apxc
* @ApexClassName: SF_PostInvoiceBatch.apx
* @description: Class that changes invoice status from Draft to Posted
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/


public class SF_PostInvoiceBatch implements Database.Batchable<sObject>, Schedulable  {
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is querrying for the invoices
    */
	public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id, Name FROM SF_Invoice__c WHERE Invoice_Date__c <=: system.today() + 1 OR Status__c = 'Draft']);
    }
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is updating invoice status and posted date
    */
    public void execute(Database.BatchableContext bc, List<SF_Invoice__c> invoices){  
        for(SF_Invoice__c invoice : invoices){
            invoice.Invoice_Posted_Date__c = system.today();
            invoice.Status__c = 'Posted';
        }
        update invoices;
        
    }
    
    public void finish(Database.BatchableContext bc){        
        
    }
    
    /*
    * @author: Mamuka Bigvava
    * @description: Schedulable context method that executes batch class 
    */
    public void execute(SchedulableContext ct){
        Database.executeBatch(new SF_PostInvoiceBatch());
    }
    
}