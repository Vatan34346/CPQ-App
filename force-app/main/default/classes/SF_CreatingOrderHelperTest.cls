@isTest
public class SF_CreatingOrderHelperTest {
    @TestSetup
    static void makeData(){
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
    
    @isTest
    static void createOrderTest(){
        
        Account testAcc = [SELECT Id, Name, SF_Shipping_Street__c,  SF_Shipping_Postal_Code__c, SF_Billing_Street__c, SF_Billing_Postal_Code__c FROM Account WHERE Name='Mamuka Bigvava'];
        Contact testCon = [SELECT Id FROM Contact];
        SF_Price_List__c pl = [SELECT Id FROM SF_Price_List__c];
        Opportunity testOpp = [SELECT Id, Name, AccountId, CloseDate, StageName, SF_Price_list__c FROM Opportunity WHERE Name='Test Opp'];
        SF_Quote__c testQuote = [SELECT Id, Name, SF_Shipping_Country__c, SF_Shipping_State__c, SF_Shipping_Street__c, SF_Shipping_Postal_Code__c, SF_Billing_Country__c, SF_Billing_State__c, SF_Billing_Street__c, SF_Billing_Postal_Code__c, Status__c FROM SF_Quote__c WHERE Opportunity__c=:testOpp.Id];
        SF_Quote_Line_Item__c testQli = [SELECT Name, SF_Quote__c, Product__c FROM SF_Quote_Line_Item__c WHERE Name='Gamepad'];
        
        testQuote.Account__c = testAcc.Id;
        testQuote.Contact__c = testCon.Id;
        testQuote.Expiration_Date__c = system.today() + 30;
        testQuote.SF_Billing_Country__c = 'Portugal';
        testQuote.SF_Billing_Postal_Code__c = '1250-096';
        testQuote.SF_Billing_State__c = 'Portugal';
        testQuote.SF_Billing_Street__c = 'Avenida da Liberdade';
        testQuote.SF_Price_List__c = pl.Id;
        testQuote.SF_Shipping_Country__c = 'Georgia';
        testQuote.SF_Shipping_Postal_Code__c = '0180';
		testQuote.SF_Shipping_State__c = 'Georgia';
        testQuote.SF_Shipping_Street__c = '315 Tsotne Dadiani Street';
        testQuote.Primary__c = true;
        testQuote.Status__c = 'Accepted';
        Test.startTest();
        update testQuote;       
        Test.stopTest();
        Integer testOrder = [SELECT COUNT() FROM SF_Order__c WHERE Quote__c =: testQuote.Id];
        System.assert(testOrder > 0, 'Order wasnt created');
        
    }
}