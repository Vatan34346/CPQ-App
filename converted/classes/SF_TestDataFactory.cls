/*
* ============================================
* @apexClassName: TestDataFactory.cls
* @description: class fro creating data;
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @dateCreated: 05/30/2022
* ============================================
*/
public abstract class SF_TestDataFactory {

    // create account
    public static Account createAccount(){
        Account acc = new Account(
            Name = 'TestName',
            SF_Account_Location_Address__c = 'United States',
            CurrencyIsoCode = 'USD',
            SF_Price_list__c='a008a00000vjqEQAAY'
        );
        return acc;
    }

    //create opportunity
    public static Opportunity createOpportunity(Id accountId){
        Opportunity opportunity=   new Opportunity(
            Name = 'opportunityTest',
            AccountId = accountId,
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            CurrencyIsoCode = 'USD'
        );
        return opportunity;
    }

   //create contact
   public static Contact createContact(Id accountId){
    Contact contact = new Contact(
        Salutation = 'Mr.',
        Primary__c = true,
        LastName = 'contactTest',
        AccountId = accountId,
        CurrencyIsoCode = 'USD'
    );
    return contact;
   }

   //create quote
   public static SF_Quote__c createQuote(Opportunity opportunity,Contact contact){
    SF_Quote__c  quote = new SF_Quote__c(
        Opportunity__c = opportunity.Id,
        Account__c = opportunity.AccountId,
        Expiration_Date__c=System.today().addDays(7),
        Contact__c=contact.Id,
        SF_Price_List__c = opportunity.SF_Price_List__c,
        Status__c = 'Draft'
    );   
    return quote;
   }

   //create quote line item
   public static SF_Quote_Line_Item__c createQuoteLineItem (Id quoteId){
    SF_Quote_Line_Item__c qli = new SF_Quote_Line_Item__c(
        SF_Quote__c=quoteId,
        Name='TEST QLI',
        Line_Item_Description__c='TESTING',
        IsBundle__c=true,
        List_Price__c=16.2,
        Unit_Price__c=12.3
    );
    return qli;
   }

}
