import { LightningElement, api } from 'lwc';

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