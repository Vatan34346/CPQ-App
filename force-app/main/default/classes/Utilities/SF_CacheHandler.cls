public class SF_CacheHandler {

    private static List<String> cachedLables;
    private static List<String> cachedTypes;
    private static final String objectApi ='SF_Quote_Line_Item__c';


    //properties
    public static List<String> labels {

        private set{
            cachedLables=cacheMetaDataLabels();
        }

        get{
            if(cachedLables==null||cachedLables.isEmpty())
                cachedLables=cacheMetaDataLabels();
            
            return cachedLables;
        }
    }
    public static List<String> types{

       private set{
        cachedTypes=cachedMetaDataTypes();
       }

       get{
        if(cachedTypes==null||cachedTypes.isEmpty())
            cachedTypes=cachedMetaDataTypes();
        
        return cachedTypes;
       }
    }
    public   List<Product__mdt> cachedInMemoryProducts {private set; get;}

    public SF_CacheHandler() {
        this.cachedInMemoryProducts=cacheProducts();
    }

    private static List<String> cachedMetaDataTypes(){
        Set<String> uniqFieldApis = getMetaDataFieldApis();
        List<String> typeList = new List<String>();
        
        for(String item : uniqFieldApis){
            String type =String.valueOf(Schema.getGlobalDescribe().get(objectApi).getDescribe().fields.getMap().get(item).getDescribe().getType());
            if(type!='PickList')
            typeList.add(type);
        }

        Cache.Org.put('local.SfQliCache.qliFieldTypes', typeList);
        return (List<String>)Cache.Org.get('local.SfQliCache.qliFieldTypes');
    }
    
    private  static List<String> cacheMetaDataLabels(){
        Set<String> uniqFieldApis = getMetaDataFieldApis();
        List<String> labelList = new List<String>();
        
        for(String item : uniqFieldApis){
            String label =(String)Schema.getGlobalDescribe().get(objectApi).getDescribe().fields.getMap().get(item).getDescribe().getLabel();
            if(label!='Currency Iso Code')
                labelList.add(label);
        }     
        Cache.Org.put('local.SfQliCache.qliFieldLabel', labelList);
        return (List<String>)Cache.Org.get('local.SfQliCache.qliFieldLabel');
    }

    private static Set<String> getMetaDataFieldApis(){
        List<Quote_line_item__mdt> metaDataLFieldApi = [SELECT Description__c FROM Quote_line_item__mdt  WHERE Label = 'Object fields for LWC'];
        List<String> fieldApis = metaDataLFieldApi[0].Description__c.split(',');
        Set<String> uniqFieldApis = new Set<String>();
        uniqFieldApis.addAll(fieldApis);
        return uniqFieldApis;
    }

    //must be deleted lately
    private  List<Product__mdt> cacheProducts(){
        List<Product__mdt> mtdProducts = [SELECT Account__c, PriceList__c, Products__c FROM Product__mdt WHERE Is_Active__c=true];
        Cache.Org.put('local.SfQliCache.inMemoryProducts',mtdProducts);
        return (List<Product__mdt>)Cache.Org.get('local.SfQliCache.inMemoryProducts');
    }
}