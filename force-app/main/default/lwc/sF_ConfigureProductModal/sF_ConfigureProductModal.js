import { LightningElement,api } from 'lwc';

export default class SF_ConfigureProductModal extends LightningElement {

    isModalOpen = false;
    @api modalData =[
        {
            id:'11',bundleName:'comp',options:[
                {id:'01',optional:true,productName:'mouse',quontity:1,basePrice:12},
                {id:'02',optional:false,productName:'headseats',quontity:1,basePrice:12},
                {id:'03',optional:true, productName:'keybord',quontity:1,basePrice:12},
                {id:'04',optional:false,productName:'hdmi',quontity:1,basePrice:12},
            ]
        },
        {
            id:'12',bundleName:'sony',options:[
                {id:'05',optional:true,productName:'hdmi',quontity:1,basePrice:12},
                {id:'06',optional:false,productName:'headseats',quontity:1,basePrice:1},
                {id:'07',optional:true, productName:'gamepad',quontity:1,basePrice:12},
                {id:'08',optional:false,productName:'gamepad',quontity:1,basePrice:12},
            ]
        },
        {
            id:'13',bundleName:'sony',options:[
                {id:'09',optional:true,productName:'hdmi',quontity:1,basePrice:12},
                {id:'10',optional:false,productName:'headseats',quontity:1,basePrice:1},
                {id:'11',optional:true, productName:'gamepad',quontity:1,basePrice:12},
                {id:'12',optional:false,productName:'gamepad',quontity:1,basePrice:12},
            ]
        },
        {
            id:'14',bundleName:'sony',options:[
                {id:'13',optional:true,productName:'hdmi',quontity:1,basePrice:12},
                {id:'14',optional:false,productName:'headseats',quontity:1,basePrice:1},
                {id:'15',optional:true, productName:'gamepad',quontity:1,basePrice:12},
                {id:'16',optional:false,productName:'gamepad',quontity:1,basePrice:12},
            ]
        },
    ]
        
        
    closeModal(){
        this.isModalOpen = false;
        this.handleModal();
    }
    handleModal(){
        const modalEvent = new CustomEvent("getmodalisclosed",{status:this.isModalOpen});
        this.dispatchEvent(modalEvent);
    }
}