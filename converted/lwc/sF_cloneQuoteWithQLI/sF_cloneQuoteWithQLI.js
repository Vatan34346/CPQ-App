import { LightningElement,api,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import cloneQuote from '@salesforce/apex/SF_QuoteController.cloneQuote';

//toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import errorNotification from '@salesforce/label/c.SF_Clone_Error';
import errorTitle from '@salesforce/label/c.error';
const VARIANT ='error';

import quoteQuestion from '@salesforce/label/c.SF_Clone_Question';

export default class SF_cloneQuoteWithQLI extends NavigationMixin(LightningElement) {

    @api recordId;
    hasRendered=true;
    @track quote=[]
    question=quoteQuestion;
    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: clone qoute with QLI.
    renderedCallback(){
        if(this.recordId!==undefined &&this.hasRendered){
            cloneQuote({quoteId:this.recordId,cloneQLI:true})
                .then((quote)=>{
                    if(quote){
                        this.quote.push(quote);
                    }
                    this.hasRendered=false;
                })
                .catch((ex)=>{
                    this.showNotification(errorTitle,errorNotification,VARIANT);
                });
        }      
     }  

    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: sends user to Quote Edit Page
    toEditPage() {
        if(Array.isArray(this.quote)&&this.quote.length>0){
            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: '/lightning/r/SF_Quote__c/' + this.quote[0].Id + '/view'
                },
            });
        }
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