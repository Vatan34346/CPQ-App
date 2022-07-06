/*
* ============================================
* @TestClass: SF_QuoteTriggerHelperTest.apxc
* @ApexClassName: QuoteTriggerHelper.apxc
* @description: Class that contains creating quote line item logic
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

public class QuoteTriggerHelper {
    
     /*
     * @author: Mamuka Bigvava
     * @description: Method that is setting default values for quote line item
     */
    public static void settingQLIValues(List<SF_Quote_Line_Item__c> qli){
        if(qli != null){
            List<Product2> products = [SELECT Id, Name, Description, SF_Is_Bundle__c 
                                       FROM Product2 WHERE Id =:qli[0].Product__c];
            
            List<SF_Price_List_Item__c> priceListItems = [SELECT Id, Base_Price__c 
                                                          FROM SF_Price_List_Item__c 
                                                          WHERE Id =:qli[0].SF_Price_List_Item__c];
            
            for(SF_Quote_Line_Item__c qlis : qli) {
                qlis.Name = products[0].Name;
                qlis.Line_Item_Description__c = products[0].Description;
                qlis.IsBundle__c = products[0].SF_Is_Bundle__c;
                qlis.List_Price__c = priceListItems[0].Base_Price__c;
                qlis.Unit_Price__c = priceListItems[0].Base_Price__c;
                qlis.Quantity__c = 1;
            }
        }
    }
}