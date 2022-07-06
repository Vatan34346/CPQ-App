/*
* ============================================
* @TestClass: SF_CreateInvoiceBatchTest.apxc
* @ApexClassName: SF_CreateInvoiceBatch.apx
* @description: Batch Class that creates invoice with status draft
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

public class SF_CreateInvoiceBatch implements Database.Batchable<sObject>, Schedulable {
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is querrying for the orders
    */
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,
                                         Name, Opportunity__r.Name, Account__c, Contact__c, Number_of_Invoices__c, CurrencyIsoCode, Order_amount__c, Status__c, Order_Start_Date__c
                                         FROM SF_Order__c WHERE Active__c = true AND Number_of_Invoices__c = 0]);
    }
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that creates invoice and gives default parameters
    */
    public void execute(Database.BatchableContext bc, List<SF_Order__c> orders){  
        
        
        List<SF_Invoice__c> invoices = new List<SF_Invoice__c>();
        final Map<Id, SF_Invoice__c> iMap = new Map<Id, SF_Invoice__c>();
        for(SF_Order__c order : orders){ 
            SF_Invoice__c invoice = new SF_Invoice__c(Account__c = order.Account__c, 
                                                      CurrencyIsoCode = order.CurrencyIsoCode,
                                                      SF_Order__c = order.Id,
                                                      Opportunity_Name__c = order.Opportunity__r.Name,
                                                      Invoice_Date__c = order.Order_Start_Date__c,
                                                      Status__c = 'Draft');
            invoices.add(invoice);
            iMap.put(order.id, invoice);
        }
        insert invoices;
        
        List<SF_Order_Product__c> orderProducts = [SELECT Id, Product__c, SF_Order__c, SF_PriceList__c, Quantity__c, Start_Date__c, End_Date__c FROM SF_Order_Product__c WHERE SF_Order__c IN: orders];
        List<SF_Invoice_Line__c> invoiceLines = new List<SF_Invoice_Line__c>();    
        for(SF_Order_Product__c op : orderProducts){
            SF_Invoice__c invoice = iMap.get(op.SF_Order__c);
            SF_Invoice_Line__c invoiceLine = new SF_Invoice_Line__c(SF_Order_Product__c = op.Id, 
                                                                    SF_Invoice__c = invoice.Id,
                                                                    Start_Date__c = op.Start_Date__c, 
                                                                    End_Date__c = op.End_Date__c,
                                                                    Product__c = op.Product__c,
                                                                    Status__c = 'Draft');
            invoiceLines.add(invoiceLine);
        }
        insert invoiceLines;
    }
    
    public void finish(Database.BatchableContext bc){        
        
    }
    
    
    /*
    * @author: Mamuka Bigvava
    * @description: Schedulable context method that executes batch class 
    */
    public void execute(SchedulableContext ct){
        Database.executeBatch(new SF_CreateInvoiceBatch());
    }
    
}