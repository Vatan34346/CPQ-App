/*
* ============================================
* @apexClassName: SF_QuoteControllerTest.cls
* @description: class test QuuoteController.cls;
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @dateCreated: 05/25/2022
* ============================================
*/
@isTest
public with sharing class SF_QuoteControllerTest {
    //@description: Creates Testing Data.
    @TestSetup
    static void makeData(){
        Account account = SF_TestDataFactory.createAccount();
        insert account;

        Opportunity opportunity = SF_TestDataFactory.createOpportunity(account.Id);
        insert opportunity;  

        Contact contact = SF_TestDataFactory.createContact(account.Id);
        insert contact;

        SF_Quote__c  quote =SF_TestDataFactory.createQuote(opportunity,contact);
        insert quote;

        SF_Quote_Line_Item__c quoteLineItem = SF_TestDataFactory.createQuoteLineItem(quote.Id);
        insert quoteLineItem;
    }

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: tests creaateQuote method.
    @isTest
    static void createQuoteTest(){
        List<Opportunity> opportunity = [SELECT Id FROM Opportunity WHERE Name ='opportunityTest' LIMIT 1];   
        SF_Quote__c quote = SF_QuoteController.createQuote(opportunity[0].Id);
        System.assert(quote!=null, 'Quote was not created');
    }



    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: tests  cloneQuote method case when cloning of QLI is not ness.
    @isTest
    static void cloneQuoteTest_withoutQLIs(){
        List<SF_Quote__c> quotes =[SELECT Id FROM SF_Quote__c LIMIT 1];
        SF_Quote__c newQuote =SF_QuoteController.cloneQuote(quotes[0].Id, false);
        System.assert(newQuote!=null,'cant clone quote');
    }

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: tests  acceptQuote method 
    @isTest
    static void acceptQuoteTest(){
        List<SF_Quote__c> quotes =[SELECT Id,Status__c FROM SF_Quote__c LIMIT 1];
        SF_QuoteController.acceptQuote(quotes[0].Id);
  
        List<SF_Quote__c> quoteForAssertion =[SELECT Status__c FROM SF_Quote__c LIMIT 1];
        system.assert(quoteForAssertion[0].Status__c=='Accepted','quote statuse field did not update');
    }

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: tests  cloneQuote method case when cloning with QLI.
    @isTest
    static void cloneQuoteTest_withQLIs(){
        List<SF_Quote__c> quotes =[SELECT Id FROM SF_Quote__c LIMIT 1];
        SF_Quote__c newQuote =SF_QuoteController.cloneQuote(quotes[0].Id, true);// check if 2 

        List<SF_Quote_Line_Item__c> qli =[SELECT Id FROM SF_Quote_Line_Item__c WHERE SF_Quote__c=:newQuote.Id];
        System.assert(qli.size()>0,'cant clone quote with qli');
    }
}
