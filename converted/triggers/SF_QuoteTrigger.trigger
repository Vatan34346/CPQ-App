// @description: trigger fror creating updating and deleting Quot;
// @author: paata gvichia
trigger SF_QuoteTrigger on SF_Quote__c (before insert, before update, before delete) {
 
 if(SF_CheckRecurtion.runOnce()){
  if(Trigger.isInsert){
    SF_QuoteTriggerHelper.processQuoteTrigger(Trigger.new, Trigger.old, SF_TriggerEvent.InsertEvent.name());
  }else if(Trigger.isUpdate){
    SF_QuoteTriggerHelper.processQuoteTrigger(Trigger.new, Trigger.old, SF_TriggerEvent.UpdateEvent.name());
  }else if(Trigger.isDelete){
    SF_QuoteTriggerHelper.processQuoteTrigger(Trigger.new, Trigger.old, SF_TriggerEvent.DeleteEvent.name());
  }
 }
}