import { LightningElement,api } from 'lwc';
import updateQuantity from '@salesforce/apex/SF_QliController.updateQuantity';

export default class SF_QliBundleOption extends LightningElement {
    @api qliId;
    @api qliData;
    @api labelInfo;
    @api currencyIsoCode;
    @api isOption;
    @api isBundle;


    expandOptions = false;
    currentQliItem;

    currencyFields = [];
    stringFields = [];
    inputableFields = [];
    otherFields = [];

 

    

    connectedCallback() {

        this.processQliInfo();
        this.processQliOptions();
        this.processColumns(this.currentQliItem[0]);

    }


    processQliInfo = () => {
        const qli = this.qliData.filter(item => {
            return item.Id === this.qliId;
        })
        this.currentQliItem = JSON.parse(JSON.stringify(qli));
        this.labelInfo = JSON.parse(JSON.stringify(this.labelInfo));
    }


    processQliOptions = () => {
        let bundleQli = {};
        this.qliData.forEach(item => {
            if (item.IsBundle__c === true) {
                bundleQli = item;
            }
        })

        this.qliData.forEach(item => {
            if (item.Quote_Line_Item__c === bundleQli.Id) {
                this.options.push(JSON.parse(JSON.stringify(item)));
            }
        })
    }

    processColumns = (qliItem) => {
        let mapQli = new Map();
        for (let key in qliItem) {
            mapQli.set(key, qliItem[key]);
        }

        this.labelInfo.forEach(item => {
            const qliObject = {
                type: item.type,
                qliFieldValue: mapQli.get(item.fieldName)
            };

            if (qliObject.type === 'CURRENCY') {
                this.currencyFields.push(qliObject);
            } else if (qliObject.type === 'DOUBLE') {
                this.inputableFields.push(qliObject)
            } else if (qliObject.type === 'STRING') {
                this.stringFields.push(qliObject)
            }
            else {
                this.otherFields.push(qliObject);
            }
        })
    }

    onQuantityChangeHandler=(event)=>{
        updateQuantity({qliId:this.qliId,quantity:event.target.value}).catch(err=>console.log(err));
    }

}