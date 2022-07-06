/*
* ============================================
* @apexClassName: SF_QuoteTriggerTest.cls
* @description: test SF_TriggerHelper.cls;
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @dateCreated: 06/06/2022
* ============================================
*/
@isTest
public class SF_QuoteTriggerTest {

    @TestSetup
    static void makeData(){
        Account account = SF_TestDataFactory.createAccount();
        insert account;

        Opportunity opportunity = SF_TestDataFactory.createOpportunity(account.Id);
        insert opportunity;  

        Contact contact = SF_TestDataFactory.createContact(account.Id);
        insert contact;

        SF_Quote__c quote =SF_TestDataFactory.createQuote(opportunity,contact);
        insert quote;

        SF_Quote__c quote1 =SF_TestDataFactory.createQuote(opportunity,contact);
        insert quote1;
    }

    //@author: paata gvichia
    //@email: paatagvichia@gmail.com
    //@dateCreated: 06/06/2022
    //DEscription: test case when inserted quote is single
    @isTest
    static void TestProcessQuoteTrigger_QuoteIsSingle(){
        List<Opportunity> opportunity = [SELECT Id,AccountId,SF_Price_List__c FROM Opportunity WHERE Name ='opportunityTest' LIMIT 1];  
        List<Contact> contact = [SELECT Id FROM Contact WHERE LastName ='contactTest' LIMIT 1];  
              
        SF_Quote__c  quote = new SF_Quote__c(
            Opportunity__c = opportunity[0].Id,
            Account__c = opportunity[0].AccountId,
            Expiration_Date__c=System.today().addDays(7),
            Contact__c=contact[0].Id,
            SF_Price_List__c = opportunity[0].SF_Price_List__c,
            Status__c = 'Draft'
        );   

        Test.startTest();
        insert quote;  
        Test.stopTest();

   

        List<SF_Quote__c> singlePrimaryQuote = [SELECT Id,Primary__c FROM SF_Quote__c WHERE Primary__c =true LIMIT 1]; 
        system.assertEquals(singlePrimaryQuote[0].Primary__c==true, singlePrimaryQuote[0].Primary__c,'created quote is not Primary');
    }
  
    //@author: paata gvichia
    //@email: paatagvichia@gmail.com
    //@dateCreated: 06/06/2022
    //DEscription: test case when trying to uncheck Primary quote
    @isTest
    static void TestProcessQuoteTrigger_UpdatePrimaryField_PrimaryIsFalse(){
        List<Opportunity> opportunity = [SELECT Id,AccountId,SF_Price_List__c FROM Opportunity WHERE Name ='opportunityTest' LIMIT 1];  
        List<SF_Quote__c> quote = [SELECT Id FROM SF_Quote__c WHERE Opportunity__c =:opportunity[0].Id];
                

        quote[0].Primary__c=false;
        try {
            Test.startTest();
            update quote;
            Test.stopTest();
        } catch (Exception ex) {
            Boolean isError =  ex.getMessage().contains('You can not uncheck Primary field. At least one Quote should be primary')? true : false;
            system.assertEquals(true, isError,'single primary could not be updated to non primary');
        }
    
    }

    //@author: paata gvichia
    //@email: paatagvichia@gmail.com
    //@dateCreated: 06/06/2022
    //DEscription: test case when trying to update  non Primary quote to Primary
    @isTest
    static void TestUpsertQuoteMethod_UpdatePrimaryField_PrimaryIsTrue(){
        List<Opportunity> opportunity = [SELECT Id,AccountId,SF_Price_List__c FROM Opportunity WHERE Name ='opportunityTest' LIMIT 1];  
        List<SF_Quote__c> quote = [SELECT Id FROM SF_Quote__c WHERE Opportunity__c =:opportunity[0].Id AND Primary__c=false];     
       

        quote[0].Primary__c=true;
        Test.startTest();
        update quote;
        Test.stopTest();  


        Integer numberOfPrimaryQuotes=[SELECT COUNT() FROM SF_Quote__c WHERE Opportunity__c =:opportunity[0].Id AND Primary__c=true];
        System.assertEquals(1, numberOfPrimaryQuotes,'Only one Primal quote per oportunitu');  
    }

    //@author: paata gvichia
    //@email: paatagvichia@gmail.com
    //@dateCreated: 06/06/2022
    //DEscription: test case when trying to delete Primary quote
    @isTest
    static void TestDeleteQuoteMethod(){
        List<Opportunity> opportunity = [SELECT Id,AccountId,SF_Price_List__c FROM Opportunity WHERE Name ='opportunityTest' LIMIT 1];  
        List<Contact> contact = [SELECT Id FROM Contact WHERE LastName ='contactTest' LIMIT 1];  
        List<SF_Quote__c> quote = [SELECT Id FROM SF_Quote__c WHERE Opportunity__c =:opportunity[0].Id];

        try {
            Test.startTest();
            delete quote;
            Test.stopTest();
        } catch (Exception ex) {
            Boolean isError =  ex.getMessage().contains('Cant delete Primary quote. Please select another quote as Primery and then delete this one') ? true : false;
            System.assertEquals(isError, false,'Single Primary quote cant be deleted');
        }
    }
}
