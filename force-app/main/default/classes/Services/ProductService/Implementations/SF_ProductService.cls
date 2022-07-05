public class SF_ProductService implements SF_IProductService {
   
    private static SF_ProductService productInstance=null;

     //logic for singleton to call methods in Controller
    private SF_ProductService(){}

    public static SF_ProductService getInstance(){
        if(productInstance==null){
            productInstance=new SF_ProductService();
        }
        return productInstance;
    }



    public  List<ProductWrapper> getProductList(Id quoteId){
        List<SF_Quote__c> quote = [SELECT SF_Price_List__c FROM SF_Quote__c WHERE Id=:quoteId];
        List<SF_Price_List_Item__c> plis = [SELECT Product__c, Base_Price__c, CurrencyIsoCode 
                                            FROM SF_Price_List_Item__c 
                                            WHERE SF_Price_List__c=:quote[0].SF_Price_List__c AND Active__c=true];
        

        Map<ID, SF_Price_List_Item__c> pliMap = new Map<ID, SF_Price_List_Item__c>();
        for (SF_Price_List_Item__c pli : plis) {
            pliMap.put(pli.Product__c, pli);
        }

        List<Product2> products = [SELECT Id, Name, SF_Optional__c, SF_Is_Bundle__c,SF_Products__c FROM Product2 WHERE Id IN :pliMap.keySet()];
        
        List<ProductWrapper> allProducts = new List<ProductWrapper>();
        for(Product2 pr : products){
            allProducts.add(new ProductWrapper(pr, pliMap.get(pr.Id)));
        }
        
        return allProducts;
    }

}
