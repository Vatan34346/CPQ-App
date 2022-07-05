public class SF_TableColumns {
    @AuraEnabled
    public String colLabel{get;set;}

    @AuraEnabled
    public String fieldName{get;set;}

    @AuraEnabled
    public String type{get;set;}

    public SF_TableColumns(String label,String fieldName,String type) {

        this.colLabel=label;
        this.fieldName=fieldName;
        this.type=type;
    }
}
