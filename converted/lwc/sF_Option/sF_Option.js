import { LightningElement, api } from 'lwc';


export default class SF_Option extends LightningElement {
    @api optionId;
    @api optional;
    @api productName;
    @api quontity;
    @api basePrice;


    handleQuantity=(event)=>{
          const price= parseInt(event.target.value)*this.basePrice;
          const quantityEvent = new CustomEvent('handleqauntity',{detail:price});
          this.dispatchEvent(quantityEvent);
    }
}