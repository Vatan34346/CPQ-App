/*
* ============================================
* @ApexClassName: SF_CreateInvoiceBatchTest.apx
* @description: Batch Class that tests if invoice is created
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

@isTest
public class SF_CreateInvoiceBatchTest {
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is getting data ready for executing batch class
    */
    @TestSetup
    static void createData(){
        Contact contact = new Contact(LastName='Bigvava');
        insert contact;
        Product2 prod = new Product2(Name='Gamepad');
        insert prod;
        SF_Price_List__c pl = new SF_Price_List__c(Name='USD Price List');
        insert pl;
        SF_Price_List_Item__c pli = new SF_Price_List_Item__c(Base_Price__c=25, SF_Price_List__c=pl.Id, Product__c=prod.Id);
        insert pli;
        Account acc = new Account(Name='Mamuka Bigvava', SF_Shipping_Street__c='315 Tsotne Dadiani Street', SF_Shipping_Postal_Code__c='0180', SF_Billing_Street__c = 'Avenida da Liberdade', SF_Billing_Postal_Code__c='1250-096', SF_Price_list__c = pl.Id, SF_Account_Location_Address__c='Georgia');
        insert acc;
        Opportunity opp = new Opportunity(Name='Test Opp',  AccountId=acc.Id,CloseDate=system.today()+30, StageName='Prospecting', SF_Price_list__c=pl.Id);
        insert opp;
        SF_Quote__c quote = new SF_Quote__c(Name='Test Quote', SF_Price_List__c=pl.Id, SF_Shipping_Country__c = 'Georgia', SF_Shipping_State__c='Georgia', SF_Shipping_Street__c='315 Tsotne Dadiani Street', SF_Shipping_Postal_Code__c='0180', SF_Billing_Country__c='Portugal', SF_Billing_State__c='Portugal', SF_Billing_Street__c='Avenida da Liberdade', SF_Billing_Postal_Code__c='1250-096', Account__c=acc.Id, Contact__c = contact.Id, Opportunity__c=opp.Id,Primary__c=true, Expiration_Date__c=system.today()+30, Status__c='Draft', CurrencyIsoCode='USD');
        insert quote;
        SF_Quote_Line_Item__c qli = new SF_Quote_Line_Item__c(Name='Gamepad', SF_Quote__c=quote.Id,Product__c=prod.Id);
        insert qli;
        
    }
    
    /*
    * @author: Mamuka Bigvava
    * @description: Method that is testing that did the batch create invoice
    */
	@isTest
    static void createInvoice(){
        SF_Quote__c testQuote = [SELECT Id, Status__c, Name FROM SF_Quote__c WHERE Status__c = 'Draft'];
        testQuote.Status__c = 'Accepted';
        update testQuote;
        
        Test.startTest();
        Id invoiceBatch = Database.executeBatch(new SF_CreateInvoiceBatch());
        Test.stopTest();
        
        AsyncApexJob aaj = [SELECT Status FROM AsyncApexJob WHERE Id =: invoiceBatch];
        System.assertEquals('Completed', aaj.Status , 'SOMETHING WENT WRONG');
        
        List<SF_Invoice__c> invoice = [SELECT Id FROM SF_Invoice__c];
        System.assertEquals(false, invoice.isEmpty(), 'Invoice was not created');
        
        List<SF_Invoice_Line__c> invoiceLine = [SELECT Id FROM SF_Invoice_Line__c WHERE SF_Invoice__c =: invoice[0].Id];
        System.assertEquals(false, invoiceLine.isEmpty(), 'Invoice LINE was not created');
        
    }
}