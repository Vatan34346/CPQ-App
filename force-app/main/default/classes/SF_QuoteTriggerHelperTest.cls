/*
* ============================================
* @ApexClassName: SF_QuoteTriggerHelperTest.apxc
* @description: Quote trigger helper test
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

@isTest
public class SF_QuoteTriggerHelperTest {
	@TestSetup
    static void makeData(){
        Account testAcc = new Account(
            Name = 'Testin account',
            SF_Account_Location_Address__c = 'United Kingdom',
            CurrencyIsoCode = 'USD'
        );
        insert testAcc;

        Opportunity testOpp = new Opportunity(
            Name = 'TestOpp',
            AccountId = testAcc.Id,
            StageName = 'Prospecting',
            CloseDate = System.today().addDays(7),
            CurrencyIsoCode = 'USD'
        );
        insert testOpp; 

        Contact testCon = new Contact(
            Salutation = 'Mr.',
            Primary__c = true,
            LastName = 'TestCon',
            AccountId = testAcc.Id,
            CurrencyIsoCode = 'USD'
        );
        insert testCon; 

        SF_Quote__c testQuote = new SF_Quote__c(
            Name = 'TestQuote',
            Account__c = testAcc.Id,
            Opportunity__c = testOpp.Id,
            Contact__c = testCon.Id,
            Expiration_Date__c = System.today().addDays(7)
        );
        insert testQuote;
        
        Product2 testProduct = new Product2(Name='Testing products', SF_Is_Bundle__c=true);
        insert testProduct;
        SF_Price_List__c pl = new SF_Price_List__c(Name='USD Price List'); 
        insert pl;
        SF_Price_List_Item__c pli = new SF_Price_List_Item__c(Base_price__c = 23, SF_Price_List__c = pl.Id, Product__c = testproduct.Id);
        insert pli;
        
        
    }
    
    /*
     * @author: Mamuka Bigvava
     * @description: Apex method that is testing values for quote line item
     */
    
    @isTest
    static void settingQLIValuesTest(){
        List<Account> testAcc = [SELECT Id FROM Account WHERE Name ='Testin account'];
        List<SF_Quote__c> testQuote = [SELECT Id FROM SF_Quote__c WHERE Account__c =:testAcc[0].Id];
        List<Product2> testProduct = [SELECT Id, Name, SF_Is_Bundle__c FROM Product2 WHERE Name ='Testing products'];
        List<SF_Price_List__c> testPriceList = [SELECT Id FROM SF_Price_List__c WHERE Name ='USD Price List'];
        List<SF_Price_List_Item__c> testPLI = [SELECT Id, Base_Price__c FROM SF_Price_List_Item__c 
                                                WHERE SF_Price_List__c =:testPriceList[0].Id AND Product__c =:testProduct[0].Id];
        
        
        SF_Quote_Line_Item__c qli = new SF_Quote_Line_Item__c(Name = 'Test QLI',
                                                              Product__c = testProduct[0].Id,
                                                              SF_Price_List_Item__c = testPli[0].Id,
                                                             SF_Quote__c = testQuote[0].Id);
        
        Test.startTest();
        insert qli;
        Test.stopTest();
        
       List<SF_Quote_Line_Item__c> testQLI2 = [SELECT Id FROM SF_Quote_Line_Item__c 
                                                WHERE Name ='Testing products'];
        
        
        System.assert(testQLI2.size() > 0, 'Quote Line Item was not created!');
    }
}