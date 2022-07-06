import { LightningElement, api } from 'lwc';

// @api optionData = [
//     {id:'01',optional:true,productName:'test',quontity:"1",basePrice:"12"},
//     {id:'02',optional:false,productName:'test',quontity:"1",basePrice:"12"},
//     {id:'03',optional:true, productName:'test',quontity:"1",basePrice:"12"},
//     {id:'04',optional:false,productName:'test',quontity:"1",basePrice:"12"},
// ]

export default class SF_ProductBundle extends LightningElement {
    @api bundleName;
    @api optionData;


    price = 0;
    connectedCallback() {
        this.optionData.forEach(item => {
            if (!!item.basePrice) {
                this.price += item.basePrice * item.quontity
            }
        })
        console.log(this.price);
    }

    // events from optiondata
    handelNewQuantity = (event) => {
        console.log(event.detail)
        this.price += event.detail
    }
}