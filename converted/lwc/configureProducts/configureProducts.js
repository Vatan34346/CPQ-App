import { api, LightningElement, track, wire } from 'lwc';
import {CurrentPageReference, NavigationMixin} from 'lightning/navigation';
import configureProducts from '@salesforce/label/c.configureProducts';
import 	accept from 	'@salesforce/label/c.SF_Accept_Quote';
import getQLIs from '@salesforce/apex/SF_ConfigureProductController.getQLIs';
import getProductList from '@salesforce/apex/SF_ConfigureProductController.getProductList';
import getQuoteLineItemFieldNames from '@salesforce/apex/SF_ConfigureProductController.getQuoteLineItemFieldNames';

import acceptQuote from '@salesforce/apex/SF_QuoteController.acceptQuote';
//
import { updateRecord } from 'lightning/uiRecordApi';
import QUOTE from '@salesforce/schema/SF_Quote__c';
import ID_FIELD from '@salesforce/schema/SF_Quote__c.Id';
import STATUS_FIELD from '@salesforce/schema/SF_Quote__c.Status__c';

//toast
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import errorNotification from '@salesforce/label/c.SF_Accept_Quote_Error';
import errorTitle from '@salesforce/label/c.error';
const VARIANT ='error';

export default class ConfigureProducts extends NavigationMixin(LightningElement) {


    @track products;
    showOptions = false;



    options;
    searchInput;
    tableHeaders;
    result;
    records;
    wiredRecords;
    @track recordId;
    qlis;
    qlis2;
    quotes;
    error;
    rowOffset = 0;
    productOptions;
    qliOptions = [];
    
    columnNames;
    labels ={
        configureProducts,
        accept
    };
    

    results;
   

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        this.recordId = currentPageReference.state.c__recordId;
    }


/////////////////////paata////////////////////////////////////////////
    
    isModalOpen = false;
    //@author:paata gvichia
    //@email:paatagvichia@gmail.com
    //@description: accepts quote by id and send to quote edit page
    processAcceptQuote(){
        acceptQuote({quoteId:this.recordId}).then(()=>{
            console.log(this.recordId)
            this.toEditPage(this.recordId);
        }).catch(()=>{
            this.showNotification(errorTitle,errorNotification,VARIANT);
        });
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

    handleModal(event){
       this.isModalOpen=event.status;
    }

    showConfig(){
        this.isModalOpen = true;
        console.log(productName);
    }
    
}