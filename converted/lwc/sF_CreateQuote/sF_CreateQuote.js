import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import createQuote from '@salesforce/apex/SF_QuoteController.createQuote';
//toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import errorNotification from '@salesforce/label/c.SF_Quote_Creation_Error';
import errorTitle from '@salesforce/label/c.error';
const VARIANT ='error';


export default class SF_CreateQuote extends NavigationMixin(LightningElement) {
    @api recordId;
    quote;
 
    renderedCallback(){
        console.log(this.recordId);
        if(this.recordId!==undefined){
            createQuote({ opportunityId: this.recordId }).then(quote => {
                if(quote){
                    this.quote = quote;
                    this.toEditPage(this.quote.Id); 
                }                        
            }).catch(() => {
                this.showNotification(errorTitle,errorNotification,VARIANT);
            });
        }      
     }   

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: sends user to Quote Edit Page
    toEditPage(quoteId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/r/SF_Quote__c/' + quoteId + '/edit'
            },
        });
    };

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: shows error to user.
    showNotification(title,err,variant) {
      const event = new ShowToastEvent({
          title: title,
          message: err,
          variant: variant,
        });
          this.dispatchEvent(event);
    }   
}
