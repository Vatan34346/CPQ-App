public class SF_CacheHandler {

    public  List<Quote_line_item__mdt> cachedLabels {
        private set{
          cachedLabels=  cacheMetaDataLabels();
        } 
        get{
            if(cachedLabels==null||cachedLabels.isEmpty()){
                cachedLabels= cacheMetaDataLabels();
            }
            return cachedLabels;
        }
    }
    public  List<Product__mdt> cachedInMemoryProducts {private set; get;}

    public SF_CacheHandler() {
        this.cachedInMemoryProducts=cacheProducts();
    }

    private List<Quote_line_item__mdt> cacheMetaDataLabels(){
        List<Quote_line_item__mdt> metaDataLabels = [SELECT Description__c FROM Quote_line_item__mdt  WHERE Label = 'Object fields for LWC'];
        Cache.Org.put('local.SfQliCache.qliFieldName', metaDataLabels);
        return (List<Quote_line_item__mdt>)Cache.Org.get('local.SfQliCache.qliFieldName');
    }

    private List<Product__mdt> cacheProducts(){
        List<Product__mdt> mtdProducts = [SELECT Account__c, PriceList__c, Products__c FROM Product__mdt WHERE Is_Active__c=true];
        Cache.Org.put('local.SfQliCache.inMemoryProducts',mtdProducts);
        return (List<Product__mdt>)Cache.Org.get('local.SfQliCache.inMemoryProducts');
    }
}
