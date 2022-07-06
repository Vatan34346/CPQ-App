public  class SF_QliWrapper {
 
    @AuraEnabled
    public List<SF_TableColumns> qliColumns {get;set;}

    @AuraEnabled
    public List<SF_Quote_Line_Item__c> qliData {get;set;}


    public SF_QliWrapper(List<SF_Quote_Line_Item__c> qli, List<SF_TableColumns> columns){

        this.qliColumns=columns;
        this.qliData=qli;
    }
}
