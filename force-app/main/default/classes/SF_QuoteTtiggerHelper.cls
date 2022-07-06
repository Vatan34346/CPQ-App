public with sharing class SF_QuoteTtiggerHelper {
    
    public static void upsertQuote(List<SF_Quote__c> newQuotes, List<SF_Quote__c> oldQuotes){
        Integer numberOfNonPrimaryQuotes=0;
        List<SF_Quote__c> allQuotes =[SELECT Id,Primary__c FROM SF_Quote__c WHERE Opportunity__c =:newQuotes[0].Opportunity__c];
        //insert 
        if(oldQuotes==null){
            //quote is first
            if(allQuotes.size()==0){
                newQuotes[0].Primary__c=true;
            }else{
                newQuotes[0].addError('error');
            }

            if(allQuotes.size()>0&&newQuotes[0].Primary__c==true){
                for(SF_Quote__c item : allQuotes){
                    item.Primary__c=false;
                }
                update allQuotes;
            }
        }else {

            if(allQuotes.size()==0&&newQuotes[0].Primary__c==false){
                newQuotes[0].addError('error');
            }

            if(allQuotes.size()>0&&newQuotes[0].Primary__c==true){
                for(SF_Quote__c item : allQuotes){
                    item.Primary__c=false;
                }
                update allQuotes;
            }

            if(allQuotes.size()>0&&newQuotes[0].Primary__c==false){

                for(SF_Quote__c item : allQuotes){
                    if(item.Primary__c==false){
                        numberOfNonPrimaryQuotes++;
                    }
                }
                if(numberOfNonPrimaryQuotes+newQuotes.size()==allQuotes.size()+newQuotes.size()){
                    newQuotes[0].addError('error');
                }

            }
        }
      
    }


    public static void deleteQuote(List<SF_Quote__c> newQuotes, List<SF_Quote__c> oldQuotes){
        if(newQuotes[0].Primary__c==true){
            newQuotes[0].addError('Cant delete Primary quote. Please select another quote as Primery and then delete this one');
        }
    }
}