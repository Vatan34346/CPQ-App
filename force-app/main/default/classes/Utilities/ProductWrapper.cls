public class ProductWrapper {
    public Decimal basePrice { get; set; }
    public String productName { get; set; }
    public String currencyIsoCode { get; set; }
    public Boolean isBundle { get; set; }
    
    public ProductWrapper(Product2 product, SF_Price_List_Item__c productListItem){
        this.productName = product.Name;
        this.isBundle = product.SF_Is_Bundle__c;
        if(productListItem != null){                
            this.basePrice = productListItem.Base_Price__c;
            this.currencyIsoCode = productListItem.CurrencyIsoCode;
        }
    }     
}