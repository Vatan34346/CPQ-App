public with sharing class SF_ProductController {
 
    @AuraEnabled(cacheable=true)
    public static List<ProductWrapper> getProductList(Id quoteId) {
        List<ProductWrapper> productList= SF_ProductService.getInstance().getProductList(quoteId);
        System.debug(productList + 'nothing');
        return productList;
    }
}
