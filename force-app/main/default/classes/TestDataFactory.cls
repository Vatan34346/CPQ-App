/*
* ============================================
* @apexClassName: TestDataFactory.cls
* @description: class fro creating data;
* @author: paata gvichia
* @email: paatagvichia@gmail.com
* @dateCreated: 05/30/2022
* ============================================
*/
public abstract class TestDataFactory {

    // create account
    public static Account createAccount(){
        Account acc = new Account(
            Name = 'TestName',
            SF_Account_Location_Address__c = 'United States',
            CurrencyIsoCode = 'USD'
        );
        return acc;
    }
   
}