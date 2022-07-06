import { api, LightningElement, track, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import shippingAddress from '@salesforce/label/c.shippingAddress';
import billingAddress from '@salesforce/label/c.billingAddress';
import city from '@salesforce/label/c.city';
import country from '@salesforce/label/c.country';
import postalCode from '@salesforce/label/c.postalCode';
import state from '@salesforce/label/c.state';
import street from '@salesforce/label/c.street';
import saveButton from '@salesforce/label/c.saveButton';
import cancelButton from '@salesforce/label/c.cancelButton';
import success from '@salesforce/label/c.success';
import error from '@salesforce/label/c.error';
import successFields from '@salesforce/label/c.successFields';

import AccountId from '@salesforce/schema/Account.Id';

import BillingCountry from '@salesforce/schema/Account.SF_Billing_Country__c';
import BillingState from '@salesforce/schema/Account.SF_Billing_State__c';
import BillingStreet from '@salesforce/schema/Account.SF_Billing_Street__c';
import BillingPostalCode from '@salesforce/schema/Account.SF_Billing_Postal_Code__c';


import ShippingCountry from '@salesforce/schema/Account.SF_Shipping_Country__c';
import ShippingState from '@salesforce/schema/Account.SF_Shipping_State__c';
import ShippingStreet from '@salesforce/schema/Account.SF_Shipping_Street__c';
import ShippingPostalCode from '@salesforce/schema/Account.SF_Shipping_Postal_Code__c';

const FIELDS = [BillingCountry, BillingState,
     BillingPostalCode, BillingStreet, 
     ShippingCountry, ShippingState, 
     ShippingStreet, ShippingPostalCode];

/*
* ============================================
* @JavascriptClassName: account.js
* @description: handler class that contains login to work with account object
* @author: Mamuka Bigvava
* @email: mamukabigvava2201@gmail.com
* ============================================
*/
export default class Account extends LightningElement {
    account;
    @api recordId;
    labels = {
        success,
        error,
        successFields,
        shippingAddress,
        billingAddress,
        city,
        country,
        postalCode,
        state,
        street,
        saveButton,
        cancelButton
    };
    @track mapMarker;
    @track address = { street: '', country: '', postalCode: '', province: ''};
    showButtons = true;
    showAddress = false;
    zoomLevel;
    listView;


    /*
     * @author: Mamuka Bigvava
     * @description: JavaScript method to get error message
     */
    showError(error){
        const errorMessage = new ShowToastEvent({
            title: this.labels.error,
            message: error.message.body,
            variant: 'error'
        })
        this.dispatchEvent(errorMessage);
    }


    /*
     * @author: Mamuka Bigvava
     * @description: JavaScript method to get success message
     */
    showSuccess(){
        const successMessage = new ShowToastEvent({
            title: this.labels.success,
            message: this.labels.successFields,
            variant: 'success'
        })
        this.dispatchEvent(successMessage);
    }

    /*
     * @author: Mamuka Bigvava
     * @description: JavaScript method that gets records from account
     */
    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    wiredRecord({ error, data}){
        if(error){
            this.dispatchEvent(
                this.showError(error)
            )
        }else if(data){
            console.log('DATA: ', data);
            this.account = data;
        }
    }


    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method that saves or updates Account Shipping address fields
     */
    saveShipping(){
        const fields = {};
        fields[AccountId.fieldApiName] = this.recordId;
        fields[ShippingStreet.fieldApiName] = this.address.street;
        fields[ShippingCountry.fieldApiName] = this.address.country;
        fields[ShippingPostalCode.fieldApiName] = this.address.postalCode;
        fields[ShippingState.fieldApiName] = this.address.province;
        const recordInput = { fields: fields };
        updateRecord(recordInput)
        .then(() => {
            this.showSuccess();
        }).catch(error => {
            this.showError(error);
        })
    }


    
    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method that saves or updates Account Billing address fields
     */
    savelBilling(){
        const fields = {};
        fields[AccountId.fieldApiName] = this.recordId;
        fields[BillingStreet.fieldApiName] = this.address.street;
        fields[BillingCountry.fieldApiName] = this.address.country;
        fields[BillingPostalCode.fieldApiName] = this.address.postalCode;
        fields[BillingState.fieldApiName] = this.address.province;
        const recordInput = { fields: fields };
        updateRecord(recordInput).then(() => {
                this.showSuccess();
            }).catch(error => {
               this.showError(error);
            });
    }



    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method to show shipping input address
     */
    showShippingAddress(){
        this.showButtons = false;
        this.showShipping = true;
    }


    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method to show billing input address
     */
    showBillingAddress(){
        this.showButtons = false;
        this.showBilling = true;
    }

    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method to close shipping address
     */
    cancelShipping(){
        this.showButtons = true;
        this.showShipping = false;
    }

    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method to close billing address
     */
    cancelBilling(){
        this.showButtons = true;
        this.showBilling = false;
    }


    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method that gets address fields from input
     */
    addressChange(e){
        this.address = {city: e.target.city, country: e.target.country, postalCode: e.target.postalCode, province: e.target.province, street: e.target.street};
        console.log(this.address, ' Addresses.......');
        this.searchAddress();
    }

    /*
     * @author: Mamuka Bigvava
     * @description: Javascript method that marks address on the map
     */
    searchAddress(){
        console.log("Went here........");
        this.mapMarker= [
            {
                location: {
                    City: this.address.city,
                    Country: this.address.country,
                    PostalCode: this.address.postalCode,
                    State: this.address.province,
                    Street: this.address.street 
                }
            }
        ];
        this.zoomLevel = 12;
        this.listView = 'visible';
        console.log("Map markers ", this.mapMarker);
    }

   
}