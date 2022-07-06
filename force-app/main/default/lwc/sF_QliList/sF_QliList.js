import { LightningElement, api } from 'lwc';
import getQli from '@salesforce/apex/SF_QliController.getQli';

export default class SF_QliList extends LightningElement {

    @api recordId
    qliData = [];
    labels = [];
    showOptions=false;

    connectedCallback() {
        if (!!this.recordId) {
            getQli({ quoteId: this.recordId }).then(result => {
                console.log(result);
                if (!!result) {
                    this.labels = result.qliColumns
                    this.qliData=result.qliData;
                }
            }).catch(er => console.log(er));
        }
    }


    expandHandler =(event) =>{
        this.showOptions = event.detail;
    }
}