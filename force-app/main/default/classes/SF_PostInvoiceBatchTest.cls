/*
* ============================================
* @ApexClassName: SF_CreateInvoiceBatchTest.apx
* @description: Batch Class that tests if invoice is updated
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

@isTest
public class SF_PostInvoiceBatchTest {
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is getting data ready for executing batch class
    */
	@TestSetup
    static void createData(){
        SF_Price_List__c pl = new SF_Price_List__c();
        insert pl;
        Account acc = new Account(Name='Mamuka Bigvava', SF_Price_list__c = pl.Id, SF_Account_Location_Address__c='Georgia');
        insert acc;
        SF_Invoice__c invoice = new SF_Invoice__c(Status__c = 'Draft', Account__c = acc.Id, Invoice_Date__c = system.today());
        insert invoice;
    }
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is testing that did the batch update invoice
    */
    @isTest
    static void updateInvoice(){
        
        Test.startTest();
        Id invoiceBatch = Database.executeBatch(new SF_PostInvoiceBatch(), 200);
        Test.stopTest();
        
        AsyncApexJob aaj = [SELECT Status FROM AsyncApexJob WHERE Id =: invoiceBatch];
        System.assertEquals('Completed', aaj.Status , 'SOMETHING WENT WRONG');
        
        SF_Invoice__c testInvoice = [SELECT Name, Status__c, Invoice_Date__c, Invoice_Posted_Date__c FROM SF_Invoice__c];
        System.assertEquals('Posted', testInvoice.Status__c, 'Invoice was not updated');
        
    }
}