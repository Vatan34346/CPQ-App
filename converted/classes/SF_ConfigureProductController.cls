/*
* ============================================
* @ApexClassName: SF_ConfigureProductController.apxc
* @description: Configure product controller
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/

public with sharing class SF_ConfigureProductController {
    
    /*
* @author: Mamuka Bigvava
* @description: Apex method that is getting products
*/
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductList(Id quoteId){
        List<SF_Quote__c> priceList = [SELECT Name, SF_Price_List__c FROM SF_Quote__c WHERE Id=:quoteId];
        List<SF_Price_List_Item__c> priceListItems = [SELECT Product__c, Base_Price__c FROM SF_Price_List_Item__c WHERE SF_Price_List__c =:priceList[0].SF_Price_List__c AND Active__c = true];       
        List<Id> productIds = new List<Id>();
        for(SF_Price_List_Item__c pli : priceListItems){
            productIds.add(pli.Product__c);
        }
        List<Product2> product = [SELECT Name, SF_Is_Bundle__c,
                                  (SELECT Id, Name FROM Option__r),
                                  (SELECT Id, Base_Price__c FROM SF_Price_List_Items__r WHERE Product__c IN: productIds AND Active__c = true)
                                  FROM Product2 WHERE Id IN: productIds];
        return product;
    }
    
    
    /*
* @author: Mamuka Bigvava
* @description: Apex method that is getting quote line items with its fields
*/
    @AuraEnabled(cacheable=true)
    public static String getQLIs(Id qId){
        List<Quote_line_item__mdt> configFields = [SELECT Description__c FROM Quote_line_item__mdt WHERE Label = 'Object fields for LWC'];
        List<String> configList = configFields[0].Description__c.split(',');
        String labels = String.join(configList,',');
        
        List<SF_Quote__c> priceList = [SELECT Name, SF_Price_List__c FROM SF_Quote__c WHERE Id=:qId];
        List<SF_Price_List_Item__c> priceListItems = [SELECT Product__c, Base_Price__c FROM SF_Price_List_Item__c WHERE Active__c = true];
        List<Id> productIds = new List<Id>();
        for(SF_Price_List_Item__c pli : priceListItems){
            productIds.add(pli.Product__c);
        }
        
        
        List<Product2> products = [SELECT Id, Name, SF_Is_Bundle__c,
                                   (SELECT Id, Name FROM Option__r),
                                   (SELECT Id, Base_Price__c FROM SF_Price_List_Items__r WHERE Product__c IN: productIds AND Active__c = true)
                                   FROM Product2 WHERE Id IN: productIds];
        
        
        Id productId = products[0].Id;
        List<SF_Quote_Line_Item__c> qlis = new  List<SF_Quote_Line_Item__c>();
        String fields = 'SELECT ' + labels + ' FROM SF_Quote_Line_Item__c WHERE SF_Quote__c =: qId';
        System.debug(fields + ' FIELDS');
        qlis = Database.query(fields);
        System.debug(qlis + 'QLIS');
        Wrapper wrapper = new Wrapper(qlis ,products);
        
        return JSON.serialize(wrapper);
    }
    
    public class Wrapper{
        public List<Product2> product  { get; set;}
        public List<SF_Quote_Line_Item__c> qli  { get; set;}
        
        public Wrapper(List<SF_Quote_Line_Item__c> qli, List<Product2> product){
            this.product = product;
            this.qli = qli;
        }
    }
    
    
    
    /*
* @author: Mamuka Bigvava
* @description: Apex method that is  getting quote line items fields
*/
    @AuraEnabled(cacheable=true)
    public static List<String> getQuoteLineItemFieldNames(){
        List<Quote_line_item__mdt> metaDataLabels = [SELECT Description__c FROM Quote_line_item__mdt  WHERE Label = 'Object fields for LWC'];
        List<String> labels = metaDataLabels[0].Description__c.split(',');
        Set<String> setLables = new Set<String>();
        setLables.addAll(labels);
        
        String ObjectApi = 'SF_Quote_Line_Item__c';
        
        List<String> labelList = new List<String>();
        
        for(String item : setLables){
            String label =(String)Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(item).getDescribe().getLabel();
            if(label!='Currency Iso Code')
                labelList.add(label);
        }
        return labelList;
    }
}