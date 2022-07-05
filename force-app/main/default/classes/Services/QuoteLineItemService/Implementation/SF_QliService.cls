public  class SF_QliService implements SF_IQliService {


    private static SF_QliService qliInstance=null;

    //logic for singleton to call methods in Controller
   private SF_QliService(){}

   public static SF_QliService getInstance(){
       if(qliInstance==null){
        qliInstance=new SF_QliService();
       }
       return qliInstance;
   }

    public SF_QliWrapper getQLIs(Id quoteId){
        SF_CacheHandler cacheHandler = new SF_CacheHandler();
        Set<String> fields = new Set<String>();
        List<Quote_line_item__mdt> metaDataLabels = cacheHandler.cachedLabels;
        List<String> fieldName =getQuoteLineItemFieldNames();
        List<String> filedType =getQuoteLineItemsFieldTypes();
        List<SF_TableColumns> columns=new List<SF_TableColumns>();

        for(Quote_line_item__mdt item : metaDataLabels){
            fields.addAll(item.Description__c.split(','));
        }

        //qlis
        String joinedFields =String.join(new List<String>(fields),',');

        System.debug('sssssssssssss'  + joinedFields);
        String query='SELECT Id,IsBundle__c,Quote_Line_Item__c,' +joinedFields + ' FROM  SF_Quote_Line_Item__c WHERE SF_Quote__c  =:quoteId';
        List<SF_Quote_Line_Item__c> qlis =Database.query(query);

        //table columns
        for(Integer i =0; i<fieldName.size();i++){
            SF_TableColumns tbColomn = new SF_TableColumns(fieldName[i],new List<String>(fields)[i],filedType[i]);
            columns.add(tbColomn);
        }


        return  new SF_QliWrapper(qlis,columns);

    }

    public List<SF_Quote_Line_Item__c> getOptions(Id qliId){
        SF_CacheHandler cacheHandler = new SF_CacheHandler();
        Set<String> fields = new Set<String>();
        List<Quote_line_item__mdt> metaDataLabels = cacheHandler.cachedLabels;

        for(Quote_line_item__mdt item : metaDataLabels){
            fields.addAll(item.Description__c.split(','));
        }

        String joinedFields =String.join(new List<String>(fields),',');
        String query='SELECT Id,Product__c,IsBundle__c,' +joinedFields + ' FROM  SF_Quote_Line_Item__c WHERE Id  =:qliId LIMIT 1';
        List<SF_Quote_Line_Item__c> qlis =Database.query(query);

        List<Id> prodIds = new List<Id>();
        for (SF_Quote_Line_Item__c item : qlis) {
            prodIds.add(item.Product__c);
        }
    
        System.debug('sssss ' + prodIds);

        List<Product2> products = [SELECT Id, Name, SF_Is_Bundle__c,(SELECT Id,Name,SF_Products__c FROM Option__r) FROM Product2 WHERE Id IN :prodIds];

        List<Product2> optionProds = new List<Product2>();
        for( Product2 item : products){
            for(Product2 pr : item.Option__r){
                optionProds.add(pr);
            }
        }

        List<Id> optionProdIds = new List<Id>();
        for( Product2 prods : optionProds){
            optionProdIds.add(prods.Id);
        }

        String optionsQliQuery='SELECT Id,Product__c,IsBundle__c,' +joinedFields + ' FROM  SF_Quote_Line_Item__c WHERE 	Product__c IN  :optionProdIds AND IsBundle__c!=true';
        List<SF_Quote_Line_Item__c> optionQlis=Database.query(optionsQliQuery);

        
 
       System.debug('sssss ' + optionQlis);
        return optionQlis;
    }

    public List<String> getQuoteLineItemFieldNames(){
        SF_CacheHandler cacheHandler = new SF_CacheHandler();
        List<Quote_line_item__mdt> metaDataLabels =cacheHandler.cachedLabels;
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

    private List<String> getQuoteLineItemsFieldTypes(){

        SF_CacheHandler cacheHandler = new SF_CacheHandler();
        List<Quote_line_item__mdt> metaDataLabels =cacheHandler.cachedLabels;
        List<String> labels = metaDataLabels[0].Description__c.split(',');
        Set<String> setLables = new Set<String>();
        setLables.addAll(labels);
        
        String ObjectApi = 'SF_Quote_Line_Item__c';
        
        List<String> typeList = new List<String>();
        
        for(String item : setLables){
            String type =String.valueOf(Schema.getGlobalDescribe().get(ObjectApi).getDescribe().fields.getMap().get(item).getDescribe().getType());
            if(type!='PickList')
            typeList.add(type);
        }
        return typeList;

    }
}
