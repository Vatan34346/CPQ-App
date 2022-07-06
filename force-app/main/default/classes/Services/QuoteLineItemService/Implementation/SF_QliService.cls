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
        List<Quote_line_item__mdt> metaDataLFieldApi = [SELECT Description__c FROM Quote_line_item__mdt  WHERE Label = 'Object fields for LWC'];
        List<String> fieldApis = metaDataLFieldApi[0].Description__c.split(',');
        Set<String> fields = new Set<String>();
        List<String> lables =SF_CacheHandler.labels;
        List<String> filedType =SF_CacheHandler.types;
        List<SF_TableColumns> columns=new List<SF_TableColumns>();

        for(String item : fieldApis){
            fields.add(item);
        }

        //qlis
        String joinedFields =String.join(new List<String>(fields),',');
        String query='SELECT Id,IsBundle__c,Quote_Line_Item__c,' +joinedFields + ' FROM  SF_Quote_Line_Item__c WHERE SF_Quote__c  =:quoteId';
        List<SF_Quote_Line_Item__c> qlis =Database.query(query);

        //table columns
        for(Integer i =0; i<lables.size();i++){
            SF_TableColumns tbColomn = new SF_TableColumns(lables[i],new List<String>(fields)[i],filedType[i]);
            columns.add(tbColomn);
        }

        return  new SF_QliWrapper(qlis,columns);
    }

    public  void updateQuantity(Id qliId,Double quantity){
        SF_Quote_Line_Item__c qli = new SF_Quote_Line_Item__c();
        qli.Id =qliId;
        qli.Quantity__c =quantity;
        Database.update(qli);
    }
}