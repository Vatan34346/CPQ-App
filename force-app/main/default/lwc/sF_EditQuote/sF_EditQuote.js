import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createQuote from '@salesforce/apex/SF_QuoteController.createQuote';
//import errorNotification from '@salesforce/lable/namespace.SF_Quote_Creation_Error';
//import deleteAllQuotes from '@salesforce/apex/SF_QuoteController.deleteAllQuotes';

export default class SF_EditQuote extends NavigationMixin(LightningElement) {
    @api recordId;
    quote;
    title=`Cant create Quote on Opportunity with id: ${this.recordId}`;
    variant='error'
 

    renderedCallback() {
        if(this.recordId!==undefined){
            createQuote({ opportunityId: this.recordId }).then(result => {
                if(result){
                    this.quote = result;
                    const quoteId = this.quote.Id;
                    this.toEditPage(quoteId); 
                    console.log(this.quote)
                }                        
            }).catch(error => {
                this.showNotification('It is impossible to create Quote. Please try again or send us feedback.');
            });

        }      
     }   

//sends user to quote edit page
    toEditPage(quoteId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/r/SF_Quote__c/' + quoteId + '/edit'
            },
        });
    };

// mwthod shows error to user
    showNotification(err) {
      const evt = new ShowToastEvent({
          title: this.title,
          message: err,
          variant: this.variant,
    });
      this.dispatchEvent(evt);
}
    

}