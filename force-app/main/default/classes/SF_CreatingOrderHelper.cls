/*
* ============================================
* @TestClass: SF_CreatingOrderHelperTest.apxc
* @ApexClassName: SF_CreatingOrderHelper.apx
* @description: Class that invokes when the trigger meets requirements
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

public class SF_CreatingOrderHelper {
    /*
    * @author: Mamuka Bigvava
    * @description: Future method that is creating order when quote is accepted
    */
    @future
    public static void createOrder(List<Id> quoteIds){
        
        final List<SF_Order__c> newOrderList = new List<SF_Order__c>();
        final List<SF_Order_Product__c> orderProductList = new List<SF_Order_Product__c>();
        final Map<ID, SF_Order__c> qoMap = new Map<ID, SF_Order__c>();
        
        List<SF_Quote__c> quotes = [SELECT Id, Account__c, Contact__c, SF_Billing_Country__c, SF_Billing_Postal_Code__c,
                                    Opportunity__c, SF_Billing_State__c, SF_Billing_Street__c, Number_of_Line_Items__c,
                                    SF_Shipping_Country__c, SF_Shipping_Postal_Code__c,
                                    (SELECT Id,  Name, Quantity__c, Product__c,
                                     SF_Price_List_Item__c, Total_Price__c, Unit_Price__c 
                                     FROM SF_Quote_Line_Items__r)
                                    FROM SF_Quote__c WHERE Id IN: quoteIds];
        
        
        
        for(SF_Quote__c quote : quotes){
            SF_Order__c order = new SF_Order__c(Account__c = quote.Account__C,
                                                Quote__c = quote.Id,
                                                Contact__c = quote.Contact__c,
                                                Billing_Country__c = quote.SF_Billing_Country__c,
                                                Billing_Postal_Code__c = quote.SF_Billing_Postal_Code__c,
                                                Activated_Date__c = system.TODAY(),
                                                Opportunity__c = quote.Opportunity__c,
                                                Active__c = true,
                                                Number_of_Order_Products__c = quote.Number_of_Line_Items__c,
                                                Order_Start_Date__c = system.today(),
                                                Order_End_Date__c = system.today() + 30,
                                                Billing_State__c = quote.SF_Billing_State__c,
                                                Billing_Street__c = quote.SF_Billing_Street__c,
                                                Shipping_Country__c = quote.SF_Shipping_Country__c,
                                                Shipping_Postal_Code__c = quote.SF_Shipping_Postal_Code__c,
                                                Status__c = 'Activated');
            newOrderList.add(order);
            qoMap.put(quote.Id, order);
        }
        insert newOrderList;
        
        
        for(SF_Quote__c quote : quotes){
            
            SF_Order__c order = qoMap.get(quote.Id);
            
            if(quote.SF_Quote_Line_Items__r != null && !quote.SF_Quote_Line_Items__r.isEmpty()){
                
                for(SF_Quote_Line_Item__c qli : quote.SF_Quote_Line_Items__r){
                    SF_Order_Product__c newOrderProduct = new SF_Order_Product__c(SF_Order__c = order.Id, 
                                                                                  Product__c = qli.Product__c, 
                                                                                  Quantity__c = qli.Quantity__c,
                                                                                  SF_Quote_Line_Item__c = qli.Id,
                                                                                  Start_Date__c = order.Order_Start_Date__c,
                                                                                  End_Date__c = order.Order_End_Date__c,
                                                                                  Total_Price__c = qli.Total_Price__c,
                                                                                  Unit_Price__c = qli.Unit_Price__c,
                                                                                  Status__c = 'Activated');
                    orderProductList.add(newOrderProduct);
                }
            }   
        }        
        insert orderProductList;        
    }
}