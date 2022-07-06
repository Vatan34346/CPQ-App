/*
* ============================================
* @apexClassName: SF_QuoteService.cls
* @description: class containing the logic for different actions with quote;
* @author: paata gvichia
* @email: paatagvichia@gmail.com	
* @dateCreated: 05/25/2022
* ============================================
*/
public  class SF_QuoteService implements SF_IQuoteService{
    
    //logic for singleton to call methods in Controller
    private static SF_QuoteService qouteInstance=null;

    private SF_QuoteService(){}

    public static SF_QuoteService getInstance(){
        if(qouteInstance==null){
            qouteInstance=new SF_QuoteService();
        }
        return qouteInstance;
    }

    /*
     * @author: paata gvichia
     * @param: opportunityID - id of opportunity.QUote should be asigned to it
     * @description: calles method from QuoteService.cls class that creates quote
     */
    public SF_Quote__c createQuote(Id opportunityId){
        SF_CacheHandler cacheHandler = new SF_CacheHandler();
        List<Opportunity> opportunities = [SELECT Id, AccountId, SF_Price_List__c,CurrencyIsoCode FROM Opportunity WHERE Id =:opportunityId LIMIT 1];
        List<Contact> contact =[SELECT Id FROM Contact WHERE AccountId =:opportunities[0].AccountId AND Primary__c=true LIMIT 1];
        Date expirationDate =System.today().addDays(7);

        List<Account> account = [SELECT Id, Name FROM Account WHERE Id =:opportunities[0].AccountId];
        List<SF_Price_List__c> priceList = [SELECT Id, Name FROM SF_Price_List__c WHERE Id =:opportunities[0].SF_Price_List__c];
        List<Product__mdt> metaDataInfo = cacheHandler.cachedInMemoryProducts;

        List<String> accountsNames = metaDataInfo[0].Account__c.split(',');
        List<String> priceListItemsNames = metaDataInfo[0].PriceList__c.split(',');
        List<String> productsNames = metaDataInfo[0].Products__c.split(',');

        List<SF_Quote_Line_Item__c> qlisList = new List<SF_Quote_Line_Item__c>();
        
        SF_Quote__c   quote = new SF_Quote__c(
                Opportunity__c = opportunityId,
                Account__c = opportunities[0].AccountId,
                Expiration_Date__c=expirationDate,
                Contact__c=contact[0].Id,
                SF_Price_List__c = opportunities[0].SF_Price_List__c,
                CurrencyIsoCode=opportunities[0].CurrencyIsoCode,
                Status__c = 'Draft'
            );    
          
            insert quote;
////////  
            for(String acc : accountsNames) {
                if(acc == account[0].Name) {
                    for(String pli : priceListItemsNames) {
                        if(pli == priceList[0].Name) {
                            List<Product2> productsList = [SELECT Id, Name, (SELECT Id FROM SF_Price_List_Items__r) 
                                                                            FROM Product2 WHERE Name IN :productsNames];
                                                                            
                            for(Integer i=0; i<productsNames.size(); i++){
                                List<SF_Price_List_Item__c> pliIds = productsList[i].SF_Price_List_Items__r;                    
                                SF_Quote_Line_Item__c qli = new SF_Quote_Line_Item__c(
                                    Name = productsList[i].Name,
                                    Product__c = productsList[i].Id,
                                    SF_Quote__c = quote.Id,
                                    SF_Price_List_Item__c = pliIds[0].Id,
                                    Quantity__c = 1
                                );
                                    qlisList.add(qli);
                            }
                        }
                    }
                }
            }        
            insert qlisList;
            return quote;
    }    
     
 /*
     * @author: paata gvichia
     * @param: quoteId - id of quote thaat should be cloned .  qliIsNeeded - if user whants to cline qli
     * @description: calles method from QuoteService.cls class that clones quote
     */
    public SF_Quote__c cloneQuote(Id quoteId,Boolean qliIsNeeded){

        List<Quote_fileds_mapping__mdt> qouteFieldsToMap = [SELECT Quote_Fields__c FROM Quote_fileds_mapping__mdt LIMIT 1];
        Set<String> fields = new Set<String>();//could be a list
        
        for(Quote_fileds_mapping__mdt item : qouteFieldsToMap){
            fields.addAll(item.Quote_Fields__c.split(','));
        }
        String queryString ='SELECT ' +String.join(new List<String>(fields),',') + ' FROM SF_Quote__c WHERE Id=:quoteId LIMIT 1';
        List<SF_Quote__c> existingQuote = Database.query(queryString);
        SF_Quote__c newQuote= new SF_Quote__c();
    
        for(String item : fields){
            newQuote.put(item,existingQuote[0].get(item));
        }
        insert newQuote;
        
        if(qliIsNeeded==true){
            List<SF_Quote_Line_Item__c> newQLIs =new List<SF_Quote_Line_Item__c>();
            List<Quote_fileds_mapping__mdt> qliFieldsToMap = [SELECT Quote_Line_Item_fieds__c FROM Quote_fileds_mapping__mdt LIMIT 1];
            Set<String> qliFields = new Set<String>();

            for(Quote_fileds_mapping__mdt item : qliFieldsToMap){
                qliFields.addAll(item.Quote_Line_Item_fieds__c.split(','));
            }
            String qliQueryString ='SELECT ' +String.join(new List<String>(qliFields),',') + ' FROM SF_Quote_Line_Item__c WHERE SF_Quote__c=:quoteId';
            List<SF_Quote_Line_Item__c> existingQLI = Database.query(qliQueryString);

            for(SF_Quote_Line_Item__c qli : existingQLI){
                SF_Quote_Line_Item__c newQli = new SF_Quote_Line_Item__c();
                for(string item : qliFields){
                    newQli.put(item,qli.get(item));
                 }
                 newQli.SF_Quote__c=newQuote.Id;
                 newQLIs.add(newQli);
            }   
            System.debug(newQLIs);
                 insert newQLIs;       
        }       
            return newQuote;
    }

     /*
     * @author: paata gvichia
     * @param: quoteId - id of quote thaat should be accepted .
     * @description: calles method from QuoteService.cls class that accpets quote and changes it statuse field to 'Accepted'
     */
    public void acceptQuote(Id quoteId){
        SF_Quote__c quotes =new SF_Quote__c();
        quotes.Id =quoteId;
        quotes.Status__c='Accepted';
        
        update quotes;
    }
}