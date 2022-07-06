import { LightningElement, api } from 'lwc';


export default class SF_Qli extends LightningElement {

    @api qliId;
    @api qliData;
    @api labelInfo;
    @api currencyIsoCode;
    @api isOption;
    @api isBundle;

    options = []
    buttonIcon = '+';
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


    handelExpand = () => {
        console.log(this.isBundle);
            this.expandOptions = !this.expandOptions;
    }
}